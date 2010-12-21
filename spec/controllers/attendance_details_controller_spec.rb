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
    response.should be_successful

    AttendanceDetail.find(:first, :conditions => { :participant_id => @participant.id, :status => 'full'}).should_not be_nil
    @event.reload.participants.should include @participant
  end

  it "should calculate the attendance detail status if none is provided" do
    event2 = @branch_1.events.create! :purpose => 'homework', :start => Time.now + 1.minute, :end => Time.now + 1.hour
    post :create, :branch_id => @branch_1.id, :event_id => event2.id, :participant => { "card_number" => '1234'}, :attendance_detail => { 'status' => '' }
    AttendanceDetail.find(:first, :conditions => { :status => 'full' }).should_not be_nil
  end
end
