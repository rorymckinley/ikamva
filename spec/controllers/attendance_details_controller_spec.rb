require 'spec_helper'

describe AttendanceDetailsController do
  before(:each) do
    Branch.delete_all
    Event.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
    @event = @branch_1.events.create! :purpose => 'tutorial', :start => Time.now, :end => Time.now + 2.hours
  end

  it "should provide a form for capturing attendance detail" do
    get :new, :branch_id => @branch_1.id, :event_id => @event.id
    response.should be_success
    response.should render_template "attendance_details/new"
  end

end
