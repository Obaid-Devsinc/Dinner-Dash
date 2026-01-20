class ItemPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    admin_access?
  end

  def new?
    create?
  end

  def update?
    admin_access?
  end

  def edit?
    update?
  end

  def destroy?
    admin_access?
  end

  class Scope < Scope
    def resolve
      user&.admin? ? scope.all : scope.active
    end
  end
end
