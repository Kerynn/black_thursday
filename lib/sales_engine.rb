require 'csv'
require 'time'
require_relative 'item'
require_relative 'merchant'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'sales_analyst'
require_relative 'invoice'
require_relative 'invoice_repository'
require_relative 'invoice_item'
require_relative 'invoice_item_repository'
require_relative 'transaction'
require_relative 'transaction_repository'
require_relative 'customer'
require_relative 'customer_repository'

class SalesEngine

  attr_reader :items,
              :merchants,
              :invoices,
              :analyst,
              :invoice_items,
              :transactions,
              :customers

  def initialize(csv_hash)
    @items = create_item_repo(csv_hash[:items]) if (csv_hash.has_key?(:items))
    @merchants = create_merchant_repo(csv_hash[:merchants]) if (csv_hash.has_key?(:merchants))
    @invoices = create_invoice_repo(csv_hash[:invoices]) if (csv_hash.has_key?(:invoices))
    @invoice_items = create_invoice_item_repo(csv_hash[:invoice_items]) if (csv_hash.has_key?(:invoice_items))
    @transactions = create_transaction_repo(csv_hash[:transactions]) if (csv_hash.has_key?(:transactions))
    @customers = create_customer_repo(csv_hash[:customers]) if (csv_hash.has_key?(:customers))
    @analyst = SalesAnalyst.new(@items, @merchants, @invoices, @invoice_items, @transactions)
  end

  def self.from_csv(csv_hash)
    sales_engine = SalesEngine.new(csv_hash)
  end

  def format_item_hash(hash)
    {:id => hash[:id].to_i,
     :name => hash[:name],
     :description => hash[:description],
     :unit_price => (hash[:unit_price].to_d * (10**(-2))),
     :created_at => Time.parse(hash[:created_at]),
     :updated_at => Time.parse(hash[:updated_at]),
     :merchant_id => hash[:merchant_id].to_i}
  end

  def create_item_repo(item_csv)
    items = []
    contents = CSV.open item_csv, headers: true, header_converters: :symbol
    contents.each do |row|
      items.push(Item.new(format_item_hash(row)))
    end
    item_repo = ItemRepository.new(items)
  end

  def format_merchant_hash(hash)
    {:id => hash[:id].to_i,
     :name => hash[:name],
     :created_at => Time.parse(hash[:created_at]),
     :updated_at => Time.parse(hash[:updated_at])}
  end

  def create_merchant_repo(merchant_csv)
    merchants = []
    contents = CSV.open merchant_csv, headers: true, header_converters: :symbol
    contents.each do |row|
      merchants.push(Merchant.new(format_merchant_hash(row)))
    end
    merchant_repo = MerchantRepository.new(merchants)
  end

  def format_invoice_hash(hash)
    {:id => hash[:id].to_i,
     :name => hash[:name],
     :customer_id => hash[:customer_id].to_i,
     :merchant_id => hash[:merchant_id].to_i,
     :status => hash[:status].to_sym,
     :created_at => Time.parse(hash[:created_at]),
     :updated_at => Time.parse(hash[:updated_at])}
  end

  def create_invoice_repo(invoice_csv)
    invoices = []
    contents = CSV.open invoice_csv, headers: true, header_converters: :symbol
    contents.each do |row|
      invoices.push(Invoice.new(format_invoice_hash(row)))
    end
    invoice_repo = InvoiceRepository.new(invoices)
  end

  def format_invoice_item_hash(hash)
    {:id => hash[:id].to_i,
     :item_id => hash[:item_id].to_i,
     :invoice_id => hash[:invoice_id].to_i,
     :quantity => hash[:quantity].to_i,
     :unit_price => hash[:unit_price].to_d * (10**(-2)),
     :created_at => Time.parse(hash[:created_at]),
     :updated_at => Time.parse(hash[:updated_at])}
  end

  def create_invoice_item_repo(invoice_items_csv)
    invoice_items = []
    contents = CSV.open invoice_items_csv, headers: true, header_converters: :symbol
    contents.each do |row|
      invoice_items.push(InvoiceItem.new(format_invoice_item_hash(row)))
    end
    invoice_item_repo = InvoiceItemRepository.new(invoice_items)
  end

  def format_transaction_hash(hash)
    {:id => hash[:id].to_i,
     :invoice_id => hash[:invoice_id].to_i,
     :credit_card_number => hash[:credit_card_number],
     :credit_card_expiration_date => hash[:credit_card_expiration_date],
     :result => hash[:result].to_sym,
     :created_at => Time.parse(hash[:created_at]),
     :updated_at => Time.parse(hash[:updated_at])}
  end

  def create_transaction_repo(transaction_csv)
    transactions = []
    contents = CSV.open transaction_csv, headers: true, header_converters: :symbol
    contents.each do |row|
      transactions.push(Transaction.new(format_transaction_hash(row)))
    end
    transaction_repo = TransactionRepository.new(transactions)
  end

  def format_customer_hash(hash)
    {:id => hash[:id].to_i,
     :first_name => hash[:first_name],
     :last_name => hash[:last_name],
     :created_at => Time.parse(hash[:created_at]),
     :updated_at => Time.parse(hash[:updated_at])}
  end

  def create_customer_repo(customer_csv)
    customers = []
    contents = CSV.open customer_csv, headers: true, header_converters: :symbol
    contents.each do |row|
      customers.push(Customer.new(format_customer_hash(row)))
    end
    customer_repo = CustomerRepository.new(customers)
  end
end
