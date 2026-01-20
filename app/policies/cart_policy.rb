class CartPolicy < ApplicationPolicy
  def show?
    public_access?
  end

  class Scope < Scope
    def resolve
      !user&.admin? ? scope : scope.none
    end
  end
end
