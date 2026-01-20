class CartItemsController < ApplicationController
  def create
  authorize :cart_item, :create?

  item_data = {
    "id" => cart_item_params[:id].to_i,
    "title" => cart_item_params[:title],
    "price" => cart_item_params[:price].to_f,
    "description" => cart_item_params[:description],
    "quantity" => cart_item_params[:quantity].to_i
  }

  if session[:cart][item_data["id"].to_s]
    session[:cart][item_data["id"].to_s]["quantity"] += item_data["quantity"]
  else
    session[:cart][item_data["id"].to_s] = item_data
  end

  store_cart_cookie
  flash.now[:notice] = "Item added to cart"
  end

  def update
    authorize :cart_item, :update?

    item_id = cart_item_params[:id].to_s
    if session[:cart][item_id] && cart_item_params[:quantity].to_i >= 1
      session[:cart][item_id]["quantity"] = cart_item_params[:quantity].to_i
    end

    store_cart_cookie
    load_cart
  end

  def destroy
    authorize :cart_item, :destroy?

    session[:cart].delete(cart_item_params[:id].to_s)
    store_cart_cookie
    load_cart
    flash.now[:notice] = "Item removed from cart"
  end

  private

  def cart_item_params
    params.permit(:id, :quantity, :title, :price, :description)
  end
end
