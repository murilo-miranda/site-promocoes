class CreatePromotionApprovals < ActiveRecord::Migration[6.1]
  def change
    create_table :promotion_approvals do |t|
      t.references :admin, null: false, foreign_key: true
      t.references :promotion, null: false, foreign_key: true
      t.datetime :approved_at

      t.timestamps
    end
  end
end
