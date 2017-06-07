require_relative './helpers.rb'
require_relative './compress.rb'
require_relative './expand.rb'

def run
  input_arr = get_and_validate_user_input

  procedure = input_arr[0]
  input_file = input_arr[1]

  if procedure == "compress"
    output = compress(input_file)
    output_file("compressed", input_file, output)
  else
    output = expand(input_file)
    output_file("expanded", input_file, output)
  end
end

run
