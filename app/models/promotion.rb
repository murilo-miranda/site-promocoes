class Promotion < ApplicationRecord
  validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date, presence: true
  validates :code, uniqueness: true
  has_many :coupon
  has_one :promotion_approval
  belongs_to :admin

  def generate_coupon!
    Coupon.transaction do
      (1..coupon_quantity).each do |number|
          coupon.create!(code: "#{code}-#{'%04d' % number}")
      end
    end
  end

  def approve!(approver)
    PromotionApproval.create!(admin: approver, promotion: self, approved_at: DateTime.now)
  end

  def approver
    promotion_approval.admin.email
  end

  def approved?
    promotion_approval
  end

  def approved_at?
    promotion_approval.approved_at.to_formatted_s(:short).to_s
  end
end
