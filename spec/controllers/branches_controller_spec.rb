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
  end
end
