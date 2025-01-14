require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_many(:merchants).through(:item) }
    it { should have_many(:bulk_discounts).through(:merchants) }


  end

  describe "Instance Methods" do
    describe '#applied_discount' do
      it 'I get the name of a discount that is applied to the invoice item' do
        merchant1 = Merchant.create!(name: 'Hair Care')

        bulk_discount_1 = BulkDiscount.create!(percentage_discount: 25, quantity_threshold: 9, merchant_id: merchant1.id)
        bulk_discount_2 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 5, merchant_id: merchant1.id)


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

        invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2,  created_at: "2012-03-27 14:54:09")
        invoice_2 = Invoice.create!(customer_id: customer_1.id, status: 2,  created_at: "2012-03-28 14:54:09")
        invoice_3 = Invoice.create!(customer_id: customer_2.id, status: 2)
        invoice_4 = Invoice.create!(customer_id: customer_3.id, status: 2)
        invoice_5 = Invoice.create!(customer_id: customer_4.id, status: 2)
        invoice_6 = Invoice.create!(customer_id: customer_5.id, status: 2)
        invoice_7 = Invoice.create!(customer_id: customer_6.id, status: 1)

        ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 9, unit_price: 10, status: 2, created_at: "2012-03-27 14:54:09")
        ii_2 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_1.id, quantity: 9, unit_price: 10, status: 2, created_at: "2012-03-28 14:54:09")
        ii_3 = InvoiceItem.create!(invoice_id: invoice_3.id, item_id: item_2.id, quantity: 2, unit_price: 8, status: 2)
        ii_4 = InvoiceItem.create!(invoice_id: invoice_4.id, item_id: item_3.id, quantity: 3, unit_price: 5, status: 1)
        ii_6 = InvoiceItem.create!(invoice_id: invoice_5.id, item_id: item_4.id, quantity: 1, unit_price: 1, status: 1)
        ii_7 = InvoiceItem.create!(invoice_id: invoice_6.id, item_id: item_7.id, quantity: 1, unit_price: 3, status: 1)
        ii_8 = InvoiceItem.create!(invoice_id: invoice_7.id, item_id: item_8.id, quantity: 1, unit_price: 5, status: 1)
        ii_9 = InvoiceItem.create!(invoice_id: invoice_7.id, item_id: item_4.id, quantity: 1, unit_price: 1, status: 1)

        transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_1.id)
        transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: invoice_2.id)
        transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: invoice_3.id)
        transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: invoice_4.id)
        transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: invoice_5.id)
        transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: invoice_6.id)
        transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_7.id)

        expect(ii_1.applied_discount).to eq(bulk_discount_1)
      end
    end

    it "applicable_discount?" do
      merchant1 = Merchant.create!(name: 'Hair Care')
      merchant2 = Merchant.create!(name: 'Hair Care')

      bulk_discount_1 = BulkDiscount.create!(percentage_discount: 25, quantity_threshold: 9, merchant_id: merchant1.id)
      bulk_discount_2 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 5, merchant_id: merchant1.id)

      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
      item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: merchant1.id)
      item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: merchant1.id)
      item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: merchant1.id)
      item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: merchant1.id)
      item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: merchant2.id)

      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
      customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
      customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
      customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
      customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')

      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

      ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 10, unit_price: 1000, status: 1)#7500
      ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 6, unit_price: 10, status: 1)#45
      ii_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_3.id, quantity: 6, unit_price: 8, status: 1)#43.2
      ii_4 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_4.id, quantity: 10, unit_price: 5, status: 1)#37.5
                                                                                                                       #7625.7

      ii_6 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_7.id, quantity: 1, unit_price: 5, status: 1)#5
      ii_7 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_8.id, quantity: 1, unit_price: 5, status: 1)#5
                                                                                                                    #10
      transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_1.id)

      expect(ii_1.applicable_discount?).to eq(bulk_discount_1)
      expect(ii_7.applicable_discount?).to eq(false)
    end
  end
end
