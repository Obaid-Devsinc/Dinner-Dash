class OrdersController < ApplicationController
  before_action :set_page_params, only: [:index]
  before_action :authenticate_user!
  before_action :check_cart, only: %i[new create]
  before_action :set_order_params, only: [:create]
  before_action :set_order, only: %i[show mark_paid complete cancel]

  def index
    if current_user.admin?
      authorize Order, :index_admin?
      @statuses = Order.statuses.keys
      @orders = params[:status].present? ? Order.by_status(params[:status]).page(params[:page]) : Order.page(params[:page])
    else
      authorize Order
      @orders = current_user.orders.with_items_count
    end
  end

  def show
    if current_user.admin?
      authorize @order, :show_admin?
      @order = Order.includes(order_items: :item).find(params[:id])
    else
      authorize @order
      @order = current_user.orders.includes(order_items: :item).find(params[:id])
    end
  end

  # Customer only
  def new
    authorize Order
    load_cart
    @order = current_user.orders.new
  end

  def create
    authorize Order
    result = CreateOrderService.new(user: current_user, cart: session[:cart] || {}, order_params: @order_params).call

    if result[:error]
      redirect_to cart_path, alert: result[:error]
    else
      session[:cart] = {}
      cookies.delete(:cart)
      redirect_to order_path(result[:order]), notice: 'Order placed successfully!'
    end
  end

  def mark_paid
    update_order_status(:paid, 'Order marked as paid.', :mark_paid?)
  end

  def complete
    update_order_status(:completed, 'Order marked as completed.', :complete?)
  end

  def cancel
    update_order_status(:cancelled, 'Order cancelled successfully.', :cancel?)
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_order_params
    @order_params = params.require(:order).permit(:email, :phone, :first_name, :last_name, :address, :city, :zip)
  end

  def set_page_params
    params.permit(:status, :page)
  end

  def check_cart
    cart = session[:cart] || {}
    redirect_to cart_path if cart.empty?
  end

  def update_order_status(new_status, success_message, policy_method)
    authorize @order, policy_method
    result = UpdateOrderStatusService.new(order: @order, new_status: new_status).call
    redirect_back fallback_location: orders_path, notice: result[:success] ? success_message : result[:error]
  end
end
