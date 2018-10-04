import copy
import utility
#########################################
#Function implementing the bcp algorithm
def bcp(A,x,b,ref_v):
	(A,x,ref_v) = redux(A,x,ref_v)
	temp_A = copy.deepcopy(A)
	temp_x = copy.deepcopy(x)
	(L,f) = lower_bound(temp_A,temp_x)

	if (L >= len(b)):
		return(b,f)
	
	if(terminalCase(A) == 1):
		return(x,1)
	elif(terminalCase(A) == -1):
		return(b,-1)

	#print('choosing the column')
	#print('xc = 1----------------------------------------------------------')
	c = choose_column(A)
	#print('%s = 1' %ref_v[c])
	A_1 = copy.deepcopy(A)
	x_1 = copy.deepcopy(x)
	b_1 = copy.deepcopy(b)
	ref_v_1 = copy.deepcopy(ref_v)
	A_1 = select_column(A_1,c) #Updating the matrix by setting xc to 1
	x_1.append(ref_v_1[c])
	ref_v_1.remove(ref_v_1[c])
	(x_1,f_1) = bcp(A_1,x_1,b_1,ref_v_1)

	if(len(x_1) < len(b)):
		b = copy.deepcopy(x_1)
		f = f_1
		if(len(b) == L):
			#print('done here')
			return(b,f)

	#print('xc = 0----------------------------------------------------------')
	#print('%s = 0' %ref_v[c])
	A_0 = copy.deepcopy(A)
	x_0 = copy.deepcopy(x)
	b_0 = copy.deepcopy(b)
	ref_v_0 = copy.deepcopy(ref_v)
	A_0 = remove_column(A_0,c)
	ref_v_0.remove(ref_v_0[c])
	(x_0,f_0) = bcp(A_0,x_0,b_0,ref_v_0)

	if(len(x_0) < len(b)):
		#print('xc = 0 if better record it')
		b = copy.deepcopy(x_0)
		f = f_0
	#print('finally getting back')
	return(b,f)
	#exit()
#if(terminalCase(A) == 1):
#########################################
#Reduce function
def redux(A,x,ref_v):
	chk = 1
	while(chk == 1):
		A_prime = copy.deepcopy(A)
		(A,x,ref_v) = find_essential_rows(A,x,ref_v)
		(A) = delete_dominating_rows(A)
		(A,x,ref_v) = delete_dominated_columns(A,x,ref_v)
		if(A != [] and A != A_prime):
			chk = 1 #Improvement
		else:
			chk = 0 #No Improvement
	return(A,x,ref_v)

####################################
#Function for finding essential rows
def find_essential_rows(A,x,ref_v):
	rows = []; rows = set(rows);
	cols = []; cols = set(cols);
	vals = [];
	
	for r in ref_v:
		vals.append('-') 

	for r in A:
		essential_elements = len(ref_v)
		for c in r:
			if(c == '-'):
				essential_elements -= 1
			else:
				dlt = r.index(c)

		if essential_elements == 1:
			if list(cols & {dlt}): #If two or more columns have an essential element
				if vals[dlt] != '-' and r[dlt] != vals[dlt]: #If those columns have different values for the essential element
					#print 'Infeasible - Returning'
					return (A,x,ref_v)
			
			rows.add(A.index(r))
			cols.add(dlt)
			vals[dlt] = r[dlt]
	
	rows = list(rows); rows.sort();
	cols = list(cols); cols.sort();

	for i in range(len(cols)):
		if(vals[cols[i]] == '1'):
			x.append(ref_v[cols[i]])
		for j in range(len(A)-1,-1,-1):
			if(A[j][cols[i]] == vals[cols[i]]):
				del A[j]



	for i in range(len(cols)-1,-1,-1):
		ref_v.remove(ref_v[cols[i]])
		for j in A:
			del j[cols[i]]

	if(A == []):
		ref_v = []
		
	#print('after removing essential rows')
	#utility.print_mat(A)
	return(A,x,ref_v)

###################################
#Function for finding row dominence
def delete_dominating_rows(A):
	tbd = []
	#if(terminalCase(A) != 0):
	#	return(A)
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
	#print tbd

	#print(tbd)
	for i in range(len(tbd)-1,-1,-1):
		del A[tbd[i]]

	#print 'After removing dominating rows'
	#utility.print_mat(A)
	return(A)

#######################################
#Function for finding column dominence
def delete_dominated_columns(A,x,ref_v):
	tbd = []
	rtbd = []
	#if(terminalCase(A) != 0):
	#	return(A,x,ref_v)

	for i in range(len(ref_v)-1):
		for j in range(i+1,len(ref_v)):
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

	#Removing the rows
	for i in range(len(tbd)):
		for j in range(len(A)-1,-1,-1):
			if(A[j][tbd[i]] == '0'):
				del A[j]
				break

	#Removing the dominated columns
	for j in range(len(tbd)-1,-1,-1):
		ref_v.remove(ref_v[tbd[j]])
		for i in A:	
			del i[tbd[j]]
			
	#print 'After removing dominating columns'
	#utility.print_mat(A)
	return(A,x,ref_v)

###########################################
#Function for determining the lower bound
def lower_bound(A,x):
	if(terminalCase(A) == -1):
		return(len(x),-1)
	elif(terminalCase(A) == 1):
		return(len(x),1)

	MIS = []
	chk = 1
	ref_A = copy.deepcopy(A)
	A = delete_rows_with_complemented_variables(A)
	#utility.print_mat(A)
	while(chk == 1):
		r = choose_shortest_row(A)
		#print(r)
		if(r != -1):
			for k in range(len(ref_A)):
				if(ref_A[k] == A[r]):
					MIS.append(k)
					break
		A = delete_intersecting_rows(A,r)
		if(A == []):
			chk = 0
	#print(MIS)
	return(len(MIS) + len(x),1)
##############################################
def delete_rows_with_complemented_variables(A):
	for i in range(len(A)-1,-1,-1):
		for j in range(len(A[0])):
			if(A[i][j] == '0'):
				del A[i]
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
		if(c_count != 0):
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
				del A[j]

	return(A)
########################################################
#Function for checking if the terminal case has reached	
def terminalCase(A):
	if(len(A) == 0):
		#print('1')
		return 1

	if(len(A) == 1):
		if(len(A[0]) == 0):
			#print('-1')
			return -1;
	#All dont cares in a row
	for i in range(len(A)):
		dash = 0;
		for j in range(len(A[0])):
			if(A[i][j] == '-'):
				dash += 1;
		if(dash == len(A[0])):
			#print('-1')
			return -1

	#One Column; Different Values
	val = A[0][0]
	if(len(A[0]) == 1):
		for i in range(len(A)):
			if(A[i][0] != val):
				#print('-1')
				return -1

	return 0
################################################
#Function for choosing the column for branching	
def choose_column(A):
	row_weight = []
	col_weight = []

	#loop for finding the row weights
	for i in range(len(A)):
		div = 0.0
		ones = 0
		for j in range(len(A[0])):
			if(A[i][j] == '1'):
				ones += 1;
		if(ones != 0):
			div = 1/float(ones)
		row_weight.append(div)

	#loop for finding the column weights
	for j in range(len(A[0])):
		wgt = 0.0
		for i in range(len(A)):
			if(A[i][j] == '1'):
				wgt += row_weight[i]
		col_weight.append(wgt)

	#CHecking for largest col weight
	comp = col_weight[0]
	col = 0
	for i in range(len(col_weight)):
		if(col_weight[i]>comp):
			col = i
			comp = col_weight[i]

	return col

#####################################
#Function for selecting the column
def select_column(A,c):
	for i in range(len(A)-1,-1,-1):
		if(A[i][c] == '1'):
			del A[i]

	for i in A:
		del i[c]

	return(A)

def remove_column(A,c):
	for i in range(len(A)-1,-1,-1):
		if(A[i][c] == '0'):
			del A[i]

	for i in A:
		del i[c]

	return(A)