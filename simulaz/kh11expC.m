## -*- texinfo -*-
## Experiment C on the 2 compartment model
##
## Colonies are said to be "strong" when N>Nplus and
## to be "weak" when N<Nminus.

# number of simulations (resolution on m)
N = 32;
# number of c.i. for each simulation
Nci = 32;
# number of days to run per each simulations
nDays= 2*365.25;

# thresholds in total population (to design weak/strong colony)
Nplus=40000;
Nminus=1000;

# fixed parameters
w=27000 ; # vary this to obtain datasets A and B
L=2500 ;
alpha=0.25 ;
sigma=0.75 ;

# Randomly chosen parameter (mortality) and initial conditions
mMin= 0.006 ;
mMax= 0.7   ;
# give any colony equal opportunity to start as weak and as strong
# (but this isn't equal to the opportunity to be neither)
popMax= Nplus+Nminus; # this is the upper limit for initial populations

# helper
g = @(y) ( y(1)+y(2) );

prefix= "output/";
faileName = "kh11ExpC.dat";
faileName = [ prefix, faileName ];
faile = fopen( faileName, "w" );
fprintf( faile, "# initialPop, finalPop, m, firstDayWeak, firstDayStrong\n");
# a separate datafile for COUNTING transitions
fbileName = "kh11ExpCbis.dat";
fbileName = [ prefix, fbileName ];
fbile = fopen( fbileName, "w" );
# in which is written the number of colonies X2Y that start in an initial X state
# and end in an Y state at the end of the simulation.
# X and Y here read as W:weak, M:medium, S:strong.
w2w=0; w2m=0; w2s=0;
m2w=0; m2m=0; m2s=0;
s2w=0; s2m=0; s2s=0;

printf("Esperimento C.\n");
doneSim= 0;
for in = 1:N
  # I want every simulation to choose again every random parameter/initial conditions
  for cix = 1:Nci
    doneSim = doneSim + 1;
    firstDayWeak= Inf; # first day this colony is weak
    firstDayStrong= Inf; # first day this colony is strong
    # set m u.r.c.
    m= mMin + rand()*(mMax -mMin);
    # function handle for this system
    df = @(t,y) [ ( L*g(y)/( w + g(y) ) - y(1)*(alpha -sigma*( y(2)/g(y) ) ) ) ;
      ( y(1)*(alpha -sigma*( y(2)/g(y) ) ) -m*y(2) ) ] ;
    # set initial conditions u.r.c.
    ratio = rand(); # proportion of total population
    cr = rand(); # ratio between compartments
    x0 = cr*ratio*popMax;
    y0 = (1-cr)*ratio*popMax;

    # solve this system
    [t,y] = ode45(df, [0:1:nDays], [x0, y0]);
    res = [t,y];

    # calculate first day of a weak/strong colony
    for ir=1:size( res, 1 ) # cycle over time for this simulation
      # detect a weak colony
      if ( res(ir,2)+res(ir,3)<Nminus ) && ( res(ir,1) < firstDayWeak )
        firstDayWeak = res(ir,1);
      endif
      # detect a strong colony
      if ( res(ir,2)+res(ir,3)>Nplus ) && ( res(ir,1) < firstDayStrong )
        firstDayStrong = res(ir,1);
      endif
    endfor
    # calculate strong/weak combination and store appropriately
    finalTime = size( res, 1 );
    if ( res(1,2)+res(1,3)<Nminus ) # colony starts weak
      if ( res(finalTime,2)+res(finalTime,3)<Nminus ) # colony ends weak
        w2w = w2w +1;
      else
        if ( res(finalTime,2)+res(finalTime,3)>Nplus ) # colony ends strong
          w2s = w2s +1;
        else # colony ends medium
          w2m = w2m +1;
        endif
      endif
    else
      if ( res(1,2)+res(1,3)>Nplus ) # colony starts strong
        if ( res(finalTime,2)+res(finalTime,3)<Nminus ) # colony ends weak
          s2w = s2w +1;
        else
          if ( res(finalTime,2)+res(finalTime,3)>Nplus ) # colony ends strong
            s2s = s2s +1;
          else # colony ends medium
            s2m = s2m +1;
          endif
        endif
      else # colony starts medium
        if ( res(finalTime,2)+res(finalTime,3)<Nminus ) # colony ends weak
          m2w = m2w +1;
        else
          if ( res(finalTime,2)+res(finalTime,3)>Nplus ) # colony ends strong
            m2s = m2s +1;
          else # colony ends medium
            m2m = m2m +1;
          endif
        endif
      endif
    endif

    # write simulation results to file
    initPop = x0 +y0;
    finPop  = res( size(res,1) , 2 ) + res( size(res,1) , 3 );
    fprintf( faile, "%d \t %d \t %f\t %d\t %d\n", int32(initPop), int32(finPop), m, firstDayWeak, firstDayStrong );
    # done, go to the next simulation
  endfor
endfor
fclose(faile);
# write and close counters file: note the formatting for Gnuplot to use 'index' (2 empty lines between blocks)
# compute totals in each bin and rescale
totW = w2w+w2m+w2s;
w2w = w2w/totW;
w2m = w2m/totW;
w2s = w2s/totW;
totM = m2w+m2m+m2s;
m2w = m2w/totM;
m2m = m2m/totM;
m2s = m2s/totM;
totS = s2w+s2m+s2s;
s2w = s2w/totS;
s2m = s2m/totS;
s2s = s2s/totS;
# ocio! ai raggruppamenti
fprintf( fbile, "%f\n%f\n%f\n\n\n%f\n%f\n%f\n\n\n%f\n%f\n%f\n", w2w, m2w, s2w, w2m, m2m, s2m, w2s, m2s, s2s );
fclose(fbile);


printf("Finite %d simulazioni.\n", doneSim);
