module RubyFlipper

  class ConditionContext

    def active?(*conditions)
      Feature.new(nil, *conditions).active?
    end

  end

end
