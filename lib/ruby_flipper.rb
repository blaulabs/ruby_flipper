module RubyFlipper

  class ConditionNotFoundError < StandardError; end

  autoload :Condition, 'ruby_flipper/condition'
  autoload :Dsl, 'ruby_flipper/dsl'
  autoload :Feature, 'ruby_flipper/feature'

  def self.conditions
    @@conditions ||= {}
  end

  def self.features
    @@features ||= {}
  end

  def self.load(file)
    Dsl.new.instance_eval(IO.read file)
  end

  def self.reset
    @@conditions = @@features = nil
  end

end
