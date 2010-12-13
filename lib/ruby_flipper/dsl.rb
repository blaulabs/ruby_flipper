module RubyFlipper

  class Dsl

    def feature(name, *conditions, &block)
      Feature.add(name, *conditions, &block)
    end
    alias :condition :feature

  end

end
