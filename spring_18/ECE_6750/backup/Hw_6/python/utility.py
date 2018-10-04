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
				#print(r); print(c); 
			elif(line[1:6] == 'names'):
				v = ['-' for i in range(c)]
				j = 7
				for i in range(c):
					v[i] = line[j]; j += 1;
					while(line[j] != ' '):
						v[i] += line[j]; j += 1;
						if j == len(line)-1:  break
					j += 1;
		else:
			#print('matrix')
			for j in range(c):
				A[y][j] = line[2*j]
			y += 1

	return (A,v) 			
			
def print_mat(A):
	if(A == []):
		print(A)
		print('0')
		print('0')
	else:
		for i in range(len(A)):
			print(A[i])
		print(len(A))
		print(len(A[0]))
		print('\n\n\n')

def print_sol(x,v):
	for i in range(len(x)):
		if(x[v[i]] == '1'):
			print(v[i])
		
		
