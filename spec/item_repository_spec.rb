require './spec/spec_helper'
require 'bigdecimal/util'

RSpec.describe ItemRepository do
  let(:item_1) {Item.new({:id => 1,
                         :name => 'Shoes',
                         :description => 'left shoe, right shoe',
                         :unit_price => BigDecimal(78.54,4),
                         :created_at => Time.now,
                         :updated_at => Time.now,
                         :merchant_id => 1})}
  let(:item_2) {Item.new({:id => 2,
                          :name => 'Cool hat',
                          :description => 'black top hat',
                          :unit_price => BigDecimal(22.24,4),
                          :created_at => Time.now,
                          :updated_at => Time.now,
                          :merchant_id => 2})}
  let(:item_3) {Item.new({:id => 3,
                          :name => 'More Expensive Cool hat',
                          :description => 'black top hat',
                          :unit_price => BigDecimal(22.24,4),
                          :created_at => Time.now,
                          :updated_at => Time.now,
                          :merchant_id => 2})}
  let(:items) {[item_1, item_2, item_3]}
  let(:item_repository) {ItemRepository.new(items)}
  
  describe '#iteration 0' do
    it '#initialize creates an item repository' do
      expect(item_repository).to be_a(ItemRepository)
    end
    
    it '#all returns an array of all known items' do
      expect(item_repository.all).to eq([item_1, item_2, item_3])
    end
    
    it '#find_by_id returns nil or an instance of item with matching id' do
      expect(item_repository.find_by_id(2)).to eq(item_2)
      expect(item_repository.find_by_id(4)).to eq(nil)
    end
    
    it '#find_by_name returns nil or an instance of item with matching name' do
      expect(item_repository.find_by_name('Cool hat')).to eq(item_2)
      expect(item_repository.find_by_name('Suit')).to eq(nil)
    end
    
    it '#find_all_with_description returns an empty array or the instances of the item with matching description' do
      expect(item_repository.find_all_with_description('black top hat')).to eq([item_2, item_3])
      expect(item_repository.find_all_with_description('BLack top Hat')).to eq([item_2, item_3])
      expect(item_repository.find_all_with_description('a really nice suit')).to eq([])
    end
  end

  it '#find_all_by price returns empty array or array of item with matching price' do
    expect(item_repository.find_all_by_price(22.24)).to eq([item_2, item_3])
    expect(item_repository.find_all_by_price(45.21)).to eq([])
  end

  it '#find_all_by price_in_range returns empty array or array of item within price range' do
    expect(item_repository.find_all_by_price_in_range(15..35)).to eq([item_2, item_3])
    expect(item_repository.find_all_by_price_in_range(5..15)).to eq([])
  end
  
  it '#find_all_by_merchant_id returns empty array or array of items with matching merchant id' do
    expect(item_repository.find_all_by_merchant_id(2)).to eq([item_2, item_3])
    expect(item_repository.find_all_by_merchant_id(5)).to eq([])
  end
  
  it '#create makes a new item instance with the attributes provided' do
    expect(item_repository.all).to eq([item_1, item_2, item_3])
    
    item_4 = item_repository.create(:name => 'Extra Cool Hat')

    expect(item_repository.all).to eq([item_1, item_2, item_3, item_4])
    expect(item_4.name).to eq('Extra Cool Hat')
    expect(item_4.id).to eq(4)
    expect(item_repository.find_by_id(4)).to eq(item_4)
  end
  
  it '#update the attributes of a specific item with the given change' do
    
    item_repository.update(1, {:id => 1, :name => 'Sneakers'})
    expect(item_repository.find_by_id(1).name).to eq('Sneakers')

    item_repository.update(1, {:id => 1, :description => 'shoes'})
    expect(item_repository.find_by_id(1).description).to eq('shoes')

    item_repository.update(1, {:id => 1, :unit_price => BigDecimal(11.99, 4)})
    expect(item_repository.find_by_id(1).unit_price).to eq(0.1199e2)
  end
  
  it '#delete a specific item from the repository' do
    item_repository.delete(1)

    expect(item_repository.all).to eq([item_2, item_3])
    expect(item_repository.all.include?(item_1)).to eq(false)
  end
end