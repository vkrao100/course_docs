#!/usr/bin/python
########################################################
# description - python file to evaluate the minimum 
#				constraints to solve a covering problem
#                 
# - author - Vikas Kumar Rao
# - UnID   - U1072596
########################################################

#helper files
import os
import sys
import copy

##########################################
# main function
##########################################

def main():
	
	# SETTING THIS VARIBLE TO '1' WILL ENMABLE ALL THE DEBUG PRINT STATEMENTS
	# WHILE SETTING IT TO '0' WILL DISABLE THE DEBUG PRINT STATEMENTS
	global verbose
	verbose = 1

	#read the input file from command line
	inpFile       = sys.argv [-1]
	baseFile,ext  = os.path.splitext(inpFile)
	Matx          = []

	# parse input txt file
	Mat,Vars      = parse_txt(inpFile)

	#output
	run_recursive_algorithm(Mat,Vars)

##########################################
# function to parse input text file and 
# determine the constraints of covering 
# problem
##########################################

def parse_txt(inpFile):

	strings = ("rows","cols","names")
	rowNum = 0
	with open(inpFile, 'r') as fin:
		for line in fin.readlines():
			if line[0] == '.':
				if(line[1] == 'e'):
					if verbose:
						print('EOF - Parsing Done\n')
					break
				#read number of rows
				elif(strings[0] in line):
					dum,numRows = line.split()
					numRows = int(numRows)
					if verbose:
						print("number of rows",numRows)
				#read number of columns
				elif(strings[1] in line):
					dum,numCols = line.split()
					numCols = int(numCols)
					if verbose:
						print("number of columns",numCols)
					#initializing matrix as list of lists
					Mat = [['-' for i in range(numCols)] for j in range(numRows)]
					if verbose:
						print("initialized matrix")
						print_mat(Mat)
				#store the column variables
				elif(strings[2] in line):
					line = line.strip(".names")
					Vars = line.split()
					if verbose:
						print("variable names for columns",Vars)
			else:
				Mat[rowNum] = line.split()
				rowNum += 1

	if verbose:
		print("original matrix for covering problem")
		print_mat(Mat)
	
	fin.close()
	return (Mat,Vars) 			

#####################################################
# wrapper to run the algorithm and check for 
# feasibility of solution
#####################################################

def run_recursive_algorithm(Mat, Vars):
	
	Soln  = []
	best  = copy.deepcopy(Vars)

	#run bcp to check for feasibility of solution
	sol,S = bcp(Mat,Soln,best,Vars)

	if(S == 1):
		print('Solution exists:')
		print(sol)
	else:
		print('Infeasible to find an assignment')

######################################################
# bcp wrapper for stepwise execution of subtasks
######################################################

def bcp(Mat,Soln,best,Vars):

	#reduce the matrix based on essentials and dominance rules
	Mat, Soln, Vars     = reduce(Mat, Soln,Vars)

	#objects to set bound constraints
	Mat_bound    = copy.deepcopy(Mat)
	Soln_bound   = copy.deepcopy(Soln)

	#define lower bound for recursion
	Bound, Solution = lower_bound(Mat_bound,Soln_bound)

	#check for the efficiency of current solution
	if (Bound >= len(best)):
		return(best,Solution)
	
	#check for terminal case
	if(terminal_case(Mat) == 1):
		return(Soln,1)
	elif(terminal_case(Mat) == -1):
		return(best,-1)

	#choose column
	choice = choose_column(Mat)

	Mat_1  = copy.deepcopy(Mat)
	Soln_1 = copy.deepcopy(Soln)
	best_1 = copy.deepcopy(best)
	Vars_1 = copy.deepcopy(Vars)

	#Updating the matrix by setting selected column to 1
	Mat_1  = select_column(Mat_1,choice) 
	
	Soln_1.append(Vars_1[choice])
	Vars_1.remove(Vars_1[choice])
	
	#recurse the solution with updated choice
	(Soln_1,Solution_1) = bcp(Mat_1,Soln_1,best_1,Vars_1)

	if(len(Soln_1) < len(best)):
		best = copy.deepcopy(Soln_1)
		Solution = Solution_1
		if(len(best) == Bound):
			return(best,Solution)

	Mat_0  = copy.deepcopy(Mat)
	Soln_0 = copy.deepcopy(Soln)
	best_0 = copy.deepcopy(best)
	Vars_0 = copy.deepcopy(Vars)

	#Updating the matrix by setting selected column to 0
	Mat_0  = remove_column(Mat_0,choice)
	Vars_0.remove(Vars_0[choice])
	
	#recurse the solution with updated choice
	(Soln_0,Solution_0) = bcp(Mat_0,Soln_0,best_0,Vars_0)

	if(len(Soln_0) < len(best)):
		best = copy.deepcopy(Soln_0)
		Soln = Solution_0
	return(best,Solution)

#########################################
# Reduce function to check for essentials, 
# row dominance and column dominance
#########################################

def reduce(Mat,Soln,Vars):
	
	condition = 1
	while(condition == 1):
		Mat_prime 	  = copy.deepcopy(Mat)
		Mat,Soln,Vars = find_essential_rows(Mat,Soln,Vars)
		Mat           = delete_dominating_rows(Mat)
		Mat,Vars = delete_dominated_columns(Mat,Vars)

		if(Mat != [] and Mat != Mat_prime):
			condition = 1 
		else:
			condition = 0

	if verbose:
		print('matrix after reduction:')
		print_mat(Mat)
	return(Mat,Soln,Vars)

####################################
#Function for finding essential rows
####################################

def find_essential_rows(Mat,Soln,Vars):
	
	rows = [] #rows to be deleted
	cols = [] #columns to be deleted
	rows = set(rows);
	cols = set(cols);
	rpts = [] #repeat values
	vals = [] #values stored in essential rows
	
	for row in Vars:
		vals.append('-')

	for row in Mat:
		essential_vals = len(Vars)
		for col in row:
			if(col == '-'):
				essential_vals -= 1
			else:
				delete = row.index(col)

		if essential_vals == 1:
			if list(cols & {delete}):
				if vals[delete] != '-' and row[delete] != vals[delete]:
					return (Mat,Soln,Vars)

			rows.add(Mat.index(row))
			cols.add(delete)
			vals[delete] = row[delete]	
	
	rows = list(rows); 
	cols = list(cols); 
	rows.sort();
	cols.sort();

	#Remove the solved rows & update the solution
	for i in range(len(cols)):
		if(vals[cols[i]] == '1'):
			Soln.append(Vars[cols[i]])
		for j in range(len(Mat)-1,-1,-1):
			if(Mat[j][cols[i]] == vals[cols[i]]):
				Mat.remove(Mat[j])

	#Remove the column which has the same value
	for i in range(len(cols)-1,-1,-1):
		Vars.remove(Vars[cols[i]])
		for j in Mat:
			del j[cols[i]]

	if(Mat == []):
		Vars = []

	if verbose:
		print('after removing essential rows')
		print_mat(Mat)
		print(Vars)
		print(Soln)

	return(Mat,Soln,Vars) 
		
###################################
#Function for finding row dominance
###################################

def delete_dominating_rows(Mat):
	
	delete = []
	
	for i in range(len(Mat)-1):
		for j in range(i+1,len(Mat)):
			for p in range(2):
				condition = 0
				for k in range(len(Mat[0])):
					#Checking dominance of i over j
					if(p == 0):
						if(Mat[j][k] == '-' or Mat[j][k] == Mat[i][k]):
							continue
						else:
							condition = 1
							break
					else:
					#Checking dominance of j over i
						if(Mat[i][k] == '-' or Mat[i][k] == Mat[j][k]):
							continue
						else:
							condition = 1
							break
				if(condition == 0):
					if(p == 0):	
						delete.append(i)
					else:
						delete.append(j)
					break # If in case both rows dominate one another

	#Checking complete; Now to deletion					
	delete = list(set(delete))
	delete.sort()

	for i in range(len(delete)-1,-1,-1):
		Mat.remove(Mat[delete[i]])
	
	if verbose:
		print('after row dominance')
		print_mat(Mat)
	return(Mat)

#######################################
#Function for finding column dominance
#######################################

def delete_dominated_columns(Mat,Vars):
	
	delete = []
	if verbose:
		print('before column dominance')
		print_mat(Mat)
		print(Vars)

	for i in range(len(Vars)-1):
		for j in range(i+1,len(Vars)):
			for k in range(2):
				condition = 0
				for l in range(len(Mat)):
					#Checking dominance of i over j
					if(k == 0):
						if((Mat[l][i] == '1') or (Mat[l][i] == '-' and Mat[l][j] != '1') or (Mat[l][i] == '0' and Mat[l][j] == '0')):
							continue
						else:
							condition = 1;
							break
					else:
					#Checking dominance of j over i
						if((Mat[l][j] == '1') or (Mat[l][j] == '-' and Mat[l][i] != '1') or (Mat[l][j] == '0' and Mat[l][i] == '0')):
							continue
						else:
							condition = 1;
							break
				if(condition == 0):
					if(k == 0):
						delete.append(j)
					else:
						delete.append(i)
					break #If in case both columns dominate one another
		
	#Checking complete; Now to deletion
	delete = list(set(delete))
	delete.sort() 

	#Removing the rows
	for i in range(len(delete)):
		for j in range(len(Mat)-1,-1,-1):
			if(Mat[j][delete[i]] == '0'):
				del Mat[j]
				break

	#Removing the dominated columns
	for j in range(len(delete)-1,-1,-1):
		Vars.remove(Vars[delete[j]])
		for i in Mat:	
			del i[delete[j]]
			
	if verbose:
		print('after column dominance')
		print_mat(Mat)
		print(Vars)

	return(Mat,Vars)

###########################################
# Determine the lower bound for the given 
# matrix
###########################################

def lower_bound(Mat,Soln):
	
	#check for terminal case
	if(terminal_case(Mat) == -1):
		return(len(Soln),-1)
	elif(terminal_case(Mat) == 1):
		return(len(Soln),1)

	MIS         = []
	condition   = 1
	Mat_r       = copy.deepcopy(Mat)
	Mat         = delete_rows_with_complemented_variables(Mat)
	while(condition == 1):
		row = choose_shortest_row(Mat)
		if(row != -1):
			for k in range(len(Mat_r)):
				if(Mat_r[k] == Mat[row]):
					MIS.append(k)
					break
		Mat = delete_intersecting_rows(Mat,row)
		if(Mat == []):
			condition = 0

	return(len(MIS)+len(Soln),1)

#######################################################
# function to delete rows with complemented variables #
#######################################################

def delete_rows_with_complemented_variables(Mat):
	
	for i in range(len(Mat)-1,-1,-1):
		for j in range(len(Mat[0])):
			if(Mat[i][j] == '0'):
				Mat.remove(Mat[i])
				break
	if verbose:
		print('after deleting rows with complemented variables')
		print_mat(Mat)

	return(Mat)

############################################################
# function to choose the shortest row for branch and bound #
############################################################

def choose_shortest_row(Mat):
	
	#return if empty matrix
	if(Mat == []):
		return(-1)

	r_count = len(Mat[0])
	c_count = 0
	sel_r   = 0
	for i in range(len(Mat)):
		c_count = 0
		for j in range(len(Mat[0])):
			if(Mat[i][j] == '1'):
				c_count += 1
		if(c_count<r_count):
			r_count = c_count
			sel_r = i

	if verbose:
		print('shortest row chosen is')
		print(sel_r)

	return(sel_r)

########################################
# function to delete intersecting rows #
########################################

def delete_intersecting_rows(Mat,row):
	
	#return if empty matrix
	if(Mat == []):
		return(Mat)
	
	col = []
	for j in range(len(Mat[0])):
		if(Mat[row][j] == '1'):
			col.append(j)

	for i in range(len(col)):
		for j in range(len(Mat)-1,-1,-1):
			if(Mat[j][col[i]] == '1'):
				Mat.remove(Mat[j])

	if verbose:
		print('after deleting intersecting rows')
		print_mat(Mat)

	return(Mat)

##########################################################
# Function for checking if the terminal case has reached #
##########################################################

def terminal_case(Mat):
	
	#return if empty matrix
	if(len(Mat) == 0):
		return 1
	
	if(len(Mat) == 1):
		if(len(Mat[0]) == 0):
			return -1;
	
	#if don't cares in a row
	for i in range(len(Mat)):
		dash = 0;
		for j in range(len(Mat[0])):
			if(Mat[i][j] == '-'):
				dash += 1;
		if(dash == len(Mat[0])):
			return -1

	#One Column; Different Values
	val = Mat[0][0]
	if(len(Mat[0]) == 1):
		for i in range(len(Mat)):
			if(Mat[i][0] != val):
				return -1

	return 0

##################################################
# Function for choosing the column for branching #
##################################################

def choose_column(Mat):
	
	row_weight = []
	col_weight = []

	#loop for finding the row weights
	for i in range(len(Mat)):
		div = 0.0
		ones = 0
		for j in range(len(Mat[0])):
			if(Mat[i][j] == '1'):
				ones += 1;
		if(ones != 0):
			div = 1/float(ones)
		row_weight.append(div)

	#loop for finding the column weights
	for j in range(len(Mat[0])):
		wgt = 0.0
		for i in range(len(Mat)):
			if(Mat[i][j] == '1'):
				wgt += row_weight[i]
		col_weight.append(wgt)

	#CHecking for largest col weight
	comp = col_weight[0]
	col = 0
	for i in range(len(col_weight)):
		if(col_weight[i]>comp):
			col = i
			comp = col_weight[i]

	if verbose:
		print('column chosen')
		print(col)

	return col

#####################################
# Function for selecting the column #
#####################################

def select_column(Mat,col):
	
	for i in range(len(Mat)-1,-1,-1):
		if(Mat[i][col] == '1'):
			del Mat[i]

	for i in Mat:
		del i[col]

	if verbose:
		print('matrix after selecting column')
		print_mat(Mat)

	return(Mat)

#############################
# Function to remove column #
#############################

def remove_column(Mat,col):
	
	for i in range(len(Mat)-1,-1,-1):
		if(Mat[i][col] == '0'):
			del Mat[i]

	for i in Mat:
		del i[col]

	if verbose:
		print('matrix after removing column')
		print_mat(Mat)

	return(Mat)

################
# matrix print #
################			

def print_mat(Mat):
	
	if(Mat == []):
		print(Mat)
		print('0')
		print('0')
	else:
		for i in range(len(Mat)):
			print(Mat[i])

######################
# call main function #
######################

if __name__ == "__main__":
    main()