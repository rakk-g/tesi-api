set terminal pngcairo size 1366,768
unset key
aggrFname="kh11ExpA2-AGGR2.dat"

line(x) = m*x +q
parab(x) = a*x**2 +b*x +c
expo(x) = a*exp(b*x +c) +d

# set xlabel "x"
set style line 1 lc rgb 'blue' pt 5 ps 1.2 lw 2  # square
set style line 2 lc rgb '0x0A0A0F' pt 5 ps 1.2 lw 1.5 dt 2  # square, dashed
set style line 3 lc rgb 'red' pt 5 ps 1.2 lw 2  # square red


# final pop vs initial pop
set title "Final Pop. against initial Pop."
set logscale y
set xrange [10:*]
set xlabel 'Initial population'
set ylabel 'Final population'
set output "k11EA2-fpopVSipop.png"
plot aggrFname using 10:($6>0?$11:1/0) with points ls 1 title 'data cond6b', \
aggrFname using 10:($6<0?$11:1/0) with points ls 1 lc rgb 'red' title 'data NO cond6b'


# Final Pop. contro w
set title "Final Population against w."
set xrange [3000:30000]
set yrange [*:100000] # c'è una linea di roba che scoppia! Ma ricalca l'andamento sotto
set xlabel 'w'
set ylabel 'Final Pop.'
fit parab(x) aggrFname using 1:11 via a, b, c
set output "k11EA2-finpopVSw.png"
plot aggrFname using 1:($6>0?$11:1/0) with points ls 1 lc rgb 'blue' title "data cond6b.", \
aggrFname using 1:($6<0?$11:1/0) with points ls 1 lc rgb 'red' title "data NO cond6b.", \
parab(x) w l ls 3 title 'quadratic fit'


# FDOD contro m
fit [0.35:1] [0:800] line(x) aggrFname using 5:12 via m, q
set xlabel "m"
set title "First Day Of (colony) Death against mortality."
set ylabel "FDOD"
set xrange [0.324:*]
set output "k11EA2-fdodVSm.png"
plot aggrFname using 5:12 w points ls 1 title "data", line(x) w l ls 3 title "linear fit"


# m_i^* contro w TODO correggere! p. colori vedi il tex
set title "m_1^*, m_2^*, m_3^* against w"
set xlabel 'w'
set ylabel "m_1^*, m_2^*, m_3^*"
set xrange[3000:*]
set yrange[0.05:100]
set logscale y
set output "k11EA2-mistarVSw.png"
set arrow from 8000,0.05 to 8000,100 nohead dashtype 2 # evidenzia la soglia di 6b!
# filtro che toglie le altre, che sono tutte zero o negative TODO chk
plot aggrFname using 1:($6>0?$7:1/0) with points ls 1 title 'm_1 6b', \
aggrFname using 1:($6>0?$8:1/0) with points ls 1 lc rgb 'red' title 'm_2 6b', \
aggrFname using 1:($6<0?$8:1/0) with points ls 1 lc rgb 'red' pt 1 title 'm_2 NO 6b', \
aggrFname using 1:($6>0?$9:1/0) with points ls 1 lc rgb 'green' title 'm_3 6b', \
aggrFname using 1:($6<0?$9:1/0) with points ls 1 lc rgb 'green' pt 1 title 'm_3 NO 6b'
# aggrFname using 1:($6<0?$7:1/0) with points ls 1 , \ # questi sono negativi
#  [ w, L, alpha, sigma, m, cond6bVal, m1Star, m2Star, m3Star, initialPop, finalPop, fdod, fdoo ] );
















# unset key
# plot for [file in system("ls output/*.dat")] file using 1:(($2)+($3)) with lines
# plot for [file in system("ls *.dat")] file every ::0::898 using 1:(($2)+($3)) with lines
# plot "datafile.dat" every ::0::(N-2) using 1:2 with lines


# set key outside
# # set yrange [*:100000]
# set logscale y
#
# set style line 1 lc rgb 'blue' pt 5 ps 1  # square
# set style line 2 lc rgb 'red' pt 2 ps 1  # x
# set style line 3 lc rgb 'purple' pt 7 ps 1  # circle
# set style line 4 lc rgb 'black' pt 8  ps 1 # triangle
#
# plot 'output/expA2aggr.dat' using ($5):((($6)>0 && ($5)<($7) )?( ($11) ):1/0) with points ls 1 title "uno", \
#     '' using ($5):((($6)>0 && ($5)>($7) && ($5)<($8) )?( ($11) ):1/0) with points ls 2 title "due", \
#     '' using ($5):((($6)>0 && ($5)>($8) )?( ($11) ):1/0) with points ls 3 title "tre"
