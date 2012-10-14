require 'factory_girl'

FactoryGirl.define do
  factory :post do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraphs.join("\n") }
    user
  end
end
