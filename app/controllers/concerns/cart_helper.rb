module CartHelper
  extend ActiveSupport::Concern

  included do
    helper_method :cart_count
    before_action :initialize_cart
    before_action :load_cart_from_cookie
  end

  def cart_count
    session[:cart].values.sum
  end

  def initialize_cart
    session[:cart] ||= {}
  end

  def load_cart_from_cookie
    if cookies.signed[:cart].present? && session[:cart].blank?
      session[:cart] = JSON.parse(cookies.signed[:cart])
    end
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
end
