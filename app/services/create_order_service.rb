class CreateOrderService
  attr_reader :user, :cart, :order_params, :order

  TAX_RATE = 0.08

  def initialize(user:, cart:, order_params:)
    @user = user
    @cart = cart
    @order_params = order_params
  end

  def call
    return { error: 'Cart is empty' } if cart.empty?

    items_in_db = Item.where(id: cart.keys)
    retired_item = items_in_db.find(&:retired?)
    return { error: "#{retired_item.title} is retired. Remove it from cart." } if retired_item

    subtotal = cart.sum { |_id, item| item['price'].to_f * item['quantity'].to_i }
    tax = (subtotal * TAX_RATE).round(2)
    total = subtotal + tax

    @order = user.orders.create!(order_params.merge(total_amount: total))

    order_items_data = cart.map { |_id, item| { order_id: order.id, item_id: item['id'], quantity: item['quantity'], price: item['price'], created_at: Time.current, updated_at: Time.current } }

    OrderItem.insert_all!(order_items_data) if order_items_data.any?
    OrderMailer.order_confirmation(order).deliver_later

    { order: order }
  end
end
