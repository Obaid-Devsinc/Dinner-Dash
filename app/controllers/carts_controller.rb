class CartsController < ApplicationController
  include LoadCart

  def show
    load_cart
  end
end
