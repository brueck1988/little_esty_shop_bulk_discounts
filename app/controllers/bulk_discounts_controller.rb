class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
    @holidays = HolidayService.get_holidays
  end

  def show

  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    bulk_discount = @merchant.bulk_discounts.create(discount_params)
    bulk_discount.save
    redirect_to "/merchant/#{@merchant.id}/bulk_discounts"
  end

  private
  def discount_params
    params.permit(:percentage_discount, :quantity_threshold)
  end
end
