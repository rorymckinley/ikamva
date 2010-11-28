class BranchesController < ApplicationController
  def index
    @branches = Branch.find(:all)
  end
  def new
  end
  def create
    Branch.create! :name => params[:name]
    redirect_to(:action => :index)
  end
end
