class ItemsController < ApplicationController
  def index
    @categories = Category.all.select(:id, :name)

    @items = Item.active.select(:id, :title, :price, :slug, :category_id)

    if params[:query].present?
      query = params[:query].downcase
      @items = @items.where("LOWER(title) LIKE ?", "%#{query}%")
    end

    if params[:category].present?
      @items = @items.where(category_id: params[:category])
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
