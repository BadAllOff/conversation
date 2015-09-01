class HomeController < ApplicationController
  def index
    @groups = Group.all.where("groups.starts_at > ?", Time.now ).order(:starts_at)
    render 'groups/index'
  end
end
