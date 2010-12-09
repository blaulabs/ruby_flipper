module RubyFlipper

  class Feature

    attr_reader :name, :description, :condition

    def initialize(name, description, condition)
      @name, @description, @condition = name, description, Condition.new(:inline_condition, condition)
    end

    def active?
      @condition.met?
    end

  end

end
