require 'spec_helper'

describe AttendanceRecordReport do
  before(:each) do
    t = Time.parse("2011-04-01 00:00:00 SAST")
    @branch_1 = Branch.create! :name => "Branch One"
    @branch_2 = Branch.create! :name => "Branch Two"
    @member_1 = @branch_1.members.create! :first_name => "Fred", :surname => "Flintstone", :grade => 8, :registration_date => t - 30.days
    @member_2 = @branch_2.members.create! :first_name => "Barney", :surname => "Rubble", :grade => 8, :registration_date => t - 30.days
    (1..100).each do |i|
      @branch_1.events.create! :start => t - i.days, :end => (t - i.days) + 2.hours
      @branch_2.events.create! :start => t - i.days, :end => (t - i.days) + 2.hours
    end
  end
  it "should provide a listing of all the members for a branch and show the attendance stats" do
    AttendanceRecordReport.generate(@branch_1.id)[:report].should == [{:first_name => "Fred", :surname => "Flintstone", :grade => 8, :percentage_attendance => 0, :attendance_record => nil}]
  end

  it "should mark a member with between 75 and 79% attendance as status green" do
    @branch_1.events[0,75].each { |event| event.attendance_details.create! :member_id => @member_1.id, :status => "full" }
    AttendanceRecordReport.generate(@branch_1.id)[:report].should == [{:first_name => "Fred", :surname => "Flintstone", :grade => 8, :percentage_attendance => 75.0, :attendance_record => "green"}]
    @branch_2.events[0,79].each { |event| event.attendance_details.create! :member_id => @member_2.id, :status => "full" }
    AttendanceRecordReport.generate(@branch_2.id)[:report].should == [{:first_name => "Barney", :surname => "Rubble", :grade => 8, :percentage_attendance => 79.0, :attendance_record => "green"}]
  end

  it "should mark a member with between 80 and 89% attendance as status silver" do
    @branch_1.events[0,80].each { |event| event.attendance_details.create! :member_id => @member_1.id, :status => "full" }
    AttendanceRecordReport.generate(@branch_1.id)[:report].should == [{:first_name => "Fred", :surname => "Flintstone", :grade => 8, :percentage_attendance => 80.0, :attendance_record => "silver"}]
    @branch_2.events[0,89].each { |event| event.attendance_details.create! :member_id => @member_2.id, :status => "full" }
    AttendanceRecordReport.generate(@branch_2.id)[:report].should == [{:first_name => "Barney", :surname => "Rubble", :grade => 8, :percentage_attendance => 89.0, :attendance_record => "silver"}]
  end

  it "should mark a member with between 80 and 89% attendance as status gold" do
    @branch_1.events[0,90].each { |event| event.attendance_details.create! :member_id => @member_1.id, :status => "full" }
    AttendanceRecordReport.generate(@branch_1.id)[:report].should == [{:first_name => "Fred", :surname => "Flintstone", :grade => 8, :percentage_attendance => 90.0, :attendance_record => "gold"}]
    @branch_2.events[0,99].each { |event| event.attendance_details.create! :member_id => @member_2.id, :status => "full" }
    AttendanceRecordReport.generate(@branch_2.id)[:report].should == [{:first_name => "Barney", :surname => "Rubble", :grade => 8, :percentage_attendance => 99.0, :attendance_record => "gold"}]
  end

  it "should mark a member with 100% attendance as status platinum" do
    @branch_1.events[0,100].each { |event| event.attendance_details.create! :member_id => @member_1.id, :status => "full" }
    AttendanceRecordReport.generate(@branch_1.id)[:report].should == [{:first_name => "Fred", :surname => "Flintstone", :grade => 8, :percentage_attendance => 100.0, :attendance_record => "platinum"}]
  end
end
