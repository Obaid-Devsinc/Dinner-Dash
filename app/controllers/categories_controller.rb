class CategoriesController < ApplicationController
  LIMIT = 8
  before_action :set_page_params, only: [:index]
  before_action :authenticate_user!, except: [:show]
  before_action :find_category, only: %i[show edit update destroy]
  after_action :verify_authorized, except: %i[index show]
  after_action :verify_policy_scoped, only: [:index]

  def index
    @categories = policy_scope(Category).page(set_page_params[:page]).per(set_page_params[:limit] || LIMIT)
    authorize Category
  end

  def show; end

  def new
    @category = Category.new
    authorize @category
  end

  def create
    @category = Category.new(category_params)
    authorize @category

    if @category.save
      redirect_to categories_path, notice: 'Category created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @category
  end

  def update
    authorize @category

    if @category.update(category_params)
      redirect_to categories_path, notice: 'Category updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    authorize @category

    if @category.destroy
      flash.now[:notice] = 'Item deleted successfully'
    else
      flash.now[:alert] = @category.errors.full_messages.to_sentence
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :image)
  end

  def set_page_params
    params.permit(:limit, :page)
  end

  def find_category
    @category = Category.find_by!(slug: params[:id])
  end
end
