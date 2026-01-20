class OrderPolicy < ApplicationPolicy
  def index_admin?
    admin_access?
  end

  def show_admin?
    admin_access?
  end

  def mark_paid?
    admin_access?
  end

  def complete?
    admin_access?
  end

  def cancel?
    admin_access?
  end

  def index?
    public_access?
  end

  def show?
    public_access? && record.user_id == user.id
  end

  def create?
    public_access?
  end

  def new?
    create?
  end

  class Scope < Scope
    def resolve
      user&.admin? ? scope.all : scope.where(user_id: user.id)
    end
  end
end
