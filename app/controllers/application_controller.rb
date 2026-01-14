class ApplicationController < ActionController::Base
  include Pundit
  include CartHelper

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :persist_cart_before_logout, if: -> { params[:action] == "destroy" && params[:controller] == "devise/sessions" }

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :display_name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :image, :display_name ])
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    else
      root_path
    end
  end

  private

  def user_not_authorized
    redirect_to root_path, alert: "You are not authorized to access this page."
  end
end
