import sys
import subprocess
import time
import os

FNULL = open(os.devnull, 'w')
size = sys.argv[1];
size = int(size)
cmd = './masGen ' + str(size) +  ' Mas' + str(size) + '.eqn' 
subprocess.call(cmd,shell=True,stdout=FNULL)
cmd = 'mkdir -p Mas' + str(size)
subprocess.call(cmd,shell=True,stdout=FNULL)
cmd = 'mv Mas' + str(size)+  '.eqn Mas' + str(size)
subprocess.call(cmd,shell=True,stdout=FNULL)


sis = open('tmp.sis','w')
sis.write('read_eqn Mas%d.eqn;\n' %size)
sis.write('resub -a;\n')
sis.write('sweep;\n')
sis.write('write_eqn Mas%d_sweep.eqn;\n' %size)
sis.close()

cmd = 'mv tmp.sis' ' Mas' + str(size)
subprocess.call(cmd,shell=True,stdout=FNULL)
cmd = 'cp eqn2ceqn.py' ' Mas' + str(size)
subprocess.call(cmd,shell=True,stdout=FNULL)


wor_dir = os.getcwd()
wor_dir = wor_dir + '/' + 'Mas' + str(size) + '/'
proc = subprocess.Popen(['sis'], stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, cwd=wor_dir)
proc.communicate(input='source tmp.sis; quit;')
# proc.communicate(input='quit;')

# exit()
# subprocess.call('sis',shell=True,cwd=wor_dir) # Can't figure out a better way as of yet. Stupid SIS
input_file = 'Mas' + str(size) + '_sweep.eqn'

subprocess.call('python eqn2ceqn.py ' + input_file,shell=True,cwd=wor_dir)

input_file = 'Mas' + str(size) + '_sweep_clean.eqn'
out_file = 'Mas' + str(size) + '_sweep_clean.alg'

cmd = 'cp -p eqn2alg' ' Mas' + str(size) + '/'
subprocess.call(cmd,shell=True,stdout=FNULL)
cmd = 'cp -p bprimtive' ' Mas' + str(size) + '/'
subprocess.call(cmd,shell=True,stdout=FNULL)
cmd = './eqn2alg ' + str(size) + ' ' + input_file + ' ' + out_file
subprocess.call(cmd,shell=True,cwd=wor_dir)

print 'hh'

exit()



