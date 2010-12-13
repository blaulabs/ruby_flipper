require 'ruby_flipper'
require 'rails'

module RubyFlipper

  class Railtie < Rails::Railtie

    initializer :initialize_ruby_flipper_config, :before => :load_config_initializers do
      RubyFlipper.config[:feature_file] = Rails.root.join 'config/features.rb'
    end

    initializer :load_ruby_flipper_features, :after => :load_config_initializers do
      RubyFlipper.load
    end

  end

end
