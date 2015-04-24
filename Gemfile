source "https://rubygems.org"

# Specify your gem's dependencies in rbnacl.gemspec
gemspec

group :development do
  gem "guard-rspec"
end

group :test do
  gem "coveralls", require: false
  gem "rbnacl-libsodium"
end

group :development, :test do
  gem "rubocop"
end
