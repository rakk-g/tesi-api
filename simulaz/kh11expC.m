## -*- texinfo -*-
## Vojo dimostrare che sono più preciso di loro, dioporco.
##
## Prende: niente
##
## Come funziona:
## - le c.i. sono scelte sempre da una UNIFORME su [xmin, xmax] e analog. su y.
## - si esplora lo spazio parametrico SOLO in m, cogli altri valori
##   fissati. m varia tra 0.0804 e 0.5078
##
## Salva un file nominato uniquely each time.
##

# number of simulations (resolution on m)
N = 30;
# number of c.i. for each simulation
Nci = 30;
# number of days to run per each simulations
nDays= 900;


# UNIFORM SPACE for initial conditions
xmin=1;
xmax=15000;
ymin=1;
ymax=6000;

# parameters
w=9800 ;
L=2500 ;
alpha=0.25 ;
sigma=0.75 ;
mMin= 0.006 ;
mMax= 0.6  ;

g = @(y) ( y(1)+y(2) );
for in = 0:N
    # set m
    m= mMin + (in/N)*(mMax -mMin);

    df = @(t,y) [ ( L*g(y)/( w + g(y) ) - y(1)*(alpha -sigma*( y(2)/g(y) ) ) ) ;
    ( y(1)*(alpha -sigma*( y(2)/g(y) ) ) -m*y(2) ) ] ;

  for cix = 1:Nci
    x0=(xmax-xmin)*rand() +xmin;
    y0=(ymax-ymin)*rand() +ymin;
    [t,y] = ode45(df, [0:1:nDays], [x0, y0]);
    res = [t,y];

    prefix= "output/";
    faileName = sprintf( "kh11ExpC-%f.dat", now() );
    faileName = [ prefix, faileName ];
    faile = fopen( faileName, "w" );
    fprintf( faile, "# t, H, F\n");
    fprintf( faile, "# parameters: %f \t %f \t %f \t %f \t %f\n", w, L, alpha, sigma, m );
    fprintf( faile, "\n" );

    for ir=1:size( res, 1 )
      fprintf( faile, "%f \t %f \t %f \n", res(ir, :) );
    endfor
    fclose(faile);
  endfor

endfor

