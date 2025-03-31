# Graphing utility for experiment C, the one studying "weak" and "strong" colonies.
#   columns in datafile are:
#   initialPop, finalPop, m, firstDayWeak, firstDayStrong

# use a good driver and medium widescreen resolution
set terminal pngcairo size 1366,768
# where aggregate data is located
fName="output/kh11ExpC.dat" # WARNING there is a separate file for bins (see 2.)
# adjust these thresholds as in the .m file
Nplus=40000
Nminus=1000
# these draw distances (on various axes) are used in a number of things.
minInitPop = 100
maxInitPop = 42000
minFinalPop = 10
maxFinalPop = 250000
Tdays=720


# 1. - Final population vs. initial population.
#      Dashed lines mark the "weak" and "strong" region in both axes.
#      Color is governed by mortality
set output "k11EC-finalPop-initPop.png"
unset key
set xlabel "Initial population"
set xrange [minInitPop:maxInitPop]
set logscale y
set ylabel "Final population"
set yrange [minFinalPop:maxFinalPop]
# show weak/strong limits on both axes
set arrow from Nminus,minFinalPop to Nminus,maxFinalPop nohead dashtype 2 linecolor "black" # weak threshold on horizontal axis
set arrow from Nplus,minFinalPop  to Nplus,maxFinalPop  nohead dashtype 2 linecolor "black" # strong threshold on horizontal axis
set arrow from minInitPop,Nminus to maxInitPop,Nminus  nohead dashtype 2 linecolor "black" # weak threshold on vertical axis
set arrow from minInitPop,Nplus  to maxInitPop,Nplus   nohead dashtype 2 linecolor "black" # strong threshold on vertical axis
set palette defined (0 "green", 0.5 "blue", 1 "red") # this is good for mortality
set cblabel "m"
plot fName using 1:2:3 with points pointtype 7 linecolor palette


# 2. - Istogrammi
#      Colonie che iniziano deboli/medie/strong e finiscono corrispondentemente
reset
set key right top
set output "k11EC-bins.png"
bs = 0.2 # boxsize (horiz.)
# TODO WARNING aggiustare diocane
set yrange [0:1]
set title "invertire iniz/fine!"
set style line 1 lc rgb 'red' lt 1 lw 2 # deboli rosse
set style line 2 lc rgb 'blue' lt 1 lw 2 # medie blu
set style line 3 lc rgb 'green' lt 1 lw 2 # forti verdi
set xtics nomirror out ('Deboli (fine)' 0,'Medie (fine)' 1, 'Forti (fine)' 2)
unset ytics # tanto mostro le percentuali sulle barre (v. trucco sotto: '%%' fa escape e ritorna il % carattere)
set style fill solid 0.7 border rgb 'grey30'
plot "output/kh11ExpCbis.dat" index 0 using ($0-bs):1:(bs) title 'Deboli (inizio)' with boxes linestyle 1, \
'' index 0 using ($0-bs):1:(sprintf("%1.0f%%", ($1)*100)) with labels offset 0,1 notitle, \
'' index 1 using 0:1:(bs) title 'Medie (inizio)' with boxes linestyle 2, \
'' index 1 using 0:1:(sprintf("%1.0f%%", ($1)*100)) with labels offset 0,1 notitle, \
'' index 2 using ($0+bs):1:(bs) title 'Forti (inizio)' with boxes linestyle 3, \
'' index 2 using ($0+bs):1:(sprintf("%1.0f%%", ($1)*100)) with labels offset 0,1 notitle


# 3. - FDW (first day weak) vs Initial population
#      Dashed lines mark the "weak" and "strong" region in x.
#      Color is governed by mortality
reset
set output "k11EC-fdw-initPop.png"
unset key
set xlabel "Initial population"
set xrange [minInitPop:maxInitPop]
set arrow from Nminus,minFinalPop to Nminus,maxFinalPop nohead dashtype 2 linecolor "black" # weak threshold on horizontal axis
set arrow from Nplus,minFinalPop  to Nplus,maxFinalPop  nohead dashtype 2 linecolor "black" # strong threshold on horizontal axis
set ylabel "FDW [days]"
set yrange [0:*]
set palette defined (0 "green", 0.5 "blue", 1 "red") # this is good for mortality
set cblabel "m"
plot fName using 1:4:3 with points pointtype 7 linecolor palette


# 4. - FDS (first day strong) vs Initial population
#      Dashed lines mark the "weak" and "strong" region in x.
#      Color is governed by mortality
reset
set output "k11EC-fds-initPop.png"
unset key
set xlabel "Initial population"
set xrange [minInitPop:maxInitPop]
set arrow from Nminus,minFinalPop to Nminus,maxFinalPop nohead dashtype 2 linecolor "black" # weak threshold on horizontal axis
set arrow from Nplus,minFinalPop  to Nplus,maxFinalPop  nohead dashtype 2 linecolor "black" # strong threshold on horizontal axis
set ylabel "FDS [days]"
set yrange [0:*]
set palette defined (0 "green", 0.5 "blue", 1 "red") # this is good for mortality
set cblabel "m"
plot fName using 1:5:3 with points pointtype 7 linecolor palette


# 5. - FDW, FDS against mortality
#      fdw (circles) and fds (triangles)
#      Color gradient is governed by final population.
reset
set output "k11EC-fdX-m.png"
# unset key
set xlabel "m"
set xrange [0:*]
set ylabel "FDW, FDS [days]"
set yrange [1:Tdays] # NOTE così tolgo quelle che *iniziano* forti o deboli
set palette defined (0 "red", 0.5 "blue", 1 "green") # this is good for populations (inverse of mortality)
set cblabel "Final population"
set arrow from 0.08,1 to 0.08,Tdays nohead dashtype 2 linecolor "black" #m1
set arrow from 0.508,1 to 0.508,Tdays nohead dashtype 2 linecolor "black" #m2
plot fName using 3:4:2 with points pointtype 7 linecolor palette title "FDW", \
'' using 3:5:2 with points pointtype 9 linecolor palette title "FDS", \
