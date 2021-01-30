class Promotion < ApplicationRecord
    validates :name, presence: true
    validates :description, presence: true
    validates :code, presence: true
    validates :discount_rate, presence: true
    validates :coupon_quantity, presence: true
    validates :expiration_date, presence: true
end
