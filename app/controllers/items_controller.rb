class ItemsController < ApplicationController
  def index
    @items = Item.active.select(:id, :title, :price, :slug)

    if params[:query].present?
      query = params[:query].downcase
      @items = @items.where("LOWER(title) LIKE ?", "%#{query}%")
    end

    @items = @items.page(params[:page]).per(9)
  end

  def show
    @item = Item
    .includes(:category)
    .select(:id, :title, :price, :slug, :description, :category_id)
    .find_by(slug: params[:id])
  end
end
