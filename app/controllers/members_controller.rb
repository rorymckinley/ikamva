class MembersController < ApplicationController
  def new
    @branch = Branch.find(params[:branch_id])
    @participation_types = Member.participation_types
    render :layout => "member"
  end

  def create
    member = Branch.find(params[:branch_id]).members.create! params[:member]
    flash[:member] = "Member created with ID of #{member.id}"
    redirect_to branch_members_path(:branch_id => params[:branch_id])
  end

  def index
    @branch = Branch.find(params[:branch_id])
    @participation_types = Member.participation_types
    @members = @branch.members
  end

  def edit
    @branch = Branch.find(params[:branch_id])
    @member = Member.find(params[:id])
    @participation_types = Member.participation_types
    render :layout => "member"
  end

  def update
    Member.find(params[:id]).update_attributes! params[:member]
    flash[:member] = 'Member Updated'
    redirect_to branch_members_path(Branch.find(params[:branch_id]))
  end
end
