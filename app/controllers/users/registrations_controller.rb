# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  def new
    @user = User.new
  end

  def create
    if params[:sns_auth] == 'true'
      pass = Devise.friendly_token
      params[:user][:password] = pass
      params[:user][:password_confirmation] = pass
      super
    else
      @user = User.new(sign_up_params)
      render :new, status: :unprocessable_entity and return unless @user.valid?

      session['devise.regist_data'] = { user: @user.attributes }
      session['devise.regist_data'][:user]['password'] = params[:user][:password]
      @user_address = @user.build_user_address
      render :new_user_address, status: :accepted
    end
  end

  def create_user_address
    @user = User.new(session['devise.regist_data']['user'])
    @user_address = UserAddress.new(user_address_params)
    render :new_user_address, status: :unprocessable_entity and return unless @user_address.valid?

    @user.build_user_address(@user_address.attributes)
    @user.save
    session['devise.regist_data']['user'].clear
    sign_in(:user, @user)

    redirect_to root_path
  end

  private

  def user_address_params
    params.require(:user_address).permit(:user_postal_code, :prefecture_id, :user_city,
                                         :user_addresses, :user_building, :user_phone_number)
  end

  def new_user_address
    @user_address = UserAddress.new
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
