require "spec_helper"

describe "participants/edit.erb" do
  before(:each) do
    Participant.delete_all
    Branch.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
    @participant_first = @branch_1.participants.create! :name => 'test 1', :card_number => '12345', :participation => 'learner'
  end

  it "should list the details of the participant being edited" do
    assign(:branch, @branch_1)
    assign(:participant, @participant_first)
    assign(:participation_types, [ {'learner' => 'Learner'}, {'volunteer' => 'Volunteer'} ])
    render
    rendered.should have_selector("form", :method => "post", :action => branch_participant_path(@branch_1, @participant_first)) do |form|
      form.should have_selector("input", :type => "hidden", :name => "_method", :value => "put")
      form.should have_selector("input", :type => "hidden", :name => "authenticity_token")
      form.should have_selector("input", :type => 'text', :name => "participant[name]", :value => @participant_first.name )
      form.should have_selector("input", :type => 'text', :name => "participant[card_number]", :value => @participant_first.card_number )
      form.should have_selector("select", :name => "participant[participation]") do |select|
        select.should have_selector("option", :value => @participant_first.participation, :selected => 'selected')
        select.should have_selector("option", :value => 'volunteer')
      end
    end
  end
end
