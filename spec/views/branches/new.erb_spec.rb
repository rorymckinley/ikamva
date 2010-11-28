require 'spec_helper'

describe "branches/new.erb" do
  it "should contain a form that will submit data for a new branch" do
    render
    rendered.should have_selector("form", :method => "post", :action => branches_path) do |form|
      form.should have_selector("input", :type => "text", :name => "name")
      form.should have_selector("input", :type => "submit")
    end
  end
end
