class Admin::DashboardController < Admin::BaseController
  def index
    @ordered_orders = Order.ordered.count
    @completed_orders = Order.completed.count
    @paid_orders = Order.paid.count
    @cancelled_orders = Order.cancelled.count
    @total_customers = User.customer.count
    @total_revenue = Order.where(status: [:completed]).sum(:total_amount)
    @latest_customers = User.customer
    .select(:id, :name, :email, :created_at, "COUNT(orders.id) AS order_count")
    .left_joins(:orders)
    .group(:id, :name)
    .limit(5)
  end
end
