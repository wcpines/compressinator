def usage_instructions
  puts "Usage: `$ ruby plaid.rb <compress|expand> <file_name>.txt`"
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
  File.open(file_name, 'wb') { |f| f.write(output) }
  puts "##########################"
  puts "         STATS:"
  puts "##########################"
  puts "Initial file size: #{File.size(input_file).to_f / 1000}kb"
  puts "Final file size: #{File.size(file_name).to_f / 1000}kb"

  puts "\nPlease see #{file_name} for results.\n\n"
end
