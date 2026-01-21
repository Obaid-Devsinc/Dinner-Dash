class CartPolicy < ApplicationPolicy
  def show?
    user.nil? || user.customer?
  end

  class Scope < Scope
    def resolve
      !user&.admin? ? scope : scope.none
    end
  end
end
