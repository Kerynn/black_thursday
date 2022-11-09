require './spec/spec_helper'

RSpec.describe SalesEngine do
  
  describe '#iteration 0' do
    let(:se){SalesEngine.new({:items     => './data/items.csv',
                              :merchants => './data/merchants.csv',
                              :invoices => './data/invoices.csv',
                              :invoice_items => './data/invoice_items.csv',
                              :transactions => './data/transactions.csv',
                              :customers => './data/customers.csv'
                            })}
    let(:item_repo){se.items}
    let(:merchant_repo){se.merchants}
    let(:invoice_repo){se.invoices}
    let(:invoice_item_repo){se.invoice_items}
    let(:transaction_repo){se.transactions}
    let(:customer_repo){se.customers}
    
    it 'exists' do
      expect(se).to be_a(SalesEngine)
    end
    
    it '#from_csv returns a SalesEngine object' do
      expect(se).to be_a(SalesEngine)
    end
    
    it 'creates an item repository object and stores in instance variable' do
      expect(item_repo).to be_a(ItemRepository)
    end

    it 'contains the data from the csv file' do
      expect(item_repo.find_by_id(263395237)).to be_a(Item)
      expect(item_repo.find_by_id(263395237).name).to eq('510+ RealPush Icon Set')
      expect(item_repo.find_by_name('HOT Crystal Dragon Fly Hand Blown Glass Art Gold Trim Figurine Lucky Collection')).to be_a(Item)
      expect(item_repo.find_by_id(1)).to eq(nil)
    end
    
    it '#create_merchant_repo creates a merchant repository object and stores in instance variable' do
      expect(merchant_repo).to be_a(MerchantRepository)
    end

    it 'contains the data from the csv file' do
      expect(merchant_repo.find_by_id(12334105)).to be_a(Merchant)
      expect(merchant_repo.find_by_id(12334105).name).to eq('Shopin1901')
      expect(merchant_repo.find_by_name('SassyStrangeArt')).to be_a(Merchant)
      expect(merchant_repo.find_by_id(1)).to eq(nil)
    end
    
    it 'creates an invoice repository object and stores in instance variable' do
      expect(invoice_repo).to be_a(InvoiceRepository)
    end
    
    it 'contains the data from the csv file' do
      expect(invoice_repo.find_by_id(1)).to be_a(Invoice)
      expect(invoice_repo.find_by_id(720)).to be_a(Invoice)
      expect(invoice_repo.find_by_id(123123123)).to eq(nil)
    end
    
    it 'creates an invoice item repository object and stores in instance variable' do
      expect(invoice_item_repo).to be_a(InvoiceItemRepository)
    end
    
    it 'contains the data from the csv file' do
      expect(invoice_item_repo.find_by_id(1)).to be_a(InvoiceItem)
      expect(invoice_item_repo.find_by_id(720)).to be_a(InvoiceItem)
      expect(invoice_item_repo.find_by_id(123123123)).to eq(nil)
    end
    
    it 'creates a transaction repository object and stores in instance variable' do
      expect(transaction_repo).to be_a(TransactionRepository)
    end

    it 'contains the data from the csv file' do
      expect(transaction_repo.find_by_id(12)).to be_a(Transaction)
      expect(transaction_repo.find_by_id(68)).to be_a(Transaction)
      expect(transaction_repo.find_by_id(123123123)).to eq(nil)
    end
    
    it 'creates a customer repository object and stores in instance variable' do
      expect(customer_repo).to be_a(CustomerRepository)
    end

    it 'contains the data from the csv file' do
      expect(customer_repo.find_by_id(174)).to be_a(Customer)
      expect(customer_repo.find_by_id(221)).to be_a(Customer)
      expect(customer_repo.find_by_id(1500)).to eq(nil)
    end
  end
end
