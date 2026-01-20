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

    items = Item.where(id: cart.keys).index_by(&:id)

    retired_item = items.values.find(&:retired?)
    return { error: "#{retired_item.title} is retired. Remove it from cart." } if retired_item

    subtotal = cart.sum { |item_id, qty| items[item_id.to_i].price * qty }
    tax = (subtotal * TAX_RATE).round(2)
    total = subtotal + tax

    @order = user.orders.create!(order_params.merge(total_amount: total))

    order_items_data =
      cart.map do |item_id, qty|
        item = items[item_id.to_i]
        { order_id: order.id, item_id: item.id, quantity: qty, price: item.price, created_at: Time.current, updated_at: Time.current }
      end

    OrderItem.insert_all!(order_items_data) if order_items_data.any?

    OrderMailer.order_confirmation(order).deliver_later

    { order: order }
  end
end
