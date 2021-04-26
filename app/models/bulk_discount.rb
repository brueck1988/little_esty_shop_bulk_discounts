class BulkDiscount < ApplicationRecord
  validates :percentage_discount, :quantity_threshold, numericality: true
  belongs_to :merchant
end
