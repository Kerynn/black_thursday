require 'csv'
require 'bigdecimal/util'
require_relative 'sales_engine'
require_relative 'item'
require_relative 'merchant'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice'
require_relative 'invoice_repository'

class SalesAnalyst
  attr_reader :items,
              :merchants,
              :invoices,
              :invoice_items,
              :transactions
  def initialize(item_repo = nil, merchant_repo = nil, invoice_repo = nil, invoice_item_repo = nil, transaction_repo = nil)
    @items = item_repo
    @merchants = merchant_repo
    @invoices = invoice_repo
    @invoice_items = invoice_item_repo
    @transactions = transaction_repo
  end

  def item_count
    items.all.count
  end

  def items_per_merchant(id)
    items.find_all_by_merchant_id(id).count
  end

  def merchant_count
    merchants.all.count
  end

  def average_items_per_merchant
    (item_count / merchant_count.to_f).round(2)
  end

  def average_items_per_merchant_standard_deviation
    merchants = @merchants.all.map do |merchant|
      @items.find_all_by_merchant_id(merchant.id).count
    end
    average = average_items_per_merchant
    differences = 0
    merchants.each { |num| differences += (num - average)**2 }
    Math.sqrt(differences / (merchants.count - 1).to_f).round(2)
  end

  def average_item_price_for_merchant(id)
    stock = (items.find_all_by_merchant_id(id))
    price_array = stock.map {|stock| stock.unit_price }.sum
    @average_item_price = (price_array / stock.count).round(2)
    @average_item_price
  end

  def average_average_price_per_merchant
    sellers = merchants.all
    array = []
    sellers.each do |seller|
      array << self.average_item_price_for_merchant(seller.id)
    end
    (array.sum / sellers.count).round(2)
  end

  def merchants_with_high_item_count
    threshold = average_items_per_merchant + average_items_per_merchant_standard_deviation
    @merchants.all.find_all { |merchant| items_per_merchant(merchant.id) > threshold }
  end

  def golden_items
    unit_price_sum = @items.all.map {|item| item.unit_price }.sum
    price_average = unit_price_sum / @items.all.count
    difference_sum = @items.all.map {|item| (price_average - item.unit_price)**2 }.sum
    price_stdrd_dev = Math.sqrt((difference_sum / @items.all.count).abs)
    @items.all.find_all  {|item|  item.unit_price > price_average + (price_stdrd_dev * 2)}
  end

  def invoice_quantity_per_merchant
    merchant_ids = @invoices.all.map { |invoice| invoice.merchant_id}
    hash = Hash.new(0)
    merchant_ids.each do |id|
      hash[id] += 1
    end
    invoices_per_merchant = hash.values.sort
  end

  def merchant_invoice_num(merchant_id)
    invoice_num = 0
    @invoices.all.each do |invoice|
      if invoice.merchant_id == merchant_id
        invoice_num += 1
      end
    end
    invoice_num
  end

  def average_invoices_per_merchant
    (invoice_quantity_per_merchant.sum.to_f / invoice_quantity_per_merchant.count).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    difference_sum = invoice_quantity_per_merchant.map {|invoice_quantity| (average_invoices_per_merchant - invoice_quantity)**2 }.sum
    price_stdrd_dev = Math.sqrt((difference_sum.to_f / invoice_quantity_per_merchant.count).abs).round(2)
  end

  def top_merchants_by_invoice_count
    threshold = average_invoices_per_merchant + average_items_per_merchant_standard_deviation * 2
    @merchants.all.find_all { |merchant| merchant_invoice_num(merchant.id) > threshold}
  end

  def bottom_merchants_by_invoice_count
    threshold = average_invoices_per_merchant - average_items_per_merchant_standard_deviation * 2
    @merchants.all.find_all { |merchant| merchant_invoice_num(merchant.id) < threshold}
  end

  def num_to_weekday(num)
    num_to_days = {0 => 'Sunday',
                   1 => 'Monday',
                   2 => 'Tuesday',
                   3 => 'Wednesday',
                   4 => 'Thursday',
                   5 => 'Friday',
                   6 => 'Saturday'}
    num_to_days[num]
  end

  def invoices_by_day
    invoice_days = invoices.all.map { |invoice| invoice.created_at.wday}
    invoices_by_day = Hash.new(0)
    invoice_days.each do |day|
      invoices_by_day[day] += 1
    end
    invoices_by_day
  end

  def find_top_days(hash, threshold)
    days = []
    hash.each do |day, invoices|
      if (invoices > threshold.round)
        days.push(num_to_weekday(day))
      end
    end
    days
  end

  def top_days_by_invoice_count
    invoices_by_weekday = invoices_by_day
    invoice_average_per_day = (invoices_by_weekday.values.sum.to_f / invoices_by_day.values.count).round(2)
    diff_sum = invoices_by_weekday.values.map { |invoices| (invoice_average_per_day - invoices)**2}.sum
    invoice_stdrd_dev = Math.sqrt((diff_sum.to_f / invoices_by_weekday.values.count).abs).round(2)
    days = find_top_days(invoices_by_weekday, invoice_average_per_day + invoice_stdrd_dev)
  end

  def invoice_status(status)
    num_status = 0
    invoices.all.each do |invoice|
      if invoice.status == status
        num_status += 1
      end
    end
    ((num_status.to_f / invoices.all.count.to_f) * 100).round(2)
  end

  def invoice_paid_in_full?(invoice_id)
    invoice_transactions = @transactions.find_all_by_invoice_id(invoice_id)
    invoice_transactions.any? do |transaction|
      transaction.result == :success
    end
  end

  def invoice_total(invoice_id)
    total_prices = @invoice_items.find_all_by_invoice_id(invoice_id).map do |invoice_item|
      invoice_item.unit_price * invoice_item.quantity
    end
    total_prices.sum
  end

  def merchants_with_pending_invoices
    invoices_pending = []
    @invoices.all.each do |invoice|
      transaction_results = @transactions.find_all_by_invoice_id(invoice.id)
      transaction_results = transaction_results.map { |transaction| transaction.result}
      if !transaction_results.any?(:success)
        invoices_pending.push(@merchants.find_by_id(invoice.merchant_id))
      end
    end
    invoices_pending.uniq
  end

  def merchants_with_only_one_item
    single_item_merchant = @merchants.all.find_all do |merchant|
      items_per_merchant(merchant.id) == 1
    end
  end

  def total_revenue_by_date(date) #yyyy-mm-dd
    ii = @invoice_items.find_all_by_date(date)
    ii.map do |invoice|
      invoice.unit_price
    end.sum.to_f.truncate(2)
  end

  def month_to_number(month)
    months_to_num = {"January" => 1,
                      "February" => 2,
                      "March" => 3,
                      "April" => 4,
                      "May" => 5,
                      "June" => 6,
                      "July" => 7,
                      "August" => 8,
                      "September" => 9,
                      "October" => 10,
                      "November" => 11,
                      "December" => 12}
    months_to_num[month]
  end

  def merchants_with_only_one_item_registered_in_month(month)
   month_value = month_to_number(month)
   merchants_in_month = @merchants.all.find_all {|merchant| merchant.created_at.month == month_value}
   merchants_with_one_item = merchants_in_month.find_all do |merchant|
     items_per_merchant(merchant.id) == 1
   end
  end

  def revenue_by_merchant(id)
    merchant_invoices = @invoices.find_all_by_merchant_id(id)
    total = 0
    merchant_invoices.each do |invoice|
      if invoice_paid_in_full?(invoice.id)
        total += invoice_total(invoice.id)
      end
    end
    total
  end

  def top_revenue_earners(x = 20)
    revenue_to_ids = {}
    @merchants.all.each do |merchant|
      revenue_to_ids[revenue_by_merchant(merchant.id)] = merchant.id
    end
    sorted_revenues = revenue_to_ids.keys.sort.reverse!.take(x)
    top_earning_merchants = []
    sorted_revenues.each do |revenue|
      top_earning_merchants.push(@merchants.find_by_id(revenue_to_ids[revenue]))
    end
    top_earning_merchants
  end

  def total_revenue_by_date(date)
    date = date.to_s
    total_revenue_for_date = 0
    date_invoices = @invoices.all.find_all {|invoice| invoice.created_at.to_s.include?(date)}
    date_invoices.each do |invoice|
      (total_revenue_for_date += invoice_total(invoice.id)) if invoice_paid_in_full?(invoice.id)
    end
    total_revenue_for_date
  end

  def most_sold_item_for_merchant(merchant_id)
    merchant_invoices = @invoices.find_all_by_merchant_id(merchant_id)
    merchant_successful_invoices = merchant_invoices.find_all { |invoice| invoice_paid_in_full?(invoice.id)}
    merchant_invoice_items = merchant_successful_invoices.map { |invoice| @invoice_items.find_all_by_invoice_id(invoice.id)}.flatten
    max_quantity_invoice_item = merchant_invoice_items.max_by { |invoice_item| invoice_item.quantity}
    invoice_items_at_max = merchant_invoice_items.select { |invoice_item| invoice_item.quantity == max_quantity_invoice_item.quantity}
    items_at_max_quantity = invoice_items_at_max.map { |invoice_item| @items.find_by_id(invoice_item.item_id)}
  end

  def best_item_for_merchant(merchant_id)
    merchant_invoices = @invoices.find_all_by_merchant_id(merchant_id)
    merchant_successful_invoices = merchant_invoices.find_all { |invoice| invoice_paid_in_full?(invoice.id)}
    if (merchant_successful_invoices.count > 0)
      merchant_invoice_items = merchant_successful_invoices.map { |invoice| @invoice_items.find_all_by_invoice_id(invoice.id)}.flatten
      max_revenue_invoice_item = merchant_invoice_items.max_by { |invoice_item| invoice_total(invoice_item.invoice_id)}
      item_at_max_revenue = @items.find_by_id(max_revenue_invoice_item.item_id)
    end
  end
end
