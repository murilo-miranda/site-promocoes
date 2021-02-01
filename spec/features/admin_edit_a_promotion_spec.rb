require 'rails_helper'

feature 'Admin edit a promotion' do
    scenario 'and attributes cannot be edited and saved with blank field' do
        Promotion.create!(name: 'Natal', description: 'Promoção de natal',
                        code: 'NATAL10', discount_rate: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033')
        
        visit root_path
        click_on 'Promoções'
        click_on 'Natal'
        click_on 'Editar'
        fill_in 'Nome', with: ''
        fill_in 'Descrição', with: ''
        fill_in 'Código', with: ''
        fill_in 'Desconto', with: ''
        fill_in 'Quantidade de cupons', with: ''
        fill_in 'Data de término', with: ''
        click_on 'Editar promoção'

        expect(page).to have_content('não pode ficar em branco', count: 5)
    end

    scenario 'and attributes cannot be edited and saved without been unique' do
        Promotion.create!(name: 'Natal', description: 'Promoção de natal',
                        code: 'NATAL10', discount_rate: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033')
        
        Promotion.create!(name: 'Cyber Monday', description: 'Promoção de cyber monday',
                        code: 'MONDAY10', discount_rate: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033')

        visit root_path
        click_on 'Promoções'
        click_on 'Cyber Monday'
        click_on 'Editar'
        fill_in 'Código', with: 'NATAL10'
        click_on 'Editar promoção'

        expect(page).to have_content('deve ser único')
    end

    scenario 'and edited successful' do
        Promotion.create!(name: 'Natal', description: 'Promoção de natal',
                        code: 'NATAL10', discount_rate: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033')

        visit root_path
        click_on 'Promoções'
        click_on 'Natal'
        click_on 'Editar'
        fill_in 'Descrição', with: 'Promoção HOHOHO'
        fill_in 'Desconto', with: '20'
        fill_in 'Data de término', with: '01/01/2033'
        click_on 'Editar promoção'

        expect(page).to have_no_content('deve ser único')
        expect(page).to have_no_content('não pode ficar em branco')
    end
end        