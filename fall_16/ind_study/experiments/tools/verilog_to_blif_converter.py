#!/usr/bin/python
# Created by Vikas Rao @ 10/03/2016
# goal: convert .verilog structural benchmarks to cadence genlib blif format
#import shutil
import os
import sys
import argparse
import fileinput
import re
import string
import datetime

def blif_write():

    #imports from given helper libraries
    from datetime import datetime

    #maintain a wire dictionary
    from collections import defaultdict
    wireDict = defaultdict(list)

    #file input details
#    fileInput     = "temp.v"
    #fileInput     = "4x4_SG_SP_AR_RC_flattened_clipped_input_non_opt.v"
    fileInput     = sys.argv [-1]

    try:
        f = open(fileInput,"r")
    except IOError:
        print ("File open failed! Need an input structural verilog file at commandline")

    f.close()

    baseFile, ext  = os.path.splitext(fileInput)
    outputSuffixB  = "blif"
    #outputSuffixM  = "v"
    outputSuffixE  = "eqn"

    #output file string
    newFileBlif = os.path.join(baseFile + "." + outputSuffixB)
    #newFileModVerilog = os.path.join(baseFile + "_modified" + "." + outputSuffixM)
    newFileEqn  = os.path.join(baseFile + "." + outputSuffixE)

    #interested keywords from input file
    interestedKeyWords = ['module', 'assign', 'input', 'output', 'wire']
    interestedSymbols  = ['^', '&', '|']

    #remove (*src*) commands and change all the "\" from instance names
    with fileinput.FileInput(fileInput, inplace=True, backup='.bak') as foperation:
        for line in foperation:
            line = re.sub( r'\(\* src.*\*\)', r'', line.rstrip())
            line = re.sub( r'([\w\d])\[', r'\1 [', line.rstrip())
            print(line)

    #close opened file
    foperation.close()

    #main function
    with open(fileInput, 'r') as fin, open(newFileBlif, 'w') as fout, open(newFileEqn, 'w') as fout1:
        for line in fin:
            if any(keyWord in line for keyWord in interestedKeyWords):
                searchObjModule = re.search( r'module\s+(.*)\(.*;', line, re.M|re.I)
                if searchObjModule:
                    firstLine      = os.path.join("#benchMark " + searchObjModule.group(1) + " generated by vikas's py script for file " + fileInput +" on " + str(datetime.now()))
                    #secondLineEqn = os.path.join("INORDER DUMMY;")
                    fout.write(firstLine)
                    fout1.write(firstLine)
                    fout1.write('\n')
                    #fout1.write(secondLineEqn)
                    fout.write('\n')
#                    fout1.write('\n')
                    secondLine = os.path.join(".module " + searchObjModule.group(1))
                    fout.write(secondLine)
                    fout.write('\n')
                searchObjInput  = re.search( r'input\s\[(\d*):(\d*)\]\s*(.*)\s*;', line, re.M|re.I)
                if searchObjInput:
                    intObjectHigh = int(searchObjInput.group(1)) + 1
                    intObjectLow  = int(searchObjInput.group(2))
                    for vector in range(intObjectLow,intObjectHigh):
                        inputBlif = os.path.join(".inputs " + searchObjInput.group(3) + "_" + str(vector))
                        inputEqn  = os.path.join("INORDER = " + searchObjInput.group(3) + "_" + str(vector) + ";")
                        fout.write(inputBlif)
                        fout1.write(inputEqn)
                        fout.write('\n')
                        fout1.write('\n')
                    ipObjectHighPresent = any(i.isdigit() for i in searchObjInput.group(1))
                    ipObjectLowPresent  = any(i.isdigit() for i in searchObjInput.group(2))
                    inputName     = searchObjInput.group(3)
                    inputName     = re.sub('[\.]','_', inputName)
                    inputName     = re.sub(r'\\','', inputName)
                    inputName     = re.sub(r'^_','w', inputName)
                    inputName     = inputName.strip()
                    if ipObjectHighPresent and ipObjectLowPresent:
                        dataLoad      = [(inputName,searchObjInput.group(1)),(inputName,searchObjInput.group(2))]
                        for name, vector in dataLoad:
                            wireDict [inputName].append(vector)
                searchObjOutput  = re.search( r'output\s\[(\d+):(\d+)\]\s*(.*)\s*;', line, re.M|re.I)
                if searchObjOutput:
                    intObjectHigh = int(searchObjOutput.group(1)) + 1
                    intObjectLow  = int(searchObjOutput.group(2))
                    for vector in range(intObjectLow,intObjectHigh):
                        outputBlif = os.path.join(".outputs " + searchObjOutput.group(3) + "_" + str(vector))
                        outputEqn  = os.path.join("OUTORDER = " + searchObjOutput.group(3) + "_" + str(vector) + ";")
                        fout.write(outputBlif)
                        fout1.write(outputEqn)
                        fout.write('\n')
                        fout1.write('\n')
                    opObjectHighPresent = any(i.isdigit() for i in searchObjOutput.group(1))
                    opObjectLowPresent  = any(i.isdigit() for i in searchObjOutput.group(2))
                    outputName     = searchObjOutput.group(3)
                    outputName     = re.sub('[\.]','_', outputName)
                    outputName     = re.sub(r'\\','', outputName)
                    outputName     = re.sub(r'^_','w', outputName)
                    outputName     = outputName.strip()
                    if opObjectHighPresent and opObjectLowPresent:
                        dataLoad      = [(outputName,searchObjOutput.group(1)),(outputName,searchObjOutput.group(2))]
                        for name, vector in dataLoad:
                            wireDict [outputName].append(vector)
                searchObjWire   = re.search( r'wire\s*\[(\d+)\:(\d+)\]\s*(.*?);', line, re.M|re.I)
                if searchObjWire:
                    intObjectHigh = any(i.isdigit() for i in searchObjWire.group(1))
                    intObjectLow  = any(i.isdigit() for i in searchObjWire.group(2))
                    wireName      = searchObjWire.group(3)
                    wireName      = re.sub('[\.]','_', wireName)
                    wireName      = re.sub(r'\\','', wireName)
                    wireName      = re.sub(r'^_','w', wireName)
                    wireName      = wireName.strip()
                    if intObjectHigh and intObjectLow:
                        dataLoad      = [(wireName,searchObjWire.group(1)),(wireName,searchObjWire.group(2))]
                        for name, vector in dataLoad:
                            wireDict [wireName].append(vector)
                searchObjAssign = re.search(r'(\/?)assign\s+(.*?)\[*(\d*)(\:*)(\d*)\]*\s*=\s*(.*?)\s+\[*(\d*)(\:*)(\d*)\]*\s*([&|^~])\s*(\S*)\s*\[*(\d*)(\:*)(\d*)\]*\s*;', line, re.M|re.I)
                if searchObjAssign:
                    if "/" in str(searchObjAssign.group(1)):
                        print ("comment line - ignored")
                    elif any(symbol in str(searchObjAssign) for symbol in interestedSymbols):
                        input1 = re.sub('[\.]','_', searchObjAssign.group(6))
                        input1 = re.sub(r'\\','', input1)
                        input1 = re.sub(r'^_','w', input1)
                        input1 = input1.strip()
                        input2 = re.sub('[\.]','_', searchObjAssign.group(11))
                        input2 = re.sub(r'\\','', input2)
                        input2 = re.sub(r'^_','w', input2)
                        input2 = input2.strip()
                        output = re.sub('[\.]','_', searchObjAssign.group(2))
                        output = re.sub(r'\\','', output)
                        output = re.sub(r'^_','w', output)
                        output = output.strip()
                        if "&" in str(searchObjAssign):
                            vector_spread_write("&", searchObjAssign, fout, fout1, wireDict, output, input1, input2)
                        elif "|" in str(searchObjAssign):
                            vector_spread_write("|", searchObjAssign, fout, fout1, wireDict, output, input1, input2)
                        elif "^" in str(searchObjAssign):
                            vector_spread_write("^", searchObjAssign, fout, fout1, wireDict, output, input1, input2)
                searchObjBufAssign = re.search(r'(\/?)assign\s+(\S*)\s+\[*(\d*)(\:*)(\d*)(\]*)\s*=\s*([~]*)\s*(\S*)\s*\[*(\d*)(\:*)(\d*)(\]*)\s*;', line, re.M|re.I)
                if searchObjBufAssign:
                    if any(symbol in str(searchObjBufAssign) for symbol in interestedSymbols):
                        print ("already processed")
                    else:
                        if "/" in str(searchObjBufAssign.group(1)):
                            print ("comment line - ignored")
                        else:
                            if "~" in searchObjBufAssign.group(7):
                               operator = " INVX1 "
                            else:
                               operator = " BUFX1 "
                            input1 = re.sub('[\.]','_', searchObjBufAssign.group(8))
                            input1 = re.sub(r'\\','', input1)
                            input1 = re.sub(r'^_','w', input1)
                            input1 = input1.strip()
                            output = re.sub('[\.]','_', searchObjBufAssign.group(2))
                            output = re.sub(r'\\','', output)
                            output = re.sub(r'^_','w', output)
                            output = output.strip()
                            dictList = (input1, output)
                            if any(var in wireDict.keys() for var in dictList):
                                write_bufinv_vector_outputs(fout, fout1, operator, searchObjBufAssign, wireDict, output, input1)
                            else:
                                write_bufinv_symbols(fout, fout1, searchObjBufAssign, operator, output, input1)
        fout.write('.end')
        print(wireDict)


def vector_spread_write(operation, lineString, fout, fout1, wireDict, output, input1, input2):

    dictList    = (output, input1, input2)

    operator    = return_operator(operation)
    operatorEqn = return_eqn_operator(operation)

    if any(var in wireDict.keys() for var in dictList):
        write_vector_outputs(fout, fout1, operator, operatorEqn, lineString, wireDict, output, input1, input2)
    else:
        write_symbols(fout, fout1, operator, operatorEqn, output, input1, input2)

def write_symbols(fout, fout1, operator, operatorEqn, output, input1, input2):

    bufInputBlif = os.path.join(".gate " + operator + " A=" + input1 + " B=" + input2 + " Y=" + output)
    bufInputEqn = os.path.join(output + " = " + input1 + operatorEqn + input2 + ";")
    fout.write(bufInputBlif)
    fout1.write(bufInputEqn)
    fout.write('\n')
    fout1.write('\n')

def write_bufinv_symbols(fout, fout1, searchObjBufAssign, operator, output, input1):

    if "'b" in str(input1):
        input1   = re.sub( r'(\d*)\'b(\d*)', r'\2', input1.rstrip())

    bufInputBlif = os.path.join(".gate" + operator + "A=" + input1 + " Y=" + output)

    if "INV" in operator:
        #bufInputEqn  = os.path.join(output + " = " + "!" + input1 + "+" + "DUMMY" + ";")
        bufInputEqn  = os.path.join(output + " = " + "!" + input1 + ";")
    else:
        bufInputEqn  = os.path.join(output + " = " + input1 + ";")
    fout.write(bufInputBlif)
    fout.write('\n')
    fout1.write(bufInputEqn)
    fout1.write('\n')

def write_vector_outputs(fout, fout1, operator, operatorEqn, lineString, wireDict, output, input1, input2):

    outputHighVec = any(i.isdigit() for i in lineString.group(3))
    outputLowVec  = any(i.isdigit() for i in lineString.group(5))
    input1HighVec = any(i.isdigit() for i in lineString.group(7))
    input1LowVec  = any(i.isdigit() for i in lineString.group(9))
    input2HighVec = any(i.isdigit() for i in lineString.group(12))
    input2LowVec  = any(i.isdigit() for i in lineString.group(14))

    if outputHighVec and outputLowVec and input1HighVec and input1LowVec and input2HighVec and input2LowVec:
        loopRange      = int(lineString.group(3)) + 1
        rangeStartIn   = int(lineString.group(5))
        rangeStartOut1 = int(lineString.group(9))
        rangeStartOut2 = int(lineString.group(14))
        for m in range(rangeStartIn, loopRange):
            bufInLineBlif = os.path.join(".gate " + operator + " A=" + input1 + "_" + str(rangeStartOut1) + " B=" + input2 + "_" + str(rangeStartOut2) + " Y=" + output + "_" + str(m))
            bufInLineEqn  = os.path.join(output + "_" + str(m) + " = " + input1 + "_" + str(rangeStartOut1) + operatorEqn + input2 + "_" + str(rangeStartOut2) + ";")
            fout.write(bufInLineBlif)
            fout.write('\n')
            fout1.write(bufInLineEqn)
            fout1.write('\n')
            rangeStartOut1 = rangeStartOut1 + 1
            rangeStartOut2 = rangeStartOut2 + 1
    elif outputHighVec and outputLowVec and input1HighVec and input1LowVec and (not(input2HighVec)) and (not(input2LowVec)):
        loopRange      = int(lineString.group(3)) + 1
        rangeStartIn   = int(lineString.group(5))
        rangeStartOut1 = int(lineString.group(9))
        rangeStartOut2 = int(wireDict [input2][1])
        for m in range(rangeStartIn, loopRange):
            bufInLineBlif = os.path.join(".gate " + operator + " A=" + input1 + "_" + str(rangeStartOut1) + " B=" + input2 + "_" + str(rangeStartOut2) + " Y=" + output + "_" + str(m))
            bufInLineEqn  = os.path.join(output + "_" + str(m) + " = " + input1 + "_" + str(rangeStartOut1) + operatorEqn + input2 + "_" + str(rangeStartOut2) + ";")
            fout.write(bufInLineBlif)
            fout.write('\n')
            fout1.write(bufInLineEqn)
            fout1.write('\n')
            rangeStartOut1 = rangeStartOut1 + 1
            rangeStartOut2 = rangeStartOut2 + 1
    elif outputHighVec and outputLowVec and input2HighVec and input2LowVec and (not(input1HighVec)) and (not(input1LowVec)):
        loopRange      = int(lineString.group(3)) + 1
        rangeStartIn   = int(lineString.group(5))
        rangeStartOut1 = int(wireDict [input1][1])
        rangeStartOut2 = int(lineString.group(14))
        for m in range(rangeStartIn, loopRange):
            bufInLineBlif = os.path.join(".gate " + operator + " A=" + input1 + "_" + str(rangeStartOut1) + " B=" + input2 + "_" + str(rangeStartOut2) + " Y=" + output + "_" + str(m))
            bufInLineEqn  = os.path.join(output + "_" + str(m) + " = " + input1 + "_" + str(rangeStartOut1) + operatorEqn + input2 + "_" + str(rangeStartOut2) + ";")
            fout.write(bufInLineBlif)
            fout.write('\n')
            fout1.write(bufInLineEqn)
            fout1.write('\n')
            rangeStartOut1 = rangeStartOut1 + 1
            rangeStartOut2 = rangeStartOut2 + 1
    elif (not(outputHighVec)) and (not(outputLowVec)) and input2HighVec and input2LowVec and input1HighVec and input1LowVec:
        loopRange      = int(wireDict [output][0]) + 1
        rangeStartIn   = int(wireDict [output][1])
        rangeStartOut1 = int(lineString.group(9))
        rangeStartOut2 = int(lineString.group(14))
        for m in range(rangeStartIn, loopRange):
            bufInLineBlif = os.path.join(".gate " + operator + " A=" + input1 + "_" + str(rangeStartOut1) + " B=" + input2 + "_" + str(rangeStartOut2) + " Y=" + output + "_" + str(m))
            bufInLineEqn  = os.path.join(output + "_" + str(m) + " = " + input1 + "_" + str(rangeStartOut1) + operatorEqn + input2 + "_" + str(rangeStartOut2) + ";")
            fout.write(bufInLineBlif)
            fout.write('\n')
            fout1.write(bufInLineEqn)
            fout1.write('\n')
            rangeStartOut1 = rangeStartOut1 + 1
            rangeStartOut2 = rangeStartOut2 + 1
    elif outputHighVec and outputLowVec and (not(input2HighVec)) and (not(input2LowVec)) and (not(input1HighVec)) and (not(input1LowVec)):
        loopRange      = int(lineString.group(3)) + 1
        rangeStartIn   = int(lineString.group(5))
        rangeStartOut1 = int(wireDict [input1][1])
        rangeStartOut2 = int(wireDict [input2][1])
        for m in range(rangeStartIn, loopRange):
            bufInLineBlif = os.path.join(".gate " + operator + " A=" + input1 + "_" + str(rangeStartOut1) + " B=" + input2 + "_" + str(rangeStartOut2) + " Y=" + output + "_" + str(m))
            bufInLineEqn  = os.path.join(output + "_" + str(m) + " = " + input1 + "_" + str(rangeStartOut1) + operatorEqn + input2 + "_" + str(rangeStartOut2) + ";")
            fout.write(bufInLineBlif)
            fout.write('\n')
            fout1.write(bufInLineEqn)
            fout1.write('\n')
            rangeStartOut1 = rangeStartOut1 + 1
            rangeStartOut2 = rangeStartOut2 + 1
    elif outputHighVec and (not(outputLowVec)) and input2HighVec and (not(input2LowVec)) and input1HighVec and (not(input1LowVec)):
        rangeStartIn   = int(lineString.group(3))
        rangeStartOut1 = int(lineString.group(7))
        rangeStartOut2 = int(lineString.group(12))
        bufInLineBlif = os.path.join(".gate " + operator + " A=" + input1 + "_" + str(rangeStartOut1) + " B=" + input2 + "_" + str(rangeStartOut2) + " Y=" + output + "_" + str(rangeStartIn))
        bufInLineEqn  = os.path.join(output + "_" + str(rangeStartIn) + " = " + input1 + "_" + str(rangeStartOut1) + operatorEqn + input2 + "_" + str(rangeStartOut2) + ";")
        fout.write(bufInLineBlif)
        fout.write('\n')
        fout1.write(bufInLineEqn)
        fout1.write('\n')
    elif outputHighVec and (not(outputLowVec)) and input2HighVec and (not(input2LowVec)) and (not(input1HighVec)) and (not(input1LowVec)):
        rangeStartIn   = int(lineString.group(3))
        rangeStartOut2 = int(lineString.group(12))
        bufInLineBlif = os.path.join(".gate " + operator + " A=" + input1 + " B=" + input2 + "_" + str(rangeStartOut2) + " Y=" + output + "_" + str(rangeStartIn))
        bufInLineEqn  = os.path.join(output + "_" + str(rangeStartIn) + " = " + input1 + operatorEqn + input2 + "_" + str(rangeStartOut2) + ";")
        fout.write(bufInLineBlif)
        fout.write('\n')
        fout1.write(bufInLineEqn)
        fout1.write('\n')
    elif outputHighVec and (not(outputLowVec)) and (not(input2HighVec)) and (not(input2LowVec)) and input1HighVec and (not(input1LowVec)):
        rangeStartIn   = int(lineString.group(3))
        rangeStartOut1 = int(lineString.group(7))
        bufInLineBlif = os.path.join(".gate " + operator + " A=" + input1 + "_" + str(rangeStartOut1) + " B=" + input2 + " Y=" + output + "_" + str(rangeStartIn))
        bufInLineEqn  = os.path.join(output + "_" + str(rangeStartIn) + " = " + input1 + "_" + str(rangeStartOut1) + operatorEqn + input2 + ";")
        fout.write(bufInLineBlif)
        fout.write('\n')
        fout1.write(bufInLineEqn)
        fout1.write('\n')
    elif (not(outputHighVec)) and (not(outputLowVec)) and input2HighVec and (not(input2LowVec)) and input1HighVec and (not(input1LowVec)):
        rangeStartOut1 = int(lineString.group(7))
        rangeStartOut2 = int(lineString.group(12))
        bufInLineBlif = os.path.join(".gate " + operator + " A=" + input1 + "_" + str(rangeStartOut1) + " B=" + input2 + "_" + str(rangeStartOut2) + " Y=" + output)
        bufInLineEqn  = os.path.join(output + " = " + input1 + "_" + str(rangeStartOut1) + operatorEqn + input2 + "_" + str(rangeStartOut2) + ";")
        fout.write(bufInLineBlif)
        fout.write('\n')
        fout1.write(bufInLineEqn)
        fout1.write('\n')
    elif (not(outputHighVec)) and (not(outputLowVec)) and (not(input2HighVec)) and (not(input2LowVec)) and (not(input1HighVec)) and (not(input1LowVec)):
        loopRange      = int(wireDict [output][0]) + 1
        rangeStartIn   = int(wireDict [output][1])
        rangeStartOut1 = int(wireDict [input1][1])
        rangeStartOut2 = int(wireDict [input2][1])
        for m in range(rangeStartIn, loopRange):
            bufInLineBlif = os.path.join(".gate " + operator + " A=" + input1 + "_" + str(rangeStartOut1) + " B=" + input2 + "_" + str(rangeStartOut2) + " Y=" + output + "_" + str(m))
            bufInLineEqn  = os.path.join(output + "_" + str(m) + " = " + input1 + "_" + str(rangeStartOut1) + operatorEqn + input2 + "_" + str(rangeStartOut2) + ";")
            fout.write(bufInLineBlif)
            fout.write('\n')
            fout1.write(bufInLineEqn)
            fout1.write('\n')
            rangeStartOut1 = rangeStartOut1 + 1
            rangeStartOut2 = rangeStartOut2 + 1

def write_bufinv_vector_outputs(fout, fout1, operator, searchObjBufAssign, wireDict, output, input1):

    outputHighVec = any(i.isdigit() for i in searchObjBufAssign.group(3))
    outputLowVec  = any(i.isdigit() for i in searchObjBufAssign.group(5))
    inputHighVec  = any(i.isdigit() for i in searchObjBufAssign.group(9))
    inputLowVec   = any(i.isdigit() for i in searchObjBufAssign.group(11))

    if "INV" in operator:
        #dummyVar    = " + DUMMY"
        dummyVar    = ""
        operatorEqn = "!"
    else:
        dummyVar    = ''
        operatorEqn = ''

    if outputHighVec and outputLowVec and inputHighVec and inputLowVec:
        loopRange     = int(searchObjBufAssign.group(3)) + 1
        rangeStartIn  = int(searchObjBufAssign.group(5))
        rangeStartOut = int(searchObjBufAssign.group(11))
        for m in range(rangeStartIn, loopRange):
            bufInLineBlif = os.path.join(".gate" + operator + "A=" + input1 + "_" + str(m) + " Y=" + output + "_" + str(rangeStartOut) )
            fout.write(bufInLineBlif)
            fout.write
            bufInLineEqn = os.path.join(output + "_" + str(rangeStartOut) + " = " + operatorEqn + input1 + "_" + str(m) + dummyVar + ";" )
            fout1.write(bufInLineEqn)
            fout1.write
            rangeStartOut = rangeStartOut + 1
    elif outputHighVec and outputLowVec and inputHighVec and (not(inputLowVec)):
        loopRange    = int(searchObjBufAssign.group(3)) + 1
        rangeStartIn = int(searchObjBufAssign.group(5))
        for m in range(rangeStartIn, loopRange):
            bufInLineBlif = os.path.join(".gate" + operator + "A=" + input1 + "_" + searchObjBufAssign.group(9) + " Y=" + output + "_" + str(m) )
            fout.write(bufInLineBlif)
            fout.write('\n')
            bufInLineEqn = os.path.join(output + "_" + str(m) + " = " + operatorEqn + input1 + "_" + searchObjBufAssign.group(9) + dummyVar + ";")
            fout1.write(bufInLineEqn)
            fout1.write('\n')
    elif outputHighVec and (not(outputLowVec)) and inputHighVec and inputLowVec:
        loopRange    = int(searchObjBufAssign.group(9)) + 1
        rangeStartIn = int(searchObjBufAssign.group(11))
        for m in range(rangeStartIn, loopRange):
            bufInLineBlif = os.path.join(".gate" + operator + "A=" + input1 + "_" + str(m) + " Y=" + output + "_" + searchObjBufAssign.group(3) )
            fout.write(bufInLineBlif)
            fout.write('\n')
            bufInLineEqn = os.path.join(output + "_" + searchObjBufAssign.group(3) + " = " + operatorEqn + input1 + "_" + str(m) + dummyVar + ";")
            fout1.write(bufInLineEqn)
            fout1.write('\n')
    elif outputHighVec and outputLowVec and (not(inputHighVec)) and (not(inputLowVec)):
        loopRange     = int(searchObjBufAssign.group(3)) + 1
        rangeStartIn  = int(searchObjBufAssign.group(5))
        rangeStartOut = int(wireDict [input1][1])
        for m in range(rangeStartIn, loopRange):
            bufInLineBlif = os.path.join(".gate" + operator + "A=" + input1 + "_" + str(rangeStartOut) + " Y=" + output + "_" + str(m) )
            fout.write(bufInLineBlif)
            fout.write('\n')
            bufInLineEqn = os.path.join(output + "_" + str(m) + " = " + operatorEqn + input1 + "_" + str(rangeStartOut) + dummyVar + ";")
            fout1.write(bufInLineEqn)
            fout1.write('\n')
            rangeStartOut = rangeStartOut + 1
    elif (not(outputHighVec)) and (not(outputLowVec)) and inputHighVec and inputLowVec:
        loopRange     = int(searchObjBufAssign.group(9)) + 1
        rangeStartIn  = int(searchObjBufAssign.group(11))
        rangeStartOut = int(wireDict [output][1])
        for m in range(rangeStartIn, loopRange):
            bufInLineBlif = os.path.join(".gate" + operator + "A=" + input1 + "_" + str(m) + " Y=" + output + "_" + str(rangeStartOut) )
            fout.write(bufInLineBlif)
            fout.write('\n')
            bufInLineEqn = os.path.join(output + "_" + str(rangeStartOut) + " = " + operatorEqn + input1 + "_" + str(m) + dummyVar + ";")
            fout1.write(bufInLineEqn)
            fout1.write('\n')
            rangeStartOut = rangeStartOut + 1
    elif outputHighVec and (not(outputLowVec)) and (not(inputLowVec)) and inputHighVec:
        bufInLineBlif = os.path.join(".gate" + operator + "A=" + input1 + "_" + searchObjBufAssign.group(9) + " Y=" + output + "_" + searchObjBufAssign.group(3))
        fout.write(bufInLineBlif)
        fout.write('\n')
        bufInLineEqn = os.path.join(output + "_" + searchObjBufAssign.group(3) + " = " + operatorEqn + input1 + "_" + searchObjBufAssign.group(9) + dummyVar + ";")
        fout1.write(bufInLineEqn)
        fout1.write('\n')
    elif outputHighVec and (not(outputLowVec)) and (not(inputLowVec)) and (not(inputHighVec)):
        bufInLineBlif = os.path.join(".gate" + operator + "A=" + input1 + " Y=" + output + "_" + searchObjBufAssign.group(3))
        fout.write(bufInLineBlif)
        fout.write('\n')
        bufInLineEqn = os.path.join(output + "_" + searchObjBufAssign.group(3) + " = " + operatorEqn + input1 + dummyVar + ";")
        fout1.write(bufInLineEqn)
        fout1.write('\n')
    elif inputHighVec and (not(outputHighVec)) and (not(outputLowVec)) and (not(inputLowVec)):
        if "'b" in str(input1):
            bufInLineBlif = os.path.join(".gate" + operator + "A=" + searchObjBufAssign.group(9) + " Y=" + output)
            bufInLineEqn  = os.path.join(output + " = " + operatorEqn + searchObjBufAssign.group(9) + dummyVar + ";")
        else:
            bufInLineBlif = os.path.join(".gate" + operator + "A=" + input1 + "_" + searchObjBufAssign.group(9) + " Y=" + output)
            bufInLineEqn  = os.path.join(output + " = " + operatorEqn + input1 + "_" + searchObjBufAssign.group(9) + dummyVar + ";")
        fout.write(bufInLineBlif)
        fout.write('\n')
        fout1.write(bufInLineEqn)
        fout1.write('\n')
    elif (not(outputHighVec)) and (not(outputLowVec)) and (not(inputLowVec)) and (not(inputHighVec)):
        loopRange     = int(wireDict [output][0]) + 1
        rangeStartIn  = int(wireDict [output][1])
        rangeStartOut = int(wireDict [input1][1])
        for m in range(rangeStartIn, loopRange):
            bufInLineBlif = os.path.join(".gate" + operator + "A=" + input1 + "_" + str(rangeStartOut) + " Y=" + output + "_" + str(rangeStartIn) )
            fout.write(bufInLineBlif)
            fout.write('\n')
            bufInLineEqn = os.path.join(output + "_" + str(rangeStartIn) + " = " + operatorEqn + input1 + "_" + str(rangeStartOut) + dummyVar + ";")
            fout1.write(bufInLineEqn)
            fout1.write('\n')
            rangeStartOut = rangeStartOut + 1
            rangeStartIn  = rangeStartIn + 1

def return_operator(operation):
    return{
        '&': 'AND2X1',
        '|': 'OR2X1',
        '^': 'XOR2X1',
     }.get(operation, None)

def return_eqn_operator(operation):
    return{
        '&': '*',
        '|': '+',
        '^': '!=',
        '~': '!',
     }.get(operation, None)

#main function call
blif_write()

