require 'spec_helper'

describe Upload do
  it "should import csv data for branches and create the branches" do
    Branch.delete_all
    Upload.import_branches("Branch 1\nBranch 2")
    branches = Branch.all
    branches.should have(2).elements
    branches[1].name.should == "Branch 2"
  end
  it "should import a set of combined data and generate branch entries from the content" do
    Branch.delete_all
    Upload.import_combined("Branch 1\nBranch 2")
    branches = Branch.all
    branches.should have(2).elements
    branches[1].name.should == "Branch 2"
  end
  it "should import a set of combined data and exclude duplicate branch entries" do
    Branch.delete_all
    Upload.import_combined("Branch 1\nBranch 2\nBranch 1")
    branches = Branch.all
    branches.should have(2).elements
    branches[1].name.should == "Branch 2"
  end
end
