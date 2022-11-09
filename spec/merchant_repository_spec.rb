require './spec/spec_helper'

RSpec.describe MerchantRepository do
  let(:merchant_1){Merchant.new({:id => 1,
                                 :name => 'Nike'})}
  let(:merchant_2){Merchant.new({:id => 2,
                                 :name => 'Adidas'})}
  let(:merchants){[merchant_1, merchant_2]}
  let(:merchant_repository){MerchantRepository.new(merchants)}
  
  describe '#iteration 0' do
    it '#initialize exists' do
      expect(merchant_repository).to be_a(MerchantRepository)
    end
    
    it '#all returns an array of all known merchants' do
      expect(merchant_repository.all).to eq([merchant_1, merchant_2])
    end
    
    it '#find_by_id returns a merchant object by id' do
      expect(merchant_repository.find_by_id(1)).to eq(merchant_1)
    end
    
    it '#find_by_name finds a merchant object with a case insensitve name search' do
      expect(merchant_repository.find_by_name('NIKE')).to eq(merchant_1)
    end
    
    it '#all_ids finds all ids' do
      expect(merchant_repository.all_ids).to eq([1, 2])
    end
    
    it '#find_all_by_name returns an array of all merchants with a specific case insensitve name' do
      merchant_3 = Merchant.new({:id => 3,
                                 :name => 'Adidas'})
      merchants = [merchant_1, merchant_2, merchant_3]
      merchant_repository = MerchantRepository.new(merchants)

      expect(merchant_repository.find_all_by_name('aDiDas')).to eq([merchant_2, merchant_3])
    end
    
    it '#create creates a new merchant with attributes' do
      merchant_3 = merchant_repository.create({:name => 'Puma'})
      
      expect(merchant_3.name).to eq('Puma')
      expect(merchant_3.id).to eq(3)
      expect(merchants).to eq([merchant_1, merchant_2, merchant_3])
      expect(merchant_repository.find_by_id(3)).to eq(merchant_3)
    end
    
    it '#update updates the name of a merchant with the given id' do
      merchant_repository.update(1, {:id => 1, :name => 'Facebook'})

      expect(merchant_repository.find_by_id(1).name).to eq('Facebook')
    end
    
    it '#delete deletes a specific merchant from the repository' do
      merchant_repository.delete(1)

      expect(merchant_repository.all.include?(merchant_1)).to eq(false)
    end
  end
end
