require 'factory_girl'

FactoryGirl.define do
  factory :page do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraphs.join("\n") }
  end
end
