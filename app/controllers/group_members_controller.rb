#TODO - refactor this sh*t
#TODO - refactor AR
#TODO - refactor counter
#TODO - refactor params
#TODO - refactor methods to crud maybe
class GroupMembersController < ApplicationController
  before_action :authenticate_user!
  around_filter :catch_not_found # catch RecordNotFound errors
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
        msg_if_member_not_exists  = 'Request to join has been sent. Please wait for a response from the initiator of the group.'
        msg_if_member_pending     = "Request to join has been sent previously. Please wait for a response from the initiator of the group."
      else
        # nothing
    end
    msg_if_member_joined        = 'You are already in this group.'

    @membership.group_id        = params[:group_id]
    @membership.user_id         = current_user.id
    @membership.accepted_by     = current_user.id
    @membership.admission_time  = Time.now

    @member = is_request?(params[:group_id], current_user.id)

    if @member.present?
      respond_to do |format|

        if @member.first.status == 'joined'
          format.html { redirect_to group_path(@group), notice: msg_if_member_joined }
        else
          format.html { redirect_to group_path(@group), alert: msg_if_member_pending }
        end
      end
    else
      if current_user.id == @group.user_id
        msg_if_member_not_exists = 'You are initiator. You are already in this group.'
      else
        @membership.save

        if @group.privacy == 'public'
          @group.members_counter +=1
          @group.save
        end
      end
      respond_to do |format|
        format.html { redirect_to group_path(@group), notice: msg_if_member_not_exists}
      end
    end
  end

  def accept_member
    if @group.user_id == current_user.id
      @membership_request = is_request?(params[:group_id], params[:user_id])

      if @membership_request.present?

        if @membership_request.first.status == 'pending'
          @membership_request.first.update(
                              status:         'joined',
                              admission_time: Time.now,
                              accepted_by:    current_user.id
                            )
          @group.members_counter +=1
          @group.save
          notice = 'User accepted.'
        else
          notice = 'The user is already in the group.'
        end

        respond_to do |format|
          format.html { redirect_to group_path(@group), notice: notice }
        end
      end
    elsif is_member?(params[:group_id], current_user.id).present? && @group.privacy == 'closed'
      @membership_request = is_request?(params[:group_id], params[:user_id])

      if @membership_request.present? && @membership_request.first.status == 'pending'
        @membership_request.first.update(
                            status:           'joined',
                            admission_time:   Time.now,
                            accepted_by:      current_user.id
                        )
        @group.members_counter +=1
        @group.save
        respond_to do |format|
          format.html { redirect_to group_path(@group), notice: 'User accepted.' }
        end
      else
        respond_to do |format|
          format.html { redirect_to group_path(@group), alert: 'Action prohibited.' }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to group_path(@group), alert: 'Action prohibited.' }
      end
    end
  end

  def decline_member
    if @group.user_id == current_user.id
      @membership_request = is_request?(params[:group_id], params[:user_id])

      if @membership_request.present?
        if  @membership_request.first.status == 'joined'
          @group.members_counter -=1
          @group.save
        end

        @membership_request.first.destroy
        respond_to do |format|
          format.html { redirect_to group_path(@group), alert: 'User declined.' }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to group_path(@group), alert: 'Action prohibited.' }
      end
    end
  end

  def leave
    @membership.group_id = params[:group_id]
    @membership.user_id  = current_user.id


    @member = is_request?(params[:group_id], current_user.id)
    if @member.present?

      if @member.first.status == 'joined'
        @group.members_counter -=1
        @group.save
      end
      GroupMembership.destroy_all(["group_id = ? AND user_id = ?", @membership.group_id.to_i, @membership.user_id.to_i])

      respond_to do |format|
        format.html { redirect_to group_path(@group), notice: "You left the group." }
      end
    else
      alert_msg = 'You are not in group.'
      if current_user.id == @group.user_id
        alert_msg = 'You are initiator. You you cant leave this group.'
      end
      respond_to do |format|
        format.html { redirect_to group_path(@group), alert: alert_msg }
      end
    end
  end

  # TODO feature method - INVITE user to group
  # def invite
  # end

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

  def is_request?(group_id, user_id)
    GroupMembership.where(["group_id = ? AND user_id = ?", group_id.to_i, user_id.to_i]).first(1)
  end

  def is_member?(group_id, user_id)
    GroupMembership.where(["group_id = ? AND user_id = ? AND status = 'joined'", group_id.to_i, user_id.to_i]).first(1)
  end

  def catch_not_found
    yield
  rescue ActiveRecord::RecordNotFound
    redirect_to groups_path, :flash => { :alert => "Record not found." }
  end
end
