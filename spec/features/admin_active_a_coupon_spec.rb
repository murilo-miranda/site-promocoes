require 'rails_helper'

feature 'Admin active a coupon' do
  scenario 'must be signed in' do
    Promotion.create(name: 'Natal', description: 'Promoção de natal',
                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                    expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'

    expect(current_path).to eq new_admin_session_path
  end

  scenario 'sucessfully' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')
    promotion = Promotion.create(name: 'Natal', description: 'Promoção de natal',
                                code: 'NATAL10', discount_rate: 10, coupon_quantity: 2,
                                expiration_date: '22/12/2033', admin: admin)
    active_coupon = Coupon.create!(code: 'NATAL10-0001', status: :active,
                                  promotion: promotion)
    inactive_coupon = Coupon.create!(code: 'NATAL10-0002', status: :inactive,
                                    promotion: promotion)

    login_as admin
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    within("##{inactive_coupon.code}") do
      click_on 'Ativar'
    end

    within("##{active_coupon.code}") do
      expect(page).to have_link('Inativar')
    end
    within("##{inactive_coupon.code}") do
      expect(page).to have_link('Inativar')
    end
  end
end
