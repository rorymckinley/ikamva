class UploadsController < ApplicationController
  def new
  end

  def branches
    contents = params[:upload][:stuff].read
    Upload.import_branches(contents)
    render :text => ''
  end
end
