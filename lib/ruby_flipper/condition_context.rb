module RubyFlipper

  class ConditionContext

    def met?(*conditions)
      Condition.new(:inline_condition, *conditions).met?
    end
    alias :condition_met? :met?

  end

end
