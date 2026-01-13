class HomeController < ApplicationController
  def index
    @items = Item.active.select(:id, :title, :price).limit(6)
    @categories = Category.select(:id, :name).limit(5)
  end
end
