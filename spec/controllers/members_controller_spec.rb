require 'spec_helper'

describe MembersController do
  before(:each) do
    authorised
    Branch.delete_all
    @branch_1 = Branch.create :name => 'Test 1'
    Member.delete_all
  end

  it "should provide a form that can be used to enter details for new members" do
    get :new, :branch_id => @branch_1.id
    assigns[:branch].should eql @branch_1
    assigns[:participation_types].should eql Member.participation_types
    response.should be_success
    response.should render_template('members/new')
  end
  
  it "should allow a new member to be created" do
    post :create, :branch_id => @branch_1.id, :member => { :name => 'Test Member', :card_number => '1235', :participation => 'volunteer'}
    @branch_1.reload
    @branch_1.members.size.should == 1
    @branch_1.members.first.card_number.should == '1235'
  end

  it "should redirect to the listing of all the branch's members after creation" do
    post :create, :branch_id => @branch_1.id, :member => { :name => 'Test Member', :card_number => '1235', :participation => 'volunteer'}
    response.should redirect_to branch_members_path(@branch_1)
  end

  it "should post a message to indicate that creation of the member was sucessful" do
    post :create, :branch_id => @branch_1.id, :member => { :name => 'Test Member', :card_number => '1235', :participation => 'volunteer'}
    flash[:member].should == 'Member created'
  end

  it "should list all members for a branch" do
    post :create, :branch_id => @branch_1.id, :member => { :name => 'Test Member', :card_number => '1235', :participation => 'volunteer'}
    get :index, :branch_id => @branch_1.id
    assigns[:members].should == @branch_1.reload.members
    assigns[:participation_types].should eql Member.participation_types
    assigns[:branch].should == @branch_1
    response.should render_template("members/index")
  end

  it "should provide a form to edit a member" do
    post :create, :branch_id => @branch_1.id, :member => { :name => 'Test Member', :card_number => '1235', :participation => 'volunteer'}
    @branch_1.reload
    get :edit, :branch_id => @branch_1.id, :id => @branch_1.members.first.id
    assigns[:branch].should == @branch_1
    assigns[:member].should == @branch_1.members.first
    assigns[:participation_types].should eql Member.participation_types
    response.should render_template("members/edit")
  end

  it "should allow a member to be edited" do
    post :create, :branch_id => @branch_1.id, :member => { :name => 'Test Member', :card_number => '1235', :participation => 'volunteer'}
    @branch_1.reload
    put :update, :branch_id => @branch_1.id, :id => @branch_1.members.first.id, :member => { :name => 'Edited Member', :card_number => '1236', :participation => 'learner' }
    @branch_1.members.first.reload
    @branch_1.members.first.name.should == 'Edited Member'
    @branch_1.members.first.card_number.should == '1236'
    @branch_1.members.first.participation.should == 'learner'
  end

  it "should redirect to the branch's particpant list after updating a member" do
    post :create, :branch_id => @branch_1.id, :member => { :name => 'Test Member', :card_number => '1235', :participation => 'volunteer'}
    @branch_1.reload
    put :update, :branch_id => @branch_1.id, :id => @branch_1.members.first.id, :member => { :name => 'Edited Member', :card_number => '1236', :participation => 'learner' }
    response.should redirect_to branch_members_path(@branch_1)
  end

  it "should provide a message to indicate that the member was updated" do
    post :create, :branch_id => @branch_1.id, :member => { :name => 'Test Member', :card_number => '1235', :participation => 'volunteer'}
    @branch_1.reload
    put :update, :branch_id => @branch_1.id, :id => @branch_1.members.first.id, :member => { :name => 'Edited Member', :card_number => '1236', :participation => 'learner' }
    flash[:member].should == "Member Updated"
  end
end
