class UploadsController < ApplicationController
  def new
  end

  def branches
    contents = params[:upload][:stuff].read
    Upload.import_branches(contents)
    render :text => ''
  end

  def combined
    contents = params[:upload][:stuff].read
    render :text => Upload.import_combined(contents).inspect
  end
end
