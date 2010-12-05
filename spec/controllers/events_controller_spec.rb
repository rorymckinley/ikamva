require 'spec_helper'

describe EventsController do
  before(:each) do
    Branch.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
  end

  it "should provide a way to capture the details of a new form" do
    get :new, :branch_id => @branch_1.id
    response.should be_success
    response.should render_template('events/new')
  end

  it "should provide a collection of event types when creating a form for a new session" do
    get :new, :branch_id => @branch_1.id
    assigns[:types].should eql Event.event_types
  end

  it "should provide a way to create a new event" do
    post :create, :branch_id => @branch_1.id, :event => { "start" => "12/05/2010 12:00", "end" => "12/05/2010 14:00", "type"=> 'homework'}
    response.should be_success
    puts Event.find(:first).inspect
    Event.find(:first).branch.should == @branch_1
  end
end
