FactoryBot.define do
  factory :membership do
    association :user
    association :group
    status { :pending }
  end
end
