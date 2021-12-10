require 'rails_helper'

describe 'Items Search API' do
  it 'can find one item by name search' do
    merchant_1 = create(:merchant)
    item_1 = create(:item, name: 'Flaming Moe', merchant_id: merchant_1.id)
    item_2 = create(:item, name: 'Flaming Homer', merchant_id: merchant_1.id)
    item_3 = create(:item, name: 'Something something flaming',
                           merchant_id: merchant_1.id)
    item_4 = create(:item, name: 'Duff', merchant_id: merchant_1.id)
    name = 'flaming'
    get "/api/v1/items/find?name=#{name}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    item = parsed[:data]
    expect(response).to be_successful

    expect(item[:attributes][:name]).to eq(item_2.name)
  end

  it 'gives an error if there are no matches' do
    merchant_1 = create(:merchant)
    item_1 = create(:item, name: 'Flaming Moe', merchant_id: merchant_1.id)
    item_2 = create(:item, name: 'Flaming Homer', merchant_id: merchant_1.id)
    item_3 = create(:item, name: 'Something something flaming',
                           merchant_id: merchant_1.id)
    item_4 = create(:item, name: 'Duff', merchant_id: merchant_1.id)
    name = 'flming'
    get "/api/v1/items/find?name=#{name}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    item = parsed[:data]

    expect(item).to eq({ error: 'No item matches that phrase' })
  end

  it 'can find all items by name search' do
    merchant_1 = create(:merchant)
    item_1 = create(:item, name: 'Flaming Moe', merchant_id: merchant_1.id)
    item_2 = create(:item, name: 'Flaming Homer', merchant_id: merchant_1.id)
    item_3 = create(:item, name: 'Something something flaming',
                           merchant_id: merchant_1.id)
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

  it 'gives an error if there are no matches in all' do
    merchant_1 = create(:merchant)
    item_1 = create(:item, name: 'Flaming Moe', merchant_id: merchant_1.id)
    item_2 = create(:item, name: 'Flaming Homer', merchant_id: merchant_1.id)
    item_3 = create(:item, name: 'Something something flaming',
                           merchant_id: merchant_1.id)
    item_4 = create(:item, name: 'Duff', merchant_id: merchant_1.id)
    name = 'flming'
    get "/api/v1/items/find_all?name=#{name}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    item = parsed[:error]

    expect(item).to eq({ details: 'No items matches this id' })
  end

  it 'gives an error if there are no name in all' do
    merchant_1 = create(:merchant)
    item_1 = create(:item, name: 'Flaming Moe', merchant_id: merchant_1.id)
    item_2 = create(:item, name: 'Flaming Homer', merchant_id: merchant_1.id)
    item_3 = create(:item, name: 'Something something flaming',
                           merchant_id: merchant_1.id)
    item_4 = create(:item, name: 'Duff', merchant_id: merchant_1.id)
    name = ''
    get "/api/v1/items/find_all?name=#{name}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    item = parsed[:error]

    expect(item).to eq({ details: 'Name cannot be blank' })
  end

  it 'can search for min price' do
    merchant_1 = create(:merchant)
    item_1 = create(:item, name: 'Flaming Moe', unit_price: 899,
                           merchant_id: merchant_1.id)
    item_2 = create(:item, name: 'Flaming Homer', unit_price: 999,
                           merchant_id: merchant_1.id)
    item_3 = create(:item, name: 'Something something flaming', unit_price: 399,
                           merchant_id: merchant_1.id)
    item_4 = create(:item, name: 'Duff', unit_price: 299,
                           merchant_id: merchant_1.id)

    min_price = 400
    get "/api/v1/items/find_all?min_price=#{min_price}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    item = parsed[:data]

    expect(item.first[:attributes][:name]).to eq(item_2.name)
    expect(item.second[:attributes][:name]).to eq(item_1.name)
  end

  it 'can search for max price' do
    merchant_1 = create(:merchant)
    item_1 = create(:item, name: 'Flaming Moe', unit_price: 899,
                           merchant_id: merchant_1.id)
    item_2 = create(:item, name: 'Flaming Homer', unit_price: 999,
                           merchant_id: merchant_1.id)
    item_3 = create(:item, name: 'Something something flaming', unit_price: 399,
                           merchant_id: merchant_1.id)
    item_4 = create(:item, name: 'Duff', unit_price: 299,
                           merchant_id: merchant_1.id)

    max_price = 400
    get "/api/v1/items/find_all?max_price=#{max_price}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    item = parsed[:data]

    expect(item.first[:attributes][:name]).to eq(item_4.name)
    expect(item.second[:attributes][:name]).to eq(item_3.name)
  end

  it 'can search for min and max price' do
    merchant_1 = create(:merchant)
    item_1 = create(:item, name: 'Flaming Moe', unit_price: 899,
                           merchant_id: merchant_1.id)
    item_2 = create(:item, name: 'Flaming Homer', unit_price: 999,
                           merchant_id: merchant_1.id)
    item_3 = create(:item, name: 'Something something flaming', unit_price: 399,
                           merchant_id: merchant_1.id)
    item_4 = create(:item, name: 'Duff', unit_price: 299,
                           merchant_id: merchant_1.id)

    min_price = 300
    max_price = 900
    get "/api/v1/items/find_all?min_price=#{min_price}&max_price=#{max_price}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    item = parsed[:data]

    expect(item.first[:attributes][:name]).to eq(item_1.name)
    expect(item.second[:attributes][:name]).to eq(item_3.name)
  end

  it 'returns an error if name and price are searched' do
    merchant_1 = create(:merchant)
    item_1 = create(:item, name: 'Flaming Moe', unit_price: 899,
                           merchant_id: merchant_1.id)
    item_2 = create(:item, name: 'Flaming Homer', unit_price: 999,
                           merchant_id: merchant_1.id)
    item_3 = create(:item, name: 'Something something flaming', unit_price: 399,
                           merchant_id: merchant_1.id)
    item_4 = create(:item, name: 'Duff', unit_price: 299,
                           merchant_id: merchant_1.id)

    name = 'flaming'
    max_price = 400
    get "/api/v1/items/find_all?max_price=#{max_price}&name=#{name}"

    parsed = JSON.parse(response.body, symbolize_names: true)
    item = parsed[:error]

    expect(item).to eq({ details: 'Choose either name OR price, not both' })
  end
end
