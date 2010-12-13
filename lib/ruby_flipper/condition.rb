module RubyFlipper

  class Condition

  private

    def self.conditions
      @@conditions ||= {}
    end

  public

    def self.reset
      @@conditions = nil
    end

    def self.add(name, *conditions)
      self.conditions[name] = new(name, *conditions)
    end

    def self.find(name)
      conditions[name] || raise(ConditionNotFoundError, "condition #{name} is not defined")
    end

    def self.met?(condition)
      if condition.is_a?(Symbol)
        find(condition).met?
      elsif condition.is_a?(Proc)
        !!ConditionContext.new.instance_eval(&condition)
      elsif condition.respond_to?(:call)
        !!condition.call
      else
        !!condition
      end
    end

    attr_reader :name, :conditions

    def initialize(name, *conditions)
      @name, @conditions = name, conditions.flatten.compact
    end

    def met?
      @conditions.map {|c| self.class.met?(c)}.all?
    end

  end

end
