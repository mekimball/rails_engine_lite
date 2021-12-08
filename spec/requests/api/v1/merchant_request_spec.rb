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
    merchant_1 = Merchant.create!(:name => "Moe's Tavern")
    
    get "/api/v1/merchants/#{merchant_1.id}"

    expect(response).to be_successful

    parsed = JSON.parse(response.body, symbolize_names: true)
    merchant = parsed[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)
    expect(merchant[:attributes]).to have_key(:id)
    expect(merchant[:attributes]).to have_key(:name)
  end
end