class CategoriesController < ApplicationController
  def show
    @category = Category.select(:id, :name).find(params[:id])
    @items = @category.items.active.select(:id, :title, :price).page(params[:page]).per(9)
  end
end
