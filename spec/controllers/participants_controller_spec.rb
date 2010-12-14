require 'spec_helper'

describe ParticipantsController do
  before(:each) do
    Branch.delete_all
    @branch_1 = Branch.create :name => 'Test 1'
    Participant.delete_all
  end

  it "should provide a form that can be used to enter details for new participants" do
    get :new, :branch_id => @branch_1.id
    assigns[:branch].should eql @branch_1
    assigns[:participation_types].should eql Participant.participation_types
    response.should be_success
    response.should render_template('participants/new')
  end
  
  it "should allow a new participant to be created" do
    post :create, :branch_id => @branch_1.id, :participant => { :name => 'Test Participant', :card_number => '1235', :participation => 'volunteer'}
    @branch_1.reload
    @branch_1.participants.size.should == 1
    @branch_1.participants.first.card_number.should == '1235'
  end

  it "should redirect to the listing of all the branch's participants after creation" do
    post :create, :branch_id => @branch_1.id, :participant => { :name => 'Test Participant', :card_number => '1235', :participation => 'volunteer'}
    response.should redirect_to branch_participants_path(@branch_1)
  end

  it "should post a message to indicate that creation of the participant was sucessful" do
    post :create, :branch_id => @branch_1.id, :participant => { :name => 'Test Participant', :card_number => '1235', :participation => 'volunteer'}
    flash[:participant].should == 'Participant created'
  end

  it "should list all participants for a branch" do
    post :create, :branch_id => @branch_1.id, :participant => { :name => 'Test Participant', :card_number => '1235', :participation => 'volunteer'}
    get :index, :branch_id => @branch_1.id
    assigns[:participants].should == @branch_1.reload.participants
    assigns[:participation_types].should eql Participant.participation_types
    assigns[:branch].should == @branch_1
    response.should render_template("participants/index")
  end

  it "should provide a form to edit a participant" do
    post :create, :branch_id => @branch_1.id, :participant => { :name => 'Test Participant', :card_number => '1235', :participation => 'volunteer'}
    @branch_1.reload
    get :edit, :branch_id => @branch_1.id, :id => @branch_1.participants.first.id
    assigns[:branch].should == @branch_1
    assigns[:participant].should == @branch_1.participants.first
    assigns[:participation_types].should eql Participant.participation_types
    response.should render_template("participants/edit")
  end

  it "should allow a participant to be edited" do
    post :create, :branch_id => @branch_1.id, :participant => { :name => 'Test Participant', :card_number => '1235', :participation => 'volunteer'}
    @branch_1.reload
    put :update, :branch_id => @branch_1.id, :id => @branch_1.participants.first.id, :participant => { :name => 'Edited Participant', :card_number => '1236', :participation => 'learner' }
    @branch_1.participants.first.reload
    @branch_1.participants.first.name.should == 'Edited Participant'
    @branch_1.participants.first.card_number.should == '1236'
    @branch_1.participants.first.participation.should == 'learner'
  end

  it "should redirect to the branch's particpant list after updating a participant" do
    post :create, :branch_id => @branch_1.id, :participant => { :name => 'Test Participant', :card_number => '1235', :participation => 'volunteer'}
    @branch_1.reload
    put :update, :branch_id => @branch_1.id, :id => @branch_1.participants.first.id, :participant => { :name => 'Edited Participant', :card_number => '1236', :participation => 'learner' }
    response.should redirect_to branch_participants_path(@branch_1)
  end

  it "should provide a message to indicate that the participant was updated" do
    post :create, :branch_id => @branch_1.id, :participant => { :name => 'Test Participant', :card_number => '1235', :participation => 'volunteer'}
    @branch_1.reload
    put :update, :branch_id => @branch_1.id, :id => @branch_1.participants.first.id, :participant => { :name => 'Edited Participant', :card_number => '1236', :participation => 'learner' }
    flash[:participant].should == "Participant Updated"
  end
end
