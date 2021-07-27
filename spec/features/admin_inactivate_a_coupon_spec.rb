require 'rails_helper'

feature 'Admin inactivate a coupon' do
  scenario 'must be signed in' do
    Promotion.create(name: 'Natal', description: 'Promoção de natal',
                     code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                     expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'

    expect(current_path).to eq new_admin_session_path
  end

  scenario 'successfully' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 2,
                                  expiration_date: '22/12/2033', admin: admin)
    promotion.generate_coupon!

    login_as admin
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
