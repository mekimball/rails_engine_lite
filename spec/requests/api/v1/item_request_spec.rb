require 'rails_helper'

describe 'Item API' do
  it 'returns all items' do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    # items = JSON.parse(response.body, symbolize_names: true)

    # expect(items.count).to eq(3)

    # items.each do |item|

    #   expect(item).to have_key(:name)
    #   expect(item[:name]).to be_a(String)
      
    #   expect(item).to have_key(:description)
    #   expect(item[:description)]).to be_a(String)

    #   expect(item).to have_key(:unit_price)
    #   expect(item[:unit_price)]).to be_a(Float)

    #   expect(item).to have_key(:merchant_id)
    #   expect(item[:merchant_id]).to be_a(Integer)
    # end
  end
end