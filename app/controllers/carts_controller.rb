class CartsController < ApplicationController
  def show
    authorize :cart, :show?

    load_cart

    cart_data = {
      items: @cart_items,
      subtotal: @cart_subtotal.round(2),
      tax: @cart_tax.round(2),
      total: @cart_total.round(2)
    }

    respond_to do |format|
      format.html
      format.json { render json: cart_data }
    end
  end
end
