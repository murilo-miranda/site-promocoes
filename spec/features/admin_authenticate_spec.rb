require 'rails_helper'

feature 'Admin authenticate' do
  scenario 'successfully' do
    admin = Admin.create!(email: 'admin@test.com', password: 'f4k3p455w0rd')

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: admin.email
    fill_in 'Senha', with: admin.password
    within('form') do
      click_on 'Entrar'
    end

    expect(page).to have_content('Login efetuado com sucesso')
    expect(page).to have_content(admin.email)
    expect(page).to have_content('Sair')
    expect(page).to have_no_content('Entrar')
  end

  scenario 'after registration' do
    visit root_path
    click_on 'Registrar'
    fill_in 'E-mail', with: 'admin@test.com'
    fill_in 'Senha', with: 'f4k3p455w0rd'
    fill_in 'Confirme sua senha', with: 'f4k3p455w0rd'
    within('form') do
      click_on 'Registrar'
    end

    expect(page).to have_content('admin@test.com')
    expect(page).to have_content('Sair')
  end
end
