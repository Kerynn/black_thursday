require './spec/spec_helper'

RSpec.describe Transaction do
  describe '#iteration 3' do
    let (:t) {Transaction.new({:id => 6,
                               :invoice_id => 8,
                               :credit_card_number => "4242424242424242",
                               :credit_card_expiration_date => "0220",
                               :result => "failed",
                               :created_at => Time.now,
                               :updated_at => Time.now
                             })}
    it '#initialize: transaction will exist and have attributes' do
      expect(t).to be_a(Transaction)
      expect(t.id).to eq(6)
      expect(t.invoice_id).to eq(8)
      expect(t.credit_card_number).to eq("4242424242424242")
      expect(t.credit_card_expiration_date).to eq("0220")
      expect(t.result).to eq("failed")
      expect(t.created_at).to be_a(Time)
      expect(t.updated_at).to be_a(Time)
    end
    
    it 'can update :credit_card_number' do
      expect(t.credit_card_number).to eq("4242424242424242")
      t.update_credit_card_number("4068631943231473")
      expect(t.credit_card_number).to eq("4068631943231473")
    end
    
    it 'can update :credit_card_expiration_date' do
      expect(t.credit_card_expiration_date).to eq("0220")
      t.update_credit_card_expiration_date("0217")
      expect(t.credit_card_expiration_date).to eq("0217")
    end
    
    it 'can update :result' do
      expect(t.result).to eq("failed")
      t.update_result("success")
      expect(t.result).to eq("success")
    end
  end
end
