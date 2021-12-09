require 'rails_helper'

describe "Items Search API" do
  it 'can find one item by name search' do
    merchant_1 = create(:merchant)
    item_1 = create(:item, name: 'Flaming Moe', merchant_id: merchant_1.id)
    item_2 = create(:item, name: 'Flaming Homer', merchant_id: merchant_1.id)
    item_3 = create(:item, name: 'Something something flaming', merchant_id: merchant_1.id)
    item_4 = create(:item, name: 'Duff', merchant_id: merchant_1.id)
    name = 'flaming'
    get "/api/v1/items/find?name=#{name}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    item = parsed[:data]

    expect(response).to be_successful

    expect(item[:attributes][:name]).to eq(item_2.name)
  end
    it 'can find all items by name search' do
    merchant_1 = create(:merchant)
    item_1 = create(:item, name: 'Flaming Moe', merchant_id: merchant_1.id)
    item_2 = create(:item, name: 'Flaming Homer', merchant_id: merchant_1.id)
    item_3 = create(:item, name: 'Something something flaming', merchant_id: merchant_1.id)
    item_4 = create(:item, name: 'Duff', merchant_id: merchant_1.id)
    name = 'flaming'
    get "/api/v1/items/find_all?name=#{name}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    item = parsed[:data]

    expect(response).to be_successful

    expect(item.first[:attributes][:name]).to eq(item_2.name)
    expect(item.second[:attributes][:name]).to eq(item_1.name)
    expect(item.third[:attributes][:name]).to eq(item_3.name)
  end
end