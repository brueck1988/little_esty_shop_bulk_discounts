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
    undiscounted_revenue = self.undiscounted_revenue
    discounted_revenue = self.discounted_revenue
    discounted_revenue + undiscounted_revenue
  end

  def undiscounted_revenue
    bulk_discounts
      .where("bulk_discounts.quantity_threshold > invoice_items.quantity")
      .sum("invoice_items.unit_price * invoice_items.quantity").to_f
  end


  def discounted_revenue
    bulk_discounts
      .where("bulk_discounts.quantity_threshold <= invoice_items.quantity")
      .select("invoice_items.id, min(invoice_items.unit_price * invoice_items.quantity * (1 - (bulk_discounts.percentage_discount / 100.0))) as total_discount")
      .group("invoice_items.id")
      .sum(&:total_discount).to_f
  end
end
