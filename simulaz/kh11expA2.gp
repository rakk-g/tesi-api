# # kh11expA2.gp
# With this script I want to generate all pictures from a batch simulation run
# of experiment A2. This will use both the simulation aggregate data
#
# Notes:
#   - Some function definitions are overridden in between plots, be careful.
#
# TODO: and maybe some specific simulation?

# use a good driver and medium widescreen resolution
set terminal pngcairo size 1366,768
# where aggregate data is located
aggrFname="handSelectedOutput/kh11ExpA2-AGGR.dat" # for testing purposes
# aggrFname="output/kh11ExpA2-AGGR.dat"

# can use these for fitting data
line(x) = m*x +q
parab(x) = a*x**2 +b*x +c
expo(x) = a*exp(b*x +c) +d

# first three types are customized
set style line 1 lc rgb 'blue' pt 5 ps 1.2 lw 2  # square blue
set style line 2 lc rgb '0x0A0A0F' pt 5 ps 1.2 lw 1.5 dt 2  # square black, dashed
set style line 3 lc rgb 'red' pt 5 ps 1.2 lw 2  # square red
# Everything set. Now we go with every plot.


# 1. - Volumetric and 2D display of each simulation run in the batch
#      Where we show the parameter space (randomly explored) and some data (size, color)
set output "k11EA2-parameterSpace3D.png"
unset key
set xlabel "m"
set ylabel "w"
set zlabel "b" # this is the initial population
set ytics 3000, 6000
set ztics 1000, 2000
set xrange [0:0.8]
set yrange [0:*]
set zrange [0:*]
# pointsize is governed by final population via this function
# final populations [100:100K] are mapped to
# point sizes in the range [0.2:2]
# psf(x) = 0.2 + 1.8*( exp( (x-100)/99900 ) -1)/(exp(1)-1)
# previous one was exponential and I don't like it. Below is a linear mapping
psf(x) = 0.2 + 2*(x-100)/99900
# WARNING you have to manually filter for final populations exceeding 100K
# to represent condition (6b) I draw color from an equivalent equation
set palette defined (0 "red", 0.5 "green", 1 "blue")
splot aggrFname using 5:1:10:($11<100000?psf($11):1/0):(($3)*($1)-($2)) with points \
pointtype 7 pointsize variable linecolor palette, \
'-' using 1:2:3 with lines ls 2
# Rectangle corners (x, y, z=0) for the region explored
0.16  3000  0
0.7 3000  0
0.7 30000 0
0.16 30000 0
0.16 3000  0  # Close the rectangle
e
# WARNING above 'end of datablock' is mandatory!
# now project onto the XZ plane (mortality vs. initial population)
set output "k11EA2-parameterSpace2D.png"
# Y settings are the Z from the 3D
set ylabel "b" # initial pop.
set ytics 1000, 2000
set yrange [0:*]
set cbrange [*:*]
set palette defined (0 "red", 0.5 "green", 1 "blue")
# all this stuff I had to setup again
plot aggrFname using 5:10:($11<100000?psf($11):1/0):(($3)*($1)-($2)) with points \
pointtype 7 pointsize variable linecolor palette


# 2. - FDOD contro m
#      Pointsize is now governed by initial population
reset
unset key
fit [0.35:1] [0:800] line(x) aggrFname using 5:12 via m, q
set xlabel "m"
set title "First Day Of (colony) Death against mortality."
set ylabel "FDOD [days]"
set ytics 100,100
set yrange [10:*]
# set logscale y
set xrange [0.324:0.7]
set output "k11EA2-fdodVSm.png"
# redefine this to be linear between our endpoints
psf(x) = 0.2 + 2*(x-50)/8050
set cbrange [*:*]
set palette defined (0 "red", 0.5 "green", 1 "blue")
plot aggrFname using 5:12:(psf($10)):(($3)*($1)-($2)) w points pointtype 7 pointsize variable linecolor palette, \
line(x) with lines linestyle 3 title "linear fit"


# 3. - Final pop. vs Initial pop.
#      Point type () is set by cond6b, while color is same as above; these are similar characteristics
#      Pointsize is set by mortality
reset
unset key
set title "Final Pop. against initial Pop."
set xrange [10:*]
set xlabel 'Initial population'
set logscale y
set yrange [10:*]
set ylabel 'Final population'
set output "k11EA2-fpopVSipop.png"
set palette defined (0 "red", 0.5 "green", 1 "blue")
# redefine this to be linear between our endpoints
psf(x) = 0.2 + 2*(x-0.016)/0.6839
plot aggrFname using 10:($6>0?$11:1/0):(psf($5)):(($3)*($1)-($2)) with points pointtype 7 pointsize variable \
linecolor palette title 'data cond6b', \
aggrFname using 10:($6<0?$11:1/0):(psf($5)):(($3)*($1)-($2)) with points pointtype 9 pointsize variable \
linecolor palette title 'data NO cond6b'


# 4. - Final Pop. contro w
#      controlling point color via the same way as above is kinda useless, as the gradient
#      varies with w horizontally. Pointsize is set by mortality now.
reset
unset key
set title "Final Population against w."
set xrange [3000:30000]
set yrange [10:100000] # c'è una linea di roba che scoppia! Ma ricalca l'andamento sotto
set xlabel 'w'
set ylabel 'Final Pop.'
# redefine this to be linear between our endpoints
psf(x) = 0.2 + 2*(x-0.016)/0.6839
set palette defined (0 "red", 0.5 "green", 1 "blue")
set output "k11EA2-finpopVSw.png"
plot aggrFname using 1:($6>0?$11:1/0):(psf($5)):(($3)*($1)-($2)) with points pointtype 7 pointsize variable \
linecolor palette title 'data cond6b', \
aggrFname using 1:($6<0?$11:1/0):(psf($5)):(($3)*($1)-($2)) with points pointtype 9 pointsize variable \
linecolor palette title 'data NO cond6b'


# 5. - m_i^* contro w (confronto tra valori calcolati e simulazioni del modello)
#      La soglia della condizione (6b) si scarica su w considerando che a-L/w>0 iff w>L/a,
#      che viene L/a = 2000/0.25 = 8000 coi nostri valori.
#      Il colore è dato dalla popolazione finale: nota che per i datapoint non si passa
#      dai colori delle soglie m_i^*.
reset
unset key
set title "m with m_1^*, m_2^* against w"
set xlabel 'w'
set ylabel "m, m_1^*, m_2^*"
set xrange[3000:*]
set yrange[0.01:2]
set logscale y
# redefine this to be linear between our endpoints
psf(x) = 0.2 + 2*(x-100)/99900
set cbrange [0:*]
set palette defined (0 "black", 0.5 "yellow", 1 "red")
set output "k11EA2-mistarVSw.png"
set arrow from 8000,0.01 to 8000,2 nohead dashtype 2 # evidenzia la soglia di 6b
plot aggrFname using 1:7 with points pointtype 7 pointsize 0.6 \
linecolor "blue" title 'm_1', \
aggrFname using 1:5:11 with points pointtype 7 pointsize 1 \
linecolor palette title 'm', \
aggrFname using 1:8 with points pointtype 7 pointsize 0.6 \
linecolor "green" title 'm_2'















