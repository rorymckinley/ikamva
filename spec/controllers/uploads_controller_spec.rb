require 'spec_helper'

describe UploadsController do
  render_views

  before(:each) do
    Branch.delete_all
    Event.delete_all
    Member.delete_all
    AttendanceDetail.delete_all
    authorised
  end
  it "should allow a file containing branch details to be uploaded" do
    post :branches, :upload => { :stuff => Rack::Test::UploadedFile.new(File.join(File.dirname(__FILE__),'../fixtures/branches.csv')) }
    Branch.all.should have(3).elements
  end
  it "should generate branches, events, learners and attendance details from a combined upload file" do
    post :combined, :upload => { :stuff => Rack::Test::UploadedFile.new(File.join(File.dirname(__FILE__),'../fixtures/combined.csv')) }
    Branch.all.should have(2).elements
    Event.all.should have(3).elements
  end
  it "should return display stats for the upload" do
    post :combined, :upload => { :stuff => Rack::Test::UploadedFile.new(File.join(File.dirname(__FILE__),'../fixtures/combined.csv')) }
    response.body.should =~ /:branches=>2/
  end
end
