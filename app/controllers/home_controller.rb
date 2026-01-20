class HomeController < ApplicationController
  def index
    authorize :home, :index?
    @items = Item.active.limit(6)
    @categories = Category.limit(5)
  end
end
