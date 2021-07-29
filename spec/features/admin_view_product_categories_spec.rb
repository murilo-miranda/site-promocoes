require 'rails_helper'

feature 'Admin view product categories' do
  scenario 'must be signed in' do

    visit root_path
    click_on 'Categoria de produtos'

    expect(current_path).to eq new_admin_session_path
  end

  scenario 'and view the infos' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')
    product_category = ProductCategory.create!(name: 'Games e Consoles',
                                              code: 'GAME')

    login_as admin
    visit root_path
    click_on 'Categoria de produtos'

    expect(current_path).to eq product_categories_path
    expect(page).to have_content('Nome:')
    expect(page).to have_content(product_category.name)
    expect(page).to have_content('Código:')
    expect(page).to have_content(product_category.code)
  end

  scenario 'and have no product category' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')

    login_as admin
    visit root_path
    click_on 'Categoria de produtos'

    expect(current_path).to eq product_categories_path
    expect(page).to have_content('Não existe registros de categorias de produtos')
  end
end