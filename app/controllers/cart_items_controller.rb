class CartItemsController < ApplicationController
  def create
    authorize :cart_item, :create?

    item_id = cart_item_params[:id].to_s

    if session[:cart][item_id]
      session[:cart][item_id]['quantity'] += cart_item_params[:quantity].to_i
    else
      session[:cart][item_id] =
        cart_item_params
          .to_h
          .transform_values
          .with_index do |value, i|
            case cart_item_params.keys[i]
            when 'id', 'quantity'
              value.to_i
            when 'price'
              value.to_f
            else
              value
            end
          end
    end

    store_cart_cookie
    flash.now[:notice] = 'Item added to cart'
  end

  def update
    authorize :cart_item, :update?

    item_id = cart_item_params[:id].to_s
    session[:cart][item_id]['quantity'] = cart_item_params[:quantity].to_i if session[:cart][item_id] && cart_item_params[:quantity].to_i >= 1

    store_cart_cookie
    load_cart

    cart_data = { items: @cart_items, subtotal: @cart_subtotal.round(2), tax: @cart_tax.round(2), total: @cart_total.round(2) }

    respond_to do |format|
      format.json { render json: cart_data }
    end
  end

  def destroy
    authorize :cart_item, :destroy?

    session[:cart].delete(cart_item_params[:id].to_s)
    store_cart_cookie
    load_cart

    cart_data = { items: @cart_items, subtotal: @cart_subtotal.round(2), tax: @cart_tax.round(2), total: @cart_total.round(2) }

    respond_to do |format|
      format.json { render json: cart_data }
    end
  end

  private

  def cart_item_params
    params.permit(:id, :quantity, :title, :price, :description)
  end
end
