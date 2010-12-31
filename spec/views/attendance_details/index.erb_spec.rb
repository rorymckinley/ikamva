require "spec_helper"

describe "attendance_details/index" do
  before(:each) do
    Branch.delete_all
    Event.delete_all
    Participant.delete_all
    AttendanceDetail.delete_all

    @branch_1 = Branch.create! :name => 'Test 1'
    @event = @branch_1.events.create! :purpose => 'tutorial', :start => Time.now, :end => Time.now + 2.hours
    @participant_1 = Participant.create! :name => 'Part One', :card_number => '1234'
    @participant_2 = Participant.create! :name => 'Part Two', :card_number => '2234'
    @detail_1 = @event.attendance_details.create :participant => @participant_1, :status => 'full'
    @detail_2 = @event.attendance_details.create :participant => @participant_2, :status => 'partial'
  end

  it "should render a list of all attendance details for an event" do
    assign(:branch, @branch_1)
    assign(:event, @event)
    render
    rendered.should contain 'Part One'
    rendered.should contain 'Full'
    rendered.should contain 'Part Two'
    rendered.should contain 'Partial'
  end

  it "should provide a link to edit an attendance detail record" do
    assign(:branch, @branch_1)
    assign(:event, @event)
    render
    render.should have_selector("a", :href => edit_branch_event_attendance_detail_path(@branch_1, @event, @detail_1)) do |edit_link|
      edit_link.should contain("Edit Attendance Detail")
    end
  end

  it "should display success messages for updates" do
    assign(:branch, @branch_1)
    assign(:event, @event)
    flash[:attendance_detail] = 'Test Flash'
    render
    render.should contain("Test Flash")
  end
end
