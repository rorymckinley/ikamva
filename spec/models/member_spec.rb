require 'spec_helper'

describe Member do
  it "should return a collection of supported participation types" do
    Member.participation_types.should == [{'learner' => 'Learner'}, {'volunteer' => 'Volunteer'}]
  end
end
