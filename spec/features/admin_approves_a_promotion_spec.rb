require 'rails_helper'

feature 'Admin approves a promotion' do
  scenario 'must be logged in' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', admin: admin)

    visit promotion_path(promotion)

    expect(current_path).to eq new_admin_session_path
  end

  scenario 'seeing a link to approve' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', admin: admin)

    login_as admin
    visit root_path
    click_on 'Promoções'
    click_on promotion.name

    expect(page).to have_link 'Aprovar'
  end

  scenario 'successfully' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', admin: admin)

    login_as admin
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Aprovar'

    expect(current_path).to eq promotion_path(promotion)
    expect(page).to have_content('Status: Aprovada')
    expect(page).to have_content('Aprovada por: ' + admin.email)
    expect(page).to have_content('Horário da aprovação: ' + Time.now)
  end
end