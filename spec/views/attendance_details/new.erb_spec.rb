require 'spec_helper'

describe "attendance_details/new" do
  before(:each) do
    Branch.delete_all
    Event.delete_all
    @branch = Branch.create! :name => 'Test Branch'
    @event = @branch.events.create! :purpose => 'tutorial', :start => Time.now, :end => Time.now + 2.hours
  end

  it "should cpature details of the card number and the attendance status" do
    assign(:branch, @branch)
    assign(:event, @event)
    render
    rendered.should have_selector("form", :action => branch_event_attendance_details_path(@branch, @event), :method => "post") do |form|
      form.should have_selector("input", :type => "hidden", :name => "authenticity_token")
      form.should have_selector("input", :type => "text", :name => "member[id]")
      form.should have_selector("select", :name => "attendance_detail[status]") do |select|
        select.should have_selector('option', :value => '') do |default_option|
          default_option.should contain('Calculate Attendance Status')
        end
        select.should have_selector('option', :value => 'partial') do |option|
          option.should contain('Partial')
        end
        select.should have_selector('option', :value => 'full')
      end
      form.should have_selector("input", :type => "submit", :value => "Save")
    end
  end

  it "should display a status message if provided" do
    flash[:attendance_detail] = 'Test Message'
    render
    rendered.should contain 'Test Message'
  end

  it "should display an error message if provided" do
    flash[:error] = 'Test Error'
    render
    rendered.should contain 'Test Error'
  end

  it "should provide a link to return to the events listing" do
    assign(:branch, @branch)
    assign(:event, @event)
    render
    rendered.should have_selector("a", :href => branch_events_path(@branch)) do |events_link|
      events_link.should contain("Return to Events")
    end
  end
end
