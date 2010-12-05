require 'spec_helper'

describe Event do
  it "should return a list of event types for selection" do
    Event.event_types.should == [['Branchcom Meeting', 'branchcom'], ['Excursion', 'excursion'], ['Holiday Programme', 'holiday'], ['Homework', 'homework'], ['Tutorial', 'tutorial'], ['Volunteer Training', 'training'], ['Workshop', 'workshop']]
  end
end
