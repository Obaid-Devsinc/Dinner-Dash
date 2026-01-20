module ApplicationHelper
    def cart_count
    session[:cart].values.sum
    end
end
