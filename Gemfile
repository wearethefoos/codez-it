source 'https://rubygems.org'

gem 'rails', '3.2.7'

gem 'mongoid'
gem 'bson_ext'
gem 'redis-namespace'

gem 'devise'
gem 'omniauth-github'
gem 'cancan'

gem 'haml-rails'                                  # haml and rails work well together
gem 'compass-rails'
gem 'redcarpet'
gem 'albino', git: 'git://github.com/austinbv/albino.git'

group :assets do
  gem 'sass-rails', '~> 3.2.3'                    # sass
  gem 'coffee-rails', '~> 3.2.1'                  # coffeescript
  gem 'closure-compiler'                          # compilation
  gem 'therubyracer', :platforms => :ruby         # js runtime
end

gem 'jquery-rails'                                # jquery

group :test do
  gem 'rake'
  gem 'database_cleaner'                          # database cleaning during tests
  gem 'cucumber-rails', require: false            # tdd framework
  gem 'capybara'                                  # tdd syntax
end

group :development, :test do
  gem 'rspec-rails'                               # test framework
  gem 'guard'                                     # autotesting
  gem 'rb-fsevent'                                # file save event detection
  gem 'guard-rspec'                               # rspec support for guard
  gem 'terminal-notifier-guard'                   # native os x notifications
  gem 'mongoid-rspec'                             # mongoid support for rspec
  gem 'factory_girl_rails'                        # factories are like fixtures ony better
  gem 'faker'                                     # generate fake data
  gem 'debugger'
end

gem 'unicorn'                                     # threaded webserver

