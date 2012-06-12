module RubyFlipper

  module ObjectMixin

    def feature_active?(name, *args)
      active = Feature.find(name).active?(*args)
      yield if active && block_given?
      active
    end
    alias :condition_met? :feature_active?

  end

end

Object.send :include, RubyFlipper::ObjectMixin
