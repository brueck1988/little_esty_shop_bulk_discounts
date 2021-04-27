class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_revenue_with_bulk_discounts
    # # discounted_revenue = Invoice.joins(:bulk_discounts).where("bulk_discounts.quantity_threshold <= invoice_items.quantity").group('bulk_discounts.id').maximum(:bulk_discounts.percentage_discount).sum("invoice_items.unit_price * invoice_items.quantity * bulk_discounts.percentage_discount / 100")
    # # undiscounted_revenue = Invoice.joins(:bulk_discounts).where("bulk_discounts.quantity_threshold > invoice_items.quantity").sum("invoice_items.unit_price * invoice_items.quantity")
    # # total = discounted_revenue + undiscounted_revenue
    # #.sum("bulk_discounts.percentage_discount.to_f / 100")
    # #.select('bulk_discounts.percentage_discount', 'invoice_items.quantity', 'invoice_items.unit_price')
    # ##.select('invoice_items.*', 'bulk_discounts.id', 'bulk_discounts.quantity_threshold', 'bulk_discounts.percentage_discount as percent')
    # require "pry";binding.pry
    # max_percentage_per_quantity_threshold = Invoice.joins(:bulk_discounts).where("bulk_discounts.quantity_threshold <= invoice_items.quantity").select('invoice_items.*', 'bulk_discounts.id', 'bulk_discounts.quantity_threshold', 'bulk_discounts.percentage_discount as percent').group('bulk_discounts.quantity_threshold').sum("(1 - max(bulk_discounts.percentage_discount) / 100) * invoice_items.unit_price * invoice_items.quantity")
    # #Invoice.joins(:bulk_discounts).where("bulk_discounts.quantity_threshold <= invoice_items.quantity").select('invoice_items.*', 'bulk_discounts.id', 'bulk_discounts.quantity_threshold', 'bulk_discounts.percentage_discount').group('bulk_discounts.quantity_threshold').sum("(1 - 'MAX bulk_discounts.percentage_discount' * invoice_items.unit_price * invoice_items.quantity")
    # discounted_revenue = Invoice.joins(:bulk_discounts).where("bulk_discounts.quantity_threshold <= invoice_items.quantity").sum("(1 - bulk_discounts.percentage_discount / 100) * invoice_items.unit_price * invoice_items.quantity")
    # undiscounted_revenue = Invoice.joins(:bulk_discounts).where("bulk_discounts.quantity_threshold > invoice_items.quantity").sum("invoice_items.unit_price * invoice_items.quantity")
    # #total = discounted_revenue + undiscounted_revenue
    10
  end

  def highest_discount
    bulk_discounts.order(:percentage_discount)
    .where("quantity_threshold <= ?", invoice_items.quantity)
    .last
    .discount
  end
end
