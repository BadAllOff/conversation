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
      # формируем масив данных для записи в базу
      @membership.group_id        = params[:group_id]
      @membership.user_id         = params[:user_id]
      @membership.accepted_by     = current_user.id
      @membership.status          = 'joined'
      @membership.admission_time  = Time.now
      # Сообщение о принятии
      member_accepted = 'User accepted.'
      if member.present?
        groupm = GroupMembership.where(["group_id = ? AND user_id = ?", @membership.group_id.to_i, @membership.user_id.to_i]).first
        groupm.status          = 'joined'
        groupm.admission_time  = Time.now
        groupm.save
        @group.members_counter +=1
        @group.save
        respond_to do |format|
          format.html { redirect_to group_path(@group), notice: member_accepted }
          end
      else

      end
    else

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

  def member
    GroupMembership.where(["group_id = ? AND user_id = ?", @membership.group_id.to_i, @membership.user_id.to_i]).first(1)
  end

  def get_member
    GroupMembership.where(["group_id = ? AND user_id = ? AND status = 'joined'", @membership.group_id.to_i, @membership.user_id.to_i])
  end

end
