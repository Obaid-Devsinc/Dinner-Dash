class Admin::DashboardController < Admin::BaseController
  def index
    @pending_orders = Order.pending.count
    @total_customers = User.customer.count
    @total_revenue = Order.where(status: [:paid, :shipped]).sum(:total_amount)
    @latest_customers = User.customer
    .select(:id, :name, :email, :created_at, "COUNT(orders.id) AS order_count")
    .left_joins(:orders)
    .group(:id, :name)
    .limit(5)
  end
end
