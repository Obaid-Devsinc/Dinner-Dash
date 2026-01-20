class CartItemsController < ApplicationController
  before_action :cart_item_params

  def create
    authorize :cart_item, :create?

    item_id = cart_item_params[:id].to_s
    quantity = cart_item_params[:quantity].to_i

    if session[:cart][item_id]
      session[:cart][item_id] += quantity
    else
      session[:cart][item_id] = quantity
    end

    store_cart_cookie
    flash.now[:notice] = 'Item added to cart'
  end

  def update
    authorize :cart_item, :update?

    item_id = cart_item_params[:id].to_s
    quantity = cart_item_params[:quantity].to_i

    session[:cart][item_id] = quantity if session[:cart][item_id] && quantity >= 1

    store_cart_cookie
    load_cart
  end

  def destroy
    authorize :cart_item, :destroy?

    item_id = cart_item_params[:id].to_s
    session[:cart].delete(item_id) if session[:cart][item_id]

    store_cart_cookie
    load_cart
    flash.now[:notice] = 'Item removed from cart'
  end

  private

  def cart_item_params
    params.permit(:id, :quantity)
  end
end
