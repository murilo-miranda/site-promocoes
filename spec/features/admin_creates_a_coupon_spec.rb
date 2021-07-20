require 'rails_helper'

feature 'Admin creates a coupon' do
  scenario 'must be signed in' do
    Promotion.create(name: 'Natal', description: 'Promoção de natal',
                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                    expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'

    expect(current_path).to eq new_admin_session_path
  end

  scenario 'successfully' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 10, expiration_date: '22/12/2033')
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')

    login_as admin
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Gerar cupon'

    expect(current_path).to eq(promotion_path(promotion))
    expect(page).to have_content('NATAL10-0001')
    expect(page).to have_content('NATAL10-0002')
    expect(page).to have_content('NATAL10-0003')
    expect(page).to have_content('NATAL10-0010')
    expect(page).to have_no_content('NATAL10-0011')
    expect(page).to have_no_content('NATAL10-0000')
  end
end