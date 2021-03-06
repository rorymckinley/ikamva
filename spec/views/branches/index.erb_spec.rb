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
  it "should display any flash messages related to the branch" do
    assign(:branches, [ @branch_1, @branch_2 ])
    flash[:branch] = 'Bah!'
    render
    rendered.should contain(flash[:branch])
  end
  it "should provide each listed branch with an edit link" do
    assign(:branches, [ @branch_1, @branch_2 ])
    render
    rendered.should have_selector("a", :href => edit_branch_path(@branch_1))
  end

  it "should provide a link to list the branch's members" do
    assign(:branches, [ @branch_1, @branch_2 ])
    render
    rendered.should have_selector("a", :href => branch_members_path(@branch_1)) do |link|
      link.should contain("Members")
    end
  end

  it "should provide a link to list the branch's events" do
    assign(:branches, [ @branch_1, @branch_2 ])
    render
    rendered.should have_selector("a", :href => branch_events_path(@branch_1)) do |link|
      link.should contain("Events")
    end
  end
end


