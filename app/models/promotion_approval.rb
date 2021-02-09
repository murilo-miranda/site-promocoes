class PromotionApproval < ApplicationRecord
  belongs_to :promotion
  belongs_to :user

  validate :approval_user

  private

  def approval_user
    if promotion && promotion.user == user
      errors.add(:user, 'não pode ser o criador da promoção')
    end
  end
end
