class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
    @holidays = HolidayService.get_holidays
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    bulk_discount = @merchant.bulk_discounts.create(discount_params)
    if bulk_discount.save
      redirect_to "/merchant/#{@merchant.id}/bulk_discounts"
    else
      flash[:notice] = "Error: Invalid Input. Complete all forms."
      redirect_to "/merchant/#{@merchant.id}/bulk_discounts/new"
    end
  end

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to "/merchant/#{params[:merchant_id]}/bulk_discounts"
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    if bulk_discount.update(discount_params)
      redirect_to "/merchant/#{merchant.id}/bulk_discounts/#{bulk_discount.id}"
    else
      flash[:notice] = "Error: Invalid Input. Complete all forms."
      redirect_to "/merchant/#{merchant.id}/bulk_discounts/#{bulk_discount.id}/edit"
    end
  end

  private
  def discount_params
    params.permit(:percentage_discount, :quantity_threshold)
  end
end
