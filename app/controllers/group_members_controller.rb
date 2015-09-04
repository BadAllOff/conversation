class GroupMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  def join

    @group_membership = GroupMembership.new()
    @group_membership.group_id        = params[:group_id]
    @group_membership.user_id         = current_user.id
    @group_membership.status          = 'joined'
    @group_membership.admission_time  = Time.now

    if member_exists?
      respond_to do |format|
        format.html { redirect_to group_path(@group), alert: "You are already in this group." }
        # format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    else
      @group_membership.save
      @group.members_counter +=1
      @group.save
      respond_to do |format|
        format.html { redirect_to group_path(@group), notice: 'You have joined the group.' }
        # format.json { redirect_to group_path(@group), status: :ok}
      end
    end

  end

  def leave
  end

  private

  def get_params
    params.require(:group_id)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def member_exists?
    GroupMembership.where(["group_id = ? AND user_id = ?", @group_membership.group_id.to_i, @group_membership.user_id.to_i]).exists?(conditions = :none)
  end
end
