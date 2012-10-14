require 'factory_girl'

FactoryGirl.define do
  factory :authentication do
    provider { Faker::Company.name }
    uid { Faker::Lorem.word }
  end
end
