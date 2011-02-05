require 'spec_helper'

describe AttendanceDetailsController do
  before(:each) do
    authorised
    Branch.delete_all
    Event.delete_all
    Member.delete_all
    AttendanceDetail.delete_all

    @branch_1 = Branch.create! :name => 'Test 1'
    @event = @branch_1.events.create! :purpose => 'tutorial', :start => Time.now, :end => Time.now + 2.hours
    @member = Member.create! :first_name => 'Part', :surname => 'One', :card_number => '1234'
  end

  it "should provide a form for capturing attendance detail" do
    get :new, :branch_id => @branch_1.id, :event_id => @event.id
    assigns[:branch].should == @branch_1
    assigns[:event].should == @event
    response.should be_success
    response.should render_template "attendance_details/new"
  end

  it "should allow attendance detail to be captured" do
    post :create, :branch_id => @branch_1.id, :event_id => @event.id, :member => { "card_number" => '1234'}, :attendance_detail => { 'status' => 'full' }

    AttendanceDetail.find(:first, :conditions => { :member_id => @member.id, :status => 'full'}).should_not be_nil
    @event.reload.members.should include @member
  end

  it "should calculate the attendance detail status if none is provided" do
    event2 = @branch_1.events.create! :purpose => 'homework', :start => Time.now + 1.minute, :end => Time.now + 1.hour
    post :create, :branch_id => @branch_1.id, :event_id => event2.id, :member => { "card_number" => '1234'}, :attendance_detail => { 'status' => '' }
    AttendanceDetail.find(:first, :conditions => { :status => 'full' }).should_not be_nil
  end

  it "should return to the form for capturing attendance details after creation" do
    post :create, :branch_id => @branch_1.id, :event_id => @event.id, :member => { "card_number" => '1234'}, :attendance_detail => { 'status' => 'full' }
    response.should redirect_to new_branch_event_attendance_detail_path(@branch_1, @event)
  end

  it "should display the status of the attendance detail created when returning to the form" do
    post :create, :branch_id => @branch_1.id, :event_id => @event.id, :member => { "card_number" => '1234'}, :attendance_detail => { 'status' => 'full' }
    attendance_detail = AttendanceDetail.find(:first)
    flash[:attendance_detail].should == "#{@member.first_name} #{@member.surname} has #{attendance_detail.status} credit"
  end

  it "should return an error if the card number cannot be mapped to a member" do
    post :create, :branch_id => @branch_1.id, :event_id => @event.id, :member => { "card_number" => '0000'}, :attendance_detail => { 'status' => 'full' }
    flash[:error].should == "No member with card number 0000"
  end

  it "should list all attendance details for an event" do
    get :index, :branch_id => @branch_1.id, :event_id => @event.id
    assigns[:branch].should == @branch_1
    assigns[:event].should == @event
    response.should render_template "attendance_details/index"
  end

  it "should provide functionality to edit an attendance detail record" do
    attendance_detail = @event.attendance_details.create! :status => 'full', :member => @member
    get :edit, :branch_id => @branch_1.id, :event_id => @event.id, :id => attendance_detail.id
    assigns[:branch].should == @branch_1
    assigns[:event].should == @event
    assigns[:attendance_detail].should == attendance_detail
    response.should be_success
    response.should render_template "attendance_details/edit"
  end

  it "should allow an attendance detail record to be updated" do
    attendance_detail = @event.attendance_details.create! :status => 'full', :member => @member
    put :update, :branch_id => @branch_1.id, :event_id => @event.id, :id => attendance_detail.id, :attendance_detail => { "status" => 'partial' }
    attendance_detail.reload.status.should == 'partial'
  end

  it "should redirect to the listing of attendance details after update" do
    attendance_detail = @event.attendance_details.create! :status => 'full', :member => @member
    put :update, :branch_id => @branch_1.id, :event_id => @event.id, :id => attendance_detail.id, :attendance_detail => { "status" => 'partial' }
    response.should redirect_to branch_event_attendance_details_path(@branch_1, @event)
  end

  it "should set a message indicating that the attendace detail record was updated successfully" do
    attendance_detail = @event.attendance_details.create! :status => 'full', :member => @member
    put :update, :branch_id => @branch_1.id, :event_id => @event.id, :id => attendance_detail.id, :attendance_detail => { "status" => 'partial' }
    flash[:attendance_detail].should == "Attendance Detail updated"
  end
end
