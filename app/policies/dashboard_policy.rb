class DashboardPolicy < ApplicationPolicy
  def index?
    admin_access?
  end
end
