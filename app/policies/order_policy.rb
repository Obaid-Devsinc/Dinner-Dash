class OrderPolicy < ApplicationPolicy
  # Admin-only actions
  def index_admin?
    user&.admin?
  end

  def show_admin?
    user&.admin?
  end

  def mark_paid?
    user&.admin?
  end

  def complete?
    user&.admin?
  end

  def cancel?
    user&.admin?
  end

  def index?
    user.present? && (user.admin? || user.customer?)
  end

  def show?
    user.customer? && record.user_id == user.id
  end

  def create?
    user.customer?
  end

  def new?
    create?
  end

  class Scope < Scope
    def resolve
      return scope.none unless user.present?

      user&.admin? ? scope.all : scope.where(user_id: user.id)
    end
  end
end
