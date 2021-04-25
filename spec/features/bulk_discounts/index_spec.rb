require 'rails_helper'

describe "merchant bulk discount index" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Jewelry')

    @bulk_discount_1 = BulkDiscount.create!(percentage_discount: 25, quantity_threshold: 10, merchant_id: @merchant1.id)
    @bulk_discount_2 = BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 5, merchant_id: @merchant1.id)
    @bulk_discount_3 = BulkDiscount.create!(percentage_discount: 5, quantity_threshold: 2, merchant_id: @merchant2.id)
    @bulk_discount_4 = BulkDiscount.create!(percentage_discount: 25, quantity_threshold: 10, merchant_id: @merchant2.id)


    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
    @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

    @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
    @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')


    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-28 14:54:09")
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1)
    @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
    @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)

    visit merchant_bulk_discounts_path(@merchant1)
  end

  it "can see all of my bulk discounts including their percentage discount and quantity thresholds" do
    expect(page).to have_content(@bulk_discount_1.percentage_discount)
    expect(page).to have_content(@bulk_discount_1.quantity_threshold)
    expect(page).to have_content(@bulk_discount_2.percentage_discount)
    expect(page).to have_content(@bulk_discount_2.quantity_threshold)
  end

  it "each bulk discount listed includes a link to its show page" do
    within("#bulk_discount-#{@bulk_discount_1.id}") do
      click_link("Percentage Discount: #{@bulk_discount_1.percentage_discount}%, Quantity Threshold: #{@bulk_discount_1.quantity_threshold}")
      expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/#{@bulk_discount_1.id}")
    end
  end

  it "lists the name and date of the next 3 upcoming US holidays" do
    within('#upcoming_holidays') do
      expect(page).to have_content("Upcoming Holidays:")
      expect(page).to have_content("Memorial Day")
      expect(page).to have_content("2021-05-31")
      expect(page).to have_content("Independence Day")
      expect(page).to have_content("2021-07-05")
      expect(page).to have_content("Labor Day")
      expect(page).to have_content("2021-09-06")
    end
  end

  it "I see a link to create a new discount and follow HAPPY PATH" do
    click_link("Create a New Discount")

    expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/new")

    fill_in 'percentage_discount', with: 15
    fill_in 'quantity_threshold', with: 5
    click_button "Create Discount"

    expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts")
    within("#bulk_discounts") do
      expect(page).to have_content("Percentage Discount: 15%")
      expect(page).to have_content("Quantity Threshold: 5")
    end
  end

  it "I see a link to create a new discount and follow SAD PATH" do
    click_link("Create a New Discount")

    expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/new")

    fill_in 'quantity_threshold', with: "fifteen"
    click_button "Create Discount"

    expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/new")
      expect(page).to have_content("Error: Invalid Input. Complete all forms.")
  end
end
