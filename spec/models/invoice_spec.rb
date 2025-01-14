require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions}
    it { should have_many :invoice_items}
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:bulk_discounts).through(:merchants) }
  end
  describe "instance methods" do
    it "total_revenue" do
      merchant1 = Merchant.create!(name: 'Hair Care')
      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
      item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant1.id)
      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 9, unit_price: 10, status: 2)
      ii_11 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(invoice_1.total_revenue).to eq(100)
    end

    it "undiscounted_revenue" do
      merchant1 = Merchant.create!(name: 'Hair Care')
      merchant2 = Merchant.create!(name: 'Weight Loss')

      bulk_discount_1 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 5, merchant_id: merchant1.id)

      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
      item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: merchant1.id)
      item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: merchant1.id)
      item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: merchant1.id)
      item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: merchant1.id)
      item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant1.id)
      item_9 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant2.id)

      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
      customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
      customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
      customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
      customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')

      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      invoice_2 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 10, unit_price: 1000, status: 1)#7500
      ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 6, unit_price: 10, status: 1)#45
      ii_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_3.id, quantity: 6, unit_price: 8, status: 1)#43.2
      ii_4 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_4.id, quantity: 10, unit_price: 5, status: 1)#37.5
                                                                                                                       #7625.7

      ii_6 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_7.id, quantity: 1, unit_price: 5, status: 1)#5
      ii_7 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 1, unit_price: 5, status: 1)#5
                                                                                                                    #10

      ii_8 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_9.id, quantity: 1, unit_price: 5, status: 1)

      transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_1.id)

      expect(invoice_1.undiscounted_revenue).to eq(10)
      expect(invoice_2.undiscounted_revenue).to eq(0)
    end

    it "discounted_revenue" do
      merchant1 = Merchant.create!(name: 'Hair Care')
      merchant2 = Merchant.create!(name: 'Weight Loss')

      bulk_discount_1 = BulkDiscount.create!(percentage_discount: 25, quantity_threshold: 9, merchant_id: merchant1.id)
      bulk_discount_2 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 5, merchant_id: merchant1.id)

      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
      item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: merchant1.id)
      item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: merchant1.id)
      item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: merchant1.id)
      item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: merchant1.id)
      item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant1.id)
      item_9 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant2.id)

      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
      customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
      customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
      customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
      customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')

      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      invoice_2 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 10, unit_price: 1000, status: 1)#7500
      ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 6, unit_price: 10, status: 1)#54
      ii_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_3.id, quantity: 6, unit_price: 8, status: 1)#43.2
      ii_4 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_4.id, quantity: 10, unit_price: 5, status: 1)#37.5
                                                                                                                       #7625.7

      ii_6 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_7.id, quantity: 1, unit_price: 5, status: 1)#5
      ii_7 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_8.id, quantity: 1, unit_price: 5, status: 1)#5

      transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_1.id)

      expect(invoice_1.discounted_revenue).to eq(7634.7)
      expect(invoice_2.discounted_revenue).to eq(0)
    end

    it "total_revenue_with_bulk_discounts" do
      merchant1 = Merchant.create!(name: 'Hair Care')

      bulk_discount_1 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 5, merchant_id: merchant1.id)

      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
      item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: merchant1.id)
      item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: merchant1.id)
      item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: merchant1.id)
      item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: merchant1.id)
      item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant1.id)

      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
      customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
      customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
      customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
      customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')

      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 10, unit_price: 1000, status: 1)#9000
      ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 6, unit_price: 10, status: 1)#54
      ii_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_3.id, quantity: 6, unit_price: 8, status: 1)#43.2
      ii_4 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_4.id, quantity: 10, unit_price: 5, status: 1)#45
                                                                                                                        #9139.2

      ii_6 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_7.id, quantity: 1, unit_price: 5, status: 1)#5
      ii_7 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 1, unit_price: 5, status: 1)#5
      #10
      transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_1.id)
      expect(invoice_1.total_revenue_with_bulk_discounts).to eq(9152.2)
    end
  end
end
