require 'spec_helper'

describe "participants/new.erb" do
  before(:each) do
    Branch.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
  end
  it "should provide a form that can be used to create a new participant" do
    assign(:branch, @branch_1)
    assign(:participation_types, [{"learner" => 'Learner'}, {"volunteer" => 'Volunteer'}])
    render
    rendered.should have_selector("form", :method => "post", :action => branch_participants_path(@branch_1)) do |form|
      form.should have_selector("input", :type => "text", :name => "participant[name]")
      form.should have_selector("input", :type => "text", :name => "participant[card_number]" )
      form.should have_selector("select", :name => "participant[participation]") do |select|
        select.should have_selector("option", :value => 'learner') do |option|
          option.should contain("Learner")
        end
        select.should have_selector("option", :value => "volunteer")
      end
      form.should have_selector("input", :type => 'submit', :value => 'Save')
    end
  end
  it "should provide a link to return to the participants listing page" do
    assign(:branch, @branch_1)
    assign(:participation_types, [{"learner" => 'Learner'}, {"volunteer" => 'Volunteer'}])
    render
    rendered.should have_selector("a", :href => branch_participants_path(@branch_1)) do |return_to_list|
      return_to_list.should contain("Return To Participant List")
    end
  end
end
