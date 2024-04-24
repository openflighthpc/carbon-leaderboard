# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    @user = find_user
    if @user.nil?
      puts new_registration_path(:user)
      render json: { location: new_registration_path(:user) }, status: :see_other
    elsif !@user.valid_password?(params["user"]["password"])
      render json: { msg: "incorrect password" }, status: :unauthorized
    else
      sign_in(:user, @user)
      current_user.auth_token = JsonWebToken.encode(user_id: @user.id)
      current_user.save
      render json: { location: root_path }, status: :see_other
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def find_user
    user_param = params["user"]["username"]
    if user_param.match?(/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/)
      User.find_by(email: user_param)
    elsif user_param.match?(/^\w{4,18}$/)
      User.find_by(username: user_param)
    end
  end

end
