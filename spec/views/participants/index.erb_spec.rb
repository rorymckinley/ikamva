require "spec_helper"

describe "participants/index.erb" do
  before(:each) do
    Branch.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
    @participant_first = @branch_1.participants.create! :name => 'test 1', :card_number => '12345', :participation => 'learner'
    @participant_second = @branch_1.participants.create! :name => 'test 2', :card_number => '12346', :participation => 'volunteer'
  end
  it "should list all the participants in the order provided" do
    assign(:participants, [ @participant_first, @participant_second ])
    assign(:participation_types, [ {'learner' => 'Learner'}, {'volunteer' => 'Volunteer'} ])
    render
    rendered.should contain('test 1')
    rendered.should contain('12345')
    rendered.should contain('Learner')
  end
end
