# -*- texinfo -*-
## Nel setting di Khoury 2011
## Plot C
## la cond 6b è verificata,
##


maxDays= 900;

title( sprintf("kh11 experiment C: N=%d days", maxDays) )
xlabel("m")
ylabel("H_0 + F_0")
# xlim( [0 20000] )
# ylim( [0 6000] )


aux= figure(1); % much annoying as it keeps refocusing
hold off
newplot
hold on
file_path= "output_concatenato.dat"
data = load(file_path);
high = data( data(:,3) > 40000 , : );
low = data( data(:,3) < 200, : );
mid = data( data(:,3) >= 200 & data(:,3) <= 40000, : );

plot(high(:,1), high(:,2) , "r+" );
plot(low(:,1), low(:,2) , "bx" );
plot(mid(:,1), mid(:,2) , "k*" );
legend("high", "low", "mid");


    # saveas( aux, [ "img/", files(k).name, "-expC-day", sprintf("%03d", day), ".png" ] , 'png' )
    # close(aux)


# % Opzionalmente, salva il grafico come immagine
# saveas(gcf, fullfile(directory_path, [files(k).name, ".png"]));


