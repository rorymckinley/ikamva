require 'spec_helper'

describe Upload do
  before(:each) do
      @contents = "\"Branch 1\",\"tutorial\",\"2011-01-01\"\n\"Branch 2\",\"homework\",\"2011-01-02\""
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
      branches[1].name.should == "Branch 2"
    end
    it "should import a set of combined data and exclude duplicate branch entries" do
      Upload.import_combined("\"Branch 1\",\"tutorial\",\"2011-01-01\"\n\"Branch 2\",\"homework\",\"2011-01-02\"\n\"   Branch 1   \",\"homework\",\"2011-01-02\"")
      branches = Branch.all
      branches.should have(2).elements
      branches[1].name.should == "Branch 2"
    end
    it "should strip any trailing or leading whitespace from the branch name before saving it" do
      Upload.import_combined("\"Branch 1\",\"tutorial\",\"2011-01-01\"\n\"   Branch 2   \",\"homework\",\"2011-01-02\"")
      branches = Branch.all
      branches.should have(2).elements
      branches[1].name.should == "Branch 2"
    end
  end
  context "Events" do
    before(:each) do
      Time.zone = "Pretoria"
      @contents = "\"Branch 1\",\"tutorial\",\"2011-01-01\",8\n\"Branch 2\",\"homework\",\"2011-01-02\",9"
      Event.delete_all
    end
    it "should import event data and link it to the branch specified in the record" do
      Upload.import_combined(@contents)
      events = Event.all
      events.should have(2).elements
      events[1].purpose.should == 'homework'
      events[0].branch.name.should == "Branch 1"
      events[1].branch.name.should == "Branch 2"
    end
    it "should import event data and link it to a branch that already exist in the database" do
      branch = Branch.create! :name => "Branch 1"
      Upload.import_combined(@contents)
      Event.first.branch.should == branch
    end
    it "should create start and end timestamps for each event" do
      Upload.import_combined(@contents)
      Event.first.start.should == Time.parse("2011-01-01") + 2.hours
      Event.first.end.should == Time.parse("2011-01-01") + 4.hours
    end
    it "should link an event to a grade" do
      Upload.import_combined(@contents)
      Event.first.grade.should == 8
    end
  end
  context "Members" do
    before(:each) do 
      Member.delete_all
      @contents = "\"Branch 1\",\"tutorial\",\"2011-01-01\",8,\"Learner\",\"One\"\n\"Branch 2\",\"homework\",\"2011-01-02\",9,\"Learner\",\"Two\""
    end
    it "should create members based on the records passed in" do
      Upload.import_combined(@contents)
      Member.all.should have(2).members
      Member.first.first_name.should == "Learner"
      Member.first.surname.should == "One"
    end
  end
end
