# app/services/update_order_status_service.rb
class UpdateOrderStatusService
  attr_reader :order, :new_status

  def initialize(order:, new_status:)
    @order = order
    @new_status = new_status
  end

  def call
    case new_status
    when :paid
      order.mark_paid!
    when :completed
      order.complete_order!
    when :cancelled
      order.cancel_order!
    else
      raise 'Invalid status'
    end

    OrderMailer.status_updated(order).deliver_later
    { success: true }
  rescue StandardError => e
    { success: false, error: e.message }
  end
end
