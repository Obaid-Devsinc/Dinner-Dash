class ApplicationController < ActionController::Base
  include Pundit
  include CartHelper

  layout :resolve_layout

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :initialize_cart, :load_cart_from_cookie
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :persist_cart_before_logout, if: -> { params[:action] == 'destroy' && params[:controller] == 'devise/sessions' }

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name display_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name image display_name])
  end

  def after_sign_in_path_for(resource)
    resource.admin? ? admin_dashboard_path : root_path
  end

  private

  def user_not_authorized
    if current_user&.admin?
      redirect_to admin_dashboard_path
    else
      redirect_to root_path
    end
  end

  def resolve_layout
    current_user&.admin? ? 'admin' : 'application'
  end
end
