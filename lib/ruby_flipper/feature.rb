module RubyFlipper

  class Feature

    def self.all
      @@features ||= {}
    end

    def self.reset
      @@features = nil
    end

    def self.add(name, *conditions, &block)
      all[name] = new(name, *conditions, &block)
    end

    def self.find(name)
      all[name] || raise(NotDefinedError, "'#{name}' is not defined")
    end

    def self.condition_met?(condition)
      if condition.is_a?(Symbol)
        find(condition).active?
      elsif condition.is_a?(Proc)
        !!ConditionContext.new.instance_eval(&condition)
      elsif condition.respond_to?(:call)
        !!condition.call
      else
        !!condition
      end
    end

    attr_reader :name, :description, :conditions

    def initialize(name, *conditions, &block)
      if conditions.last.is_a?(Hash)
        opts = conditions.pop
        @description = opts[:description]
        conditions << opts[:condition]
        conditions << opts[:conditions]
      end
      @name, @conditions = name, [conditions, block].flatten.compact
    end

    def active?
      conditions.map {|condition| self.class.condition_met?(condition)}.all?
    end

  end

end
