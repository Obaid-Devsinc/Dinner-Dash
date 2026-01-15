module LoadCart
  def load_cart
  cart = session[:cart] || {}

  @cart_items = []
  @cart_subtotal = 0
  @cart_tax = 0
  @cart_total = 0

  return if cart.empty?

  items = Item.where(id: cart.keys)

  items.each do |item|
    qty = cart[item.id.to_s].to_i
    subtotal = item.price * qty

    @cart_items << {
      product: item,
      quantity: qty,
      subtotal: subtotal
    }

    @cart_subtotal += subtotal
  end

  @cart_tax = (@cart_subtotal * 0.08).round(2)
  @cart_total = @cart_subtotal + @cart_tax
end
end
