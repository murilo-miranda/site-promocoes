require 'rails_helper'

feature 'Admin view promotions' do
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
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', admin: admin)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday', code: 'CYBER15',
                      discount_rate: 15, expiration_date: '22/12/2033', admin: admin)

    login_as admin
    visit root_path
    click_on 'Promoções'

    expect(page).to have_content('Natal')
    expect(page).to have_content('Promoção de Natal')
    expect(page).to have_content('10,00%')
    expect(page).to have_content('Cyber Monday')
    expect(page).to have_content('Promoção de Cyber Monday')
    expect(page).to have_content('15,00%')
  end

  scenario 'and view details' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', admin: admin)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday', code: 'CYBER15',
                      discount_rate: 15, expiration_date: '22/12/2033', admin: admin)

    login_as admin
    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    expect(page).to have_content('Cyber Monday')
    expect(page).to have_content('Promoção de Cyber Monday')
    expect(page).to have_content('15,00%')
    expect(page).to have_content('CYBER15')
    expect(page).to have_content('22/12/2033')
    expect(page).to have_content('90')
  end

  scenario 'and no promotion are created' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')

    login_as admin
    visit root_path
    click_on 'Promoções'

    expect(page).to have_content('Nenhuma promoção cadastrada')
  end

  scenario 'and return to home page' do
    admin = Admin.create!(email: 'msilva@test.com', password: '123456')
    Promotion.create!(name: 'Natal', description: '',
                      code: 'NATAL10', discount_rate: 10,
                      coupon_quantity: 10, expiration_date: '22/12/2033',
                      admin: admin)

    login_as admin
    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  scenario 'and return to promotion page' do
    admin = Admin.create!(email: 'admin@test.com', password: '123456')
    Promotion.create!(name: 'Natal', description: '',
                      code: 'NATAL10', discount_rate: 10,
                      coupon_quantity: 10, expiration_date: '22/12/2033',
                      admin: admin)

    login_as admin
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    expect(current_path).to eq promotions_path
  end

  scenario 'search for promotion name' do
    admin = Admin.create!(email: 'admin@test.com', password: '123456')
    Promotion.create!(name: 'Natal', description: '',
                      code: 'NATAL10', discount_rate: 10,
                      coupon_quantity: 10, expiration_date: '22/12/2033',
                      admin: admin)
    Promotion.create!(name: 'Pascoa', description: '',
                      code: 'PASCOA10', discount_rate: 10,
                      coupon_quantity: 10, expiration_date: '22/12/2033',
                      admin: admin)

    login_as admin
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'Natal'
    click_on 'Pesquisar'

    expect(current_path).to eq search_path
    expect(page).to have_content('Natal')
    expect(page).to_not have_content('Pascoa')
  end

  scenario 'search for a non-existent promotion name' do
    admin = Admin.create!(email: 'admin@test.com', password: '123456')
    Promotion.create!(name: 'Natal', description: '',
                      code: 'NATAL10', discount_rate: 10,
                      coupon_quantity: 10, expiration_date: '22/12/2033',
                      admin: admin)

    login_as admin
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'Pascoa'
    click_on 'Pesquisar'

    expect(current_path).to eq search_path
    expect(page).to_not have_content('Natal')
    expect(page).to have_content('Nenhuma promoção com este nome foi encontrado.')
  end
end
