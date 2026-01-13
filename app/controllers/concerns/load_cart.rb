module LoadCart
  def load_cart
    cart = session[:cart] || {}
    @cart_items = Item.where(id: cart.keys).map do |item|
      {
        product: item,
        quantity: cart[item.id.to_s],
        subtotal: item.price * cart[item.id.to_s]
      }
    end

    @cart_subtotal = @cart_items.sum { |i| i[:subtotal] }
    @cart_tax = (@cart_subtotal * 0.08).round(2)
    @cart_total = @cart_subtotal + @cart_tax
  end
end
