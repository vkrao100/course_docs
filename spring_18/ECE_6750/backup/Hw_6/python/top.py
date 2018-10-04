import utility
import numpy
import functions
import copy

(A,ref_v) = utility.parse("simple.txt")
#ref_v is a reference of the variables.
x = []
b = copy.deepcopy(ref_v) #Initial solution
print(x)
print(b)
#utility.print_sol(x,v)
sol = functions.bcp(A,x,b,ref_v)
