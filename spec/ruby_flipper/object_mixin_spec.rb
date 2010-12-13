require 'spec_helper'

describe RubyFlipper::ObjectMixin do

  it 'should be included in Object' do
    Object.included_modules.should include RubyFlipper::ObjectMixin
  end

  describe '#feature_active?' do

    subject do
      # this is not really needed, since one could just call feature_active?
      # but to be independent of the inclusion in Object (see above), better
      # create a new subject that is sure to include RubyFlipper::ObjectMixin.
      Class.new do
        include RubyFlipper::ObjectMixin
      end.new
    end

    context 'with an active feature' do

      before(:each) do
        RubyFlipper::Feature.add(:active, true)
      end

      it 'should return true when called without a block' do
        subject.feature_active?(:active).should == true
      end

      it 'should execute the block and return true when called with a block' do
        var = 'before'
        subject.feature_active?(:active) do
          var = 'after'
        end.should == true
        var.should == 'after'
      end

    end

    context 'with an inactive feature' do

      before(:each) do
        RubyFlipper::Feature.add(:inactive, false)
      end

      it 'should return false when called without a block' do
        subject.feature_active?(:inactive).should == false
      end

      it 'should not execute the block and return false when called with a block' do
        subject.feature_active?(:inactive) do
          fail 'the given block should not be called'
        end.should == false
      end

    end

    context 'with a missing feature' do

      it 'should raise an error when called without a block and the referenced feature is not defined' do
        lambda { subject.feature_active?(:missing) }.should raise_error RubyFlipper::FeatureNotFoundError, 'feature missing is not defined'
      end

      it 'should not execute the block and raise an error when called with a block and the referenced feature is not defined' do
        lambda { subject.feature_active?(:missing) { fail 'the given block should not be called' } }.should raise_error RubyFlipper::FeatureNotFoundError, 'feature missing is not defined'
      end

    end

  end

end
