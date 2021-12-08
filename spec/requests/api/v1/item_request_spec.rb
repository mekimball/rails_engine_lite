require 'rails_helper'

describe 'Items API' do
  before(:each) do
    @merchant_1 = Merchant.create!(name: "Test", id: 1)
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
    merchant_1 = Merchant.create!(:name => "Moe's Tavern")
    item_1 = Item.create!(name: 'Flaming Moe', )
    
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
    expect(created_item.merchant_id).to eq(1)
  end

  it 'can update an item' do

    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: "This is a New Name" }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("This is a New Name")
  end

  it 'can delete an item' do
    item = create(:item)

    delete "/api/v1/items/#{item.id}"

    deleted_item_response = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(deleted_item_response[:id]).to eq(item.id)
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end