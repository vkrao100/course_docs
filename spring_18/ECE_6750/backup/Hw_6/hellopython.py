print("hello world")
name = 'utk7'

print(name)
file_name = 'example.txt'
f = open(file_name,'r')

for line in f.readlines():
#	print(line)
#	print(line[0])
	print(len(line))
	if line[0] == '.':
		print('command')
	else:
		print('matrix') 	

#for letter in line:
#	print(letter)
#print(line[0])
st = '-'
print('done')
st = 'r 5'
mat = [['-' for x in range(int(st[2]))] for x in range(int(st[2]))]


st1 = 'x';st2 = 'y';


print(st1+st2)
#print(mat[1][3])

print('x' + str(5))

def parse(str):
	
	return
 
