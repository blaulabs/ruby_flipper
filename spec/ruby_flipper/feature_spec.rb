require 'spec_helper'

describe RubyFlipper::Feature do

  describe 'initializer' do

    it 'should store name, description and condition' do
      feature = RubyFlipper::Feature.new(:feature_name, 'what it does', false)
      feature.name.should == :feature_name
      feature.description.should == 'what it does'
      condition = feature.condition
      condition.should be_a(RubyFlipper::Condition)
      condition.name.should == :inline_condition
      condition.conditions.should == [false]
    end

  end

  describe '#active?' do

    it 'should return met? of the feature\'s condition' do
      RubyFlipper::Feature.new(:feature_name, 'description', true).active?.should == true
    end

  end

end
