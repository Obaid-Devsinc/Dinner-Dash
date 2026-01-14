class CategoriesController < ApplicationController
  def show
    @category = Category.select(:id, :name, :slug).find_by(slug: params[:id])
    @items = @category.items.active.select(:id, :title, :price, :slug).page(params[:page]).per(9)
  end
end
