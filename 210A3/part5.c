#include <stdio.h>    
#include <stdlib.h>    

typedef enum {false, true} bool;  

typedef struct {  
    signed short code;  
    signed short position;  
    signed short opCode;  
    signed short DR;  
    signed short SR1;  
    signed short PCoffset9;  
    signed short SR2;  
    signed short imm5;  
    bool isImm5;  
    char n;  
    char z;  
    char p;  
} LC3;  
//instrc required LD, LEA, LDI, AND, NOT, ADD, BR  

void setUpLC3(signed short *fileLine, signed short *array, LC3* mainCode, signed short *PC, signed short *opCodeMask, 
signed short *DRMask, signed short *SR1Mask, signed short *PCoffset9Mask, signed short *SR2Mask, 
signed short *imm5Mask, signed short *isImm5mask, signed short *nMask, signed short *zMask, signed short *pMask, signed short *origin); 

void printStatus(signed short *registers, signed short *PC, signed short *IR, char *CC, signed short *origin);
void runCode(LC3* mainCode, signed short *registers, signed short *origin, signed short *PC, signed short *IR, char *CC);
void setcc(signed short *registers, LC3 *mainCode, signed short *PC, signed short *origin, char *CC);

void setUpLC3(signed short *fileLine, signed short *array, LC3* mainCode, signed short *PC, signed short *opCodeMask, 
signed short *DRMask, signed short *SR1Mask, signed short *PCoffset9Mask, signed short *SR2Mask, 
signed short *imm5Mask, signed short *isImm5mask, signed short *nMask, signed short *zMask, signed short *pMask, 
signed short *origin) { 
    if (*fileLine == 0) {  
        *PC = array[0];  
        *origin = array[0];
    } else {  
        mainCode[*fileLine - 1].code = array[0];  
        mainCode[*fileLine - 1].position = *PC + *fileLine - 1;  
        mainCode[*fileLine - 1].opCode = array[0] & *opCodeMask;
        mainCode[*fileLine - 1].DR = (array[0] & *DRMask) >> 9;  
        mainCode[*fileLine - 1].SR1 = (array[0] & *SR1Mask) >> 6; 
        mainCode[*fileLine - 1].PCoffset9 = array[0] & *PCoffset9Mask; 
        mainCode[*fileLine - 1].SR2 = array[0] & *SR2Mask; 
        mainCode[*fileLine - 1].imm5 = array[0] & *imm5Mask; 
        if ((array[0] & *isImm5mask) > 0) { 
            mainCode[*fileLine - 1].isImm5 = true; 
        } else { 
            mainCode[*fileLine - 1].isImm5 = false; 
        }  
         
        if ((array[0] & *nMask) > 0) { 
            mainCode[*fileLine - 1].n = 'N'; 
        } else { 
            mainCode[*fileLine - 1].n = 'X'; 
        }  

        if ((array[0] & *zMask) > 0) { 
            mainCode[*fileLine - 1].z = 'Z'; 
        } else { 
            mainCode[*fileLine - 1].z = 'X'; 
        }  
         
        if ((array[0] & *pMask) > 0) { 
            mainCode[*fileLine - 1].p = 'P'; 
        } else { 
            mainCode[*fileLine - 1].p = 'X'; 
        }    
    }  
}  
// opcodes are not altered stored so it is exact thus  
// LD = 8192 , LEA = -8192 , LDI = -24576, AND = 20480, NOT = -28672, ADD = 4096, BR = 0; 
// 0xf025 is HALT TRAP, binary = 11110000 00100101, int = -4059  
void printStatus(signed short *registers, signed short *PC, signed short *IR, char *CC, signed short *origin) {
    if (*PC == *origin) { 
        printf("Initial state\n"); 
    } else { 
        printf("after executing instruction\t0x%04hx\n", *IR); 
    } 

    for (int i = 0; i < 8; i++) {
        printf("R%d\t0x%04hx\n", i, registers[i]);
    }
    printf("PC\t0x%04hx\n", *PC); 
    printf("IR\t0x%04hx\n", *IR); 
    printf("CC\t%c\n", *CC); 
    printf("==================\n"); 
} 

void runCode(LC3* mainCode, signed short *registers, signed short *origin, signed short *PC, signed short *IR, char *CC) { 
    while (mainCode[*PC - *origin].code != -4059) { 
        *PC += 1; 
        *IR = mainCode[*PC - *origin - 1].code;
        switch (mainCode[*PC - *origin - 1].opCode) {
            case (8192):    // LD 
                registers[mainCode[*PC - *origin - 1].DR] = mainCode[*PC - *origin + mainCode[*PC - *origin - 1].PCoffset9].code;
                setcc(registers, mainCode, PC, origin, CC);
                break; 

            case (-8192):   // LEA 
                registers[mainCode[*PC - *origin - 1].DR] = mainCode[*PC - *origin + mainCode[*PC - *origin - 1].PCoffset9].position;
                setcc(registers, mainCode, PC, origin, CC);
                break; 

            case (-24576):  // LDI 
                registers[mainCode[*PC - *origin - 1].DR] = mainCode[((mainCode[*PC - *origin + mainCode[*PC - *origin - 1].PCoffset9].code) - *origin)].code;
                setcc(registers, mainCode, PC, origin, CC);
                break; 

            case (20480):    // AND 
                if (mainCode[*PC - *origin - 1].isImm5) {
                    registers[mainCode[*PC - *origin - 1].DR] = (mainCode[*PC - *origin - 1].imm5) & (registers[mainCode[*PC - *origin - 1].DR]);
                } else {
                    registers[mainCode[*PC - *origin - 1].DR] = registers[mainCode[*PC - *origin - 1].SR1] & registers[mainCode[*PC - *origin - 1].SR2];    
                }
                setcc(registers, mainCode, PC, origin, CC);
                printStatus(registers, PC, IR, CC, origin);
                break; 

            case (-28672):    // NOT 
                break;  
             
            case (4096):    // ADD 
                break;  

            case (0):    // BR 
                break;  
        } 
    } 
} 

void setcc(signed short *registers, LC3 *mainCode, signed short *PC, signed short *origin, char *CC) {
    if (registers[mainCode[*PC - *origin - 1].DR] < 0) {
        *CC = 'N';
    } else if (registers[mainCode[*PC - *origin - 1].DR] == 0) {
        *CC = 'Z';
    } else if (registers[mainCode[*PC - *origin - 1].DR] > 0) {
        *CC = 'P';
    }
}

int main(int argc, char *argv[]) {    
    FILE *file;    
    unsigned char byte1[2];    
    signed short array[2];   
    signed short fileLine = 0;  
    LC3 mainCode[40000];  

    // USE signed SHORT 
    signed short opCodeMask = -4096;  
    signed short DRMask = 3584;  
    signed short SR1Mask = 448; 
    signed short PCoffset9Mask = 511;  
    signed short SR2Mask = 7; 
    signed short imm5Mask = 31; 
    signed short isImm5Mask = 32; 
    signed short nMask = 2048; 
    signed short zMask = 1024; 
    signed short pMask = 512; 

    signed short origin = 0;
    signed short registers[8] = {0, 0, 0, 0, 0, 0, 0, 0};
    signed short PC = 0; 
    signed short IR = 0; 
    char CC = 'Z';  

    file = fopen(argv[1], "r");    
    if (file == NULL) {    
        printf("Cannot open file \n");    
        exit(0);    
    }    

    while (1) {   
        fread (&byte1, 1, 2, file);   
        if (feof(file)) { break; }   
        array[0] = (signed short) byte1[1];   
        array[1] = (signed short) byte1[0];    
        array[1] = array[1] << 8;   
        array[0] = array[1] | array[0];          
        setUpLC3(&fileLine, array, mainCode, &PC, &opCodeMask, &DRMask, &SR1Mask, &PCoffset9Mask, &SR2Mask, &imm5Mask, &isImm5Mask, &nMask, &zMask, &pMask, &origin);  
        fileLine++;  
          
    }   
    fclose(file);  

    //printStatus(registers, &PC, &IR, &CC, &origin);
    runCode(mainCode, registers, &origin, &PC, &IR, &CC);// break on HALT 0xf025 is HALT TRAP, binary = 11110000 00100101, int = -4059  
    //printStatus(registers, &PC, &IR, &CC, &origin);
    return 0;    
}