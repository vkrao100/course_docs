def find_essential_rows(A,x,ref_v):
	rows = []
	cols = []
	rpts = []
	vals = []
	#if(terminalCase(A) != 0):
	#	return(A,x,ref_v)
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
				rpts.append(cols[j])
	rpts = list(set(rpts))
	rpts.sort()
	#Deleting duplicate columns
	for i in range(len(rpts)-1,-1,-1):
		cols.remove(cols[rpts[i]])
		rows.remove(rows[rpts[i]])
		vals.remove(vals[rpts[i]])	

	
	#Now to deletion
	#Removing the rows & updating the solution
	cols = list(set(cols))
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
	if(A == []):
		ref_v = []
					
	#print('after removing essential rows')
	return(A,x,ref_v)
