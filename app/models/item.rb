class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_item(search_name)
    where("name ILIKE ?", "%#{search_name}%").order('name asc').limit(1)
  end

    def self.find_all_items(search_name)
    where("name ILIKE ?", "%#{search_name}%").order('name asc')
  end
end
