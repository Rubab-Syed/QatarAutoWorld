class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
  	@user = User.from_omniauth(request.env["omniauth.auth"])

  	if !@user.new_record?
  		sign_in_and_redirect @user, :event => :authentication
  		set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  	elsif !@user.valid?
  		session["devise.facebook_data"] = request.env["omniauth.auth"]
  		redirect_to new_user_registration_url
  	end
  end

  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])    

    if @user.valid?
        sign_in_and_redirect @user, :event => :authentication
        set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
    else
        session["devise.google_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
    end
  end
end
