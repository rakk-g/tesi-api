## -*- texinfo -*-
## Capiamo la situazione reale in relazione alle affermazioni degli autori.
##
## Prende: niente
##
## Come funziona:
## - per le c.i. si cicla la popTot, viene scelta random la frazione per ogni comparto.
## - si esplora lo spazio parametrico in w ed m.
##
## For each simulation, format is # t, H, F.
## Put aggregated data in a separated file, calculated values and additional data:
## - parameters w, L, alpha, sigma, m
## -  alpha - L/w (existence and stability)
## -  m_1^*, m_2^* and m_3^*
## -  initial total population
## -  final total population
## -  FDOD: First Day of Death
## -  FDOO: First Day of Over # TODO scegliere
##
## Salva un file nominato uniquely each time.
##

# number of simulations (resolution on m)
N = 12 ;
# number of c.i. for each simulation
Nci = 12 ;
# number of cycles on w
Nwc = 12 ;
# number of cycles on total population
Npop = 6 ;
# number of days to run per each simulations
nDays= 2* 365;
# threshold for First Day of Death (of the colony)
fdodThres = 20;


# condizioni iniziali: random, scelgo solo la pop.
popMin = 15    ;
popMax = 9000 ;
mMin   = 0.016 ;
mMax   = 0.7   ; # WARNING
wMin   = 3000  ;
wMax   = 30000 ;


# FIXED parameters
L=2000 ;
alpha=0.25 ;
sigma=0.75 ;

# these I can set right now
g = @(y) [ y(1)+y(2) ] ;
R = @(y) [ alpha-sigma*( y(2)/g(y) ) ] ; # recruitment

prefix= "output/";
fbileName = "kh11ExpA2-AGGR.dat" ;
fbile = fopen( [prefix, fbileName], "w" );
fprintf( fbile, "# w, L, alpha, sigma, m, lhs(cond6b), m1*, m2*, m3*, initial pop., final pop., FDOD, FDOO \n" );

printf("Processing...\n");
tic();

for in = 0:N
  # set m
  m= mMin + (in/N)*(mMax -mMin) ;

    for iw=0:Nwc
      # set w
      w = wMin + (iw/Nwc)*(wMax-wMin) ;
      E = @(y) [ L*g(y)/( w + g(y) ) ] ;  # eclosion

      for p=0:Npop
        popTot = popMin + (p/Npop)*(popMax-popMin) ;

        df = @(t,y) [ (E(y) - y(1)*R(y)) ; (y(1)*R(y) -m*y(2)) ] ;

        cas = rand() ;
        x0= popTot*cas ;
        y0= popTot*(1-cas) ;

        [t,y] = ode45(df, [0:1:nDays], [x0, y0]);
        res = [t,y];

        faileName = sprintf( "kh11ExpA2-%f.dat", now() );
        faileName = [ prefix, faileName ];
        faile = fopen( faileName, "w" );
        fprintf( faile, "# t, H, F, E, R\n");
        # init. for aggregate calculations
        fdod = Inf;
        fdoo = Inf;
        for ir=1:size( res, 1 )
          # t, H, F

          # now I add E and R
          eV = E( res(ir, 2:3) );
          rV = R( res(ir, 2:3) );
          fprintf( faile, "%f \t %f \t %f \t %f \t %f \n", [ res(ir, :), eV, rV ] );

          # aggr. calculations
          if ( res(ir,2)+res(ir,3)<fdodThres ) && ( res(ir,1) < fdod )
            fdod = res(ir,1);
          endif
          if ( eV - rV * res(ir:2) < 0 ) && ( res(ir,1) < fdoo )
            fdoo = res(ir,1);
          endif
        endfor
        fclose(faile);

        ## calculate nice values and put in aggregate datafile
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
        fprintf( fbile, "%f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \t %f \n",
            [ w, L, alpha, sigma, m, cond6bVal, m1Star, m2Star, m3Star, initialPop, finalPop, fdod, fdoo ] );
      endfor # popTot
  endfor # w
endfor # m
fclose(fbile);

toc()
