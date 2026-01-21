class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize :dashboard, :index?

    @stats = {
      orders: {
        ordered: Order.ordered.count,
        completed: Order.completed.count,
        paid: Order.paid.count,
        cancelled: Order.cancelled.count
      },
      customers: {
        total: User.customer.count,
        latest: User.customer.limit(5)
      },
      revenue: {
        total: Order.completed.sum(:total_amount)
      }
    }
  end
end
