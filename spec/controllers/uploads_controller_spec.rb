require 'spec_helper'

describe UploadsController do
  before(:all) do
    Branch.delete_all
  end
  before(:each) do
    authorised
  end
  it "should allow a file containing branch details to be uploaded" do
    post :branches, :upload => { :stuff => Rack::Test::UploadedFile.new(File.join(File.dirname(__FILE__),'../fixtures/branches.csv')) }
    Branch.find(:all).should have(3).elements
  end

end
