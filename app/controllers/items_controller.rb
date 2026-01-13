class ItemsController < ApplicationController
  def index
    @items = Item.active.select(:id, :title, :price)

    if params[:query].present?
      query = params[:query].downcase
      @items = @items.where("LOWER(title) LIKE ?", "%#{query}%")
    end

    @items = @items.page(params[:page]).per(9)
  end

  def show
    @item = Item
    .includes(:category)
    .select(:id, :title, :price, :description, :category_id)
    .find_by(id: params[:id])
  end
end
