module RubyFlipper

  class Dsl

    def condition(name, *conditions, &block)
      RubyFlipper.conditions[name] = Condition.new(name, conditions, block)
    end

    def feature(name, opts)
      RubyFlipper.features[name] = Feature.new(name, opts[:description], opts[:condition])
    end

  end

end
