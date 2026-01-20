class CategoryPolicy < ApplicationPolicy
  def index?
    admin_access?
  end

  def show?
    true
  end

  def new?
    create?
  end

  def create?
    admin_access?
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
      user.admin? ? scope.all : scope.none
    end
  end
end
