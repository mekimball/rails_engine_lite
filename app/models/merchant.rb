class Merchant < ApplicationRecord
  has_many :items

  def self.find_merchant(search_name)
    where('name ILIKE ?', "%#{search_name}%").order('name asc').first
  end

  def self.find_all_merchants(search_name)
    where('name ILIKE ?', "%#{search_name}%").order('name asc')
  end
end
