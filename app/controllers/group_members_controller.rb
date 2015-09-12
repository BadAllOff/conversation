#TODO - refactor this sh*t
class GroupMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_membership, only: [:join, :accept_member, :leave]

  def join

    case @group.privacy
      when 'public'
        @membership.status        = 'joined'
        msg_if_member_not_exists  = 'You have joined the group'
      when 'closed'
        @membership.status        = 'pending'
        msg_if_member_not_exists  = 'Request to join has been sent. Please wait for a response from the group members.'
        msg_if_member_pending     = 'Request to join has been sent previously. Please wait for a response from the group members.'
      when 'private'
        @membership.status        = 'pending'
        msg_if_member_not_exists  = 'Request to join has been sent. Please wait for a response from the group members.'
        msg_if_member_pending     = "Request to join has been sent previously. Please wait for a response from the initiator of the group."
      else
        # nothing
    end
    msg_if_member_joined      = 'You are already in this group.'

    @membership.group_id        = params[:group_id]
    @membership.user_id         = current_user.id
    @membership.accepted_by     = current_user.id
    @membership.admission_time  = Time.now

    @member = member
    if @member.present?
      respond_to do |format|
        if @member.first.status == 'joined'
          format.html { redirect_to group_path(@group), notice: msg_if_member_joined }
        else
          format.html { redirect_to group_path(@group), alert: msg_if_member_pending }
        end
      end
    else
      @membership.save
      if @group.privacy == 'public'
        @group.members_counter +=1
        @group.save
      end
      respond_to do |format|
        format.html { redirect_to group_path(@group), notice: msg_if_member_not_exists}
      end
    end
  end

  def accept_member
    if @group.user_id == current_user.id
      @membership_request = get_membership_request(params[:group_id], params[:user_id])
      if @membership_request.present?
        @membership_request.first.update(
                                    status:          'joined',
                                    admission_time:  Time.now,
                                    accepted_by: current_user.id
        )
        @group.members_counter +=1
        @group.save
        respond_to do |format|
          format.html { redirect_to group_path(@group), notice: 'User accepted.' }
        end
      end
    elsif member?(params[:group_id], current_user.id) && @group.privacy == 'closed'
      @membership_request = get_membership_request(params[:group_id], params[:user_id])
      if @membership_request.present?
        @membership_request.first.update(
            status:          'joined',
            admission_time:  Time.now,
            accepted_by: current_user.id
        )
        @group.members_counter +=1
        @group.save
        respond_to do |format|
          format.html { redirect_to group_path(@group), notice: 'User accepted.' }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to group_path(@group), alert: 'Action prohibited.' }
      end
    end
  end

  def leave
    @membership.group_id        = params[:group_id]
    @membership.user_id         = current_user.id

    if member.present?
      GroupMembership.destroy_all(["group_id = ? AND user_id = ?", @membership.group_id.to_i, @membership.user_id.to_i])
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

  def set_membership
    @membership = GroupMembership.new()
  end

  def get_membership_request(group_id, user_id)
    GroupMembership.where(["group_id = ? AND user_id = ?", group_id.to_i, user_id.to_i]).first(1)
  end

  def member
    GroupMembership.where(["group_id = ? AND user_id = ?", @membership.group_id.to_i, @membership.user_id.to_i]).first(1)
  end

  def get_member
    GroupMembership.where(["group_id = ? AND user_id = ? AND status = 'joined'", @membership.group_id.to_i, @membership.user_id.to_i])
  end

  def member?(group_id, user_id)
    GroupMembership.where(["group_id = ? AND user_id = ? AND status = 'joined'", group_id.to_i, user_id.to_i]).first(1)
  end

end
