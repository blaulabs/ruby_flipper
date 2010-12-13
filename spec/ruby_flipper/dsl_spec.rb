require 'spec_helper'

describe RubyFlipper::Dsl do

  it 'should ensure mocked methods exist' do
    RubyFlipper::Feature.should respond_to(:add)
  end

  [:feature, :condition].each do |method|

    describe "##{method}" do

      it 'should call add with only a name' do
        RubyFlipper::Feature.expects(:add).with(:feature_name).returns(:feature)
        subject.send(method, :feature_name).should == :feature
      end

      it 'should call add with a name and conditions' do
        RubyFlipper::Feature.expects(:add).with(:feature_name, :one, :two).returns(:feature)
        subject.send(method, :feature_name, :one, :two).should == :feature
      end

      it 'should call add with a name, conditions and a block' do
        block = lambda {}
        # cannot mock this since mocha doesn't allow to test for a proc [thomas, 2010-12-13]
        feature = subject.send(method, :feature_name, :one, :two, &block)
        feature.conditions.should == [:one, :two, block]
      end

    end

  end

end
