require 'ruby_flipper/object_mixin'

module RubyFlipper

  class NotDefinedError < StandardError; end

  autoload :ConditionContext, 'ruby_flipper/condition_context'
  autoload :Dsl, 'ruby_flipper/dsl'
  autoload :Feature, 'ruby_flipper/feature'

  def self.load(file)
    Dsl.new.instance_eval(IO.read file)
  end

  def self.reset
    Feature.reset
  end

end
