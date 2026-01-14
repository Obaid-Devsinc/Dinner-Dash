class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [ :show, :mark_paid, :complete, :cancel ]

  def index
    @statuses = Order.statuses.keys
    @orders = if params[:status].present?
                Order.select(:id, :first_name, :last_name, :email, :status, :total_amount, :created_at)
                     .where(status: params[:status])
                     .page(params[:page])
    else
                Order.select(:id, :first_name, :last_name, :email, :status, :total_amount, :created_at)
                     .page(params[:page])
    end
  end

  def show
    @order = Order.includes(order_items: :item).find(params[:id])
  end

  def mark_paid
    if @order.ordered?
      @order.update!(status: :paid)
      OrderMailer.status_updated(@order).deliver_later
      redirect_back fallback_location: admin_orders_path, notice: "Order marked as paid."
    else
      redirect_back fallback_location: admin_orders_path, alert: "Only ordered orders can be marked as paid."
    end
  end

  def complete
    if @order.paid?
      @order.update!(status: :completed)
      OrderMailer.status_updated(@order).deliver_later
      redirect_back fallback_location: admin_orders_path, notice: "Order marked as completed."
    else
      redirect_back fallback_location: admin_orders_path, alert: "Only paid orders can be marked as completed."
    end
  end

  def cancel
    if @order.ordered? || @order.paid?
      @order.update!(status: :cancelled)
      OrderMailer.status_updated(@order).deliver_later
      redirect_back fallback_location: admin_orders_path, alert: "Order cancelled successfully."
    else
      redirect_back fallback_location: admin_orders_path, alert: "Only ordered or paid orders can be cancelled."
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
