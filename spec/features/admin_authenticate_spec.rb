require 'rails_helper'

feature 'Admin authenticate' do
  scenario 'successfully' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')

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
end
