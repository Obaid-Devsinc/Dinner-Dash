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

  private

  def public_access?
    user.nil? || user.customer?
  end

  class Scope < Scope
    def resolve
      (user.nil? || user.customer?) ? scope : scope.none
    end
  end
end
