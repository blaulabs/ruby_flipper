require 'spec_helper'

describe RubyFlipper do

  describe '.load' do

    def load_features
      RubyFlipper.load(File.expand_path '../fixtures/features.rb', __FILE__)
    end

    context 'conditions' do

      context ':static_is_cherry' do

        it 'should not be met when static is not cherry when loading' do
          load_features
          RubyFlipper::Condition.find(:static_is_cherry).should_not be_met
        end

        it 'should not be met when static is not cherry when loading even when it is when called' do
          load_features
          FLIPPER_ENV[:static] = 'cherry'
          RubyFlipper::Condition.find(:static_is_cherry).should_not be_met
        end

        it 'should be met when static is not cherry when called' do
          FLIPPER_ENV[:static] = 'cherry'
          load_features
          RubyFlipper::Condition.find(:static_is_cherry).should be_met
        end

      end

      context ':dynamic_is_floyd' do

        it 'should not be met when dynamic is not floyd when called' do
          load_features
          RubyFlipper::Condition.find(:dynamic_is_floyd).should_not be_met
        end

        it 'should not be met when dynamic is not floyd when called even when it was when loaded' do
          FLIPPER_ENV[:dynamic] = 'floyd'
          load_features
          FLIPPER_ENV[:dynamic] = 'sue'
          RubyFlipper::Condition.find(:dynamic_is_floyd).should_not be_met
        end

        it 'should be met when dynamic is floyd when called' do
          load_features
          FLIPPER_ENV[:dynamic] = 'floyd'
          RubyFlipper::Condition.find(:dynamic_is_floyd).should be_met
        end

      end

      context ':combined_is_cherry_and_floyd' do

        it 'should not be met when static is not cherry when loaded even when it is when called and dynamic is floyd' do
          load_features
          FLIPPER_ENV[:dynamic] = 'floyd'
          RubyFlipper::Condition.find(:combined_is_cherry_and_floyd).should_not be_met
        end

        it 'should not be met when static is cherry but dynamic is not floyd when called even when it was when loaded' do
          FLIPPER_ENV[:static] = 'cherry'
          FLIPPER_ENV[:dynamic] = 'floyd'
          load_features
          FLIPPER_ENV[:dynamic] = 'sue'
          RubyFlipper::Condition.find(:combined_is_cherry_and_floyd).should_not be_met
        end

        it 'should be met when static is cherry when loaded and dynamic is floyd when called even when static is not cherry when called and dynamic was not floyd when called' do
          FLIPPER_ENV[:static] = 'cherry'
          load_features
          FLIPPER_ENV[:static] = 'philip'
          FLIPPER_ENV[:dynamic] = 'floyd'
          RubyFlipper::Condition.find(:combined_is_cherry_and_floyd).should be_met
        end

      end

      context ':combined_is_lulu_first_then_gavin' do

        it 'should not be met when changing is not lulu when loaded even when it is gavin when called' do
          load_features
          FLIPPER_ENV[:changing] = 'gavin'
          RubyFlipper::Condition.find(:combined_is_lulu_first_then_gavin).should_not be_met
        end

        it 'should not be met when changing is lulu when loaded but it is not gavin when called' do
          FLIPPER_ENV[:changing] = 'lulu'
          load_features
          RubyFlipper::Condition.find(:combined_is_lulu_first_then_gavin).should_not be_met
        end

        it 'should be met when changing is lulu when loaded gavin when called' do
          FLIPPER_ENV[:changing] = 'lulu'
          load_features
          FLIPPER_ENV[:changing] = 'gavin'
          RubyFlipper::Condition.find(:combined_is_lulu_first_then_gavin).should be_met
        end

      end

    end

    context 'features' do

      context ':disabled' do

        it 'should not be active' do
          load_features
          RubyFlipper::Feature.find(:disabled).should_not be_active
        end

      end

      context ':floyd' do

        it 'should not be active when dynamic is not floyd' do
          load_features
          RubyFlipper::Feature.find(:floyd).should_not be_active
        end

        it 'should be active when dynamic is floyd' do
          load_features
          FLIPPER_ENV[:dynamic] = 'floyd'
          RubyFlipper::Feature.find(:floyd).should be_active
        end

      end

      context ':philip' do

        it 'should not be active when dynamic is not philip' do
          load_features
          RubyFlipper::Feature.find(:philip).should_not be_active
        end

        it 'should be active when dynamic is philip' do
          load_features
          FLIPPER_ENV[:dynamic] = 'philip'
          RubyFlipper::Feature.find(:philip).should be_active
        end

      end

      context ':patti' do

        it 'should not be active when changing is not patti when loaded' do
          load_features
          FLIPPER_ENV[:dynamic] = 'floyd'
          FLIPPER_ENV[:changing] = 'gavin'
          RubyFlipper::Feature.find(:patti).should_not be_active
        end

        it 'should not be active when dynamic is not floyd when called' do
          FLIPPER_ENV[:changing] = 'patti'
          FLIPPER_ENV[:dynamic] = 'floyd'
          load_features
          FLIPPER_ENV[:dynamic] = 'sue'
          FLIPPER_ENV[:changing] = 'gavin'
          RubyFlipper::Feature.find(:patti).should_not be_active
        end

        it 'should not be active when changing is not gavin when called' do
          FLIPPER_ENV[:changing] = 'patti'
          FLIPPER_ENV[:changing] = 'gavin'
          load_features
          FLIPPER_ENV[:dynamic] = 'floyd'
          FLIPPER_ENV[:changing] = 'sue'
          RubyFlipper::Feature.find(:patti).should_not be_active
        end

        it 'should be active when changing is patti when loaded, dynamic is floyd when called and changing is gavin when called' do
          FLIPPER_ENV[:changing] = 'patti'
          load_features
          FLIPPER_ENV[:dynamic] = 'floyd'
          FLIPPER_ENV[:changing] = 'gavin'
          RubyFlipper::Feature.find(:patti).should be_active
        end

      end

      context ':sue' do

        it 'should not be active when static is not cherry when loaded and dynamic is not floyd when called' do
          FLIPPER_ENV[:dynamic] = 'floyd'
          load_features
          FLIPPER_ENV[:dynamic] = 'gavin'
          FLIPPER_ENV[:changing] = 'sue'
          RubyFlipper::Feature.find(:sue).should_not be_active
        end

        it 'should not be active when changing is not sue when called' do
          FLIPPER_ENV[:static] = 'cherry'
          load_features
          FLIPPER_ENV[:dynamic] = 'floyd'
          RubyFlipper::Feature.find(:sue).should_not be_active
        end

        it 'should be active when static is cherry when loaded and changing is sue when called' do
          FLIPPER_ENV[:static] = 'cherry'
          load_features
          FLIPPER_ENV[:changing] = 'sue'
          RubyFlipper::Feature.find(:sue).should be_active
        end

        it 'should be active when dynamic is floyd when called and changing is sue when called' do
          load_features
          FLIPPER_ENV[:dynamic] = 'floyd'
          FLIPPER_ENV[:changing] = 'sue'
          RubyFlipper::Feature.find(:sue).should be_active
        end

      end

    end

  end

end
