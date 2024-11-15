# set title "expC2 data A"

set terminal pngcairo size 1366,768
set output "kh11expC2B.png"
set key outside
unset key

set xlabel "m"
set ylabel "N(900) / N(0)"
set yrange [*:1000]

set logscale y

set style line 1 lc rgb 'blue' pt 5 ps 0.7  # square
set style line 2 lc rgb 'red' pt 2 ps 0.7  # x
set style line 3 lc rgb 'purple' pt 7   # circle
set style line 4 lc rgb 'black' pt 8   # triangle
set style line 5 lc rgb 'black' dt 2 lw 1.5 # lower bounds
set style line 6 lc rgb 'black' dt 3 lw 1.5 # upper bounds
set style line 7 lc rgb 'black' pt 1 ps 0.7 # +


lowBound= 100
highBound = 40000

# set xrange [*:0.61]
# set yrange [lowBound/2 : 2*highBound]
#
# set arrow from 0.0804, graph 0 to 0.0804, graph 1 nohead ls 5
# set arrow from 0.5078, graph 0 to 0.5078, graph 1 nohead ls 6


# B
plot 'output_expC2b.dat' using ($1):($3)/($2) with points ls 2 ps 1, \
1 with lines ls 1

# # A
# plot 'output_expC2a.dat' using 1:(($3)<lowBound?($2):1/0) with points ls 1 title 'crepano iniz', \
#     'output_expC2a.dat' using 1:(($3)>highBound?($2):1/0) with points ls 2 title 'forti iniz', \
#     'output_expC2a.dat' using 1:(($3)>highBound?($3):1/0) with points ls 3title 'forti fina', \
#     'output_expC2a.dat' using 1:( ( ($3)<highBound && ($3)>lowBound ) ?($2):1/0) with points ls 7 title 'mid iniz', \
#     'output_expC2a.dat' using 1:( ( ($3)<highBound && ($3)>lowBound ) ?($3):1/0) with points ls 4 title 'mid fina', \
#     lowBound with lines ls 5, \
#     highBound with lines ls 6

unset output
