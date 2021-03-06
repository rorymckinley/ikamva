require "spec_helper"

describe "events/edit.erb" do
  before(:each) do
    Branch.delete_all
    Event.delete_all
    @branch_1 = Branch.create! :name => "Test Branch"
    @event = @branch_1.events.create! :start => Time.now, :end => Time.now + 2.hours, :purpose => "tutorial", :grade => 11
  end

  it "should provide a form to edit an existing event" do
    assign(:branch, @branch_1)
    assign(:event, @event)
    assign(:purposes, [{ 'tutorial' => 'Tutorial' }, { 'workshop' => 'Workshop' }])
    render
    rendered.should have_selector("form", :method => "post", :action => branch_event_path(@branch_1, @event)) do |form|
      form.should have_selector("input", :type => "hidden", :name => "authenticity_token")
      form.should have_selector("input", :type => "hidden", :name => "_method", :value => "put")
      form.should have_selector("input", :type => "text", :name => "event[start]", :id => "start_date")
      form.should have_selector("input", :type => "text", :name => "event[end]", :id => "end_date")
      form.should have_selector("select", :name => "event[purpose]") do |select|
        select.should have_selector("option", :value => "tutorial", :selected => "selected") do |selected_option|
          selected_option.should contain("Tutorial")
        end
        select.should have_selector("option", :value => "workshop")
      end
      form.should have_selector("select", :name => "event[grade]") do |select|
        select.should have_selector("option", :value => "11", :selected => "selected")
      end
      form.should have_selector("input", :type => "submit", :value => "Save")
    end
  end

  it "should provide a link to return to the events page" do
    assign(:branch, @branch_1)
    assign(:purposes, [{ 'type_1' => 'Type 1' }, { 'type_2' => 'Type 2' }])

    render
    rendered.should have_selector("a", :href => branch_events_path(@branch_1)) do |events_link|
      events_link.should contain("Return to Events")
    end
  end
end
