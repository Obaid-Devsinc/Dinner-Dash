class CartItemsController < ApplicationController
  include LoadCart
  def create
    @cart_items = []
    item_id  = params[:id].to_s
    quantity = params[:quantity].to_i

  if session[:cart][item_id]
    session[:cart][item_id] += quantity
  else
    session[:cart][item_id] = quantity
  end

  store_cart_cookie

  respond_to do |format|
    format.turbo_stream { flash.now[:notice] = "Item added to cart" }
    format.html { redirect_to cart_path, notice: "Item added to cart" }
  end
  end

  def update
    item_id = params[:id].to_s
    quantity = params[:quantity].to_i

    if session[:cart][item_id] && quantity >= 1
      session[:cart][item_id] = quantity
    end

    store_cart_cookie

    load_cart

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path }
    end
  end

  def destroy
    item_id = params[:id].to_s
    session[:cart].delete(item_id) if session[:cart][item_id]

    store_cart_cookie

    load_cart

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Item removed from cart" }
      format.html { redirect_to cart_path, notice: "Item removed from cart" }
    end
  end
end
