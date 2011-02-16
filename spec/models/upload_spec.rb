require 'spec_helper'

describe Upload do
  it "should import csv data for branches and create the branches" do
    Branch.delete_all
    Upload.import_branches("Branch 1\nBranch 2")
    branches = Branch.all
    branches.should have(2).elements
    branches[1].name.should == "Branch 2"
  end
end
