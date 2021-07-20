require 'rails_helper'

feature 'Admin inactivate a coupon' do
  scenario 'successfully' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 2,
                                  expiration_date: '22/12/2033')
    promotion.generate_coupon!

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    within("##{promotion.code}-0001") do
      click_on 'Inativar'
    end

    expect(current_path).to eq(promotion_path(promotion))
    within("##{promotion.code}-0001") do
      expect(page).to have_content('NATAL10-0001 (Inativo)')
      expect(page).to_not have_link('Inativar')
    end
  end
end