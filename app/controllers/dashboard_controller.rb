class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize :dashboard, :index?

    @ordered_orders = Order.ordered.count
    @completed_orders = Order.completed.count
    @paid_orders = Order.paid.count
    @cancelled_orders = Order.cancelled.count
    @total_customers = User.customer.count
    @total_revenue = Order.completed.sum(:total_amount)
    @latest_customers = User.customer.limit(5)
  end
end
