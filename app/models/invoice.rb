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
    discounted_revenue = Invoice.joins(:bulk_discounts).where("bulk_discounts.quantity_threshold <= invoice_items.quantity").sum("invoice_items.unit_price * invoice_items.quantity * bulk_discounts.percentage_discount / 100")
    undiscounted_revenue = Invoice.joins(:bulk_discounts).where("bulk_discounts.quantity_threshold < invoice_items.quantity").sum("invoice_items.unit_price * invoice_items.quantity")
    discounted_revenue + undiscounted_revenue
    #Invoice.joins(:bulk_discounts).where("invoice.status = 2 AND bulk_discounts.quantity_threshold <= invoice_items.quantity").sum("(invoice_items.unit_price * invoice_items.quantity) * (bulk_discounts.discount/100)")
  end

  def highest_discount
    bulk_discounts.order(:percentage_discount)
    .where("quantity_threshold <= ?", invoice_items.quantity)
    .last
    .discount
  end
end
