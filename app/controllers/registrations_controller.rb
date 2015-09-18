class RegistrationsController < Devise::RegistrationsController

  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end

  protected

  def after_update_path_for(resource)
    edit_user_registration_path(resource)
  end
end
