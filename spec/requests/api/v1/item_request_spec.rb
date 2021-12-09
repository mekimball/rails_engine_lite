require 'rails_helper'

describe 'Items API' do
  before(:each) do
    @merchant_1 = Merchant.create!(name: "Moe's Tavern")
  end
  it 'returns all items' do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful
    
    parsed = JSON.parse(response.body, symbolize_names: true)
    items = parsed[:data]
    expect(items.count).to eq(3)
    
    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
    end
  end
  it 'returns a single item' do
    item_1 = Item.create(name: "Moe's Tavern", description: "this is a description", unit_price: 25.99, merchant_id: @merchant_1.id)
    
    get "/api/v1/items/#{item_1.id}"
    
    expect(response).to be_successful

    parsed = JSON.parse(response.body, symbolize_names: true)
    item = parsed[:data]

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
  end

  it 'can create an item' do
    item_params = {
                    name: 'Test',
                    description: 'This is a description',
                    unit_price: 24.55,
                    merchant_id: "#{@merchant_1.id}",
                  }
                  headers = {"CONTENT_TYPE" => "application/json"}
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq('Test')
    expect(created_item.description).to eq('This is a description')
    expect(created_item.unit_price).to eq(24.55)
    expect(created_item.merchant_id).to eq(@merchant_1.id)
  end

  it 'can update an item' do
    item_1 = Item.create(name: "Moe's Tavern", description: "this is a description", unit_price: 25.99, merchant_id: @merchant_1.id)

    previous_name = Item.last.name
    item_params = { name: "This is a New Name" }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item_1.id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: item_1.id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("This is a New Name")
  end

  it 'can delete an item' do
    merchant_1 = Merchant.create!(name: "Moe's Tavern")
    item_1 = merchant_1.items.create!(name: "Flaming Moe", description: "It's delicious!", unit_price: 8.99)

    delete "/api/v1/items/#{item_1.id}"

    deleted_item_response = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(deleted_item_response[:id]).to eq(item_1.id)
    expect(Item.count).to eq(0)
    expect{Item.find(item_1.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
  
  it 'can return the merchant data for an item' do
    merchant_1 = Merchant.create!(name: "Moe's Tavern")
    item_1 = merchant_1.items.create!(name: "Flaming Moe", description: "It's delicious!", unit_price: 8.99)
    
    get "/api/v1/items/#{item_1.id}/merchant"

    parsed = JSON.parse(response.body, symbolize_names: true)
    merchant = parsed[:data]

    expect(response).to be_successful
    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)
    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)
    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end
end