require 'spec_helper'

describe RubyFlipper::Feature do

  describe '.all' do

    it 'should be a hash' do
      RubyFlipper::Feature.all.should == {}
    end

  end

  describe '.reset' do

    it 'should reset the all hash' do
      RubyFlipper::Feature.add(:inactive, false)
      RubyFlipper::Feature.all.should_not be_empty
      RubyFlipper::Feature.reset
      RubyFlipper::Feature.all.should be_empty
    end

  end

  describe '.add' do

    it 'should call new with only a name and store the feature' do
      RubyFlipper::Feature.expects(:new).with(:feature_name).returns(:feature)
      RubyFlipper::Feature.add(:feature_name).should == :feature
      RubyFlipper::Feature.all[:feature_name].should == :feature
    end

    it 'should call add with a name and conditions and store the feature' do
      RubyFlipper::Feature.expects(:new).with(:feature_name, :one, :two).returns(:feature)
      RubyFlipper::Feature.add(:feature_name, :one, :two).should == :feature
      RubyFlipper::Feature.all[:feature_name].should == :feature
    end

    it 'should call add with a name, conditions and a block and store the feature' do
      block = lambda {}
      # cannot mock this since mocha doesn't allow to test for a proc [thomas, 2010-12-13]
      feature = RubyFlipper::Feature.add(:feature_name, :one, :two, &block)
      feature.conditions.should == [:one, :two, block]
      RubyFlipper::Feature.all[:feature_name].should == feature
    end

  end

  describe '.find' do

    it 'should return the stored feature' do
      feature = RubyFlipper::Feature.add(:feature_name)
      RubyFlipper::Feature.find(:feature_name).should == feature
    end

    it 'should raise an error when the referenced feature is not defined' do
      lambda { RubyFlipper::Feature.find(:feature_name) }.should raise_error RubyFlipper::NotDefinedError, '\'feature_name\' is not defined'
    end

  end

  describe '.condition_met?' do

    context 'with a symbol' do

      it 'should return the state of the referenced feature' do
        RubyFlipper::Feature.add(:referenced, true)
        RubyFlipper::Feature.condition_met?(:referenced).should == true
      end

      it 'should raise an error when the referenced feature is not defined' do
        lambda { RubyFlipper::Feature.condition_met?(:missing) }.should raise_error RubyFlipper::NotDefinedError, '\'missing\' is not defined'
      end

    end

    {
      true       => true,
      'anything' => true,
      false      => false,
      nil        => false
    }.each do |condition, expected|

      it "should call a given proc and return #{expected} when it returns #{condition}" do
        RubyFlipper::Feature.condition_met?(lambda { condition }).should == expected
      end

      it "should call anything callable and return #{expected} when it returns #{condition}" do
        RubyFlipper::Feature.condition_met?(stub(:call => condition)).should == expected
      end

      it "should return #{expected} when the condition is #{condition}" do
        RubyFlipper::Feature.condition_met?(condition).should == expected
      end

    end

    context 'with a complex proc' do

      it 'should return the met? of the combined referenced conditions' do
        RubyFlipper::Feature.add(:true, true)
        RubyFlipper::Feature.add(:false, false)
        RubyFlipper::Feature.condition_met?(lambda { active?(:true) || active?(:false) }).should == true
        RubyFlipper::Feature.condition_met?(lambda { active?(:true) && active?(:false) }).should == false
      end

    end

  end

  describe 'initializer' do

    it 'should store the name' do
      RubyFlipper::Feature.new(:feature_name).name.should == :feature_name
    end

    it 'should store the description' do
      RubyFlipper::Feature.new(:feature_name, :description => 'desc').description.should == 'desc'
    end

    it 'should work with a single static condition' do
      RubyFlipper::Feature.new(:feature_name, true).conditions.should == [true]
    end

    it 'should work with multiple static conditions' do
      RubyFlipper::Feature.new(:feature_name, true, :development).conditions.should == [true, :development]
    end

    it 'should work with a dynamic condition as parameter' do
      condition = lambda { true }
      RubyFlipper::Feature.new(:feature_name, condition).conditions.should == [condition]
    end

    it 'should work with a dynamic condition as block' do
      condition = lambda { true }
      RubyFlipper::Feature.new(:feature_name, &condition).conditions.should == [condition]
    end

    it 'should work with a combination of static and dynamic conditions' do
      condition = lambda { true }
      RubyFlipper::Feature.new(:feature_name, false, :live, condition).conditions.should == [false, :live, condition]
    end

    it 'should work with conditions given in the opts hash as :condition' do
      RubyFlipper::Feature.new(:feature_name, :condition => true).conditions.should == [true]
    end

    it 'should work with conditions given in the opts hash as :conditions' do
      RubyFlipper::Feature.new(:feature_name, :conditions => false).conditions.should == [false]
    end

    it 'should work with a combination of arrays, dynamic conditions and conditions given in the opts hash and eliminate nil' do
      condition = lambda { true }
      RubyFlipper::Feature.new(:feature_name, [false, nil], :condition => [nil, 'c'], :conditions => ['c1', 'c2'], &condition).conditions.should == [false, 'c', 'c1', 'c2', condition]
    end

  end

  describe '#active?' do

    it 'should return false when not all conditions are met (with dynamic)' do
      RubyFlipper::Feature.new(:feature_name, true, lambda { false }).active?.should == false
    end

    it 'should return false when not all conditions are met (only static)' do
      RubyFlipper::Feature.new(:feature_name, false, true).active?.should == false
    end

    it 'should return true when all conditions are met' do
      RubyFlipper::Feature.new(:feature_name, true, true).active?.should == true
    end

  end

end
