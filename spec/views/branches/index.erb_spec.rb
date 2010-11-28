require 'spec_helper'

describe "branches/index.erb" do
  before(:each) do
    Branch.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
    @branch_2 = Branch.create! :name => 'Test 2'
  end
  it "should list the branches present in the database" do
    assign(:branches, [ @branch_1, @branch_2 ])
    render
    rendered.should contain("Test 1")
    rendered.should contain("Test 2")
  end
  it "should provide a link to the form for creating a new branch" do
    assign(:branches, [ @branch_1, @branch_2 ])
    render
    rendered.should have_selector("a", :href => new_branch_path)
  end
end


