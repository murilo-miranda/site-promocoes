require 'rails_helper'

describe Promotion do
  context 'validation' do
    it 'attributes cannot be blank' do
      promotion = Promotion.new

      expect(promotion.valid?).to eq false
      expect(promotion.errors.count).to eq 6
    end

    it 'description is optional' do
      admin = Admin.create!(email: 'msilva@test.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: '',
                                    code: 'NATAL10', discount_rate: 10,
                                    coupon_quantity: 10, expiration_date: '22/12/2033',
                                    admin: admin)

      expect(promotion.valid?).to eq true
    end

    it 'error messages are in  portuguese' do
      promotion = Promotion.new

      promotion.valid?

      expect(promotion.errors[:name]).to include('não pode ficar em branco')
      expect(promotion.errors[:code]).to include('não pode ficar em branco')
      expect(promotion.errors[:discount_rate]).to include('não pode ficar em branco')
      expect(promotion.errors[:coupon_quantity]).to include('não pode ficar em branco')
      expect(promotion.errors[:expiration_date]).to include('não pode ficar em branco')
    end

    it 'code must be uniq' do
      admin = Admin.create(email: 'msilva@test.com', password: '123456')
      Promotion.create(name: 'Natal', description: '',
                       code: 'NATAL10', discount_rate: 10,
                       coupon_quantity: 10, expiration_date: '22/12/2033',
                       admin: admin)

      promotion = Promotion.new(code: 'NATAL10')

      promotion.valid?

      expect(promotion.errors[:code]).to include('já está em uso')
    end
  end

  context '#generate_coupon' do
    it 'successfully' do
      admin = Admin.create!(email: 'msilva@test.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: '',
                                    code: 'NATAL10', discount_rate: 10,
                                    coupon_quantity: 10, expiration_date: '22/12/2033',
                                    admin: admin)

      promotion.generate_coupon!

      expect(promotion.coupon.size).to eq 10
      expect(promotion.coupon.first.code).to eq 'NATAL10-0001'
      expect(promotion.coupon.last.code).to eq 'NATAL10-0010'
      expect(promotion.coupon.last.code).not_to eq 'NATAL10-0000'
      expect(promotion.coupon.last.code).not_to eq 'NATAL10-0011'
    end

    it 'should not generate if coupon already exist' do
      admin = Admin.create!(email: 'msilva@test.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: '',
                                    code: 'NATAL10', discount_rate: 10,
                                    coupon_quantity: 10, expiration_date: '22/12/2033',
                                    admin: admin)
      promotion.coupon.create!(code: 'NATAL10-0001')

      expect { promotion.generate_coupon! }.to raise_error(ActiveRecord::RecordInvalid)
      expect(promotion.coupon.size).to eq 1
    end
  end

  context 'admin references' do
    it 'must have' do
      admin = Admin.create!(email: 'msilva@test.com', password: '123456')
      promotion = Promotion.create(name: 'Natal', description: '',
                                   code: 'NATAL10', discount_rate: 10,
                                   coupon_quantity: 10, expiration_date: '22/12/2033',
                                   admin: admin)

      result = promotion.valid?

      expect(promotion.admin).to eq admin
      expect(result).to eq true
    end
  end
end
