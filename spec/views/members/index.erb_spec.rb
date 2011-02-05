require "spec_helper"

describe "members/index.erb" do
  before(:each) do
    Member.delete_all
    Branch.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
    @member_first = @branch_1.members.create! :first_name => 'test', :surname => '1', :card_number => '12345', :participation => 'learner'
    @member_second = @branch_1.members.create! :first_name => 'test', :surname => '2', :card_number => '12346', :participation => 'volunteer'
  end

  it "should list all the members for a branch" do
    assign(:members, [ @member_first, @member_second ])
    assign(:participation_types, [ {'learner' => 'Learner'}, {'volunteer' => 'Volunteer'} ])
    assign(:branch, @branch_1)
    render
    rendered.should contain('test 1')
    rendered.should contain('12345')
    rendered.should contain('Learner')
  end

  it "should provide a link to edit a member" do
    assign(:members, [ @member_first, @member_second ])
    assign(:participation_types, [ {'learner' => 'Learner'}, {'volunteer' => 'Volunteer'} ])
    assign(:branch, @branch_1)
    render
    rendered.should have_selector("a", :href => edit_branch_member_path(@branch_1, @member_first)) do |edit_link|
      edit_link.should contain("Edit Member")
    end
  end

  it "should provide a link to create a new member" do
    assign(:members, [ @member_first, @member_second ])
    assign(:participation_types, [ {'learner' => 'Learner'}, {'volunteer' => 'Volunteer'} ])
    assign(:branch, @branch_1)
    render
    rendered.should have_selector("a", :href => new_branch_member_path(@branch_1)) do |new_link|
      new_link.should contain("Create Member")
    end
  end

  it "should provide a link to return to the branch listing" do
    assign(:members, [ @member_first, @member_second ])
    assign(:participation_types, [ {'learner' => 'Learner'}, {'volunteer' => 'Volunteer'} ])
    assign(:branch, @branch_1)
    render
    rendered.should have_selector("a", :href => branches_path) do |branches_link|
      branches_link.should contain("Return to Branches")
    end
  end
end
