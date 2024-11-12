""" Parser per i dati sputati dalle simulazioni fatte con khoury2011.m

    Poi ci calcola
"""

from math import sqrt
import os

class simulation():

    def __init__( self ):
        # params
        self.w = -1
        self.L = -1
        self.alpha = -1
        self.sigma = -1
        self.m = -1

    def R( self, t, H, F ):
        """ Recruitment

            Useful for calculating Age of Onset of Precocious Foraging
        """
        return ( self.alpha - self.sigma*F/(H+F) )

    def E( self, t, H, F ):
        """ Eclosion """
        return self.L*( (H+F)/( self.w+H+F) )

    def cond6b( self ):
        return ( self.alpha - self.L/self.w > 0 ) and 1 or 0

    def cond6a( self ):
        num = self.alpha + self.sigma +sqrt( (self.alpha - self.sigma)**2 + 4*self.L*self.sigma/self.w )
        den = self.alpha - self.L/self.w
        fact = self.L /(2*self.w)
        return ( self.m < fact * num / den ) and 1 or 0


    def processRow( self, r ):
        """ r contains t, H, F
            of one simulation. It is a vector of strings.

            Adds to the right end:
            - R recruitment
            - 1 or 0, if it verifies condition (6a)
            - 1 or 0, if it verifies conditio (6b)
            -
        """

        # print("row: ", r)

        # keep trace if I have params or not

        if not r: # empty line
            return False

        elif r[1] == 'parameters:' : # set parameters
            self.w = float( r[2] )
            self.L = float( r[3] )
            self.alpha = float( r[4] )
            self.sigma = float( r[5] )
            self.m = float( r[6] )
            print ("Parameters set.")
            # print( self.w, self.L, self.alpha, self.sigma, self.m)
            return False

        elif r[0] == '#' : # another comment w/o parameters
            return False

        else: # it contains a line of data: t, H, F and parameters are set (we hope)
            [t, H, F ] = [ float( a ) for a in r ]
            if ( H <= 0 or F <= 0 ):
                return False

            # print( t, H, F )
            # print("deve ser pos: %f" % ((self.alpha-self.sigma)**2 + 4*self.L*self.sigma/self.w ) )
            newData = [ t, H, F, \
                self.E( t, H, F ), \
                self.R( t, H, F ), \
                self.cond6a(  ), \
                self.cond6b(  )
            ]
            # print("row ending, return: ", newData)
            return newData
        # processRow END.


    def parseFile ( self, path ):
        """ Parsa il file e produce un analogo con tutti i numerelli ben calcolati per graficare
        """

        faile = open( path, 'r' )
        li = path.split('.')
        outPath = '.'.join(li[:-1]) + '.clean.' + li[-1]
        fbile = open ( outPath, 'w' )
        fbile.write("# t H F E R cond6a cond6b w L alpha sigma m\n")

        while( True ):
            s = faile.readline()
            if not s:
                print("readline: break")
                break
            # else we split here since file mostly contains data
            r = s.split()
            try:
                prr = self.processRow( r )
            except ZeroDivisionError:
                # I think R fails because H+F=0, we stop processing the file
                break

            if prr:
                # print("prr: ", type(prr), prr )
                paramz = [ self.w, self.L, self.alpha, self.sigma, self.m ]
                # print("paramz: ", type(paramz), paramz )
                prr.extend( paramz )
                # writeThis = tuple( writeThis )
                # print( prr )
                fbile.write("%f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \n" % tuple(prr) )
                # input()

        # print("closing files.")
        faile.close()
        fbile.close()
        #make clean
        os.remove( path )
        return


# aka MAIN()
directory_path = "output"
# Itera su tutti gli elementi nella directory
for filename in os.listdir(directory_path):
    file_path = os.path.join(directory_path, filename)

    if os.path.isfile(file_path) and filename.endswith(".dat"): # WARNING non distingue .clean
        simu = simulation()
        print("processing ", filename)
        simu.parseFile( file_path )











