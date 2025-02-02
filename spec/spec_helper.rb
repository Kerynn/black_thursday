require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

require 'pry'

require 'bigdecimal/util'
require './lib/item'
require './lib/merchant'
require './lib/item_repository'
require './lib/merchant_repository'
require './lib/sales_analyst'
require './lib/invoice'
require './lib/invoice_repository'
require './lib/invoice_item'
require './lib/invoice_item_repository'
require './lib/transaction'
require './lib/transaction_repository'
require './lib/customer'
require './lib/customer_repository'
