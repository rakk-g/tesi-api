# -*- texinfo -*-
## Nel setting di Khoury 2011
## Plot A
##


maxDays= 300;

title("kh11 experiment A: cond. (6a) m < L/(2w) ... ")
xlabel("H")
ylabel("F")
xlim( [0 20000] )
ylim( [0 6000] )

directory_path = "output";
% Ottieni una lista di tutti i file nella directory
files = dir(fullfile(directory_path, "*.dat"));
% Ciclo su tutti i file
for day = 0:maxDays
    printf("Graph up to day %d\n", day);
    aux= figure(1); % much annoying as it keeps refocusing
    hold off
    newplot
    hold on
    for k = 1:length(files)
        % Costruisci il percorso completo del file
        file_path = fullfile(directory_path, files(k).name);
        % Carica i dati del file
        data = load(file_path);
        f6aData = data( data(:, 6) == 1 & data(:, 1) <= day , : );
        f6aNData = data( data(:, 6) == 0 & data(:, 1) <= day , : );

        plot(f6aData(:,2), f6aData(:,3) , "color","red" );
        plot(f6aNData(:,2), f6aNData(:,3) , "color","blue" );
    endfor
    saveas( aux, [ "img/", files(k).name, "-expA-day", sprintf("%03d", day), ".png" ] , 'png' )
    close(aux)
endfor


# % Opzionalmente, salva il grafico come immagine
# saveas(gcf, fullfile(directory_path, [files(k).name, ".png"]));


