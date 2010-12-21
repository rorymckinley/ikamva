require 'spec_helper'

describe AttendanceDetail do
  before(:each) do
  end

  context "on creation" do
    it "should set its status to to full if no explicit status is provided and it is before the start of a session" do
      event = Event.create :purpose => 'homework' , :start => Time.now + 10.minutes, :end => Time.now + 1.hour
      participant = Participant.create! :name => 'Part One', :card_number => '1234'
      detail = AttendanceDetail.create! :event_id => event.id, :participant_id => participant.id
      detail.status.should == 'full'
    end
  end
end
