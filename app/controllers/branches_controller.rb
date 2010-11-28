class BranchesController < ApplicationController
  def index
    @branches = Branch.find(:all)
  end
  def new
  end
end
