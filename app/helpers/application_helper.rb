module ApplicationHelper
  def cart_count
    session[:cart].values.sum { |item| item["quantity"].to_i }
  end
end
