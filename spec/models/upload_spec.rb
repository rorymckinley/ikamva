require 'spec_helper'

describe Upload do
  before(:each) do
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
      Upload.import_combined("Branch 1\nBranch 2")
      branches = Branch.all
      branches.should have(2).elements
      branches[1].name.should == "Branch 2"
    end
    it "should import a set of combined data and exclude duplicate branch entries" do
      Upload.import_combined("Branch 1\nBranch 2\n   Branch 1   ")
      branches = Branch.all
      branches.should have(2).elements
      branches[1].name.should == "Branch 2"
    end
    it "should strip any trailing or leading whitespace from the branch name before saving it" do
      Upload.import_combined("Branch 1\n    Branch 2    ")
      branches = Branch.all
      branches.should have(2).elements
      branches[1].name.should == "Branch 2"
    end
  end
  context "Events" do
    before(:each) do
      Event.delete_all
    end
    it "should import event data and link it to the branch specified in the record" do
      Upload.import_combined("\"Branch 1\",\"tutorial\"\n\"Branch 2\",\"homework\"")
      events = Event.all
      events.should have(2).elements
      events[1].purpose.should == 'homework'
      events[0].branch.name.should == "Branch 1"
      events[1].branch.name.should == "Branch 2"
    end
    it "should import event data and link it to a branch that already exist in the database" do
      branch = Branch.create! :name => "Branch 1"
      Upload.import_combined("\"Branch 1\",\"tutorial\"\n\"Branch 2\",\"homework\"")
      Event.first.branch.should == branch
    end
  end
end
