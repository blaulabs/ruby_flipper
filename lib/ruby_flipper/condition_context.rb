module RubyFlipper

  class ConditionContext

    def active?(*conditions)
      Feature.new(:inline_condition, *conditions).active?
    end

  end

end
