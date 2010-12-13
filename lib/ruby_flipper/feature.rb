module RubyFlipper

  class Feature

  private

    def self.features
      @@features ||= {}
    end

  public

    def self.reset
      @@features = nil
    end

    def self.add(name, description, condition)
      features[name] = new(name, description, condition)
    end

    def self.find(name)
      features[name] || raise(FeatureNotFoundError, "feature #{name} is not defined")
    end

    attr_reader :name, :description, :condition

    def initialize(name, description, condition)
      @name, @description, @condition = name, description, Condition.new(:inline_condition, condition)
    end

    def active?
      @condition.met?
    end

  end

end
