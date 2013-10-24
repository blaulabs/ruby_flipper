# Ruby Flipper
![Travis-CI](https://secure.travis-ci.org/blaulabs/ruby_flipper.png)

Ruby Flipper makes it easy to define features and switch them on and off. It's configuration DSL provides a very flexible but still not too verbose syntax to fulfil your flipping needs.


## Usage

To use ruby flipper, you have to load a feature definition file somewhere:

```ruby
RubyFlipper.load(File.expand_path '../features.rb', __FILE__)
```

This configuration can be reset by calling:

```ruby
RubyFlipper.reset
```


## Feature Definitions

The file loaded by ruby flipper is written in ruby flipper's simple DSL. The most basic feature definition is just a feature with a name. Without any further conditions, the feature is active by default.

```ruby
feature :always_on_feature
```

You can specify conditions that are used to determine whether a feature is active or not in three different ways:

```ruby
feature :conditional_feature_with_parameter, false
feature :conditional_feature_with_condition_opt, :condition #> false
feature :conditional_feature_with_conditions_opt, :conditions #> false
```

In the examples above, the features are statically disabled. You can use three different types of conditions.

### Static Conditions

A static condition is a boolean that is evaluated when the feature definitions are loaded. This can be used to statically activate/deactivate features or make features dependent on variables that don't change during runtime.

```ruby
feature :development_feature, Rails.env.development?
```ruby

This defines a feature that is only active in Rails' development mode.

### Reference Conditions

A reference condition is a symbol that references another feature. This can be used to make a feature dependent on another feature or extract complex condition definitions and reuse them for several features.

```ruby
feature :dependent_feature, :development_feature
```

This defines a feature that is only active when the feature :development_feature is active.

### Dynamic Conditions

A dynamic condition is a proc (or anything that responds to :call) that will be evaluated each time the state of a feature is checked. This can be used to activate/deactivate features dynamically depending on variables that change during runtime.

```ruby
feature :admin_feature, condition #> lambda { User.current.is_admin? }
```

This defines a feature that is only active when the current user is an admin (the user specific stuff must be implemented somewhere else).

Dynamic conditions can also be given to the feature method as a block:

```ruby
feature :admin_feature do
  User.current.is_admin?
end
```

Within such a proc, you can also check whether another feature is active or not to phrase complex condition dependencies:

```ruby
feature :shy_feature do
  active?(:development_feature) && (active?(:admin_feature) || Time.now.hour < 8)
end
```

This defines a feature that is only active when the feature :development_feature is active and either the feature :admin_feature is active or it is between midnight and 8:00 in the morning (however that might be useful).

### Combined Conditions

A combined condition is an array of other conditions. Any type of condition can be combined in an array. All conditions have to be met for a feature to be active.

```ruby
feature :combined_feature, [:development_feature, lambda { User.current.name == 'patti' }]
```

This defines a feature that is only enabled when the feature :development_feature is enbled and the current user is 'patti'.

### More

For more examples, see spec/fixtures/features.rb and spec/ruby_flipper_spec.rb (section 'integration specs using spec/fixtures/features.rb' which is an end-to-end integration test).


## Condition Definitions

If you have a lot of dependent features with shared conditions you can clean up your definition file by explicitly defining conditions that aren't used as features but just as conditions real features depend on.

```ruby
condition :development, Rails.env.development?
condition :admin do
  User.current.is_admin?
end
feature :user_administration, :development, :admin
feature :new_feature, :development
```

Of course, you can nest this as deep as you like (features depending on conditions depending on conditions depending on features depending on conditions...), although this might lead to completely incomprehensible rulesets.

The condition method is just an alias to the feature method, so internally, it makes absolutely no difference which method you use. Using both methods just helps you structuring your feature definitions and makes the feature definition file easier to understand.


## Usage

Finally, there are two ways to check whether a feature is active or not within your code. You can just give it a block that will only be evaluated when the feature is active:

```ruby
feature_active?(:hidden_feature) do
  # do something for that feature
end
```

or if you need the state of a feature as a boolean value or want to do something when a feature is not active:

```ruby
if feature_active?(:hidden_feature)
  # do something for that feature
else
  # do something else
end
```

Its also possible to pass arbitary arguments to `feature_active?` like so:
  
```ruby
if feature_active?(:hidden_feature, "secret_sauce")
  ...
end
```

Those parameters will be passed to the block defining the condition.

This method is defined on Object, so it is available anywhere you might ever need it.


## Describing Features

Last and least, you can describe your features, for example when you use ticket numbers or anything other cryptic for your feature names. The description isn't used anywhere yet, but it might make your code more readable.

```ruby
feature :feature_452, :development, :description #> 'Feature 452: An end user can change his data on his profile page.'
```

You could also just use comments for that, but giving this to ruby flipper in code enables you to evaluate your features and print lists containing the description.

```ruby
RubyFlipper::Feature.all.each do |feature|
  puts "#{feature.name}: #{feature.description}"
end
```

## Contributors:

- Thanks to [Ryan Ahearn](https://github.com/rahearn) for implementing dynamic parameters to `feature_active?`

## License

ruby_flipper is released under the [MIT License](http://www.opensource.org/licenses/MIT).
