class Admin::OrdersController < Admin::BaseController
  def index
    @statuses = Order.statuses.keys
    @orders = if params[:status].present?
              Order.select(:id, :first_name, :last_name, :email, :status, :total_amount, :created_at).where(status: params[:status]).page(params[:page])
    else
              Order  .select(:id, :first_name, :last_name, :email, :status, :total_amount, :created_at).page(params[:page])
    end
  end

  def show
    @order = Order.includes(order_items: :item).find(params[:id])
  end

  def edit
    @statuses = Order.statuses.keys
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])

    if @order.update(order_params)
      OrderMailer.status_updated(@order).deliver_later
      redirect_to admin_orders_path, notice: "Order status updated"
    else
      render :edit
    end
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end
end
