class BranchesController < ApplicationController
  def index
    @branches = Branch.find(:all)
  end

  def new
  end

  def edit
    @branch = Branch.find(params[:id])
  end

  def create
    Branch.create! :name => params[:name]
    flash[:branch] = 'Branch Created'
    redirect_to(:action => 'index')
  end

  def update
    Branch.find(params[:id]).update_attributes! params[:branch]
    flash[:branch] = 'Branch Updated'
    redirect_to(:action => :index)
  end
end
