require 'rails_helper'

describe 'Merchant API' do
  it 'returns all merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    
    parsed = JSON.parse(response.body, symbolize_names: true)
    merchants = parsed[:data]
    expect(merchants.count).to eq(3)
    
    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end
    
  it 'returns a single merchant' do
    id = create(:merchant).id
    
    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful
    
    parsed = JSON.parse(response.body, symbolize_names: true)
    merchant = parsed[:data]
    
    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)
    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)
    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end
  
  it 'can return all a merchants items' do
    merchant_1 = Merchant.create!(name: "Moe's Tavern")
    merchant_2 = Merchant.create!(name: "Joe's Tavern")
    item_1 = merchant_1.items.create!(name: "Flaming Moe", description: "It's delicious!", unit_price: 8.99)
    item_2 = merchant_1.items.create!(name: "Flaming Homer", description: "It's more delicious!", unit_price: 9.99)
    item_3 = merchant_2.items.create!(name: "Duff", description: "It's okay!", unit_price: 3.99)


    get "/api/v1/merchants/#{merchant_1.id}/items"

    parsed = JSON.parse(response.body, symbolize_names: true)
    items = parsed[:data]

    expect(response).to be_successful
    expect(items.count).to eq(2)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
    end
  end
end