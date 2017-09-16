class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    attrs = [:name]
    devise_parameter_sanitizer.permit(:sign_up, keys: [attrs])
    devise_parameter_sanitizer.permit(:account_update, keys: [attrs])
  end
end
