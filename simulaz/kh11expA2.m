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
## -  FDOO: First Day of Over-recruitment
##
## Uncomment faile lines to have a file uniquely named for each simulation also
## WARNING this code is highly inefficient.

# WARNING trigger for alternative simulation (with variable mortality)
#   false: vanilla version
#   true: skip vanilla and execute alternative version
vmTrigger = false
# number of iterations on m (resolution on m)
# m is no more random, it is equispaced
N = 16 ;
# number of c.i. for each simulation
Nci = 16 ;
# number of cycles on w (resolution on w)
Nwc = 12 ;
# number of days to run per each simulations
nDays= 2* 365.25; # be careful as this heavily impacts computation time
# threshold for First Day of Death (of the colony)
fdodThres = 30;


# condizioni iniziali: random, scelgo solo la pop.
popMin = 50    ;
popMax = 9000  ;
mMin   = 0.016 ;
mMax   = 0.7   ; # WARNING
wMin   = 3000  ;
wMax   = 30000 ;


# FIXED parameters
L=2000 ; # egg-laying rate for the queen
alpha=0.25 ; #
sigma=0.75 ; #

# I can set these right now
g = @(y) [ y(1)+y(2) ] ; # sum (handle)
R = @(y) [ alpha-sigma*( y(2)/g(y) ) ] ; # recruitment

prefix= "output/";
fbileName = "kh11ExpA2-AGGR.dat" ;
fbile = fopen( [prefix, fbileName], "w" );
fprintf( fbile, "# w, L, alpha, sigma, m, lhs(cond6b), m1*, m2*, m3*, initial pop., final pop., FDOD, FDOO \n" );

printf("Processing...\n");
tic();

for in = 0:N
  if (vmTrigger)
    break
  endif
  printf("Vanilla version.\n")
  # set m evenly spaced
  m= mMin + (in/N)*(mMax -mMin) ;

    for iw=0:Nwc
      for p=0:Nci
        # set w u.r.c.
        w = wMin + rand()*(wMax-wMin) ;
        # set initial population u.r.c.
        popTot = popMin + rand()*(popMax-popMin) ;
        # distribute u.r. initial population
        cas = rand() ;
        x0= popTot*cas ;
        y0= popTot*(1-cas) ;
        # create function handle
        E = @(y) [ L*g(y)/( w + g(y) ) ] ;  # eclosion
        df = @(t,y) [ (E(y) - y(1)*R(y)) ; (y(1)*R(y) -m*y(2)) ] ;

        [t,y] = ode45(df, [0:1:nDays], [x0, y0]);
        res = [t,y];

        # init. for aggregate calculations
        # WARNING use appropriate caution when plotting
        fdod = Inf;
        fdoo = Inf;
        for ir=1:size( res, 1 ) # cycle over time
          # now calculate E and R at current time
          # res(i) is a vector with t, H(t) and F(t).
          eV = E( res(ir, 2:3) );
          rV = R( res(ir, 2:3) );
          # add these at the end of the line
          # fprintf( faile, "%f \t %f \t %f \t %f \t %f \n", [ res(ir, :), eV, rV ] );

          # aggr. calculations
          if ( res(ir,2)+res(ir,3)<fdodThres ) && ( res(ir,1) < fdod )
            fdod = res(ir,1); # found new potential First Day of (colony) Death
          endif
          if ( eV - rV * res(ir:2) < 0 ) && ( res(ir,1) < fdoo )
            # this is the first day that dH/dt is negative
            # WARNING this has multiple causing factors: disease, too high pop., etc.
            fdoo = res(ir,1);
          endif
        endfor
        # fclose(faile);
        # this one simulation finished.

        # calculate nice values and put in aggregate datafile
        # first 5 columns: model parameters for each simulation
        # successive columns: calculated values from parameters and simulation:
        #   condition (6b) is satisfied or not (derived from parameters)
        #   m_i^* values for existence theorem (derived from parameters)
        #   initial population  (initial conditions)
        #   final population (simulation)
        #   FDOD, FDOO (simulation)
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
# all simulations finished.
fclose(fbile);

## WARNING ALTERNATIVE VERSION (triggered above)
## This alternative version of the script implements a variable mortality experiments.
## TODO ci starebbe forse di metterlo nel .tex prima della versione vanilla?
##
##    mortA(t): a step function that jumps from mortLo and MortHi at t=tMortA
if (vmTrigger)
  printf("Alternative version.\n");

  mortLo = 0.15;
  mortHi = 0.55;
  tMortA = 300; # this is really the median point of the impulse in A, B, C, and double the start of D.
  # mortality: step
  mortA = @(t) [ mortLo + (mortHi-mortLo)*(t>tMortA) ];
  # mortality: sawtooth
  tSpanB = 50; # this is the amplitude of the impulse in B, C and the wavelength in D
  mortB = @(t) [ mortLo + (mortHi-mortLo)*( abs(t-tMortA)<tSpanB )*( 1- abs( (t-tMortA)/tSpanB ) ) ];
  # mortality: gaussian
  mortC = @(t) [ mortLo + (mortHi-mortLo)*exp(-( (2*(t-tMortA)/tSpanB)^2 )) ];

  # mortality: sinusoidal, but is low before t=tMortA/2
  lambdaD = tSpanB;
  lowScale = 0.09;
  hiScale = 1.31;
  mortD = @(t) [ mortLo + (t>tMortA/2)*max(0,lowScale*(mortHi-mortLo)*0.5*( 1+ sin( (t-tMortA)*2*pi/tSpanB- pi/2 ) )) ];
  mortE = @(t) [ mortLo + (t>tMortA/2)*max(0,hiScale*(mortHi-mortLo)*0.5*( 1+ sin( (t-tMortA)*2*pi/tSpanB- pi/2 ) )) ];

  # WARNING globals override
  nDays = 2.5*tMortA;
  w = 25000;
  x0= 10000;
  y0= 4000;
  # BEGIN: code stolen from vanilla
  E = @(y) [ L*g(y)/( w + g(y) ) ] ;  # eclosion
  dfA = @(t,y) [ (E(y) - y(1)*R(y)) ; (y(1)*R(y) -mortA(t)*y(2)) ] ;
  dfB = @(t,y) [ (E(y) - y(1)*R(y)) ; (y(1)*R(y) -mortB(t)*y(2)) ] ;
  dfC = @(t,y) [ (E(y) - y(1)*R(y)) ; (y(1)*R(y) -mortC(t)*y(2)) ] ;
  dfD = @(t,y) [ (E(y) - y(1)*R(y)) ; (y(1)*R(y) -mortD(t)*y(2)) ] ;
  dfDbase = @(t,y) [ (E(y) - y(1)*R(y)) ; (y(1)*R(y) -mortLo*y(2)) ] ;
  dfE = @(t,y) [ (E(y) - y(1)*R(y)) ; (y(1)*R(y) -mortE(t)*y(2)) ] ;

  [t,y] = ode45(dfA, [0:1:nDays], [x0, y0]); resA=[t,y];
  [t,y] = ode45(dfB, [0:1:nDays], [x0, y0]); resB = [t,y];
  [t,y] = ode45(dfC, [0:1:nDays], [x0, y0]); resC = [t,y];
  [t,y] = ode45(dfD, [0:1:nDays], [x0, y0]); resD = [t,y];
  [t,y] = ode45(dfDbase, [0:1:nDays], [x0, y0]); resDbase = [t,y];
  [t,y] = ode45(dfE, [0:1:nDays], [x0, y0]); resE = [t,y];
  # END: code stolen from vanilla
  fcAile = fopen( [prefix, "alternativeA.dat"], "w" );
  fprintf( fcAile, "# t, \t H, \t F, \t m\n" );
  fcBile = fopen( [prefix, "alternativeB.dat"], "w" );
  fprintf( fcBile, "# t, \t H, \t F, \t m\n" );
  fcCile = fopen( [prefix, "alternativeC.dat"], "w" );
  fprintf( fcCile, "# t, \t H, \t F, \t m\n" );
  fcDile = fopen( [prefix, "alternativeD.dat"], "w" );
  fprintf( fcDile, "# t, \t H, \t F, \t m\n" );
  fcDBile = fopen( [prefix, "alternativeDbase.dat"], "w" );
  fprintf( fcDBile, "# t, \t H, \t F, \t m\n" );
  fcEile = fopen( [prefix, "alternativeE.dat"], "w" );
  fprintf( fcEile, "# t, \t H, \t F, \t m\n" );
  for ir=1:size( resA, 1 ) # cycle over time
    fprintf( fcAile, "%f \t %f \t %f \t %f\n", [ resA(ir, :), mortA( resA(ir,1) ) ] );
  endfor
  fclose(fcAile);
  for ir=1:size( resB, 1 ) # cycle over time
    fprintf( fcBile, "%f \t %f \t %f \t %f\n", [ resB(ir, :), mortB( resB(ir,1) ) ] );
  endfor
  fclose(fcBile);
  for ir=1:size( resC, 1 ) # cycle over time
    fprintf( fcCile, "%f \t %f \t %f \t %f\n", [ resC(ir, :), mortC( resC(ir,1) ) ] );
  endfor
  fclose(fcCile);
  for ir=1:size( resD, 1 ) # cycle over time
    fprintf( fcDile, "%f \t %f \t %f \t %f\n", [ resD(ir, :), mortD( resD(ir,1) ) ] );
  endfor
  fclose(fcDile);
  for ir=1:size( resDbase, 1 ) # cycle over time
    fprintf( fcDBile, "%f \t %f \t %f \t %f\n", [ resDbase(ir, :), mortLo ] );
  endfor
  fclose(fcDBile);

  for ir=1:size( resE, 1 ) # cycle over time
    fprintf( fcEile, "%f \t %f \t %f \t %f\n", [ resE(ir, :), mortE( resE(ir,1) ) ] );
  endfor
  fclose(fcEile);

endif #alt. version







# this shows total time elapsed (CPU time)
toc()
