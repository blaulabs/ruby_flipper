require 'spec_helper'

describe RubyFlipper::ConditionContext do

  describe '#active?' do

    it 'should return the met? of the referenced condition' do
      RubyFlipper::Feature.add(:referenced, true)
      subject.active?(:referenced).should == true
    end

    it 'should raise an error when the referenced condition is not defined' do
      lambda { subject.active?(:referenced) }.should raise_error RubyFlipper::NotDefinedError, '\'referenced\' is not defined'
    end

    it 'should handle multiple conditions as well' do
      RubyFlipper::Feature.add(:referenced1, true)
      RubyFlipper::Feature.add(:referenced2, false)
      subject.active?(:referenced1, :referenced2).should == false
      RubyFlipper::Feature.add(:referenced2, true)
      subject.active?(:referenced1, :referenced2).should == true
    end

  end

end
