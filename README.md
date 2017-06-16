# WCZip

### Run Instructions

This program provides two procedures for compressing text files, `compress` and `expand`.

It takes 2 arguments: the desired procedure and an input file. e.g.

`bin/wczip compress data.txt`


To install, you will need ruby installed on your system. It should be compatible with any
version > 2.1.

### Testing

To run unit tests, run `bundle install`, then `rspec` from the main app directory

### Thought process

In a first attempt to compress the data, I looped through each line and counted recurrences of a
given character, replacing them with a count.  This gave fairly good compression for highly
repetitive files (like the sample file), but failed on any files containing integers.  The results
were hopelessly ambiguous as to what was a char count vs an actual char.  Efforts to make it more
clear, e.g. always storing counts as three digits from 0-100 (given the assumption that all input
text would be 100x100) actually made the compression rates worse.

I considered Huffman encoding, but this would require a more complex data structure (tree/trie) as
well as the transmission of both the encoding and the compressed contents.  I opted instead for an
implementation of the Lempel-Ziv compression algorithm. The resulting codes--captured as an array of
integers--are converted to a byte string and stored in a text file that can be transmitted.  Decoding
the compressed file requires nothing more than a dictionary of ASCII values from 0-255 which can be
generated on the fly.

Note: this current implementation does not flush the symbol table as it builds out encountered
substrings, so if this implementation were used on large files, that may become an issue.
