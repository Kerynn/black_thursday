class InvoiceItemRepository
  attr_reader :invoiceitems

  def inspect
    "#<#{self.class} #{@invoiceitems.size} rows>"
  end

  def initialize(invoiceitems)
    @invoiceitems = invoiceitems
  end

  def all
    @invoiceitems
  end

  def find_by_id(id)
    @invoiceitems.find {|invoiceitem| invoiceitem.id == id}
  end

  def find_all_by_item_id(id)
    @invoiceitems.find_all {|invoiceitem| invoiceitem.item_id == id}
  end

  def find_all_by_invoice_id(id)
    @invoiceitems.find_all {|invoiceitem| invoiceitem.invoice_id == id}
  end

  def create(attributes)
    ids = @invoiceitems.map { |invoiceitem| invoiceitem.id}
    attributes[:id] = ids.max + 1
    new_invoice_item = InvoiceItem.new(attributes)
    @invoiceitems.push(new_invoice_item)
    new_invoice_item
  end

  def delete(id)
    @invoiceitems.delete(find_by_id(id))
  end
end