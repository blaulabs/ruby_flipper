module RubyFlipper

  module ObjectMixin

    def feature_active?(name)
      active = RubyFlipper.features[name].active?
      yield if active && block_given?
      active
    end

  end

end

Object.send :include, RubyFlipper::ObjectMixin
