require_relative './helpers.rb'

def compress(file)

  data_string = check_and_read_input_file(file)

  # init ascii/codeword symbol_table, e.g."e"=>101
  symbol_table = {}
  (0..255).each { |i| symbol_table[i.chr] = i }

  prefix_string = "" # longest substring previously encountered
  data_string.chars.each_with_object([]) do |char, result|
    test_string = prefix_string + char
    if symbol_table.has_key?(test_string)
      prefix_string = test_string # Greedily match longest possible unencountered string
    else
      result << symbol_table[prefix_string] # => int; First pass should be between 0 and 255
      symbol_table[test_string] = symbol_table.length # => e.g. 256 on first pass--new entry
      prefix_string = char
    end
  end.pack("S*") # convert array of digits to byte string so
                 # you don't just store ASCII of numbers
end
