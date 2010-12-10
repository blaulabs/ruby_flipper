require 'spec_helper'

describe RubyFlipper::ConditionContext do

  describe '#met?' do

    it 'should return the met? of the referenced condition' do
      RubyFlipper.conditions[:referenced] = RubyFlipper::Condition.new(:referenced, true)
      subject.met?(:referenced).should == true
    end

    it 'should raise an error when the referenced condition is not defined' do
      lambda { subject.met?(:referenced) }.should raise_error RubyFlipper::ConditionNotFoundError, 'condition referenced is not defined'
    end

    it 'should handle multiple conditions as well' do
      RubyFlipper.conditions[:referenced1] = RubyFlipper::Condition.new(:referenced1, true)
      RubyFlipper.conditions[:referenced2] = RubyFlipper::Condition.new(:referenced2, false)
      subject.met?(:referenced1, :referenced2).should == false
      RubyFlipper.conditions[:referenced2] = RubyFlipper::Condition.new(:referenced2, true)
      subject.met?(:referenced1, :referenced2).should == true
    end

  end

end
