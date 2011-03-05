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
    Upload.import_combined("Branch 1\nBranch 2\n   Branch 1   ")
    branches = Branch.all
    branches.should have(2).elements
    branches[1].name.should == "Branch 2"
  end
  it "should strip any trailing or leading whitespace from the branch name before saving it" do
    Branch.delete_all
    Upload.import_combined("Branch 1\n    Branch 2    ")
    branches = Branch.all
    branches.should have(2).elements
    branches[1].name.should == "Branch 2"
  end
end
