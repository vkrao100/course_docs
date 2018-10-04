import copy

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


for i in range(1,6):
	print(i)

a = ['foo', 5]
b = a[:]
c = list(a)
d = copy.copy(a)

a.append('baz')
print('original: %r\n slice: %r\n list(): %r\n copy: %r'% (a, b, c, d))	

T = [1,4,4,3,6,7,9,7,1,0,0,0,5]
T = list(set(T))
T.sort()
print(T)
F = [[5,7],[6]]
R = [[5,5],[6]]

if(R[0] == F[0]):
	print('good')
else:
	print('bad')
def parse(str):
	
	return
 
