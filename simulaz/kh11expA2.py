""" Combina tutti i dataoutput di una serie di simulazioni kh11expA2.m
    mette insieme l'ultima riga da ognuno
"""

import os

output_path = "output/expA2aggr.dat"
input_dir = "handSelectedOutput/output_expA2"

fo = open( output_path, 'w' )

nFiles = 0
# print( "Extraction: ", end='' )
for fiName in os.listdir( input_dir ):
    with open( input_dir + os.sep + fiName, 'r' ) as fi:
        for line in fi:
            pass
        lastLine = line
        fi.close()
    fo.write( lastLine )
    # print( '.', end='', flush=True )
    nFiles = nFiles + 1
fo.close()
print( "\n%d files processed.", nFiles )


