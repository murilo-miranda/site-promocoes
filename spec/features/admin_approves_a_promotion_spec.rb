require 'rails_helper'

feature 'Admin approves a promotion' do
  scenario 'must be logged in' do
    admin = Admin.create!(email: 'creator@admin', password: 'f4k3p455w0rd')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', admin: admin)

    visit promotion_path(promotion)

    expect(current_path).to eq new_admin_session_path
  end

  scenario 'seeing a link to approve' do
    creator = Admin.create!(email: 'creator@admin', password: 'f4k3p455w0rd')
    approver = Admin.create!(email: 'approver@admin', password: 'f4k3p455w0rd')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', admin: creator)

    login_as approver
    visit root_path
    click_on 'Promoções'
    click_on promotion.name

    expect(page).to have_link 'Aprovar'
  end

  scenario 'successfully' do
    creator = Admin.create!(email: 'creator@admin', password: 'f4k3p455w0rd')
    approver = Admin.create!(email: 'approver@admin', password: 'f4k3p455w0rd')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', admin: creator)

    login_as approver
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Aprovar'

    expect(current_path).to eq promotion_path(promotion)
    expect(page).to have_content('Status: Aprovada')
    expect(page).to have_content("Aprovada por: #{approver.email}")
    expect(page).to have_content("Aprovada em: #{DateTime.now.to_formatted_s(:short)}")
  end

  scenario 'can not be approved by creator' do
    creator = Admin.create!(email: 'creator@admin', password: 'f4k3p455w0rd')
    approver = Admin.create!(email: 'approver@admin', password: 'f4k3p455w0rd')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', admin: creator)

    login_as creator
    visit root_path
    click_on 'Promoções'
    click_on promotion.name

    expect(current_path).to eq promotion_path(promotion)
    expect(page).to_not have_link('Aprovar')
    expect(page).to have_content('Status: Pendente')
    expect(page).to_not have_content("Aprovada por: #{approver.email}")
    expect(page).to_not have_content("Aprovada em: #{DateTime.now.to_formatted_s(:short)}")
  end
end
