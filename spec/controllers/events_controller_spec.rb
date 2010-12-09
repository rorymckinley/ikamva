require 'spec_helper'

describe EventsController do
  before(:each) do
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
    post :create, :branch_id => @branch_1.id, :event => { "start" => "12/05/2010 12:00", "end" => "12/05/2010 14:00", "purpose"=> 'homework'}
    event = Event.find(:first)
    event.branch.should == @branch_1
    event.purpose.should == 'homework'
    event.start.strftime("%Y%m%d%H%M%S").should == "20101205120000"
    event.end.strftime("%Y%m%d%H%M%S").should == "20101205140000"
  end
  
  it "should redirect to the listing of the branch's events after creation" do
    post :create, :branch_id => @branch_1.id, :event => { "start" => "12/05/2010 12:00", "end" => "12/05/2010 14:00", "purpose"=> 'homework'}
    response.should redirect_to branch_events_path(@branch_1)
  end

  it "should set a message indicating that the even thas been created" do
    post :create, :branch_id => @branch_1.id, :event => { "start" => "12/05/2010 12:00", "end" => "12/05/2010 14:00", "purpose"=> 'homework'}
    flash[:event].should == "Event created"
  end

  it "should list the events for a particular branch" do
    post :create, :branch_id => @branch_1.id, :event => { "start" => "12/05/2010 12:00", "end" => "12/05/2010 14:00", "purpose"=> 'tutorial'}
    post :create, :branch_id => @branch_1.id, :event => { "start" => "12/05/2010 16:00", "end" => "12/05/2010 18:00", "purpose"=> 'tutorial'}
    get :index, :branch_id => @branch_1.id
    response.should render_template 'events/index' 
    @branch_1.reload
    assigns[:events].should == [@branch_1.events.first, @branch_1.events.last]
    assigns[:branch].should == @branch_1
  end
end
