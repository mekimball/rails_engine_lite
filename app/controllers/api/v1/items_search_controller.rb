class Api::V1::ItemsSearchController < ApplicationController
  def find_all
    if params.include?(:name) && (params.include?(:min_price) || params.include?(:max_price))
      render json: { error: { details: 'Choose either name OR price, not both' } },
             status: 400
    elsif params[:name] == ''
      render json: { error: { details: 'Name cannot be blank' } }, status: 400
    elsif params.include?(:min_price) || params.include?(:max_price)
      render json: ItemSerializer.new(Item.find_by_price(params))
    elsif Item.find_all_items(params[:name]).empty?
      render json: { data: [] },
             status: 200
    else
      render json: ItemSerializer.new(Item.find_all_items(params[:name]))
    end
  end

  def find
    find_name = Item.find_item(params[:name])
    if find_name.nil?
      render json: { data: { error: 'No item matches that phrase' } },
             status: 200
    else
      render json: ItemSerializer.new(find_name)
    end
  end
end
