FactoryBot.define do
  factory :post do
    association :user
    association :group
    title { "Sample Post Title" }
    content { "This is a sample content for the post." }
    status { :draft }
    published_at { nil }
  end
end
