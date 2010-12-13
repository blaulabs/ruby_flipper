require 'bundler'
Bundler.require(:default, :development)

FLIPPER_ENV = {}

Rspec.configure do |config|
  config.mock_with :mocha
  config.after(:each) do
    RubyFlipper.reset
    FLIPPER_ENV.clear
  end
end
