require 'rails_helper'

feature 'Admin creates a Product Category ' do
  scenario 'must be signed in' do
    visit root_path
    click_on 'Categoria de produtos'

    expect(current_path).to eq new_admin_session_path
  end

  scenario 'successfully' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')

    login_as admin
    visit root_path
    click_on 'Categoria de produtos'
    click_on 'Registrar uma categoria de produtos'
    fill_in 'Nome', with: 'Games e Consoles'
    fill_in 'Código', with: 'GAME'
    click_button 'Registrar'

    expect(ProductCategory.count).to eq 1
  end

  scenario 'can not be blank' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')

    login_as admin
    visit root_path
    click_on 'Categoria de produtos'
    click_on 'Registrar uma categoria de produtos'
    fill_in 'Nome', with: ''
    fill_in 'Código', with: ''
    within('form') do
      click_button 'Registrar'
    end

    expect(ProductCategory.count).to eq 0
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Código não pode ficar em branco')
  end

  scenario 'can not create with exist code already' do
    ProductCategory.create!(name: 'Games e Consoles', code: 'GAME')
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')

    login_as admin
    visit root_path
    click_on 'Categoria de produtos'
    click_on 'Registrar uma categoria de produtos'
    fill_in 'Nome', with: 'Periféricos'
    fill_in 'Código', with: 'GAME'
    click_button 'Registrar'

    expect(ProductCategory.count).to eq 1
    expect(page).to have_content('Código já está em uso')
  end
end
