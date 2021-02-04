class Promotion < ApplicationRecord
    has_many :coupons

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
end
