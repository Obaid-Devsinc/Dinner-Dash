class HomePolicy < ApplicationPolicy
  def index?
    public_access?
  end
end
