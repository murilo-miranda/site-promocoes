class Promotion < ApplicationRecord
  validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date, presence: true
  validates :code, uniqueness: true
  has_many :coupon
  belongs_to :admin

  def generate_coupon!
    Coupon.transaction do
      (1..coupon_quantity).each do |number|
          coupon.create!(code: "#{code}-#{'%04d' % number}")
      end
    end
  end

  def approve!(approver)
    PromotionApproval.create!(admin: approver, promotion: self, approved_at: Time.now)
  end

  def approver
    PromotionApproval.find(admin: self.admin)
  end
end
