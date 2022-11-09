require './spec/spec_helper'

RSpec.describe Merchant do
  let(:m){Merchant.new({:id => 5, 
                        :name => 'Turing School'
                        })}
  
  describe '#iteration 1' do
    it '#initialize exists and has readable attributes' do
      expect(m).to be_a(Merchant)
      expect(m.id).to eq(5)
      expect(m.name).to eq('Turing School')
    end

    it '#update_name updates a merchant objects name' do
      m.update_name('Westpoint')
      expect(m.name).to eq('Westpoint')
    end
  end
end
