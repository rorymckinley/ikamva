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

  it "should provide a link to edit an existing event" do
    assign(:events, [@event_1, @event_2])
    assign(:branch, @branch)
    render
    rendered.should have_selector("a", :href => edit_branch_event_path(@branch, @event_1)) do |edit_link|
      edit_link.should contain("Edit Event")
    end
  end

  it "should provide a link to add attendance detail for an event" do
    assign(:events, [@event_1, @event_2])
    assign(:branch, @branch)
    render
    rendered.should have_selector("a", :href => new_branch_event_attendance_detail_path(@branch, @event_1)) do |attendance_link|
      attendance_link.should contain("Add Attendance Detail")
    end
  end

  it "should provide a link to the listing of an event's attendance details" do
    assign(:events, [@event_1, @event_2])
    assign(:branch, @branch)
    render
    rendered.should have_selector("a", :href => branch_event_attendance_details_path(@branch, @event_1)) do |attendance_list_link|
      attendance_list_link.should contain "Attendance Details"
    end
  end

  it "should provide a link to return to the branch listing" do
    assign(:events, [@event_1, @event_2])
    assign(:branch, @branch)
    render
    rendered.should have_selector("a", :href => branches_path) do |branches_link|
      branches_link.should contain "Return to Branches"
    end
  end
end

