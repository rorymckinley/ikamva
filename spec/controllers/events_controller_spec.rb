require 'spec_helper'

describe EventsController do
  before(:each) do
    authorised
    Branch.delete_all
    Event.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
  end

  it "should provide a way to capture the details of a new form" do
    get :new, :branch_id => @branch_1.id
    response.should be_success
    response.should render_template('events/new')
  end

  it "should provide a collection of event types when creating a form for a new session" do
    get :new, :branch_id => @branch_1.id
    assigns[:purposes].should eql Event.event_purposes
  end

  it "should provide a way to create a new event" do
    post :create, :branch_id => @branch_1.id, :event => { "start" => "2010-12-05 12:00", "end" => "2010-12-05 14:00", "purpose"=> 'homework', "grade" => 8}
    event = Event.find(:first)
    event.branch.should == @branch_1
    event.purpose.should == 'homework'
    event.grade.should == 8
    event.start.strftime("%Y%m%d%H%M%S").should == "20101205120000"
    event.end.strftime("%Y%m%d%H%M%S").should == "20101205140000"
    event.start.zone.should == 'SAST'
  end
  
  it "should redirect to the listing of the branch's events after creation" do
    post :create, :branch_id => @branch_1.id, :event => { "start" => "2010-12-05 12:00", "end" => "2010-12-05 14:00", "purpose"=> 'homework', "grade"=> 11}
    response.should redirect_to branch_events_path(@branch_1)
  end

  it "should set a message indicating that the even thas been created" do
    post :create, :branch_id => @branch_1.id, :event => { "start" => "2010-12-05 12:00", "end" => "2010-12-05 14:00", "purpose"=> 'homework', "grade"=> 11}
    flash[:event].should == "Event created"
  end

  it "should list the events for a particular branch" do
    Event.create :branch_id => @branch_1.id, :start => "2010-12-05 12:00", :end => "2010-12-05 14:00", :purpose => "tutorial", :grade => 11
    Event.create :branch_id => @branch_1.id, :start => "2010-12-05 16:00", :end => "2010-12-05 18:00", :purpose => "tutorial", :grade => 11
    get :index, :branch_id => @branch_1.id
    response.should render_template 'events/index' 
    @branch_1.reload
    assigns[:events].should == [@branch_1.events.first, @branch_1.events.last]
    assigns[:events][0].start.zone.should == 'SAST'
    assigns[:branch].should == @branch_1
  end

  it "should provide a form for editing an event" do
    Event.create :branch_id => @branch_1.id, :start => "2010-12-05 12:00", :end => "2010-12-05 14:00", :purpose => "tutorial", :grade => 11
    @branch_1.reload
    get :edit, :branch_id => @branch_1.id, :id => @branch_1.events.first.id
    assigns[:purposes].should == Event.event_purposes
    assigns[:branch].should == @branch_1
    assigns[:event].should == @branch_1.events.first
    assigns[:event].start.zone.should == 'SAST' # Check that the time zone is set to SAST
    response.should render_template 'events/edit'
  end

  it "should update an event" do
    event = Event.create :branch_id => @branch_1.id, :start => "2010-12-05 12:00", :end => "2010-12-05 14:00", :purpose => "tutorial", :grade => 11
    put :update, :branch_id => @branch_1.id, :id => event.id, "event" => {"start" => "2010-12-05 16:00", "end" => "2010-12-05 18:00", "purpose" => 'homework', "grade" => 10}
    event.reload
    event.start.strftime("%Y%m%d%H%M%S %Z").should ==  "20101205160000 SAST"
    event.end.strftime("%Y%m%d%H%M%S %Z").should ==  "20101205180000 SAST"
    event.purpose.should == 'homework'
    event.grade.should == 10
  end

  it "should redirect to the event listing page after updating an event" do
    event = Event.create :branch_id => @branch_1.id, :start => "2010-12-05 12:00", :end => "2010-12-05 14:00", :purpose => "tutorial", :grade => 11
    put :update, :branch_id => @branch_1.id, :id => event.id, "event" => {"start" => "2010-12-05 16:00", "end" => "2010-12-05 18:00", "purpose" => 'homework', "grade" => 11}
    response.should redirect_to branch_events_path(@branch_1)
  end

  it "should provide a message indicating that the event was updated" do
    event = Event.create :branch_id => @branch_1.id, :start => "2010-12-05 12:00", :end => "2010-12-05 14:00", :purpose => "tutorial", :grade => 11
    put :update, :branch_id => @branch_1.id, :id => event.id, "event" => {"start" => "2010-12-05 16:00", "end" => "2010-12-05 18:00", "purpose" => 'homework', "grade" => 11}
    flash[:event].should == 'Event Updated'

  end
end
