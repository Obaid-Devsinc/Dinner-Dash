class Admin::ItemsController < Admin::BaseController
  before_action :find_item, only: [ :edit, :update, :destroy ]

  def index
    @items = Item.includes(:category)
    .select(:id, :title, :price, :retired, :slug, :category_id)
    .page(params[:page]).per(8)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_items_path, notice: "Item created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to admin_items_path, notice: "Item updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @item.destroy
      respond_to do |format|
        format.html { redirect_to admin_items_path, notice: "Item deleted successfully" }
        format.turbo_stream { flash.now[:notice] = "Item deleted successfully" }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_items_path, alert: @item.errors.full_messages.to_sentence }
        format.turbo_stream { flash.now[:alert] = @item.errors.full_messages.to_sentence }
      end
    end
  end


  private

  def item_params
    params.require(:item).permit(:title, :description, :price, :retired, :category_id, :image)
  end

  def find_item
    @item = Item.find_by(slug: params[:id])
  end
end
