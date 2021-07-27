# frozen_string_literal: true

class PromotionsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @promotions = Promotion.all
  end

  def show
    @promotion = Promotion.find(params[:id])
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(promotion_params)
    @promotion.admin = current_admin

    if @promotion.save
      redirect_to @promotion
    else
      render new_promotion_path
    end
  end

  def destroy
    promotion = Promotion.find(params[:id])
    promotion.destroy

    redirect_to promotions_path
  end

  def edit
    @promotion = Promotion.find(params[:id])
  end

  def update
    @promotion = Promotion.find(params[:id])

    if @promotion.update(promotion_params)
      redirect_to @promotion
    else
      render :edit
    end
  end

  def generate_coupon
    @promotion = Promotion.find(params[:id])

    @promotion.generate_coupon!

    redirect_to promotion_path(@promotion)
  end

  def approve
    promotion = Promotion.find(params[:id])

    promotion.approve!(current_admin)

    redirect_to promotion_path(promotion)
  end

  private

  def promotion_params
    params.require(:promotion).permit(:name, :description, :code, :discount_rate,
                                      :coupon_quantity, :expiration_date)
  end
end
