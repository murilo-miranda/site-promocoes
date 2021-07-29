require 'rails_helper'

feature 'Admin edit a product category' do
  scenario 'must be signed in' do

    visit root_path
    click_on 'Categoria de produtos'

    expect(current_path).to eq new_admin_session_path
  end

  scenario 'expecting a edit link' do
    admin = Admin.create!(email: 'msilva@admin', password: 'f4k3p455w0rd')
    product_category = ProductCategory.create!(name: 'Games e Consoles',
                                              code: 'GAME')

    login_as admin
    visit root_path
    click_on 'Categoria de produtos'
    click_on product_category.name

    expect(current_path).to eq product_cateogory_path(ProductCategory.last)
    expect(page).to have_link('Editar categoria')
  end
end