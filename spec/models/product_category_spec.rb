require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  describe 'validation' do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:code)}
  end

  describe 'uniqueness' do
    it {should validate_uniqueness_of(:code)}
  end
end
