# TODO HOME and other paths
# TODO VK registration when app and OAuth will work correctly
class AuthenticationsController < ApplicationController
  # def index
  #   @authentications = current_user.authentications.all
  # end
  #
  # def destroy
  #   @authentication = Authentication.find(params[:id])
  #   @authentication.destroy
  #   redirect_to authentications_url, :notice => "Successfully destroyed authentication."
  # end

  # def home
  #
  # end

  def failure
    flash[:alert] = 'Sorry. Something wrong happened. We are working on that problem now.'
    redirect_to root_path
  end

  def twitter
    omni = request.env["omniauth.auth"]
    # raise omni.to_yaml
    authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])

    if authentication
      flash[:notice] = "Logged in Successfully with Twitter"
      sign_in_and_redirect User.find(authentication.user_id)
    elsif current_user
      token = omni['credentials'].token
      token_secret = omni['credentials'].secret

      current_user.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)
      flash[:notice] = "Authentication successful. With Twitter"
      sign_in_and_redirect current_user
    else
      user = User.new
      user.apply_omniauth(omni)
      user.first_name = omni.info.name

      if user.save
        flash[:notice] = "Logged in. With Twitter"
        sign_in_and_redirect User.find(user.id)
      else
        session[:omniauth] = omni.except('extra')
        session["devise.user_attributes"] = user.attributes
        redirect_to new_user_registration_path
      end
    end
  end

  def facebook
    omni = request.env["omniauth.auth"]
   #raise omni.to_yaml
    authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])

    if authentication
      flash[:notice] = "Logged in Successfully with Facebook"
      sign_in_and_redirect User.find(authentication.user_id)
    elsif current_user
      token = omni['credentials'].token
      token_secret = ''

      current_user.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)
      flash[:notice] = "Authentication successful. With Facebook"
      sign_in_and_redirect current_user
    else
      user = User.new
      user.apply_omniauth(omni)
      user.email      = omni['info'].email
      user.first_name = omni['info'].first_name
      user.last_name  = omni['info'].last_name

      user.skip_confirmation!
      if user.save
        flash[:notice] = "Logged in."
        sign_in_and_redirect User.find(user.id)
      else
        session[:omniauth] = omni.except('extra')
        session["devise.user_attributes"] = user.attributes
        redirect_to new_user_registration_path
      end
    end
  end


end
