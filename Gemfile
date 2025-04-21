source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "mysql2", "~> 0.5"
gem "puma", ">= 5.0"

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

gem "graphql"
gem "graphiql-rails", group: :development
gem "devise"
gem "devise-jwt"

group :development, :test do
  gem "pry"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-graphql", require: false
  gem "graphql-docs", require: false
  gem "rspec-rails"
end

group :test do
  gem "factory_bot_rails"
  gem "shoulda-matchers"
end
