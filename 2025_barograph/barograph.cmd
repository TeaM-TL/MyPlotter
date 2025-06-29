#!/usr/bin/env gnuplot
set terminal qt font "" persist noraise title "Barograph" 
unset title  # "Barograph" font ",12"

set xlabel "Time hours" font ",12"
set xdata time
set timefmt "%Y-%m-%d_%H:%M"
set xtics timedate
set xtics format "%H:%M"
set ylabel "Temperature [C]" font ",18"
set yrange [-10:45]
set ytics -10,5,45 font ",12"
set y2label "Pressure [hPa]" font ",18"
set y2range [980:1035]
set y2tics 980,5,1035 font ",12"
while (1) {
    last_line = system("tail -n 1 ~/barograph/barograph.data")
    last_date = strftime("%Y-%m-%d %H:%M", strptime("%Y-%m-%d_%H:%M", word(last_line, 1)))
    last_pressure = real(word(last_line, 2))
    last_temp = real(word(last_line, 3))
    unset label 1
    set label 1 sprintf("Last data at %s", last_date)  \
        at graph .025,.97 left font ",12"
    unset label 2
    set label 2 sprintf("Pressure: %.1f hPa", last_pressure) \
        at graph .025,.93 left textcolor rgb "red" font ",18"
    unset label 3
    set label 3 sprintf("Temperature: %.1f°C", last_temp) \
        at graph .025,.88 left textcolor rgb "blue" font ",15"
    set grid
    unset key
    plot \
        '~/barograph/barograph.data' using 1:2 axes x1y2 \
            with line linecolor rgb "red" linewidth 3 title "Pressure", \
        '~/barograph/barograph.data' using 1:3 axes x1y1 \
            with line linecolor rgb "blue" linewidth 1 title "Temperature" 
    pause 30
}