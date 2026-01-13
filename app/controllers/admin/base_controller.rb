# app/controllers/admin/base_controller.rb
class Admin::BaseController < ApplicationController
 layout "admin"

  before_action :authenticate_user!
  before_action :authorize_admin

  private

  def authorize_admin
    authorize current_user, :admin_access?
  end
end
