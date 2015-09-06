class GroupMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group

  def join
    @group_membership = GroupMembership.new()
    @group_membership.group_id        = params[:group_id]
    @group_membership.user_id         = current_user.id
    case @group.privacy
      when 'public'
        @group_membership.status  = 'joined'
        msg_if_member_not_exists  = 'You have joined the group'
        msg_if_member_exists      = 'You are already in this group.'
      when 'private'
        @group_membership.status  = 'pending'
        msg_if_member_not_exists  = 'Request to join has been sent'
        msg_if_member_exists      = 'Request to join has been sent previously. Please wait for a response from the group members.'
      when 'closed'
        @group_membership.status  = 'pending'
        msg_if_member_not_exists  = 'Request to join has been sent'
        msg_if_member_exists      = "Request to join has been sent previously. Please wait for a response from the initiator of the group."
    end

    @group_membership.admission_time  = Time.now

    if member_exists?
      respond_to do |format|
        format.html { redirect_to group_path(@group), alert: msg_if_member_exists }
        # format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    else
      @group_membership.save
      @group.members_counter +=1
      @group.save
      respond_to do |format|
        format.html { redirect_to group_path(@group), notice: msg_if_member_not_exists }
        # format.json { redirect_to group_path(@group), status: :ok}
      end
    end
  end

  def leave
    @group_membership = GroupMembership.new()
    @group_membership.group_id        = params[:group_id]
    @group_membership.user_id         = current_user.id

    if member_exists?
      GroupMembership.destroy_all(["group_id = ? AND user_id = ?", @group_membership.group_id.to_i, @group_membership.user_id.to_i])
      @group.members_counter -=1
      @group.save

      respond_to do |format|
        format.html { redirect_to group_path(@group), notice: "You left the group." }
        # format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    else
      respond_to do |format|
        format.html { redirect_to group_path(@group), alert: 'You are not in group.' }
        # format.json { redirect_to group_path(@group), status: :ok}
      end
    end
  end


  def invite

  end



  private

  def get_params
    params.require(:group_id)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def member_exists?
    GroupMembership.exists?(["group_id = ? AND user_id = ?", @group_membership.group_id.to_i, @group_membership.user_id.to_i])
  end

  def get_member
    GroupMembership.where(["group_id = ? AND user_id = ?", @group_membership.group_id.to_i, @group_membership.user_id.to_i])
  end
end
