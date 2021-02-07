require 'rails_helper'

feature 'Admin search for promotion' do
  scenario 'search for natal' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 10,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')

    visit root_path
    within('form') do
      fill_in 'search', with: 'Fulano'
    end
    click_on 'Search'

    expect(page).to have_content('NATAL10')
    expect(page).to have_no_content('CYBER15')
  end
end