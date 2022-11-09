require './spec/spec_helper'
require 'bigdecimal/util'

RSpec.describe Item do
  let (:item) {Item.new({:id => 1,
                         :name => 'item_name',
                         :description => 'item_description' ,
                         :unit_price => BigDecimal(10.99,4),
                         :created_at => '2022-10-31 15:57:01.540729000 -0600',
                         :updated_at => '2022-10-31 15:57:01.540729000 -0600',
                         :merchant_id => 1})}
  describe '#iteration 0' do
    it '#initialize exists and creates readable attributes' do
      expect(item).to be_a(Item)
      expect(item.id).to eq(1)
      expect(item.name).to eq('item_name')
      expect(item.description).to eq('item_description')
      expect(item.unit_price).to eq(0.1099e2)
      expect(item.created_at).to eq('2022-10-31 15:57:01.540729000 -0600')
      expect(item.updated_at).to eq('2022-10-31 15:57:01.540729000 -0600')
      expect(item.merchant_id).to eq(1)
    end
    
    it '#unit_price_to_dollars returns a formatted float' do
      expect(item.unit_price_to_dollars).to eq(10.99)
    end
    
    it '#update will update the item name' do
      item.update_name('candle')
      expect(item.name).to eq('candle')
    end

    it 'can update the item description' do
      item.update_description('taper candle')
      expect(item.description).to eq('taper candle')
    end

    it 'can update the item unit price' do
      item.update_unit_price(BigDecimal(11.99, 4))
      expect(item.unit_price).to eq(0.1199e2)
    end
  end
end
