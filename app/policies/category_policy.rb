class CategoryPolicy < ApplicationPolicy
  def index?
    user&.admin?
  end

  def show?
    true
  end

  def new?
    create?
  end

  def create?
    user&.admin?
  end

  def update?
    user&.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user&.admin?
  end

  class Scope < Scope
    def resolve
      user.admin? ? scope.all : scope.none
    end
  end
end
