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
feature :philip, :description => 'just for philip', :condition => proc { FLIPPER_ENV[:dynamic] == 'philip' }

# feature depending on array of a static condition, a predefined condition and a dynamic condition (lambda)
# given in :conditions (can be both :condition/:conditions)
feature :patti, :description => 'just for patti', :conditions => [
  FLIPPER_ENV[:changing] == 'patti',
  :dynamic_is_floyd,
  proc { FLIPPER_ENV[:changing] == 'gavin'}
]

# feature with a complex combination of dynamic and predifined conditions given as a block
feature :sue, :description => 'just for sue' do
  (active?(:static_is_cherry) || active?(:dynamic_is_floyd)) && FLIPPER_ENV[:changing] == 'sue'
end
