# # kh11expA2-alt.gp
# Alternative A2 experiment.

# use a good driver and medium widescreen resolution
set terminal pngcairo size 1366,768
dataFileA = "output/alternativeA.dat"
dataFileB = "output/alternativeB.dat"
dataFileC = "output/alternativeC.dat"
dataFileD = "output/alternativeD.dat"
dataFileDB = "output/alternativeDbase.dat"
dataFileE = "output/alternativeE.dat"

set macros
R = "(0.25-0.75*($3)/(($2)+($3)))"
E = "(2000*(($2)+($3))/(25000+($2)+($3)))"

# A - step
unset key
set xrange [0:600]
set xlabel "t"
set output "alternativeA.png"
set multiplot layout 2,1 rowsfirst
set yrange [0:20000]
set ylabel "H, F"
set y2label "E"
set y2range [0:1200]
set y2tics  # Enable the secondary y-axis (right side)
set ytics nomirror  # Avoid duplicating left y-axis on the right
plot dataFileA using 1:2 with lines lc "blue" title "H", '' using 1:3 with lines lc "blue" dt 2 title "F", \
dataFileA using 1:@E with lines lc "green" title "E" axes x1y2

set yrange [0:0.7]
set ylabel "m"
set y2range [0.03:0.13]
set y2label "R"
set y2tics
set ytics nomirror
plot dataFileA using 1:4 with lines lc "red" title "m", \
dataFileA using 1:@R with lines lc "blue" title "R" axes x1y2
unset multiplot

# B - triangular
reset
unset key
set xrange [0:600]
set xlabel "t"
set output "alternativeB.png"
set multiplot layout 2,1 rowsfirst
set yrange [0:20000]
set ylabel "H,F"
set y2range [0:1200]
set y2label "E"
set y2tics
set ytics nomirror
plot dataFileB using 1:2 with lines lc "blue" title "H", '' using 1:3 with lines lc "blue" dt 2 title "F", \
dataFileB using 1:@E with lines lc "green" title "E" axes x1y2

set yrange [0:0.7]
set ylabel "m"
set y2range [0.03:0.13]
set y2label "R"
set y2tics
set ytics nomirror
plot dataFileB using 1:4 with lines lc "red" title "m", \
dataFileB using 1:@R with lines lc "blue" title "R" axes x1y2
unset multiplot

# C - gaussian
unset key
set xrange [0:600]
set xlabel "t"
set output "alternativeC.png"
set multiplot layout 2,1 rowsfirst
set yrange [0:20000]
set ylabel "H,F"
set y2range [0:1200]
set y2label "E"
set y2tics
set ytics nomirror
plot dataFileC using 1:2 with lines lc "blue" title "H", '' using 1:3 with lines lc "blue" dt 2 title "F", \
dataFileC using 1:@E with lines lc "green" title "E" axes x1y2

set yrange [0:0.7]
set ylabel "m"
set y2range [0.03:0.13]
set y2label "R"
set y2tics
set ytics nomirror
plot dataFileC using 1:4 with lines lc "red" title "m", \
dataFileC using 1:@R with lines lc "blue" title "R" axes x1y2
unset multiplot

# D - sinusoidal (LOW disease)
#   another simulation with base mortality is drawn
unset key
set xrange [0:600]
set xlabel "t"
set output "alternativeD.png"
set multiplot layout 2,1 rowsfirst
set yrange [0:20000]
set ylabel "H,F"
set y2range [0:1200]
set y2label "E"
set y2tics
set ytics nomirror
plot dataFileD using 1:2 with lines lc "blue" title "H", '' using 1:3 with lines lc "blue" dt 2 title "F", \
dataFileDB using 1:2 with lines lc "grey" title "H", '' using 1:3 with lines lc "grey" dt 2 title "F", \
dataFileD using 1:@E with lines lc "green" title "E" axes x1y2

set yrange [0:0.7]
set ylabel "m"
set y2range [0.03:0.13]
set y2label "R"
set y2tics
set ytics nomirror
plot dataFileD using 1:4 with lines lc "red" title "m", \
dataFileD using 1:@R with lines lc "blue" title "R" axes x1y2
unset multiplot
# E - sinusoidal (HIGH disease)
#   another simulation with base mortality is drawn
unset key
set xrange [0:600]
set xlabel "t"
set output "alternativeE.png"
set multiplot layout 2,1 rowsfirst
set yrange [0:20000]
set ylabel "H,F"
set y2range [0:1200]
set y2label "E"
set y2tics
set ytics nomirror
plot dataFileE using 1:2 with lines lc "blue" title "H", '' using 1:3 with lines lc "blue" dt 2 title "F", \
dataFileDB using 1:2 with lines lc "grey" title "H", '' using 1:3 with lines lc "grey" dt 2 title "F", \
dataFileE using 1:@E with lines lc "green" title "E" axes x1y2

set yrange [0:0.7]
set ylabel "m"
set y2range [0.03:0.13]
set y2label "R"
set y2tics
set ytics nomirror
plot dataFileE using 1:4 with lines lc "red" title "m", \
dataFileE using 1:@R with lines lc "blue" title "R" axes x1y2
unset multiplot

