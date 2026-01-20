class ItemsController < ApplicationController
  before_action :set_page_params, only: [:index]
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_item, only: %i[show edit update destroy]
  after_action :verify_policy_scoped, only: [:index]
  after_action :verify_authorized, except: %i[index show]

  def index
    @items = policy_scope(Item)

    if current_user&.admin?
      @items = @items.includes(:category).page(set_page_params[:page]).per(set_page_params[:limit])
      authorize Item
    else
      @categories = Category.all

      if params[:query].present?
        query = params[:query].downcase
        @items = @items.where('LOWER(title) LIKE ?', "%#{query}%")
      end

      @items = @items.where(category_id: params[:category]) if params[:category].present?

      @items = @items.page(params[:page]).per(9)
    end
  end

  def show
    authorize @item unless current_user&.admin?
  end

  def new
    @item = Item.new
    authorize @item
  end

  def create
    @item = Item.new(item_params)
    authorize @item

    if @item.save
      redirect_to items_path, notice: 'Item created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @item
  end

  def update
    authorize @item

    if @item.update(item_params)
      redirect_to items_path, notice: 'Item updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @item

    if @item.destroy
      flash.now[:notice] = 'Item deleted successfully'
    else
      flash.now[:alert] = @item.errors.full_messages.to_sentence
    end
  end

  private

  def item_params
    params.require(:item).permit(:title, :description, :price, :retired, :category_id, :image)
  end

  def set_page_params
    params.permit(:limit, :page).tap { |whitelisted| whitelisted[:limit] ||= 8 }
  end

  def find_item
    @item = Item.find_by!(slug: params[:id])
  end
end
