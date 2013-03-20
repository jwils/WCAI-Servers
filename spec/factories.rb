FactoryGirl.define do
  factory :user do 
    sequence(:email) { |n| "foo#{n}@example.com" }
    password 'secret'
    password_confirmation { |u| u.password }
    sequence(:name) { |n| "Foo#{n}"}
    institution 'University of Pennsylvania'
  end
end
