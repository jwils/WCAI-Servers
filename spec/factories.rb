FactoryGirl.define do
  factory :user do 
    sequence(:email) { |n| "foo#{n}@example.com" }
    password 'secret'
    password_confirmation { |u| u.password }
    sequence(:name) { |n| "Foo#{n}"}
    institution 'University of Pennsylvania'

    trait :admin do
      after(:create) {|user| user.add_role :admin}
    end

    trait :administrator do
      after(:create) {|user| user.add_role :admin}
    end


    trait :research_assistant do
      after(:create) {|user| user.add_role :research_assistant}
    end

    trait :researcher do
      after(:create) do |user|
        user.project = build(:project)
        user.add_role(:researcher, project)
      end
    end
  end

  factory :project do
    association :user, :admin
    company_id Company.new(:name => "Test Company").id
    current_state "Testing"
    description "This is the project description"
    start_date  { Time.now }
  end
end
