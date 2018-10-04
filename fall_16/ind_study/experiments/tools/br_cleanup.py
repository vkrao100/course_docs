import fileinput
import sys

input_file = sys.argv[1];
f = open(input_file,'r');
input_file = input_file.split('.')
output_file = input_file[0] + '_cleaned' +'.blif'
# print output_file
blif = open(output_file,'w')


for line in f.readlines():
	print line
	ed = line.replace('[','wire')
	ed = ed.replace(']','')
	blif.write('%s' %ed)

blif.close()
f.close()