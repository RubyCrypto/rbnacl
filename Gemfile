source "https://rubygems.org"

gemspec

group :development do
  gem "guard-rspec"
end

group :test do
  gem "rspec"
  gem "rubocop", "0.39.0"
  gem "coveralls", require: false
  gem "rbnacl-libsodium", ENV["LIBSODIUM_VERSION"]
end

group :development, :test do
  gem "rake"
end
