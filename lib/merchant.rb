require 'csv'

class Merchant
  attr_reader :id,
              :name,
              :created_at,
              :updated_at

  def initialize(merch_hash)
    @id = merch_hash[:id]
    @name = merch_hash[:name]
    @created_at = merch_hash[:created_at]
    @updated_at = merch_hash[:updated_at]
  end

  def update_name(name)
    @name = name
  end
end
