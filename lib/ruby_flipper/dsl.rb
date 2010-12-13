module RubyFlipper

  class Dsl

    def condition(name, *conditions, &block)
      Condition.add(name, conditions, block)
    end

    def feature(name, opts)
      Feature.add(name, opts[:description], opts[:condition])
    end

  end

end
