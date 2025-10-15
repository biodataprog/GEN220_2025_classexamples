#!/usr/bin/env python3
import itertools
import sys
import re

# based on post here
# https://drj11.wordpress.com/2010/02/22/python-getting-fasta-with-itertools-groupby/

# define what a header looks like in FASTA format
def isheader(line):
    return line[0] == '>'


# this function reads in fasta file and returns pairs of data
# where the first item is the ID and the second is the sequence
# it isn't that efficient as it reads it all into memory
# but this is good enough for our project
def aspairs(filename):
    seq_id = ''
    sequence = ''
    with open(filename,"r") as f:
        for header,group in itertools.groupby(f, isheader):
            if header:
                line = next(group)
                seq_id = line[1:].split()[0]
            else:
                sequence = ''.join(line.strip() for line in group)
                yield seq_id, sequence

inputfile="E_coli_K12.pep"
protseqs = aspairs(inputfile)

numprots = 0
AA_counts = {}
for p in protseqs:
    numprots +=1
    pepid = p[0]
    pepseq = p[1]
    # loop through all the letters in this sequence
    for aa in pepseq:
        count = 1 + AA_counts.get(aa,0)
        AA_counts[aa] = count
total_len = sum(AA_counts.values())
print(f'There are {numprots} proteins')
print(AA_counts,"\n",total_len)
for aa in sorted(AA_counts):
    fraction = AA_counts[aa] / total_len
    print(f'{aa}\t{100*fraction:6.3f}%')

print("now sorted by most frequent AA")
for aa in sorted(AA_counts,reverse=True,key=lambda x: AA_counts[x]):
    print(f'{aa}\t{100*AA_counts[aa]/total_len:6.3f}%')


