require 'rails_helper'

describe "Items Search API" do
  it 'can find one item by name search' do
    merchant_1 = Merchant.create!(name: "Moe's Tavern")
    merchant_2 = Merchant.create!(name: "Joe's Tavern")
    merchant_3 = Merchant.create!(name: "Tavern of Moe")
    name = 'Moe'
    get "/api/v1/merchants/find?name=#{name}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    merchant = parsed[:data]

    expect(response).to be_successful

    expect(merchant.first[:attributes][:name]).to eq(merchant_1.name)
  end
  it 'can find all items by name search' do

    merchant_1 = Merchant.create!(name: "Moe's Tavern")
    merchant_2 = Merchant.create!(name: "Joe's Tavern")
    merchant_3 = Merchant.create!(name: "Tavern of Moe")
    name = 'Moe'
    get "/api/v1/merchants/find_all?name=#{name}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    merchant = parsed[:data]

    expect(response).to be_successful

    expect(merchant.first[:attributes][:name]).to eq(merchant_1.name)
    expect(merchant.second[:attributes][:name]).to eq(merchant_3.name)
  end
end