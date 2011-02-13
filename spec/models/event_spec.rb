require 'spec_helper'

describe Event do
  it "should return a list of event purposes for selection" do
    Event.event_purposes.should == [
                                     { 'branchcom' => 'Branchcom Meeting' }, 
                                     { 'careers' => 'Careers Indaba'},
                                     { 'computer' => 'Computer Class'},
                                     { 'excursion' => 'Excursion' }, 
                                     { 'holiday' => 'Holiday Programme' }, 
                                     { 'homework' => 'Homework' }, 
                                     { 'parents' => 'Parents Meeting'},
                                     { 'prize' => 'Prize Giving'},
                                     { 'talent' => 'Talent Show'},
                                     { 'tutorial' => 'Tutorial' }, 
                                     { 'training' => 'Volunteer Training' }, 
                                     { 'workshop' => 'Workshop' }
                                   ]
  end

  it "should return a time after which members are considered to be late" do
    event = Event.create! :start => Time.now, :end => Time.now + 1.hour, :purpose => 'tutorial'
    event.late_after.should == event.start + 20.minutes
  end
end
