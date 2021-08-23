class ApplicationController < ActionController::Base
  include Pundit
	before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized



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
    flash[:alert] = "You are not allowed to delete the transaction"
    redirect_to transactions_path
  end

end
