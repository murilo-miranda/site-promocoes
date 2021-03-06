class Promotion < ApplicationRecord
    has_many :coupons
    has_one :promotion_approval
    belongs_to :user

    validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date, presence: true
    validates :name, :code, uniqueness: true
    validates :discount_rate, :coupon_quantity, numericality: true

    def generate_coupons!
        Coupon.transaction do
            (1..coupon_quantity).each do |number|
                coupons.create!(code: "#{code}-#{'%04d' % number}")
            end
        end
    end

    def approve!(approval_user)
        PromotionApproval.create(promotion:self, user: approval_user)
    end

    def approved?
        promotion_approval
    end

    def approver?
        promotion_approval.user
    end
end
