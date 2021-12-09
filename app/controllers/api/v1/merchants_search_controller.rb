class Api::V1::MerchantsSearchController < ApplicationController

  def index
    find_names = Merchant.find_all_merchants(params[:name])
    render json: MerchantSerializer.new(find_names)
  end

  def show
    find_name = Merchant.find_merchant(params[:name])
    render json: MerchantSerializer.new(find_name)
  end
end