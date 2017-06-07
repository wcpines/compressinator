require_relative './helpers.rb'

def expand(file)

  data_string = check_and_read_input_file(file)

  # Use the same basic ASCII table with keys/values switched and rebuild in the
  # same way as when the data was first compressed.

  symbol_table = Array.new(256) { |i| i.chr  } # Array will work; indeces == keys
  codes = data_string.unpack("S*") # Convert compressed text [binary] back to ints

  # https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-02-introduction-to-eecs-ii-digital-communication-systems-fall-2012/readings/MIT6_02F12_chap03.pdf

  original_data = ""
  prefix_string = symbol_table[codes.shift]
  original_data << prefix_string

  codes.each do |code|
    if symbol_table[code].nil?
      new_string = prefix_string + prefix_string[0]
    else
      new_string = symbol_table[code]
    end
    original_data << new_string
    symbol_table << prefix_string + new_string[0]
    prefix_string = new_string
  end
  original_data
end
