#!/bin/bash

# only works for 2X1 gates (perhaps add more gates in gate list) and A,B(IN) Y(OUT) attr names

filename=$1
idx=0

# check how many kinds of gates:
# grep .gate $filename | sort -u -k 2

names=("NAND" "AND" "NOR" "OR" "XOR")

for gate in "nand" "and" "nor" "or" "xor"; do
	grep -w "${names[${idx}]}2X1" $filename |& tee ${gate}.blif.tmp
	cut -d " " -f 3- ${gate}.blif.tmp | sed 's/\s*A=/ /' | sed 's/\sB=/ /' | sed 's/\sY=/ /'  > ${gate}.tmp
	while read in1 in2 out
	do
		echo "$out = ${names[${idx}]}($in1,$in2)" >> ${filename}.bench
	done <${gate}.tmp
	idx=`expr ${idx} + 1`
done

grep INV $filename |& tee inv.blif.tmp
cut -d " " -f 3- inv.blif.tmp | sed 's/\s*A=/ /' | sed 's/\sY=/ /' > inv.tmp
while read in out
do
	echo "$out = NOT($in)" >> ${filename}.bench
done <inv.tmp

grep BUF $filename |& tee buf.blif.tmp
cut -d " " -f 3- buf.blif.tmp | sed 's/\s*A=/ /' | sed 's/\sY=/ /' > buf.tmp
while read in out
do
	echo "$out = BUF($in)" >> ${filename}.bench
done <buf.tmp
\rm *.tmp
