#include <stdio.h>

// Maximum page number in use
#define MAX_LNP 67108865
#define SECTOR_SIZE 512
#define PAGE_SIZE 8192

char lpnmap[MAX_LNP] = {0, };

int main(int argc, char *argv[]) {
	if (argc != 3) {
		printf("Usage: %s <input_file> <output_file>\n", argv[0]);
		return 1;
	}

	FILE *inputFile, *outputFile;
	inputFile = fopen(argv[1], "r");
	outputFile = fopen(argv[2], "w");
	if (inputFile == NULL || outputFile == NULL) {
		perror("file open error\n");
		return 1;
	}


	char line[256];

	while (fgets(line, sizeof(line), inputFile)) {
		double timestamp;
		int cpuid, sectorsize, flag;
		long long sectornum;

		int result = sscanf(line, "%lf %d %lld %d %d", &timestamp, &cpuid, &sectornum, &sectorsize, &flag);

		long long startlpn = sectornum * SECTOR_SIZE / PAGE_SIZE;
		long long endlpn = (sectornum * SECTOR_SIZE + sectorsize * SECTOR_SIZE) / PAGE_SIZE;

		if((sectornum * SECTOR_SIZE + sectorsize * SECTOR_SIZE) % PAGE_SIZE == 0){
			// endlpn - 1
			endlpn--;
		}

		for(int lpn = startlpn; lpn <= endlpn; lpn++){	
			if (flag == 1 && lpnmap[lpn] == 0){ 
				fprintf(outputFile, "%d\t%d\n", lpn, PAGE_SIZE); 
			}

			lpnmap[lpn] = 1;
		}
	}
	fclose(inputFile);
	fclose(outputFile);
	return 0;
}

