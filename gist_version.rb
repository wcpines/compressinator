def usage_instructions
  puts "Usage: `$ ruby gist_version.rb <compress|expand> <file_name>.txt`"
end


def print_err(code, input="[empty]")
  case code
  when 1
    puts "ERROR: File provided for compression is empty"
    puts "^^^^^"
    usage_instructions
    exit
  when 2
    sqg = "^" * input.length
    puts "ERROR: File '#{input}' not found"
    puts "             #{sqg}"
    usage_instructions
    exit
  when 3
    puts "ERROR: Invalid number of command inputs"
    puts "^^^^^"
    usage_instructions
    exit
  when 4
    sqg = "^" * input.length
    puts "ERROR:  '#{input}' is an invalid procedure"
    puts "         #{sqg}"
    usage_instructions
    exit
  end
end


def get_and_validate_user_input
  print_err(3) if ARGV.length != 2

  procedure = ARGV[0]
  input_file = ARGV[1]

  if procedure != "compress" && procedure != "expand"
    print_err(4, procedure)
  end

  return [procedure, input_file]
end


def check_and_read_input_file(file)
  begin
    data_string = File.read(file)
  rescue Errno::ENOENT
    print_err(2, file)
  end

  print_err(1, file) if data_string.empty?

  return data_string
end


def output_file(procedure, input_file, output)
  file_name = "#{procedure}.txt"
  File.open(file_name, 'w') { |f| f.write(output) }
  puts "##########################"
  puts "         STATS:"
  puts "##########################"
  puts "Initial file size: #{File.size(input_file).to_f / 1000}kb"
  puts "Final file size: #{File.size(file_name).to_f / 1000}kb"

  puts "\nPlease see #{file_name} for results.\n\n"
end

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
