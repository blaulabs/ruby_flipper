require 'spec_helper'

describe RubyFlipper::Dsl do

  describe '#condition' do

    it 'should store a condition' do
      block = lambda { true }
      condition = subject.condition :condition_name, true, false, &block
      condition.should be_a(RubyFlipper::Condition)
      condition.conditions.should == [true, false, block]
      RubyFlipper::Condition.find(:condition_name).should == condition
    end

  end

  describe '#feature' do

    it 'should store a feature' do
      feature = subject.feature :feature_name, :description => 'desc', :condition => :cond
      feature.should be_a(RubyFlipper::Feature)
      feature.name.should == :feature_name
      condition = feature.condition
      condition.should be_a(RubyFlipper::Condition)
      condition.conditions.should == [:cond]
      RubyFlipper::Feature.find(:feature_name).should == feature
    end

  end

end
