require 'spec_helper'

describe "events/index.erb" do
  before(:each) do
    Branch.delete_all
    Event.delete_all
    
    @branch = Branch.create :name => 'Test 1'
    @event_1 = Event.create! :purpose => 'homework', :start => Time.now, :end => Time.now + 2.hours, :branch => @branch
    @event_2 = Event.create! :purpose => 'tutorial', :start => Time.now, :end => Time.now + 2.hours, :branch => @branch
  end

  it "should display a list of events" do
    assign(:events, [@event_1, @event_2])
    render
    rendered.should contain 'Homework'
    rendered.should contain 'Tutorial'
  end

  it "should provide a link to create a new event" do
    assign(:events, [@event_1, @event_2])
    assign(:branch, @branch)
    render
    rendered.should have_selector("a", :href=> new_branch_event_path(@branch))
  end
end

