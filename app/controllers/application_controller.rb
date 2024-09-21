class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
  before_action :set_user_cookie

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end

  private

  def set_user_cookie
    if user_signed_in?
      cookies.signed[:user_id] = current_user.id
    end
  end
  
end
