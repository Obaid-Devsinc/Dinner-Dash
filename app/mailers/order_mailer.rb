class OrderMailer < ApplicationMailer
  default from: "obaidbro9@gmail.com"

  def order_confirmation(order)
    @order = order
    @user = order.user
    mail(to: @order.email, subject: "Dinner Dash - Order ##{order.id} Confirmation")
  end

  def status_updated(order)
    @order = order
    mail(to: @order.email, subject: "Dinner Dash - Order ##{@order.id} Status Updated")
  end
end
