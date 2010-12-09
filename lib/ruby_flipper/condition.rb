module RubyFlipper

  class Condition

    attr_reader :name, :conditions

    def initialize(name, *conditions)
      @name, @conditions = name, conditions.flatten.compact
    end

    def met?
      @conditions.map {|c| self.class.condition_met?(c)}.all?
    end

    def self.condition_met?(condition)
      if condition.is_a?(Symbol)
        referenced_condition = RubyFlipper.conditions[condition]
        raise ConditionNotFoundError, "condition #{condition} is not defined" if referenced_condition.nil?
        referenced_condition.met?
      elsif condition.respond_to?(:call)
        !!condition.call
      else
        !!condition
      end
    end

  end

end
