class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, :only => [:create, :update]
  
  def new
    if params[:potential_user].present?
      @potential_user = PotentialUser.create(params.require(:potential_user).permit(:email, :phone_number))
      @user = User.new({:email => @potential_user.email, :phone_number => @potential_user.phone_number})
      # respond_with @user
    else
      @user = User.new
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    build_resource(configure_permitted_parameters)
    resource.save

    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
  
  def update
    if params[:just_phone_number]
      respond_to do |format|
        current_user.update(params.require(:user).permit(:phone_number))
        format.js { render "reservations/ready_to_book.js.erb" }
      end
    else
      @user = User.where(:email => params[:user][:email]).first
      if !@user.provider.present? and @user.update_with_password(configure_permitted_parameters)
        flash[:success] = "Your profile updated successfully"
      elsif @user.provider.present? and @user.update_without_password(configure_permitted_parameters)
        flash[:success] = "Your profile updated successfully"
      else
        flash[:alert] = @user.errors.full_messages
      end
      redirect_to :back
    end
  end
  
  protected
  
  def configure_permitted_parameters
    if params[:commit] == "Sign up"
      params.require(:user).permit(:email, :password, :fullname, :phone_number, :cnic, :image, 
                                   :provider, :uid, :confirmed_at)
    else
      params.require(:user).permit(:email, :fullname, :phone_number, :description, :avatar,
                                   :password, :password_confirmation, :current_password, :cnic)
    end
  end

  def update
    if params[:just_phone_number]
      respond_to do |format|
        current_user.update(params.require(:user).permit(:phone_number))
        format.js { render "reservations/ready_to_book.js.erb" }
      end
    else
      @user = User.where(:email => params[:user][:email]).first
      if !@user.provider.present? and @user.update_with_password(configure_permitted_parameters)
        flash[:success] = "Your profile updated successfully"
      elsif @user.provider.present? and @user.update_without_password(configure_permitted_parameters)
        flash[:success] = "Your profile updated successfully"
      else
        flash[:alert] = @user.errors.full_messages
      end
      redirect_to :back
    end
  end
  
  protected
  
  def configure_permitted_parameters
    if params[:commit] == "Sign up"
      params.require(:user).permit(:email, :password, :fullname, :phone_number, :cnic, :image, 
                                   :provider, :uid, :confirmed_at)
    else
      params.require(:user).permit(:email, :fullname, :phone_number, :description, :avatar,
                                   :password, :password_confirmation, :current_password, :cnic)
    end
  end
  
  # def account_update_params
 #    devise_parameter_sanitizer.permit(:account_update, keys:[:fullname, :phone_number, :description, :avatar])
  #  end
end
