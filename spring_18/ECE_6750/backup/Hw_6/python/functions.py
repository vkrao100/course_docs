import copy
import utility
#########################################
#Function implementing the bcp algorithm
def bcp(A,x,b,ref_v):
	(A,x) = redux(A,x,ref_v)
	print('after reduction steps')
	utility.print_mat(A)
	
	temp_A = copy.deepcopy(A)
	temp_x = copy.deepcopy(x)
	L = functions.lower_bound(temp_A,temp_x,v)
	print('after lower bound')
	print(L)
	if (L >= len(b)):
		utility.print_sol(v,ref_x)
		exit() 

#if(terminalCase(A) == 1):
#########################################
#Reduce function
def redux(A,x,ref_v):
	chk = 1
	while(chk == 1):
		A_prime = copy.deepcopy(A)
		(A,x,ref_v) = find_essential_rows(A,x,ref_v)
		(A) = delete_dominating_rows(A)
		exit()
		(A,x,ref_v) = delete_dominated_columns(A,x,ref_v)
		if(A != [] and A != A_prime):
			chk = 1 #Improvement
		else:
			chk = 0 #No Improvement
	return(A,x,v)

####################################
#Function for finding essential rows
def find_essential_rows(A,x,ref_v):
	rows = []
	cols = []
	rpts = []
	vals = []
	for i in range(len(A)):
		asn = len(ref_v)
		for j in range(len(ref_v)):
			if(A[i][j] == '-'):
				asn -= 1
			else:
				dlt = j
		if(asn == 1):
			rows.append(i)
			cols.append(dlt)
			vals.append(A[i][dlt])
	#Checking if any column repeats with different values
	for i in range(len(cols)-1):
		for j in range(i+1,len(cols)):
			if(cols[i] == cols[j] and A[rows[i]][cols[i]] != A[rows[j]][cols[j]]):
				rpts.append(j)
	rpts = list(set(rpts))
	rpts.sort()
	#Deleting duplicate columns
	for i in range(len(rpts)-1,-1,-1):
		cols.remove(rpts[i])
		rows.remove(rpts[i])
		vals.remove(rpts[i])	
	
	#Now to deletion
	#Removing the rows & updating the solution
	for i in range(len(cols)):
		if(vals[i] == '1'):
			x.append(ref_v[cols[i]])
		for j in range(len(A)-1,-1,-1):
			if(A[j][cols[i]] == vals[i]):
				A.remove(A[j])

	cols.sort()
	#Removing the column 
	for i in range(len(cols)-1,-1,-1):
		ref_v.remove(ref_v[cols[i]])
		for j in A:
			del j[cols[i]]
					
	print('after removing essential rows')
	utility.print_mat(A)
	#print(len(A))
	#print('\n\n\n\n')
	print(ref_v)
	print(x)
	return(A,x,ref_v)

###################################
#Function for finding row dominence
def delete_dominating_rows(A):
	tbd = []
	for i in range(len(A)-1):
		for j in range(i+1,len(A)):
			for p in range(2):
				chk = 0
				for k in range(len(A[0])):
					#Checking dominance of i over j
					if(p == 0):
						if(A[j][k] == '-' or A[j][k] == A[i][k]):
							continue
						else:
							chk = 1
							break
					else:
					#Checking dominance of j over i
						if(A[i][k] == '-' or A[i][k] == A[j][k]):
							continue
						else:
							chk = 1
							break
				if(chk == 0):
					if(p == 0):	
						tbd.append(i)
					else:
						tbd.append(j)
					break # If in case both rows dominate one another

	#Checking complete; Now to deletion					
	tbd = list(set(tbd))
	tbd.sort()

	#print(tbd)
	for i in range(len(tbd)-1,-1,-1):
		A.remove(A[tbd[i]])
	print('after row dominance')
	utility.print_mat(A)
	#print(x)
	#print(v)
	return(A)

#######################################
#Function for finding column dominence
def delete_dominated_columns(A,x,v):
	tbd = []
	rtbd = []
	for i in range(len(A[0])-1):
		for j in range(i+1,len(A[0])):
			for p in range(2):
				chk = 0
				for k in range(len(A)):
					#Checking dominance of i over j
					if(p == 0):
						if((A[k][i] == '1') or (A[k][i] == '-' and A[k][j] != '1') or (A[k][i] == '0' and A[k][j] == '0')):
							continue
						else:
							chk = 1;
							break
					else:
					#Checking dominance of j over i
						if((A[k][j] == '1') or (A[k][j] == '-' and A[k][i] != '1') or (A[k][j] == '0' and A[k][i] == '0')):
							continue
						else:
							chk = 1;
							break
				if(chk == 0):
					if(p == 0):
						tbd.append(j)
					else:
						tbd.append(i)
					break #If in case both columns dominate one another
		
	#Checking complete; Now to deletion
	tbd = list(set(tbd))
	tbd.sort()
	#Updating the solution
	for i in range(len(tbd)-1,-1,-1):
		v[x[tbd[i]]] = '0'
		x.remove(x[tbd[i]]) 

	#Checking rows with '0' entry for the columns in tbd
	for i in range(len(A)):
		for j in range(len(tbd)):
			if(A[i][tbd[j]] == '0'):
				rtbd.append(i)

	rtbd = list(set(rtbd))
	rtbd.sort()

	#Removing the rows
	for i in range(len(rtbd)-1,-1,-1):
		A.remove(A[rtbd[i]])

	#Removing the dominated columns
	for j in range(len(tbd)-1,-1,-1):
		for i in A:	
			del i[tbd[j]]

	#print('after column dominance')
	#utility.print_mat(A)
	#print(x)
	#print(v)
	return(A,x,v)

###########################################
#Function for determining the lower bound
def lower_bound(A,x,v):
	MIS = []
	chk = 1
	ref_A = copy.deepcopy(A)
	A = delete_rows_with_complemented_variables(A)
	while(chk == 1):
		r = choose_shortest_row(A)
		if(r != -1):
			for k in range(len(ref_A)):
				if(ref_A[k] == A[r]):
					MIS.append(k)
					break
		A = delete_intersecting_rows(A,r)
		if(A == []):
			chk = 0
	print(MIS)
	return(len(MIS) + len(v) - len(A[0]))
##############################################
def delete_rows_with_complemented_variables(A):
	for i in range(len(A)-1,-1,-1):
		for j in range(len(A[0])):
			if(A[i][j] == '0'):
				A.remove(A[i])
				break
	return(A)
################################################
def choose_shortest_row(A):
	if(A == []):
		return(-1)
	r_count = len(A[0])
	c_count = 0
	r = 0
	for i in range(len(A)):
		c_count = 0
		for j in range(len(A[0])):
			if(A[i][j] == '1'):
				c_count += 1
		if(c_count<r_count):
			r_count = c_count
			r = i
	return(r)

def delete_intersecting_rows(A,r):
	if(A == []):
		return(A)
	col = []
	for j in range(len(A[0])):
		if(A[r][j] == '1'):
			col.append(j)

	for i in range(len(col)):
		for j in range(len(A)-1,-1,-1):
			if(A[j][col[i]] == '1'):
				A.remove(A[j])

	return(A)
########################################################
#Function for checking if the terminal case has reached	
def terminalCase(A):
	trmnl = 0
	
