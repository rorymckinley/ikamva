require 'spec_helper'

describe BranchesController do
  it "should list all the branches" do
    Branch.should_receive(:find).with(:all)
    get :index
    response.should be_success
    response.should render_template("branches/index")
  end
  it "should provide a way to create a new branch" do
    get :new
    response.should be_success
  end
end
