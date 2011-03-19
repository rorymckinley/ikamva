require 'spec_helper'

describe Upload do
  before(:each) do
    @contents = %Q{"Branch","Surname","First Name","Grade","2011/02/19","2011/02/26"
"Branch One","Flintstone","Fred",10,1,0.5
"Branch Two","Rubble","Barney",9,,1}
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
    @contents = %Q{"Branch","Surname","First Name","Grade","2011/02/19","2011/02/26"
"Branch One","Flintstone","Fred",10,1,0.5
"Branch Two","Rubble","Barney",9,,1
"  Branch One  ","Rubble","Barney",9,,1}
      Upload.import_combined(@contents)
      branches = Branch.all
      branches.should have(2).elements
      branches[1].name.should == "Branch Two"
    end
    it "should strip any trailing or leading whitespace from the branch name before saving it" do
    @contents = %Q{"Branch","Surname","First Name","Grade","2011/02/19","2011/02/26"
"Branch One","Flintstone","Fred",10,1,0.5
"    Branch Two  ","Rubble","Barney",9,,1}
      Upload.import_combined(@contents)
      branches = Branch.all
      branches.should have(2).elements
      branches[1].name.should == "Branch Two"
    end
  end
  context "Events" do
    before(:each) do
      Time.zone = "Pretoria"
      @contents = %Q{"Branch","Surname","First Name","Grade","2011/02/19","2011/02/26"
"Branch One","Flintstone","Fred",10,1,0.5
"Branch Two","Rubble","Barney",9,,1
      }
      Event.delete_all
    end
    it "should create an event for each branch-date-grade combination present in the data"
    it "should create artificial start and end times for each event"
  end
  context "Members" do
    before(:each) do 
      Member.delete_all
      @contents = %Q{"Branch","Surname","First Name","Grade","2011/02/19","2011/02/26"
"Branch One","Flintstone","Fred",10,1,0.5
"Branch Two","Rubble","Barney",9,,1
      }
    end
    it "should create members based on the records passed in" do
      pending
      Upload.import_combined(@contents)
      Member.all.should have(2).members
      Member.first.first_name.should == "Learner"
      Member.first.surname.should == "One"
    end
    it "should link members to branches" do
      pending
      Upload.import_combined(@contents)
      Branch.find_by_name("Branch 1").members.first.surname.should == "One"
      Branch.find_by_name("Branch 2").members.first.surname.should == "Two"
    end
  end
end
