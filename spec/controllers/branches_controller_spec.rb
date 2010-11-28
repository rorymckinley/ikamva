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
    post :create, :name => 'Test 99'
    Branch.count.should == 3
    Branch.find(:last).name.should == 'Test 99'
  end

  it "should redirect to the list page after creation" do
    post :create, :name => 'Test 99'
    response.should redirect_to :action => :index
  end
end
