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
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 10, expiration_date: '22/12/2033',
                                  admin: admin)

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

  scenario 'search for coupon code' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2, expiration_date: '22/12/2033',
                                  admin: admin)
    promotion.generate_coupon!

    login_as admin
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    fill_in 'Busca', with: 'NATAL10-0002'
    click_on 'Pesquisar'

    expect(page).to have_content('NATAL10-0002')
    expect(page).to_not have_content('NATAL10-0001')
  end

  scenario 'search for non-existent coupon code' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 2, expiration_date: '22/12/2033',
                                  admin: admin)
    promotion.generate_coupon!

    login_as admin
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    fill_in 'Busca', with: 'PASCOA-0002'
    click_on 'Pesquisar'

    expect(page).to_not have_content('NATAL-0002')
    expect(page).to_not have_content('PASCOA-0002')
    expect(page).to have_content('Nenhum cupom com este nome foi encontrado')
  end
end
