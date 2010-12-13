require 'spec_helper'

describe RubyFlipper::ConditionContext do

  describe '#active?' do

    it 'should return true on an active feature' do
      RubyFlipper::Feature.add(:referenced, true)
      subject.active?(:referenced).should == true
    end

    it 'should return false on an inactive feature' do
      RubyFlipper::Feature.add(:referenced, false)
      subject.active?(:referenced).should == false
    end

    it 'should raise an error when the referenced condition is not defined' do
      lambda { subject.active?(:referenced) }.should raise_error RubyFlipper::NotDefinedError, '\'referenced\' is not defined'
    end

    it 'should handle multiple conditions as well' do
      RubyFlipper::Feature.add(:referenced1, true)
      RubyFlipper::Feature.add(:referenced2, false)
      RubyFlipper::Feature.add(:referenced3, true)
      subject.active?(:referenced1, :referenced2).should == false
      subject.active?(:referenced1, :referenced3).should == true
    end

  end

end
