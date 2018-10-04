import sys
import subprocess
import time
import os

def and2cnf(y,a,b,tmp_file):
	if a=='0' and b=='0':
		tmp_file.write('-%s 0\n' %(y))
	else:
		tmp_file.write('%s -%s -%s 0\n' %(y,a,b) )
		tmp_file.write('-%s %s 0\n' %(y,a) )
		tmp_file.write('-%s %s 0\n' %(y,b) )
	return;

def or2cnf(y,a,b,tmp_file):
	tmp_file.write('-%s %s %s 0\n' %(y,a,b) )
	tmp_file.write('%s -%s 0\n' %(y,a) )
	tmp_file.write('%s -%s 0\n' %(y,b) )
	return;	

def nand2cnf(y,a,b,tmp_file):
	tmp_file.write('-%s -%s -%s 0\n' %(y,a,b) )
	tmp_file.write('%s %s 0\n' %(y,a) )
	tmp_file.write('%s %s 0\n' %(y,b) )
	return;

def xor2cnf(y,a,b,tmp_file):
	tmp_file.write('-%s -%s -%s 0\n' %(y,a,b) )
	tmp_file.write('%s %s -%s 0\n' %(y,a,b) )
	tmp_file.write('%s -%s %s 0\n' %(y,a,b) )
	tmp_file.write('-%s %s %s 0\n' %(y,a,b) )
	return;

def mux2cnf(y,s,a,b,tmp_file):
	tmp_file.write('%s -%s %s 0\n' %(s,a,y))
	tmp_file.write('%s %s -%s 0\n' %(s,a,y))
	tmp_file.write('-%s -%s %s 0\n' %(s,b,y))
	tmp_file.write('-%s %s -%s 0\n' %(s,b,y))

def eq2cnf(y,a,tmp_file):
	tmp_file.write('%s -%s 0\n' %(y,a))
	tmp_file.write('-%s %s 0\n' %(y,a))

input_file = sys.argv[1];
f = open(input_file,'r');
input_file = input_file.split('.')[0];
tmp_file = input_file + '_tmp.cnf'
to_delete = tmp_file;
input_file = input_file + '.cnf';

cnf = open(input_file,'w');
tmp_file = open(tmp_file,'w');
line = f.readline().strip();
#nvec = int(line)
nvec = 1;

# print vec;

vdir = {};
line = f.readline().strip();
line = line.split();
nvar = len(line)
for i in range(len(line)):
	vdir[line[i]] = str(i+1);

cl_count = 0;
for line in f.readlines():
	line = line.strip();
	if line[0] == 'a':
		line = line.strip('a(').strip(')')
		line = line.split(',')
		line  = [i.strip() for i in line]
		# print line
		for vn in range(nvec):	
			y = str(int(vdir[line[0]]) + vn*nvar)
			a = str(int(vdir[line[1]]) + vn*nvar)
			b = str(int(vdir[line[2]]) + vn*nvar)
			and2cnf(y,a,b,tmp_file)
			cl_count += 3;

	if line[0] == 'l':
		line = line.strip('l(').strip(')')
		line = line.split(',')
		line  = [i.strip() for i in line]
		# print line
		for li in line:
			if li[0] == '-':
				li = li.strip('-')
				vv = str(int(vdir[li]))
				tmp_file.write('-%s ' %vv)
			else:
				vv = str(int(vdir[li]))
				tmp_file.write('%s ' %vv)
		tmp_file.write('0\n')
		cl_count += 1;

	if line[0] == 'n':
		line = line.strip('n(').strip(')')
		line = line.split(',')
		line  = [i.strip() for i in line]
		# print line
		for vn in range(nvec):	
			y = str(int(vdir[line[0]]) + vn*nvar)
			a = str(int(vdir[line[1]]) + vn*nvar)
			b = str(int(vdir[line[2]]) + vn*nvar)
			nand2cnf(y,a,b,tmp_file)
			cl_count += 3;

	if line[0] == 'o':
		line = line.strip('o(').strip(')')
		line = line.split(',')
		line  = [i.strip() for i in line]
		# print line
		for vn in range(nvec):	
			y = str(int(vdir[line[0]]) + vn*nvar)
			a = str(int(vdir[line[1]]) + vn*nvar)
			b = str(int(vdir[line[2]]) + vn*nvar)
			or2cnf(y,a,b,tmp_file)
			cl_count += 3;

	if line[0] == 'x':
		line = line.strip('x(').strip(')')
		line = line.split(',')
		line  = [i.strip() for i in line]
		# print line
		for vn in range(nvec):	
			y = str(int(vdir[line[0]]) + vn*nvar)
			a = str(int(vdir[line[1]]) + vn*nvar)
			b = str(int(vdir[line[2]]) + vn*nvar)
			xor2cnf(y,a,b,tmp_file)
			cl_count += 4;

	if line[0] == 'm':
		line = line.strip('m(').strip(')')
		line = line.split(',')
		line  = [i.strip() for i in line]
		# print line
		for vn in range(nvec):	
			y = str(int(vdir[line[0]]) + vn*nvar)
			s = str(int(vdir[line[1]]) + vn*nvar)
			a = str(int(vdir[line[2]]) + vn*nvar)
			b = str(int(vdir[line[3]]) + vn*nvar)
			mux2cnf(y,s,a,b,tmp_file)
			cl_count += 4;
			if vn != 0:
				s1 = str(int(vdir[line[1]]) + (vn-1)*nvar)
				s2 = str(int(vdir[line[1]]) + (vn)*nvar)
				eq2cnf(s1,s2,tmp_file)
				cl_count += 2;

	if line[0] == 't':
		line = line.strip('t').strip()
		line = line.split()
		for i in line:
			if i[0] == '-':
				i = i.strip('-')
				vv = str(int(vdir[i]))
				tmp_file.write('-%s 0\n' %vv)
				cl_count += 1;
			else:
				vv = str(int(vdir[i]))
				tmp_file.write('%s 0\n' %vv)
				cl_count += 1;

cnf.write('p cnf %d %d\n' %(nvar,cl_count))
tmp_file.close()
tmp_file = open(to_delete,'r');

for line in tmp_file.readlines():
	cnf.write(line);

cnf.close()
tmp_file.close()
f.close()

subprocess.call(['rm %s' %to_delete],shell=True)
