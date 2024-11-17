
plot for [file in system("ls *.dat")] file using 1:(($2)+($3)) with lines
plot for [file in system("ls *.dat")] file every ::0::898 using 1:(($2)+($3)) with lines
plot "datafile.dat" every ::0::(N-2) using 1:2 with lines


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
