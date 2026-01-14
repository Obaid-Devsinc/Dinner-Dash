class OrdersController < ApplicationController
  include LoadCart

  before_action :authenticate_user!
  before_action :check_cart, only: [ :new, :create ]
  before_action :set_order_params, only: [ :create ]

  def index
    @orders = current_user.orders
    .select("orders.*, COUNT(order_items.id) AS order_items_count")
    .left_joins(:order_items)
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
    cart = session[:cart]

    cart.each do |item_id, qty|
      item = Item.find(item_id)

      if item.retired?
        flash[:alert] = "#{item.title} is retired. Please remove it from your cart before placing the order."
        redirect_to cart_path
        return
      end
    end

    order = current_user.orders.create!(
      @order_params.merge(
        total_amount: calculate_cart_total(cart)
      )
    )

    cart.each do |item_id, qty|
      item = Item.find(item_id)
      order.order_items.create!(
        item: item,
        quantity: qty,
        price: item.price
      )
    end

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

  def calculate_cart_total(cart)
    subtotal = cart.sum do |item_id, qty|
      item = Item.find(item_id)
      item.price * qty
    end
    tax = (subtotal * 0.08).round(2)
    subtotal + tax
  end

  def set_order_params
    @order_params = params.require(:order).permit(
      :email, :phone, :first_name, :last_name,
      :address, :city, :zip
    )
  end
end
