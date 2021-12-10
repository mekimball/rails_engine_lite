require 'rails_helper'

describe 'Items Search API' do
  it 'can find one item by name search' do
    merchant_1 = Merchant.create!(name: "Moe's Tavern")
    merchant_2 = Merchant.create!(name: "Joe's Tavern")
    merchant_3 = Merchant.create!(name: 'Tavern of Moe')
    name = 'Moe'
    get "/api/v1/merchants/find?name=#{name}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    merchant = parsed[:data]

    expect(response).to be_successful

    expect(merchant[:attributes][:name]).to eq(merchant_1.name)
  end

  it 'gives an error if there are no matches' do
    merchant_1 = Merchant.create!(name: "Moe's Tavern")
    merchant_2 = Merchant.create!(name: "Joe's Tavern")
    merchant_3 = Merchant.create!(name: 'Tavern of Moe')

    name = 'flming'
    get "/api/v1/merchants/find?name=#{name}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    item = parsed[:data]

    expect(item).to eq({:error=>"No merchant matches that phrase"})
  end

  it 'can find all items by name search' do
    merchant_1 = Merchant.create!(name: "Moe's Tavern")
    merchant_2 = Merchant.create!(name: "Joe's Tavern")
    merchant_3 = Merchant.create!(name: 'Tavern of Moe')
    name = 'Moe'
    get "/api/v1/merchants/find_all?name=#{name}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    merchant = parsed[:data]

    expect(response).to be_successful

    expect(merchant.first[:attributes][:name]).to eq(merchant_1.name)
    expect(merchant.second[:attributes][:name]).to eq(merchant_3.name)
  end

  it 'gives an error if there are no matches for all' do
    merchant_1 = Merchant.create!(name: "Moe's Tavern")
    merchant_2 = Merchant.create!(name: "Joe's Tavern")
    merchant_3 = Merchant.create!(name: 'Tavern of Moe')

    name = 'flming'
    get "/api/v1/merchants/find_all?name=#{name}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    merchant = parsed[:error]

    expect(merchant).to eq([])
  end
end
