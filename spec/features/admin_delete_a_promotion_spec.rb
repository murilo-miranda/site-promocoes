require 'rails_helper'

feature 'Admin delete a promotion' do
  scenario 'expecting to have a link to delete the promotion' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'

    expect(current_path).to eq promotion_path(Promotion.last)
    expect(page).to have_link('Excluir promoção')
  end

  scenario 'by clicking the link' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Excluir promoção'

    expect(current_path).to eq promotions_path
    expect(page).to have_no_content('Natal')
    expect(page).to have_no_content('Promoção de Natal')
    expect(Promotion.exists?).to eq false
  end
end