source 'https://rubygems.org'

gem 'activeadmin'
gem 'devise'
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.2'
gem 'sidekiq'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rubocop', '~> 0.62.0'
  gem 'simplecov'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'flamegraph'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rack-mini-profiler', '~> 0.10'
  gem 'stackprof'
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
