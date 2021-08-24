class ApplicationController < ActionController::Base
  include Pundit
	before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::NotNullViolation, with: :null_values_not_allowed
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authenticate_user!
  

  def after_sign_in_path_for resource
    stored_location_for(resource) || dashboard_index_path
  end

  protected
  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation)}
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password)}
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def null_values_not_allowed
    flash[:alert] = "OOPS! You forgot to enter some values. Null values are not allowed!"
    redirect_to dashboard_index_path
  end

  def record_not_found
    flash[:alert] = "No record found!"
    redirect_to(request.referrer || root_path)
  end


end
