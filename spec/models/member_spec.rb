require 'spec_helper'

describe Participant do
  it "should return a collection of supported participation types" do
    Participant.participation_types.should == [{'learner' => 'Learner'}, {'volunteer' => 'Volunteer'}]
  end
end
