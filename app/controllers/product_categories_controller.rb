class ProductCategoriesController < ApplicationController
  before_action :authenticate_admin!

  def index; end

  def new
    @product_category = ProductCategory.new
  end

  def create
    @product_category = ProductCategory.new(product_category_params)

    if @product_category.save
      redirect_to product_categories_path
    else
      flash[:notice] = @product_category.errors
      render new_product_category_path
    end
  end

  private

  def product_category_params
    params.require(:product_category).permit(:name, :code)
  end
end
