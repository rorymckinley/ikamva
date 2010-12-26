require 'spec_helper'

describe BranchesController do

  before(:each) do
    Branch.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
    @branch_2 = Branch.create! :name => 'Test 2'
  end

  it "should list all the branches" do
    get :index
    response.should be_success
    response.should render_template("branches/index")
    assigns(:branches).should eq [@branch_1, @branch_2]
  end

  it "should provide a way to create a new branch" do
    get :new
    response.should be_success
    response.should render_template("branches/new")
  end

  it "should create a new branch" do
    post :create, :branch => { 'name' => 'Test 99' }
    Branch.count.should == 3
    Branch.find(:last).name.should == 'Test 99'
  end

  it "should redirect to the list page after creation" do
    post :create, :branch => { 'name' => 'Test 99' }
    response.should redirect_to :action => :index
  end

  it "should provide a success message after creation" do
    post :create, :branch => { 'name' => 'Test 99' }
    flash[:branch].should == 'Branch Created'
  end

  it "should provide a way to edit an existing branch" do
    get :edit, :id => @branch_1.id
    response.should be_success
    response.should render_template("branches/edit")
    assigns[:branch].should == @branch_1
  end

  it "should update an existing branch" do
    put :update, :id => @branch_1.id, :branch => {:name => 'Branch Update'}
    @branch_1.reload.name.should == 'Branch Update'
  end

  it "should redirect to the list page after updating" do
    put :update, :id => @branch_1.id, :branch => {:name => 'Branch Update'}
    response.should redirect_to :action => :index
  end

  it "should provide a success message after updating a record" do
    put :update, :id => @branch_1.id, :branch => {:name => 'Branch Update'}
    flash[:branch].should == 'Branch Updated'
  end
end
