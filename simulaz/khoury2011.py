""" Parser per i dati sputati dalle simulazioni fatte con khoury2011.m

    Poi ci calcola
"""

from math import sqrt

# params
w = -1
L = -1
alpha = -1
sigma = -1
m = -1

def R( t, H, F ):
    """ Recruitment

        Useful for calculating Age of Onset of Precocious Foraging
    """
    return alpha - sigma*F/(H+F)

def E( t, H, F ):
    """ Eclosion """
    return L*( (H+F)/(w+H+F) )

def cond6b( t, H, F ):
    return ( alpha - L/w > 0 )

def cond6a( t, H, F ):
    num = alpha + sigma +sqrt( (alpha-sigma)**2 + 4*L*sigma/w )
    den = alpha - L/w
    fact = L /(2*w)
    return ( m < fact * num / den )



def calculateFromParams( t, H, F ):
    pass


def processRow( r ):
    """ r contains t, H, F
        of one simulation. It is a vector of strings.

        Adds to the right end:
        - R recruitment
        - 1 or 0, if it verifies condition (6a)
        - 1 or 0, if it verifies conditio (6b)
        -
    """

    # keep trace if I have params or not

    if not r: # empty line
        return False

    elif r[1] == 'parameters:' : # set parameters
        w = float( r[2] )
        L = float( r[3] )
        alpha = float( r[4] )
        sigma = float( r[5] )
        m = float( r[6] )
        print ("Parameters set.")
        print( w, L, alpha, sigma, m)
        print("deve ser pos: %f" % ((alpha-sigma)**2 + 4*L*sigma/w ) )
        return False

    elif r[0] == '#' : # another comment w/o parameters
        return False

    else: # it contains a line of data: t, H, F and parameters are set (we hope)
        [t, H, F ] = [ float( a ) for a in r ]
        print("deve ser pos: %f" % ((alpha-sigma)**2 + 4*L*sigma/w ) )
        newData = [ t, H, F, \
            E( t, H, F ), \
            R( t, H, F ), \
            cond6a( t, H, F ), \
            cond6b( t, H, F )
        ]
        return newData
    # processRow END.


def parseFile ( path ):
    """ Parsa il file e produce un analogo con tutti i numerelli ben calcolati per graficare
    """

    faile = open( path, 'r' )

    while( True ):
        s = faile.readline()
        if not s:
            break
        r = s.split()
        prr = processRow( r )
        print("old row: %s" % s)
        print("new row: ", prr)
        input()
    faile.close()



# aka MAIN()
parseFile( "output/khoury2011-739561.335199.dat" )
