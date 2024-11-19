# logistic and its first three derivatives

set terminal pngcairo size 1366,768
set xrange [-6:6]
unset key
set xlabel "x"
set style line 1 lc rgb 'blue' pt 5 ps 1.2 lw 2  # square
set style line 2 lc rgb '0x0A0A0F' pt 5 ps 1.2 lw 1.5 dt 2  # square, dashed

# logistic
set title "Logistic function"
set ylabel "f(x)"
set output "logisticF.png"
plot 1/(1+exp(-x)) with lines ls 1

# logistic velocity
set title "Logistic velocity"
set ylabel "f'(x)"
set output "logisticV.png"
plot exp(-x)/(1+exp(-x))**2 with lines ls 1

# logistic acceleration
set title "Logistic acceleration"
set ylabel "f''(x)"
set output "logisticA.png"
plot -exp(-x)/(1+exp(-x))**2 + 2*exp(-2*x)/(1+exp(-x))**3 with lines ls 1, 0 with lines ls 2

# logistic jerk
set title "Logistic jerk"
set ylabel "f'''(x)"
set output "logisticJ.png"
# plot 3*exp(-x)*( 1 -2*exp(-x) -exp(-2*x) )/( 1+exp(-x) )**4 with lines ls 1
plot ( exp(-3*x) -4*exp(-2*x) +exp(-x) )/(1+exp(-x))**4 with lines ls 1, 0 with lines ls 2

set output

