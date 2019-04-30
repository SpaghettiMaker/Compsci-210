#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    FILE *file;
    unsigned char byte1;
    unsigned char byte2;
    file = fopen(argv[1], "r");
    if (file == NULL) {
        printf("Cannot open file \n");
        exit(0);
    }
    while (fread (&byte1, 1, 1, file)) {
        if(feof(file)) { 
            break;
        }
        fread (&byte2, 1, 1, file);
        printf("0x%04x\n", (unsigned int) byte2 | (unsigned int) byte1 << 8);
    }
    fclose(file);
    return 0;
}