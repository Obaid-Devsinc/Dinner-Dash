class Admin::CategoriesController < Admin::BaseController
  before_action :find_category, only: [ :edit, :update, :destroy ]

  def index
    @categories = Category
    .left_joins(:items)
    .select(:id, :name, :slug, "COUNT(items.id) AS items_count")
    .group(:id, :name)
    .page(params[:page])
    .per(8)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "Category created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Category updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      respond_to do |format|
        format.html { redirect_to admin_categories_path, notice: "Category deleted successfully" }
        format.turbo_stream { flash.now[:notice] = "Category deleted successfully" }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_categories_path, alert: @category.errors.full_messages.to_sentence }
        format.turbo_stream { flash.now[:alert] = @category.errors.full_messages.to_sentence }
      end
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :image)
  end

  def find_category
    @category = Category.find_by(slug: params[:id])
  end
end
