# WCZip

### Run Instructions

This program provides two procedures for compressing text files, `compress` and `expand`.

It takes 2 arguments: the desired procedure and an input file. e.g.

`$ bin/wczip expand compressed.txt`


To install, you will need ruby installed on your system. It should be compatible with any
version > 2.1

### Thought process

In a first attempt to compress the data, I simply looped through each line and counted
recurrences of a given character, and replaced them with a count.  This gave fairly good
impression for highly repetitive files, but failed on any files containing ASCII numbers.
The results were hopelessly ambiguous as to what was a count and what was an actual char.
Efforts to make it more clear, (e.g. store counts as three digits from 0-100--given the
expectation that all inputs would be 100x100)  made the compression much worse.

I also considered huffman encoding, but this would require a more complex data structure
(tree/trie) as well as transmitting both the encoding and the compressed contents.  I
opted instead for an implementation of the lempel-ziv compression algorithm. The resulting
codes--an array of ints--are converted to a byte string and stored in a text file that can
be transmitted.  Decoding the compressed file requires nothing than a dictionary of ASCII
values from 0-255, which can be easily generated on the fly.

My current implementation does not flush the symbol table as it builds out encountered
substrings, so if this implementation were used on large files, that may become an issue.



-wcpines
