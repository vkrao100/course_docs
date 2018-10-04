import utility
import sys
import functions
import copy

input_file = sys.argv[1]
(A,ref_v) = utility.parse(input_file)
#utility.print_mat(A)
#ref_v is a reference of the variables.
x = []
rpt = 0
b = copy.deepcopy(ref_v) #Initial solution
for i in range(len(A)-1,-1,-1):
	dash = 0
	for j in range(len(A[0])):
		if(A[i][j] == '-'):
			dash += 1
	if(dash == len(A[0])):
		A.remove(A[i])
		rpt = 1
if(rpt == 1):
	print('Ignoring the completely empty row (containing only dont cares) provided in the input')
#print(x)
#print(b)
(sol,f) = functions.bcp(A,x,b,ref_v)
if(f == 1):
	print('Solution:')
	print(sol)

else:
	print('Infeasible')
	#print(sol)
