require 'factory_girl'

FactoryGirl.define do
  sequence(:random_string) {|n| Faker::Lorem.word }

  factory :account do
    name { generate(:random_string) }
  end
end
