FactoryBot.define do
  factory :group do
    association :owner, factory: :user
    name { "Group #{SecureRandom.hex(4)}" }
    description { "Description for #{name}" }
    status { :active }
  end
end
