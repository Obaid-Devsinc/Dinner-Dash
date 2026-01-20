module CartHelper
  extend ActiveSupport::Concern

  def initialize_cart
    session[:cart] ||= {}
  end

  def load_cart_from_cookie
    session[:cart] = JSON.parse(cookies.signed[:cart]) if cookies.signed[:cart].present? && session[:cart].blank?
  end

  def store_cart_cookie
    if session[:cart].present?
      cookies.signed[:cart] = { value: session[:cart].to_json, expires: 7.days.from_now }
    else
      cookies.delete(:cart)
    end
  end

  def persist_cart_before_logout
    store_cart_cookie
  end

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

      @cart_items << { product: item, quantity: qty, subtotal: subtotal }

      @cart_subtotal += subtotal
    end

    @cart_tax = (@cart_subtotal * 0.08).round(2)
    @cart_total = @cart_subtotal + @cart_tax
  end
end
