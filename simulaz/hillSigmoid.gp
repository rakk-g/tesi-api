set title "Sigmoidi di Hill"
K=3.5
set key outside
set xrange [0:20]
set yrange [0:1]
set arrow from K,0 to K,0.5 nohead dashtype 2
set label "K" at K,-0.02 center
plot for [i=1:4] (x**i)/(K**i + x**i) with lines title 'i='.i

