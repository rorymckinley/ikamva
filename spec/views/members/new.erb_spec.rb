require 'spec_helper'

describe "members/new.erb" do
  before(:each) do
    Branch.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
  end
  it "should provide a form that can be used to create a new member" do
    assign(:branch, @branch_1)
    assign(:participation_types, [{"learner" => 'Learner'}, {"volunteer" => 'Volunteer'}])
    render
    rendered.should have_selector("form", :method => "post", :action => branch_members_path(@branch_1)) do |form|
      form.should have_selector("input", :type => "text", :name => "member[first_name]")
      form.should have_selector("input", :type => "text", :name => "member[surname]")
      form.should have_selector("input", :type => "text", :name => "member[card_number]" )
      form.should have_selector("input", :type => "text", :name => "member[gender]" )
      form.should have_selector("input", :type => "text", :name => "member[date_of_birth]" )
      form.should have_selector("input", :type => "text", :name => "member[mobile_number]" )
      form.should have_selector("input", :type => "text", :name => "member[parent_guardian_number]" )
      form.should have_selector("input", :type => "radio", :name => "member[disabilities]" )
      form.should have_selector("input", :type => "text", :name => "member[address]" )
      form.should have_selector("input", :type => "text", :name => "member[school]" )
      form.should have_selector("input", :type => "text", :name => "member[grade]" )
      form.should have_selector("input", :type => "text", :name => "member[email]" )
      form.should have_selector("input", :type => "text", :name => "member[id_number]" )
      form.should have_selector("input", :type => "text", :name => "member[citizenship]" )
      form.should have_selector("input", :type => "text", :name => "member[parent_guardian_1_relationship]" )
      form.should have_selector("input", :type => "text", :name => "member[parent_guardian_2_relationship]" )
      form.should have_selector("input", :type => "text", :name => "member[parent_guardian_1_job]" )
      form.should have_selector("input", :type => "text", :name => "member[parent_guardian_2_job]" )
      form.should have_selector("textarea", :name => "member[subjects]")
      form.should have_selector("textarea", :name => "member[ikamvanite_family_members]")

      form.should have_selector("select", :name => "member[participation]") do |select|
        select.should have_selector("option", :value => 'learner') do |option|
          option.should contain("Learner")
        end
        select.should have_selector("option", :value => "volunteer")
      end
      form.should have_selector("input", :type => 'submit', :value => 'Save changes')
    end
  end
  it "should provide a link to return to the members listing page" do
    assign(:branch, @branch_1)
    assign(:participation_types, [{"learner" => 'Learner'}, {"volunteer" => 'Volunteer'}])
    render
    rendered.should have_selector("a", :href => branch_members_path(@branch_1)) do |return_to_list|
      return_to_list.should contain("Return To Member List")
    end
  end
end
