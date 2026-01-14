class HomeController < ApplicationController
  def index
    @items = Item.active.select(:id, :title, :price, :slug).limit(6)
    @categories = Category.select(:id, :name, :slug).limit(5)
  end
end
