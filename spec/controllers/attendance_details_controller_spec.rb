require 'spec_helper'

describe AttendanceDetailsController do
  before(:each) do
    Branch.delete_all
    Event.delete_all
    Participant.delete_all
    AttendanceDetail.delete_all

    @branch_1 = Branch.create! :name => 'Test 1'
    @event = @branch_1.events.create! :purpose => 'tutorial', :start => Time.now, :end => Time.now + 2.hours
    @participant = Participant.create! :name => 'Part One', :card_number => '1234'
  end

  it "should provide a form for capturing attendance detail" do
    get :new, :branch_id => @branch_1.id, :event_id => @event.id
    assigns[:branch].should == @branch_1
    assigns[:event].should == @event
    response.should be_success
    response.should render_template "attendance_details/new"
  end

  it "should allow attendance detail to be captured" do
    post :create, :branch_id => @branch_1.id, :event_id => @event.id, :participant => { "card_number" => '1234'}, :attendance_detail => { 'status' => 'full' }

    AttendanceDetail.find(:first, :conditions => { :participant_id => @participant.id, :status => 'full'}).should_not be_nil
    @event.reload.participants.should include @participant
  end

  it "should calculate the attendance detail status if none is provided" do
    event2 = @branch_1.events.create! :purpose => 'homework', :start => Time.now + 1.minute, :end => Time.now + 1.hour
    post :create, :branch_id => @branch_1.id, :event_id => event2.id, :participant => { "card_number" => '1234'}, :attendance_detail => { 'status' => '' }
    AttendanceDetail.find(:first, :conditions => { :status => 'full' }).should_not be_nil
  end

  it "should return to the form for capturing attendance details after creation" do
    post :create, :branch_id => @branch_1.id, :event_id => @event.id, :participant => { "card_number" => '1234'}, :attendance_detail => { 'status' => 'full' }
    response.should redirect_to new_branch_event_attendance_detail_path(@branch_1, @event)
  end

  it "should display the status of the attendance detail created when returning to the form" do
    post :create, :branch_id => @branch_1.id, :event_id => @event.id, :participant => { "card_number" => '1234'}, :attendance_detail => { 'status' => 'full' }
    attendance_detail = AttendanceDetail.find(:first)
    flash[:attendance_detail].should == "#{@participant.name} has #{attendance_detail.status} credit"
  end

  it "should return an error if the card number cannot be mapped to a participant" do
    post :create, :branch_id => @branch_1.id, :event_id => @event.id, :participant => { "card_number" => '0000'}, :attendance_detail => { 'status' => 'full' }
    flash[:error].should == "No participant with card number 0000"
  end

  it "should list all attendance details for an event" do
    get :index, :branch_id => @branch_1.id, :event_id => @event.id
    assigns[:branch].should == @branch_1
    assigns[:event].should == @event
    response.should render_template "attendance_details/index"
  end
end
