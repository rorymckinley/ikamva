require 'spec_helper'

describe Session do
  it "should return a list of session types for selection" do
    Session.session_types.should == [['Branchcom Meeting', 'branchcom'], ['Excursion', 'excursion'], ['Holiday Programme', 'holiday'], ['Homework', 'homework'], ['Tutorial', 'tutorial'], ['Volunteer Training', 'training'], ['Workshop', 'workshop']]
  end
end
