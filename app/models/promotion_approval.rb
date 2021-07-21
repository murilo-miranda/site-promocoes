class PromotionApproval < ApplicationRecord
  belongs_to :admin
  belongs_to :promotion
end
