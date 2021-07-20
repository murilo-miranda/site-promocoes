require 'rails_helper'

feature 'Admin edit a promotion' do
  scenario 'must be signed in' do
    Promotion.create(name: 'Natal', description: 'Promoção de natal',
                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                    expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'

    expect(current_path).to eq new_admin_session_path
  end

  scenario 'expecting a edit link' do
    Promotion.create(name: 'Natal', description: 'Promoção de natal',
                     code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                     expiration_date: '22/12/2033')
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')

    login_as admin
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'

    expect(current_path).to eq promotion_path(Promotion.last)
    expect(page).to have_link('Editar promoção')
  end

  scenario 'successfully' do
    Promotion.create(name: 'Natal', description: 'Promoção de natal',
                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                    expiration_date: '22/12/2033')
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')

    login_as admin
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Editar promoção'

    fill_in 'Nome', with: 'Pascoa'
    fill_in 'Descrição', with: 'Promoção de Pascoa'
    fill_in 'Código', with: 'PASCOA15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '100'
    fill_in 'Data de término', with: '22/12/2050'
    click_on 'Enviar'

    expect(current_path).to eq promotion_path(Promotion.last)
    expect(page).to have_content('Pascoa')
    expect(page).to have_content('Promoção de Pascoa')
    expect(page).to have_content('PASCOA15')
    expect(page).to have_content('15')
    expect(page).to have_content('100')
    expect(page).to have_content('22/12/2050')
    expect(page).to have_no_content('Natal')
    expect(page).to have_no_content('Promoção de Natal')
  end

  scenario 'and cannot be updated with blank attribute' do
    Promotion.create!(name: 'Natal', description: 'Promoção de natal',
                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                    expiration_date: '22/12/2033')
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')

    login_as admin
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Editar promoção'

    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Não foi possível atualizar a promoção')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Código não pode ficar em branco')
    expect(page).to have_content('Desconto não pode ficar em branco')
    expect(page).to have_content('Quantidade de cupons não pode ficar em branco')
    expect(page).to have_content('Data de término não pode ficar em branco')
  end

  scenario 'and cannot be updated with a code already used' do
    Promotion.create!(name: 'Natal', description: 'Promoção de natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Dia do jogador', description: 'Promoção de natal',
                      code: 'PLAY10', discount_rate: 10, coupon_quantity: 10,
                      expiration_date: '22/12/2033')
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')

    login_as admin
    visit root_path
    click_on 'Promoções'
    click_on 'Dia do jogador'
    click_on 'Editar promoção'

    fill_in 'Código', with: 'NATAL10'
    click_on 'Enviar'

    expect(page).to have_content('Não foi possível atualizar a promoção')
    expect(page).to have_content('Código já está em uso')
  end
end