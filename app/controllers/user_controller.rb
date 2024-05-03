class UserController < ApplicationController

  def profile
    @user = User.find_by(username: params[:username])
    @user_owns_profile = user_signed_in? && @user&.id == current_user.id
    @devices = Device.where(user_id: @user.id)
  end
end
