require "spec_helper"

describe "attendance_details/edit" do
  before(:each) do
    Branch.delete_all
    Event.delete_all
    Member.delete_all
    AttendanceDetail.delete_all

    @branch= Branch.create! :name => 'Test 1'
    @event = @branch.events.create! :purpose => 'tutorial', :start => Time.now, :end => Time.now + 2.hours
    @member = Member.create! :name => 'Part One', :card_number => '1234'
    @attendance_detail = @event.attendance_details.create! :status => 'full', :member => @member
  end

  it "should provide a form that can be used to edit an attendance detail record" do
    assign(:branch, @branch)
    assign(:event, @event)
    assign(:attendance_detail, @attendance_detail)
    render
    rendered.should contain("Edit Attendance Detail for #{@member.name}")
    rendered.should have_selector("form", :action => branch_event_attendance_detail_path(@branch, @event, @attendance_detail), :method => "post") do |form|
      form.should have_selector("select", :name => "attendance_detail[status]") do |select|
        select.should have_selector("option", :value => "full", :selected => "selected") do |selected_option|
          selected_option.should contain("Full")
        end
        select.should have_selector("option", :value => "partial")
      end
      form.should have_selector("input", :type => "submit", :value => "Save")
      form.should have_selector("input", :type => "hidden", :name => "_method", :value => "put")
      form.should have_selector("input", :name => "authenticity_token", :type => "hidden")
    end
  end

  it "should provide a link to return to the event" do
    assign(:branch, @branch)
    assign(:event, @event)
    assign(:attendance_detail, @attendance_detail)
    render
    rendered.should have_selector('a', :href => branch_event_path(@branch, @event)) do |event_link|
      event_link.should contain("Return to Event")
    end
  end
end
