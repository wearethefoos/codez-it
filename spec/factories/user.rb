require 'factory_girl'

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'p4ssw0rd' }
    confirmed_at { Time.now.yesterday }

    account

    after(:create) do |user, evaluator|
      user.authentications = FactoryGirl.create_list :authentication, 1, user: user
    end

    factory :admin do
      admin true
    end
  end
end
