#!/usr/bin/python
# Created by Vikas Rao @ 11/17/2017
# goal: script to convert eqn files into cnf format.
# steps:
#     
########################################################################

import os
import sys
import time
import re
import fileinput
import string
import subprocess
import gc
from time import sleep
from itertools import islice


def main():
    
    #warning for input variable sync in both eqn files
    print("The tool assumes that the primary inputs and outputs for both eqn files must be same with exact same variable names as well\n");
    
    f1 = sys.argv [-2]
    f2 = sys.argv [-1]
    baseFile1, ext1 = os.path.splitext(f1)
    baseFile2, ext2 = os.path.splitext(f2)
    global globalVars 
    global secondLine 
    global inputVars 
    global baseName
    global outputVars 
    global iterationCount
    global satfileName
    global xVarCount
    global firstFile
    global sat 
    sat = True
    iterationCount = 0
    globalVars  = list()
    inputVars   = list()
    outputVars  = list()
    baseName    = os.path.join(baseFile1 + '_' + baseFile2 + '_')
    intOutTxt   = os.path.join(baseName + str(iterationCount) + "_tmp.txt")
    firstFile   = os.path.join(baseName + str(iterationCount) + ".txt") 

    while(sat):
        satfileName, intOutTxt = iteration_loop(intOutTxt,f1,f2)
        intOutTxt   = read_sat_file(satfileName, intOutTxt)
        gc.collect()

def iteration_loop(intOutTxt,f1,f2):

    global satfileName

    print('Running iteration %s'%iterationCount)

    write_variable_names(intOutTxt,f1,f2)
    
    write_mastrovito_gates(intOutTxt,f1)
    
    write_montgomery_gates(intOutTxt,f2)

    write_miter(intOutTxt)

    intOut = replace_input_names(intOutTxt)

    write_first_line(intOut)

    satfileName = ckt2cnf(intOut)

    return satfileName, intOut

def write_variable_names(fileOut,in1,in2):
    
    comVars   = list()
    temp1Vars = list()
    temp2Vars = list()
    diffVars  = list()
    global secondLine
    global inputVars
    global outputVars

    interestedKeyWords = ['INORDER', 'OUTORDER', 'UC(']
    with open(in1, 'r') as fin1, open(in2, 'r') as fin2, open(fileOut, 'a') as fout:
            for linef1 in fin1:
                if any(keyWord in linef1 for keyWord in interestedKeyWords):
                    searchObjModule = re.search( r'INORDER\s*=\s*(.*)', linef1, re.M|re.I)
                    if searchObjModule:
                        secondLine = searchObjModule.group(1) + (" x_1 x_2 x_3 x_4 ")
                        secondLine = secondLine.replace(';','')
                        comVars    = secondLine.split()
                        inputVars  = re.split(r"[^\w]", searchObjModule.group(1))
                        inputVars  = list(filter(None, inputVars))
                        if iterationCount != 0:
                            for i in range(0,len(inputVars)):
                                globalVars.append(inputVars[i]+str(iterationCount))
                    searchObjModule = re.search( r'OUTORDER\s*=\s*(.*)', linef1, re.M|re.I)
                    if searchObjModule:
                        outputVars = re.split(r"[^\w]", searchObjModule.group(1))
                        comVars    = comVars + outputVars
                        outputVars = list(filter(None, outputVars))
                else:
                    linef1 = linef1.strip()
                    temp1Vars = temp1Vars + re.split(r"[^\w]", linef1)
            temp1Vars = list(filter(None, temp1Vars))
            diffVars  = list(set(temp1Vars) - set(comVars))
            for j in range(0,len(diffVars)):
                globalVars.append(diffVars[j]+'ma_'+str(iterationCount))
            for linef2 in fin2:
                if any(keyWord in linef2 for keyWord in interestedKeyWords):
                    pass
                else:
                    linef2 = linef2.strip()
                    temp2Vars = temp2Vars + re.split(r"[^\w]", linef2)
            temp2Vars = list(filter(None, temp2Vars))
            diffVars = list(set(temp2Vars) - set(comVars))
            for j in range(0,len(diffVars)):
                globalVars.append(diffVars[j]+'mo_'+str(iterationCount))
            for i in range(0,len(outputVars)):
                globalVars.append(outputVars[i]+'ma_'+str(iterationCount))
                globalVars.append(outputVars[i]+'mo_'+str(iterationCount))

def write_mastrovito_gates(fileOut,in1):
 
    interestedKeyWords = ['INORDER','OUTORDER']
    with open(in1, 'r') as fin1, open(fileOut, 'a') as fout:
            for line in fin1:
                if any(keyWord in line for keyWord in interestedKeyWords):
                    pass
                elif ('UC(' in line):
                    line = line.strip()
                    searchObjModule = re.search( r'UC\((.*)\s*=\s*(.*)\^(.*)\);', line, re.M|re.I)
                    intT = searchObjModule.group(1).strip()
                    fout.write('m('+ intT + '_1ma_' + str(iterationCount) + ', ' + searchObjModule.group(3).strip() + 'ma_' + str(iterationCount) + ', x_1, x_2)\n')
                    fout.write('m('+ intT + '_2ma_' + str(iterationCount) + ', ' + searchObjModule.group(3).strip() + 'ma_' + str(iterationCount) + ', x_3, x_4)\n')
                    fout.write('m('+ intT + 'ma_' + str(iterationCount) + ', ' + searchObjModule.group(2).strip() + 'ma_' + str(iterationCount) + ', ' + intT + '_1ma_' + str(iterationCount) + ', ' + intT + '_2ma_' + str(iterationCount) + ')\n')
                    globalVars.append(intT + '_1ma_' + str(iterationCount))
                    globalVars.append(intT + '_2ma_' + str(iterationCount))
                elif ('*' in line):
                    line = line.strip()
                    searchObjModule = re.search( r'(.*)\s*=\s*(.*)\*(.*);', line, re.M|re.I)
                    fout.write('a('+ searchObjModule.group(1).strip() + 'ma_' + str(iterationCount) +', ' + searchObjModule.group(2).strip() + 'ma_' + str(iterationCount) +', ' + searchObjModule.group(3).strip() + 'ma_' + str(iterationCount) + ')\n')
                elif ('^' in line):
                    line = line.strip()
                    searchObjModule = re.search( r'(.*)\s*=\s*(.*)\^(.*);', line, re.M|re.I)
                    fout.write('x('+ searchObjModule.group(1).strip() + 'ma_' + str(iterationCount) + ', ' + searchObjModule.group(2).strip() + 'ma_' + str(iterationCount) + ', ' + searchObjModule.group(3).strip() + 'ma_' + str(iterationCount) + ')\n')

def write_montgomery_gates(fileOut,in2):
    
    tempVars = list()
 
    interestedKeyWords = ['INORDER','OUTORDER']
    with open(in2, 'r') as fin2, open(fileOut, 'a') as fout:
            for line in fin2:
                if any(keyWord in line for keyWord in interestedKeyWords):
                    pass
                else:
                    tempVars = re.split(r"[^\w]", line)
                    tempVars = list(filter(None, tempVars))
                    if len(tempVars)==2:
                        if tempVars[1]=="0":
                            fout.write('a('+ tempVars[0] + 'mo_' + str(iterationCount) + ', ' + tempVars[1] + ', ' + tempVars[1]+')\n')
                        else:
                            fout.write('a('+ tempVars[0] + 'mo_' + str(iterationCount) + ', ' + tempVars[1] + 'mo_' + str(iterationCount) + ', ' + tempVars[1] + 'mo_' + str(iterationCount) +')\n')
                    elif len(tempVars)==3:
                        if ('*' in line):
                            line = line.strip()
                            searchObjModule = re.search( r'(.*)\s*=\s*\(?(.*)\*([\w\d]*)\s*\)?;', line, re.M|re.I)
                            fout.write('a('+ searchObjModule.group(1) + 'mo_' + str(iterationCount) + ', ' + searchObjModule.group(2) + 'mo_' + str(iterationCount) + ', ' + searchObjModule.group(3) + 'mo_' + str(iterationCount) + ')\n')
                        elif ('^' in line):
                            line = line.strip()
                            searchObjModule = re.search( r'(.*)\s*=\s*(.*)\^(.*);', line, re.M|re.I)
                            fout.write('x('+ searchObjModule.group(1) + 'mo_' + str(iterationCount) + ', ' + searchObjModule.group(2) + 'mo_' + str(iterationCount) + ', ' + searchObjModule.group(3) + 'mo_' + str(iterationCount) +')\n')
                    elif len(tempVars)==4:
                        if (')^' in line):
                            fout.write('a('+ tempVars[0] + '_1mo_' + str(iterationCount) + ', ' + tempVars[1] + 'mo_' + str(iterationCount) +', ' + tempVars[2] + 'mo_' + str(iterationCount) +')\n')
                            globalVars.append(tempVars[0] + '_1mo_' + str(iterationCount))
                            fout.write('x('+ tempVars[0] + 'mo_' + str(iterationCount) + ', ' + tempVars[0] + '_1mo_' + str(iterationCount) + ', ' + tempVars[3] + 'mo_' + str(iterationCount) +')\n')
                        elif ('^(' in line):
                            fout.write('a('+ tempVars[0] + '_1mo_' + str(iterationCount) + ', ' + tempVars[2] + 'mo_' + str(iterationCount) +', ' + tempVars[3] + 'mo_' + str(iterationCount) +')\n')
                            globalVars.append(tempVars[0] + '_1mo_' + str(iterationCount))
                            fout.write('x('+ tempVars[0] + 'mo_' + str(iterationCount) +', ' + tempVars[0] + '_1mo_' + str(iterationCount) + ', ' + tempVars[1] + 'mo_' + str(iterationCount) +')\n')
                        else:
                            fout.write('x('+ tempVars[0] + '_1mo_' + str(iterationCount) + ', ' + tempVars[1] +'mo_' + str(iterationCount) + ', ' + tempVars[2] + 'mo_' + str(iterationCount) +')\n')
                            globalVars.append(tempVars[0] + '_1mo_' + str(iterationCount))
                            fout.write('x('+ tempVars[0] + 'mo_' + str(iterationCount) +', ' + tempVars[0] + '_1mo_' + str(iterationCount) + ', ' + tempVars[3] + 'mo_' + str(iterationCount) +')\n')
                    elif len(tempVars)==5:
                        fout.write('a('+ tempVars[0] + '_1mo_' + str(iterationCount) + ', ' + tempVars[2] + 'mo_' + str(iterationCount) +', ' + tempVars[3] + 'mo_' + str(iterationCount) +')\n')
                        globalVars.append(tempVars[0] + '_1mo_' + str(iterationCount))
                        fout.write('x('+ tempVars[0] + '_2mo_' + str(iterationCount) + ', ' + tempVars[0] + '_1mo_' + str(iterationCount) + ', ' + tempVars[1] + 'mo_' + str(iterationCount) +')\n')
                        globalVars.append(tempVars[0] + '_2mo_' + str(iterationCount))
                        fout.write('x('+ tempVars[0] + 'mo_' + str(iterationCount) +', ' + tempVars[0] + '_2mo_' + str(iterationCount) + ', ' + tempVars[4] + 'mo_' + str(iterationCount) +')\n')

def write_miter(fileOut):

    tempVars = list()
    levels = 0
    index = 0
    logVal = 0
    global outputVars
    with open(fileOut, 'a') as fout:
        for idx in range(0,len(outputVars)):
            fout.write('x('+ outputVars[idx] + 'mi_' + str(iterationCount)+ '_' + str(levels) + ', ' + outputVars[idx] + 'ma_'+str(iterationCount) + ', ' + outputVars[idx] +'mo_'+str(iterationCount) + ')\n')
            globalVars.append(outputVars[idx] + 'mi_' + str(iterationCount) + '_' + str(levels))
            tempVars.append(outputVars[idx] + 'mi_' + str(iterationCount) + '_' + str(levels))
        numLevels = 2**(len(outputVars)-1).bit_length()
        bufferLevels = numLevels - len(outputVars)
        for bufferL in range(0,bufferLevels):
            bufferString = 'z_'+str(len(outputVars)+bufferL)+'_'
            fout.write('x('+ bufferString + 'mi_' + str(iterationCount)+ '_' + str(levels) + ', 0, 0)\n')
            globalVars.append(bufferString + 'mi_' + str(iterationCount)+ '_' + str(levels))
            tempVars.append(bufferString + 'mi_' + str(iterationCount)  + '_'+ str(levels))
        for bufferVars in range(len(tempVars),2*numLevels-1):
            globalVars.append('z_'+str(bufferVars)+'_mi' + '_' + str(iterationCount))
            tempVars.append('z_'+str(bufferVars)+'_mi'+ '_' + str(iterationCount))
        for upperLoop in range(0,numLevels-1):
            fout.write('o('+ tempVars[numLevels+upperLoop] + ', ' + tempVars[index] + ', ' + tempVars[index+1] + ')\n')
            index=index+2
        if iterationCount==0:
            fout.write('t '+ tempVars[len(tempVars)-1]+'\n')
        else:
            fout.write('t -'+ tempVars[len(tempVars)-1]+'\n')

def write_first_line(fileOut):
    
    global secondLine
    if iterationCount == 0:
        globalVars.append('0')
    intVars = " ".join(str(x) for x in globalVars)
    secondLine = '1\n'+ secondLine + intVars + '\n'
    with open(fileOut, 'r+') as fout:
        content = fout.read()
        fout.seek(0, 0)
        fout.write(secondLine.rstrip('\r\n') + '\n' + content)
        fout.close()
        print("created txt format miter circuit for the given eqn files\n")

def replace_input_names(fileNameIn):

    tempVars = list()
    inppVars = list()
    replaceDict = {}
    tmp_name = fileNameIn.strip('_tmp.txt') + ('.txt')
    for index in inputVars:
        inppVars.extend([index,index])
    for idx in range(0,len(inputVars)):
        tempVars.append(inputVars[idx]+'ma_'+str(iterationCount))
        tempVars.append(inputVars[idx]+'mo_'+str(iterationCount))
    if iterationCount==0:
        for ind in range(len(inppVars)):
            replaceDict[tempVars[ind]] = inppVars[ind]
    else:
        for ind in range(len(inppVars)):
            replaceDict[tempVars[ind]] = inppVars[ind]+str(iterationCount)
    with open(fileNameIn, "r") as fin, open(tmp_name, "w") as fout:
        for line in fin:
            for i,j in replaceDict.items():
                line = line.replace(i,j)
            fout.write(line)
    subprocess.call(['rm %s' %fileNameIn],shell=True)
    return tmp_name

def ckt2cnf(fileArgument):

    global iterationCount
    global satfileName
    if iterationCount == 4:
        debug = True
    else:
        debug = False
    baseFile = fileArgument.strip('.txt')
    print("created cnf file for the given txt\n")
    subprocess.call(["python ckt2cnf.py " + fileArgument + " " + str(debug)],shell=True)
    print("running picosat on given cnf\n")
    satfileName = baseFile + "_sat" + str(iterationCount) + ".txt"
    subprocess.call(["picosat "+ baseFile + ".cnf >" + satfileName],shell=True)
    iterationCount = iterationCount + 1

    return satfileName

def read_sat_file(fileNameIn,fileNameOut):

    global sat
    global satfileName
    global firstFile
    satVars  = list()
    tempVars = list()
    intOutTxt = os.path.join(baseName + str(iterationCount) + "_tmp.txt")
    with open(fileNameIn,'r') as fin, open(fileNameOut,'r') as fprev, open(intOutTxt,'w') as fout:
        data  = fin.read().splitlines(True)
        data2 = fprev.read().splitlines(True)
        if "s SATISFIABLE" in data[0]:
            print("found a satisfying assignment for iteration %s\n"%iterationCount)
            satVars.append('t')
            tempVars = tempVars + data[1].strip('v').split()
            tempVars = tempVars + data[2].strip('v').split()
            for inp in range(0,len(inputVars)):
                if "-" in tempVars[inp]:
                    satVars.append('-' + inputVars[inp] + str(iterationCount))
                else:
                    satVars.append(inputVars[inp] + str(iterationCount))
            for inp2 in range(2,len(data2)):
                fout.writelines(data2[inp2])
            intVars = " ".join(str(x) for x in satVars)
            fout.write(intVars + '\n')
        else:
            sat = False
            print("No satisfying assignment for iteration %s\n"%iterationCount)
            with open(firstFile) as f:
                for i, l in enumerate(f):
                    pass
            delete_lines = i+1
            for inp2 in range(0,len(data2)):
                if inp2 in range(2,delete_lines):
                    pass
                else:
                    fout.writelines(data2[inp2])
            intOutTxtNew = intOutTxt.strip('_tmp.txt') + ('.txt')
            subprocess.call(['mv %s %s' %(intOutTxt,intOutTxtNew)],shell=True)
            satfileName = ckt2cnf(intOutTxtNew)
    return intOutTxt

if __name__ == "__main__":
    main()
