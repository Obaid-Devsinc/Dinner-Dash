class CartItemPolicy < ApplicationPolicy
  def create?
    public_access?
  end

  def update?
    public_access?
  end

  def destroy?
    public_access?
  end

  class Scope < Scope
    def resolve
      !user&.admin? ? scope : scope.none
    end
  end
end
