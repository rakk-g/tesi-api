## -*- texinfo -*-
## Capiamo la situazione reale in relazione alle affermazioni degli autori.
##
## Prende: niente
##
## Come funziona:
## - le c.i. si cicla la popTot, viene scelta random la frazione per ogni comparto.
## - si esplora lo spazio parametrico in w ed m.
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
N = 36 ;
# number of c.i. for each simulation
Nci = 24 ;
# number of cycles on w
Nwc = 12 ;
# number of cycles on total population
Npop = 6 ;
# number of days to run per each simulations
nDays= 365;


# condizioni iniziali: random, scelgo solo la pop.
popMin = 4     ;
popMax = 15000 ;
mMin   = 0.006 ;
mMax   = 0.8  ;
wMin   = 3000  ;
wMax   = 30000 :


# FIXED parameters
L=2500 ;
alpha=0.25 ;
sigma=0.75 ;


g = @(y) ( y(1)+y(2) );
for in = 0:N
  # set m
  m= mMin + (in/N)*(mMax -mMin) ;

    for iw=0:Nwc
      # set w
      w = wMin + (iw/Nwc)*(wMax-wMin) ;

      for p=0:Npop
        popTot = popMin + (p/Npop)*(popMax-popMin) ;

        df = @(t,y) [ ( L*g(y)/( w + g(y) ) - y(1)*(alpha -sigma*( y(2)/g(y) ) ) ) ;
        ( y(1)*(alpha -sigma*( y(2)/g(y) ) ) -m*y(2) ) ] ;

        cas = rand();
        x0=(xmax-xmin)*cas +xmin ;
        y0=(ymax-ymin)*(1-cas) +ymin ;
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

        printf( faile, "%f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \n",
            [ w, L, alpha, sigma, m, cond6bVal, m1Star, m2Star, m3Star, initialPop, finalPop ] );

        fclose(faile);
      endfor # popTot
  endfor # w
endfor # m

