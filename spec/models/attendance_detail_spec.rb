require 'spec_helper'

describe AttendanceDetail do
  before(:each) do
      @member = Member.create! :first_name => 'Part', :surname => 'One', :card_number => '1234'
  end

  context "on creation" do
    it "should set its status to to full if no explicit status is provided and it is before the start of a session" do
      event = Event.create :purpose => 'homework' , :start => Time.now + 10.minutes, :end => Time.now + 1.hour
      detail = AttendanceDetail.create! :event_id => event.id, :member_id => @member.id
      detail.status.should == 'full'
    end

    it "should set the status to partial if the attendance is outside the sessions late tolerance" do
      event = Event.create :purpose => 'homework' , :start => Time.now - 12.hours, :end => Time.now + 5.minutes
      detail = AttendanceDetail.create! :event_id => event.id, :member_id => @member.id
      detail.status.should == 'partial'
    end

    it "should leave the status unchanged if it has ben explicitly set" do
      event = Event.create :purpose => 'homework' , :start => Time.now + 10.minutes, :end => Time.now + 1.hour
      detail = AttendanceDetail.create! :event_id => event.id, :member_id => @member.id, :status => 'partial'
      detail.status.should == 'partial'
    end
  end

  context "on update" do
    it "should not attempt to calculate a status" do
      event = Event.create :purpose => 'homework' , :start => Time.now + 10.minutes, :end => Time.now + 1.hour
      detail = AttendanceDetail.create! :event_id => event.id, :member_id => @member.id
      detail.update_attributes! :status => nil
      detail.status.should be_nil
    end
  end
end
