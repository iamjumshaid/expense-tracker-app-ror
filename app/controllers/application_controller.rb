class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?


  def after_sign_in_path_for resource
    stored_location_for(resource) || dashboard_index_path
  end

  protected
  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation)}
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password)}
  end

end
