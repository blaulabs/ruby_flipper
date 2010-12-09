# statically configured condition (initially evaluated when configuration is loaded)
condition :static_is_cherry, FLIPPER_ENV[:static] == 'cherry'

# dynamically configured condition (evaluated on each access)
condition :dynamic_is_floyd do
  FLIPPER_ENV[:dynamic] == 'floyd'
end

# combined condition referencing both above
condition :combined_is_cherry_and_floyd, :static_is_cherry, :dynamic_is_floyd

# combined condition with static and dynamic
condition :combined_is_lulu_first_then_gavin, FLIPPER_ENV[:changing] == 'lulu' do
  FLIPPER_ENV[:changing] == 'gavin'
end


# disabled feature
feature :disabled, :description => 'disabled feature', :condition => false

# feature referencing a single predefined condition
feature :floyd, :description => 'just for floyd', :condition => :dynamic_is_floyd

# feature depending on a dynamic condition (lambda)
feature :philip, :description => 'just for philip', :condition => lambda { FLIPPER_ENV[:dynamic] == 'philip' }

# feature depending on array of a static condition, a predefined condition and a dynamic condition (lambda)
feature :patti, :description => 'just for patti', :condition => [
  FLIPPER_ENV[:changing] == 'patti',
  :dynamic_is_floyd,
  lambda { FLIPPER_ENV[:changing] == 'gavin'}
]
