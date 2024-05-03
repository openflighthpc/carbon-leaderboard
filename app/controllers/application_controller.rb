class ApplicationController < ActionController::Base
  require 'json_web_token'
  before_action :configure_permitted_parameters, if: :devise_controller?

  def not_found
    render json: { error: 'not_found' }
  end

  # Round a float to a specified number of significant figures
  def signif(val, digits)
    val.zero? ? 0 : val.round(-(Math.log10(val).ceil - digits))
  end

  # Authorization which does not allow nil tokens
  # Use this for things that CANNOT be done anonymously
  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      decoded = JsonWebToken.decode(header)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: "Auth Error: #{e.message}", status: :unauthorized
    rescue JWT::DecodeError => e
      render json: "Auth Error: #{e.message}", status: :unauthorized
    end
  end

  # Authorization which allows nil tokens.
  # Use this for actions that don't REQUIRE a sign-in, but have extra functionality for signed-in users.
  def authorize_anonymous
    header = request.headers['Authorization']
    if header
      header = header.split(' ').last
    else
      return
    end
    begin
      decoded = JsonWebToken.decode(header)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: "Auth Error: #{e.message}", status: :unauthorized
    rescue JWT::DecodeError => e
      render json: "Auth Error: #{e.message}", status: :unauthorized
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email])
  end
end
