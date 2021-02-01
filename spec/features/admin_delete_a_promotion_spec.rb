require 'rails_helper'

feature 'Admin delete a promotion' do
    scenario 'and delete successful' do
        Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033')

        visit root_path
        click_on 'Promoções'
        click_on 'Natal'
        click_on 'Deletar'
        visit root_path
        click_on 'Promoções'

        expect(page).to have_no_content('Natal')
    end
=begin
    scenario 'and delete unsuccessfully' do
        Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033')
        
        visit root_path
        click_on 'Promoções'
        click_on 'Natal'
        click_on 'Deletar'
        
        #Pesquisar por Drivers que possibilitam ao teste declinar a mensagem na hora de deletar

        visit root_path
        click_on 'Promoções'

        expect(page).to have_content('Natal')
    end
=end
end