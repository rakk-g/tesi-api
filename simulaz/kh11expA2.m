## -*- texinfo -*-
## Capiamo la situazione reale in relazione alle affermazioni degli autori.
##
## Prende: niente
##
## Come funziona:
## - le c.i. sono scelte sempre da una UNIFORME su [xmin, xmax] e analog. su y.
## - si esplora lo spazio parametrico SOLO in m, cogli altri valori tenuti costanti.
##
## For each simulation, format is # t, H, F.
## Adds a terminating line with parameters, calculated values and additional data:
## - parameters w, L, alpha, sigma, m
## -  alpha - L/w (existence and stability)
## -  m_1^*, m_2^* and m_3^*
## -  initial total population
## -  final total population
##
## Salva un file nominato uniquely each time.
##

# number of simulations (resolution on m)
N = 73;
# number of c.i. for each simulation
Nci = 400;
# number of days to run per each simulations
nDays= 900;


# UNIFORM SPACE for initial conditions
xmin=1;
xmax=12000;
ymin=1;
ymax=6000;

# parameters
w=27000 ;
L=2500 ;
alpha=0.25 ;
sigma=0.75 ;
mMin= 0.006 ;
mMax= 0.85  ;

g = @(y) ( y(1)+y(2) );
for in = 0:N
    # set m
    m= mMin + (in/N)*(mMax -mMin)

    df = @(t,y) [ ( L*g(y)/( w + g(y) ) - y(1)*(alpha -sigma*( y(2)/g(y) ) ) ) ;
    ( y(1)*(alpha -sigma*( y(2)/g(y) ) ) -m*y(2) ) ] ;

  for cix = 1:Nci
    x0=(xmax-xmin)*rand() +xmin ;
    y0=(ymax-ymin)*rand() +ymin ;
    [t,y] = ode45(df, [0:1:nDays], [x0, y0]);
    res = [t,y];

    prefix= "output/";
    faileName = sprintf( "kh11ExpA2-%f.dat", now() );
    faileName = [ prefix, faileName ];
    faile = fopen( faileName, "w" );
    fprintf( faile, "# t, H, F\n");
    # fprintf( faile, "# parameters: %f \t %f \t %f \t %f \t %f\n", w, L, alpha, sigma, m );
    for ir=1:size( res, 1 )
      fprintf( faile, "%f \t %f \t %f \n", res(ir, :) );
    endfor
    ## terminating line with parameters, calculated values and additional data:
    fprintf( faile, "\n" );
    fprintf( faile, "# w, L, alpha, sigma, m, lhs(cond6b), m1*, m2*, m3*, initial pop., final pop.\n" );
    cond6bVal = alpha - L/w;
    mStarFac = L/(2*w);
    mStarRad = (alpha - sigma)^2 +4 * sigma * L / w;
    m1 = mStarFac* ( alpha + sigma - sqrt( mStarRad ) ) / cond6bVal;
    m2 = mStarFac* ( alpha + sigma + sqrt( mStarRad ) ) / cond6bVal;
    m1Star = min( m1, m2 );
    m2Star = max( m1, m2 );
    m3Star = sigma*L / (w*(alpha+sigma));
    initialPop = res( 1 , 2 ) + res( 1 , 3 );
    finalPop = res( size(res,1) , 2 ) + res( size(res,1) , 3 );
    fprintf( faile, "%f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \n",
        [ w, L, alpha, sigma, m, cond6bVal, m1Star, m2Star, m3Star, initialPop, finalPop ] );
    fclose(faile);
  endfor

endfor

