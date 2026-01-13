
class UserPolicy < ApplicationPolicy
  def admin_access?
    user.admin?
  end
end
