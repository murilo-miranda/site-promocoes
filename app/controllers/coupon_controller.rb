# frozen_string_literal: true

class CouponController < ApplicationController
  def inactivate
    coupon = Coupon.find(params[:id])

    coupon.inactive!

    redirect_to promotion_path(coupon.promotion)
  end

  def active
    coupon = Coupon.find(params[:id])

    coupon.active!

    redirect_to promotion_path(coupon.promotion)
  end

  def search
    @coupons = Coupon.where(code: params[:q])
  end
end
