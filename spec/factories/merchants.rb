FactoryBot.define do
  factory :merchant do
    name { Faker::TvShows::Simpsons.character }
  end
end
