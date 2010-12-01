require 'spec_helper'

describe SessionsController do
  before(:each) do
    Branch.delete_all
    @branch_1 = Branch.create! :name => 'Test 1'
  end

  it "should provide a way to capture the details of a new form" do
    get :new, :branch_id => @branch_1.id
    response.should be_success
    response.should render_template('sessions/new')
  end
end
