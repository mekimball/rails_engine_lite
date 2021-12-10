class Api::V1::MerchantsSearchController < ApplicationController
  def find_all
    find_names = Merchant.find_all_merchants(params[:name])
    if find_names.empty?
      render json: { data: [] }, status: 404
    else
      render json: MerchantSerializer.new(find_names)
    end
  end

  def find
    find_name = Merchant.find_merchant(params[:name])
    if find_name.nil?
      render json: { data: { error: 'No merchant matches that phrase' } },
             status: 404
    else
      render json: MerchantSerializer.new(find_name)
    end
  end
end
