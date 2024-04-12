class ApplicationController < ActionController::Base
  require 'json_web_token'
  before_action :configure_permitted_parameters, if: :devise_controller?

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      decoded = JsonWebToken.decode(header)
      user = User.find(decoded[:user_id])
      { user: user, errors: nil }
    rescue ActiveRecord::RecordNotFound => e
      { errors: e.message }
    rescue JWT::DecodeError => e
      { errors: e.message }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email])
  end
end
