require "spec_helper"

describe "members/edit.erb" do
  before(:each) do
    Member.delete_all
    Branch.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
    @member_first = @branch_1.members.create! :first_name => 'test', :surname => '1', :card_number => '12345', :participation => 'learner'
  end

  it "should list the details of the member being edited" do
    assign(:branch, @branch_1)
    assign(:member, @member_first)
    assign(:participation_types, [ {'learner' => 'Learner'}, {'volunteer' => 'Volunteer'} ])
    render
    rendered.should have_selector("form", :method => "post", :action => branch_member_path(@branch_1, @member_first)) do |form|
      form.should have_selector("input", :type => "hidden", :name => "_method", :value => "put")
      form.should have_selector("input", :type => "hidden", :name => "authenticity_token")
      form.should have_selector("input", :type => 'text', :name => "member[name]", :value => @member_first.name )
      form.should have_selector("input", :type => 'text', :name => "member[card_number]", :value => @member_first.card_number )
      form.should have_selector("select", :name => "member[participation]") do |select|
        select.should have_selector("option", :value => @member_first.participation, :selected => 'selected')
        select.should have_selector("option", :value => 'volunteer')
      end
      form.should have_selector("input", :type => "submit", :value => "Save")
    end
  end
  it "should provide a link to return to the member listing" do
    assign(:branch, @branch_1)
    assign(:member, @member_first)
    assign(:participation_types, [ {'learner' => 'Learner'}, {'volunteer' => 'Volunteer'} ])
    render
    rendered.should have_selector("a", :href => branch_members_path(@branch_1)) do |return_to_list|
      return_to_list.should contain("Return To Member List")
    end
  end
end
