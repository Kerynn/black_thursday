require './spec/spec_helper'

RSpec.describe Invoice do
  let (:i){Invoice.new({:id          => 6,
                        :customer_id => 7,
                        :merchant_id => 8,
                        :status      => 'pending',
                        :created_at  => '2022-11-02 11:33:36.699596 -0600',
                        :updated_at  =>  '2022-11-02 11:33:36.699596 -0600',
                        })}

  describe '#initialize' do
    it 'will exist and have attributes' do
      expect(i).to be_a(Invoice)
      expect(i.id).to eq(6)
      expect(i.customer_id).to eq(7)
      expect(i.merchant_id).to eq(8)
      expect(i.status).to eq('pending')
    end

    it 'will have a time' do
      expect(i.created_at).to eq('2022-11-02 11:33:36.699596 -0600')
      expect(i.updated_at).to eq('2022-11-02 11:33:36.699596 -0600')
    end
    
    it '#update_customer_id will update customer id' do
      i.update_customer_id(7)
      expect(i.customer_id).to eq(7)
    end
    
    it '#update_merchant_id will update merchant_id' do
      i.update_merchant_id(9)
      expect(i.merchant_id).to eq(9)
    end
    
    it '#update_status will update status' do
      i.update_status('paid')
      expect(i.status).to eq('paid')
    end
  end

  describe '#update_time' do
    it 'will update time' do
      i = Invoice.new({:id          => 6,
                       :customer_id => 7,
                       :merchant_id => 8,
                       :status      => 'pending',
                       :created_at  => '2022-11-02 11:33:36.699596 -0600',
                       :updated_at  => Time.now
                      })
      original_time = i.updated_at
      expect(i.update_time).to be > original_time
    end
  end
end
