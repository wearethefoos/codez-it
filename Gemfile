source 'https://rubygems.org'

gem 'rails', '3.2.7'

gem 'mongoid'
gem 'bson_ext'

gem 'devise'

gem 'haml-rails'                                  # haml and rails work well together

group :assets do
  gem 'sass-rails', '~> 3.2.3'                    # sass
  gem 'coffee-rails', '~> 3.2.1'                  # coffeescript
  gem 'closure-compiler'                          # compilation
  gem 'therubyracer', :platforms => :ruby         # js runtime
end

gem 'jquery-rails'                                # jquery

group :test do
  gem 'guard'                                     # autotesting
  gem 'guard-rspec'                               # rspec support for guard
  gem 'database_cleaner'                          # database cleaning during tests
  gem 'factory_girl_rails'                        # factories are like fixtures ony better
  gem 'cucumber-rails'                            # tdd framework
  gem 'capybara'                                  # tdd syntax
  gem 'mongoid-rspec'                             # mongoid support for rspec
end

group :development, :test do
  gem 'rspec-rails'                               # test framework
  gem 'debugger'
end

gem 'unicorn'                                     # threaded webserver
