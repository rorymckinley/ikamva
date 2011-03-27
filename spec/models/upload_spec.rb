require 'spec_helper'

describe Upload do
  before(:each) do
    @contents = %Q{"Branch","Surname","First Name","Grade","Registration Date","2011/02/18","2011/02/26"
"Branch One","Flintstone","Fred",10,"2011/02/01",1,0.5
"Branch Two","Rubble","Barney",9,"2011/02/01",,1}
    Branch.delete_all
  end
  context "branches" do
    it "should import csv data for branches and create the branches" do
      Upload.import_branches("Branch 1\nBranch 2")
      branches = Branch.all
      branches.should have(2).elements
      branches[1].name.should == "Branch 2"
    end
    it "should import a set of combined data and generate branch entries from the content" do
      Upload.import_combined(@contents)
      branches = Branch.all
      branches.should have(2).elements
      branches[1].name.should == "Branch Two"
    end
    it "should import a set of combined data and exclude duplicate branch entries" do
    @contents = %Q{"Branch","Surname","First Name","Grade","Registration Date","2011/02/18","2011/02/26"
"Branch One","Flintstone","Fred",10,"2011/02/01",1,0.5
"Branch Two","Rubble","Barney",9,"2011/02/01",,1
"  Branch One  ","Rubble","Barney",9,"2011/02/01",,1}
      Upload.import_combined(@contents)
      branches = Branch.all
      branches.should have(2).elements
      branches[1].name.should == "Branch Two"
    end
    it "should strip any trailing or leading whitespace from the branch name before saving it" do
    @contents = %Q{"Branch","Surname","First Name","Grade","Registration Date","2011/02/18","2011/02/26"
"Branch One","Flintstone","Fred",10,"2011/02/01",1,0.5
"    Branch Two  ","Rubble","Barney",9,"2011/02/01",,1}
      Upload.import_combined(@contents)
      branches = Branch.all
      branches.should have(2).elements
      branches[1].name.should == "Branch Two"
    end
  end
  context "Events" do
    before(:each) do
      Time.zone = "Pretoria"
      Event.delete_all
    end
    it "should create an event representing for which there has been attendance and linked to the appropriate grade" do
      Upload.import_combined(@contents)
      Event.all.should have(3).events
      Branch.find(:first, :conditions => { :name => 'Branch One'}).events.find(:all, :conditions => {:grade => 10}).should have(2).events
      Branch.find(:first, :conditions => { :name => 'Branch Two'}).events.find(:all, :conditions => {:grade => 9}).should have(1).event
    end
    it "should create artificial start and end times based on the date given" do
      Upload.import_combined(@contents)
      evt = Branch.find(:first, :conditions => { :name => 'Branch Two'}).events.first
      evt.start.strftime("%Y-%m-%d %H:%M:%S %z").should == "2011-02-26 02:00:00 +0200"
      evt.end.strftime("%Y-%m-%d %H:%M:%S %z").should == "2011-02-26 04:00:00 +0200"
    end
    it "should not create a duplicate event if there is already en event for a particular date-branch-grade combination" do
      @contents = %Q{"Branch","Surname","First Name","Grade","Registration Date","2011/02/18","2011/02/26"
"Branch One","Flintstone","Fred",10,"2011/02/01",1,0.5
"Branch One","van Pebbles","Mario",9,"2011/02/01",1,0.5
"Branch Two","Rubble","Barney",9,"2011/02/01",,1
"Branch Two","Rubble","Barney",9,"2011/02/01",0.5,1}
      Upload.import_combined(@contents)
      Event.all.should have(6).events
      Branch.find(:first, :conditions => { :name => 'Branch One'}).events.find(:all, :conditions => {:grade => 10}).should have(2).events
      Branch.find(:first, :conditions => { :name => 'Branch One'}).events.find(:all, :conditions => {:grade => 9}).should have(2).events
      Branch.find(:first, :conditions => { :name => 'Branch Two'}).events.find(:all, :conditions => {:grade => 9}).should have(2).events
    end
    it "should create weekday events as homework events and weekend events as tutorials" do
      Upload.import_combined(@contents)
      Event.find(:first, :conditions => { :start => Time.parse("2011-02-18 02:00:00 +0200")}).purpose.should == 'homework'
      Event.find(:first, :conditions => { :start => Time.parse("2011-02-26 02:00:00 +0200")}).purpose.should == 'tutorial'
    end
  end
  context "Members" do
    before(:each) do 
      Member.delete_all
    end
    it "should strip off trailing and leading spaces from member names"
    it "should check for duplicates members based on the trimmed member names"
    it "should create members based on the records passed in" do
      Upload.import_combined(@contents)
      Member.all.should have(2).members
      Member.first.first_name.should == "Fred"
      Member.first.surname.should == "Flintstone"
      Member.first.grade.should == 10
      Member.last.surname.should == "Rubble"
    end
    it "should link members to branches" do
      Upload.import_combined(@contents)
      Branch.find_by_name("Branch One").members.first.surname.should == "Flintstone"
      Branch.find_by_name("Branch Two").members.first.surname.should == "Rubble"
    end
    it "should default all members to learners" do
      Upload.import_combined(@contents)
      Member.first.participation.should == "learner"
    end
    it "should not create members if they already exist for that branch based on first name, surname and grade" do
      @contents = %Q{"Branch","Surname","First Name","Grade","Registration Date","2011/02/18","2011/02/26"
"Branch One","Flintstone","Fred",10,"2011/02/01",1,0.5
"Branch One","Flintstone","Fred",9,"2011/02/01",1,0.5
"Branch One","Right Said","Fred",9,"2011/02/01",1,0.5
"Branch Two","Rubble","Barney",9,"2011/02/01",,1
"Branch Two","Rubble","Betty",9,"2011/02/01",,1
"Branch Two","Flintstone","Fred",10,"2011/02/01",1,0.5
"Branch Two","Rubble","Barney",9,"2011/02/01",,1}
      Upload.import_combined(@contents)
      Branch.find_by_name("Branch One").members.find(:all, :conditions => { :surname => "Flintstone"}).should have(2).members
      Branch.find_by_name("Branch One").members.find(:all, :conditions => { :surname => "Right Said"}).should have(1).members
      Branch.find_by_name("Branch Two").members.find(:all, :conditions => { :first_name => "Betty"}).should have(1).member
      Branch.find_by_name("Branch Two").members.find(:all, :conditions => { :first_name => "Barney"}).should have(1).member
      Branch.find_by_name("Branch Two").members.find(:all, :conditions => { :surname => "Flintstone"}).should have(1).members
    end
  end
  context "Attendance Details" do
    before(:each) do
      Member.delete_all
      Branch.delete_all
      Event.delete_all
      AttendanceDetail.delete_all
      @contents = %Q{"Branch","Surname","First Name","Grade","Registration Date","2011/02/18","2011/02/26"
"Branch One","Flintstone","Fred",10,"2011/02/01",1,0.5
"Branch One","Rubble","Betty",10,"2011/02/01",1,0.5
"Branch One","Flintstone","Wilma",9,"2011/02/01",1,0.5
"Branch Two","Rubble","Barney",9,"2011/02/01",,1}
    end
    it "should create an attendance detail entry for the each attended event" do
      Upload.import_combined(@contents)
      AttendanceDetail.all.should have(7).entries
      branch_1 = Branch.find_by_name("Branch One")
      branch_2 = Branch.find_by_name("Branch Two")
      branch_1.events.find(:first, :conditions => { :start => Time.parse("2011/02/18")+2.hours, :grade => 10 }).members.should have(2).members
      branch_1.events.find(:first, :conditions => { :start => Time.parse("2011/02/18")+2.hours, :grade => 10 }).members.should include Member.find_by_first_name("Fred")
      branch_1.events.find(:first, :conditions => { :start => Time.parse("2011/02/18")+2.hours, :grade => 10 }).members.should include Member.find_by_first_name("Betty")

      branch_1.events.find(:first, :conditions => { :start => Time.parse("2011/02/26")+2.hours, :grade => 9 }).members.should == [Member.find_by_first_name("Wilma")]
      branch_2.events.find(:first, :conditions => { :start => Time.parse("2011/02/26")+2.hours, :grade => 9 }).members.should == [Member.find_by_first_name("Barney")]
    end
    it "should create attendance details with the correct status" do
      Upload.import_combined(@contents)
      fred = Member.find_by_first_name("Fred")
      branch_1 = Branch.find_by_name("Branch One")

      branch_1.events.find(:first, :conditions => { :start => Time.parse("2011/02/18")+2.hours, :grade => 10 }).attendance_details.find(:first, :conditions => { :member_id => fred.id }).status.should == 'full'
      branch_1.events.find(:first, :conditions => { :start => Time.parse("2011/02/26")+2.hours, :grade => 10 }).attendance_details.find(:first, :conditions => { :member_id => fred.id }).status.should == 'partial'
    end
    it "should not create duplicate attendance detail records" do
      @contents = %Q{"Branch","Surname","First Name","Grade","Registration Date","2011/02/18","2011/02/26"
"Branch One","Flintstone","Fred",10,"2011/02/01",1,0.5
"Branch One","Flintstone","Fred",10,"2011/02/01",1,0.5
"Branch Two","Rubble","Barney",9,"2011/02/01",,1}
      Upload.import_combined(@contents)
      fred = Member.find_by_first_name("Fred")
      branch_1 = Branch.find_by_name("Branch One")

      branch_1.events.find(:first, :conditions => { :start => Time.parse("2011/02/18")+2.hours, :grade => 10 }).attendance_details.should have(1).element
    end
  end
end
