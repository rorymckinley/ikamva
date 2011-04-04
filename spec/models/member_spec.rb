require 'spec_helper'

describe Member do
  it "should return a collection of supported participation types" do
    Member.participation_types.should == [{'learner' => 'Learner'}, {'volunteer' => 'Volunteer'}]
  end
  it "should give a total of the attendance details linked to the member" do
    member = Member.create! :first_name => "Fred", :surname => "Flintstone"
    member.attendance_details.create! :status => "full", :event_id => 1
    member.attendance_details.create! :status => "partial", :event_id => 2
    member.attendance_total.should == 1.5
  end
end
