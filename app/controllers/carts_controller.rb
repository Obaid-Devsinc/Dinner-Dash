class CartsController < ApplicationController
  def show
    authorize :cart, :show?
    load_cart
  end
end
