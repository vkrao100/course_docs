import numpy

def parse(file_name):
	f = open(file_name,'r')
	y = 0
	for line in f.readlines():
		if line[0] == '.':
			if(line[1] == 'e'):
				print('Parsing Done')
				break
			elif(line[1:5] == 'rows'):
				r = int(line[6:len(line)])
			elif(line[1:5] == 'cols'):
				c = int(line[6:len(line)])
				A = [['-' for i in range(c)] for j in range(r)]
				print(r); print(c); 
			elif(line[1:6] == 'names'):
				x = ['-' for i in range(c)]
				j = 7
				for i in range(c):
					x[i] = line[j]; j += 1;
					while(line[j] != ' '):
						x[i] += line[j]; j += 1;
						if j == len(line)-1:  break
					j += 1;
		else:
			print('matrix')
			for j in range(c):
				A[y][j] = line[2*j]
			y += 1

	
#	for i in range(c):
#		print(x[i])
#	
#	for i in range(r):
#		print('\n')
#		for j in range(c):
#			print(A[i][j])
	return (A,x) 			
			


