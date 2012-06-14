# -*- encoding : utf-8 -*-
require 'ruby_flipper/object_mixin'

module RubyFlipper

  class NotDefinedError < StandardError; end

  autoload :ConditionContext, 'ruby_flipper/condition_context'
  autoload :Dsl, 'ruby_flipper/dsl'
  autoload :Feature, 'ruby_flipper/feature'

  def self.config
    @@config ||= {}
  end

  def self.config=(config)
    @@config = config
  end

  def self.load(file = nil)
    file ||= config[:feature_file]
    raise ArgumentError, 'you have to either specify or configure a feature definition file in RubyFlipper::config[:feature_file]' if file.nil?
    Dsl.new.instance_eval(IO.read file) if File.exist?(file)
  end

  def self.reset
    @@config = nil
    Feature.reset
  end

  def self.silence_warnings
    warn_level = $VERBOSE
    $VERBOSE = nil
    yield
  ensure
    $VERBOSE = warn_level
  end

end

require 'ruby_flipper/railtie' if defined?(Rails)
