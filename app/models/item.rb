class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_item(search_name)
    where('name ILIKE ?', "%#{search_name}%").order('name asc').first
  end

  def self.find_all_items(search_name)
    where('name ILIKE ?', "%#{search_name}%").order('name asc')
  end

  def self.find_by_price(prices)
    if prices.include?(:min_price) && !prices.include?(:max_price)
      where("unit_price >= ?", prices[:min_price].to_f).order("name asc")
    elsif prices.include?(:max_price) && !prices.include?(:min_price)
      where("unit_price <= ?", prices[:max_price].to_f).order("name asc")
    elsif prices.include?(:min_price) && prices.include?(:max_price)
      where("unit_price BETWEEN ? AND ?", prices[:min_price].to_f, prices[:max_price].to_f).order("name asc")
    end
  end
end
