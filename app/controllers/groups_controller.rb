class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :show_map]
  before_action :authenticate_user!, except: [:index,:show,:new, :show_all]
  # GET /groups
  # GET /groups.json
  def index
    # todo change title of the page
    @groups = Group.all.where("groups.starts_at > ?", Time.now ).order(:starts_at)
  end

  def show_all
    # todo change title of the page
    @groups = Group.all.order(:starts_at)
    render 'index'
  end

  def my
    @groups = Group.all.where("groups.user_id = ?", current_user.id ).order(:created_at)
    render 'my_groups'
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  def show_map
    @hash = Gmaps4rails.build_markers(@group) do |group, marker|
      marker.lat group.latitude
      marker.lng group.longitude
      marker.infowindow ("<h4>#{group.group_name}</h4><p>#{group.venue}</p>")
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
    @hash = Gmaps4rails.build_markers(@group) do |group, marker|
      marker.lat group.latitude
      marker.lng group.longitude
    end
  end

  # GET /groups/1/edit
  def edit
    if @group.user_id == current_user.id
      @hash = Gmaps4rails.build_markers(@group) do |group, marker|
        marker.lat group.latitude || 40.36603994719198
        marker.lng group.longitude || 49.83751684427261
      end
    else
      redirect_to @group, alert: "You can't edit this group. Only owner can edit group.";
    end
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    @group.user_id = current_user.id

    respond_to do |format|
      if @group.save
        format.html { redirect_to group_path(@group), notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    if @group.user_id == current_user.id
      respond_to do |format|
        if @group.update(group_params)
          format.html { redirect_to @group, notice: 'Group was successfully updated.' }
          format.json { render :show, status: :ok, location: @group }
        else
          format.html { render :edit }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to @group, alert: "You can't edit this group. Only owner can edit group.";
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:group_name, :topics, :starts_at, :ends_at, :venue, :max_members, :privacy, :latitude, :longitude, :gmap_zoom)
    end
end
