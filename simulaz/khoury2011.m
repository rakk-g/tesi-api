## -*- texinfo -*-
## Provo a ripercorrere i passi della loro ricerca.
## Esperimento self-contained con octave.
##
## Prende: niente
##
## Come funziona:
## - le c.i. sono scelte sempre da una UNIFORME su [xmin, xmax] e analog. su y.
## - si itera un numero N di volte scegliendo da una normale per ogni parametro
##   per quanto riguarda w, L, alpha, sigma e m.
##
## Salva un file nominato uniquely each time.
##

# number of simulations (different parameters)
N = 200;
# number of c.i. for each simulation
Nci = 10
# number of days to run per each simulations
nDays= 300;


# UNIFORM SPACE for initial conditions
xmin=0;
xmax=15000;
ymin=0;
ymax=6000;

# GAUSSIAN for parameters
# values given represent mu (mean)
# you have to give sigma (variance)
normalVarianceFraction = 0.2333;
# NormalSigma is this fraction times the following (each)
param_mu= [
  w=27000 ;
  L=2500 ;
  alpha=0.25 ;
  sigma=0.75 ;
  m=0.4 ;
]

g = @(y) ( y(1)+y(2) );
for in = 1:N
#   extracting parameter values
  p = param_mu + ( normalVarianceFraction*param_mu .* randn( size(param_mu, 1), 1 ) );
#   and clipping
  p = max( p, eps );

  w = p(1) ;
  L = p(2) ;
  alpha = p(3) ;
  sigma = p(4) ;
  m = p(5) ;
  df = @(t,y) [ ( L*g(y)/( w + g(y) ) - y(1)*(alpha -sigma*( y(2)/g(y) ) ) ) ;
    ( y(1)*(alpha -sigma*( y(2)/g(y) ) ) -m*y(2) ) ] ;

  for cix = 1:Nci
    x0=(xmax-xmin)*rand() +xmin;
    y0=(ymax-ymin)*rand() +ymin;
    [t,y] = ode45(df, [0:1:nDays], [x0, y0]);
    res = [t,y];

    prefix= "output/";
    faileName = sprintf( "khoury2011-%f.dat", now() );
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

