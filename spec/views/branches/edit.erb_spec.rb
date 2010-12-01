require 'spec_helper'

describe "branches/edit.erb" do
  before(:each) do
    Branch.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
  end
  it "should return a form populated with the details of the branch to be edited" do
    assign(:branch, @branch_1)
    render
    rendered.should have_selector("form", :method => "post", :action => branch_path(@branch_1)) do |form|
      form.should have_selector("input", :type => "hidden", :name => "_method", :value => "put")
      form.should have_selector("input", :type => "text", :name => "branch[name]", :value => @branch_1.name)
      form.should have_selector("input", :type => "submit", :value => "Save")
      form.should have_selector("input", :type => "hidden", :name => "authenticity_token")
    end
  end
end

