class OrdersController < ApplicationController
  include LoadCart

  before_action :authenticate_user!
  before_action :check_cart, only: [ :new, :create ]
  before_action :set_order_params, only: [ :create ]

  def index
    @orders = current_user.orders
    .left_joins(:order_items)
    .select(:id, :status, :total_amount, :created_at, "COUNT(order_items.id) AS order_items_count")
    .group(:id)
  end

  def show
    @order = current_user.orders
    .includes(order_items: :item)
    .find(params[:id])
  end

  def new
    load_cart
    @order = current_user.orders.new
  end

  def create
    cart = session[:cart] || {}
    return redirect_to cart_path, alert: "Your cart is empty" if cart.empty?

    item_ids = cart.keys
    items = Item.where(id: item_ids).index_by(&:id)

    items.each do |id, item|
      if item.retired?
        flash[:alert] = "#{item.title} is retired. Please remove it from cart before placing order."
        redirect_to cart_path
        return
      end
    end

    subtotal = cart.sum { |item_id, qty| items[item_id.to_i].price * qty }
    tax = (subtotal * 0.08).round(2)
    total = subtotal + tax

    order = current_user.orders.create!(@order_params.merge(total_amount: total))

    order_items_data = cart.map do |item_id, qty|
      item = items[item_id.to_i]
      { order_id: order.id, item_id: item.id, quantity: qty, price: item.price, created_at: Time.current, updated_at: Time.current }
    end

    OrderItem.insert_all!(order_items_data) if order_items_data.any?

    OrderMailer.order_confirmation(order).deliver_later

    session[:cart] = {}
    cookies.delete(:cart)

    redirect_to order_path(order), notice: "Order placed successfully!"
  end


  private

  def check_cart
    cart = session[:cart]
    redirect_to cart_path if cart.empty?
  end

  def set_order_params
    @order_params = params.require(:order).permit(
      :email, :phone, :first_name, :last_name,
      :address, :city, :zip
    )
  end
end
