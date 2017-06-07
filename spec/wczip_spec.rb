require_relative "./spec_helper.rb"
require_relative "../lib/wczip.rb"



describe 'run' do
  ignore_puts

  after(:all) do
    ["compressed.txt", "expanded.txt"].each do |name|
      File.delete(name)
    end
  end

  dir = File.dirname(__FILE__)
  test_file = "#{dir}/test_data.txt"

  describe 'compress' do

    output = ""

    it "produces a byte string" do
      output = compress(test_file)

      expect(output).to be_instance_of(String)
      expect(output.encoding.to_s).to eq("ASCII-8BIT")

    end

    it "compresses a file such that the resulting data is smaller than the input" do
      input_size = File.read(test_file).bytesize
      output_size = output.bytesize
      expect(output_size).to be < input_size
    end

    describe 'output_file' do
      it "writes the resulting string to a file called 'compressed.txt'" do
        output_file("compressed", test_file, output)
        expect(File).to exist("./compressed.txt")
      end
    end

  end

  describe 'expand' do
    compressed_output = compress(test_file)
    output_file("compressed", test_file, compressed_output)

    file = "compressed.txt"
    output = expand(file)

    it "Expands a compressed file such that the resulting data is greater than the original file" do
      input_size = File.read(file).bytesize
      output_size = output.bytesize
      expect(output_size).to be > input_size
    end

    describe 'output_file' do
      it "should write the resulting string to a file called 'expanded.txt'" do
        output_file("expanded", "compressed.txt", output)
        expect(File).to exist("./expanded.txt")
      end

      it "should produce a file identical to the original input" do
        expect(File.read('expanded.txt')).to eq(File.read(test_file))
      end
    end
  end
end
