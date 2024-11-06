# -*- texinfo -*-
## Nel setting di Khoury 2011
## Plot A
##


maxDays= 370;

hold off
newplot
xlabel("H")
ylabel("F")
hold on

directory_path = "output";
% Ottieni una lista di tutti i file nella directory
files = dir(fullfile(directory_path, "*.dat"));
% Ciclo su tutti i file
for k = 1:length(files)
    % Costruisci il percorso completo del file
    file_path = fullfile(directory_path, files(k).name);
    % Carica i dati del file
    data = load(file_path);
    f6aData = data( data(:, 6) == 1 , : );
    f6aNData = data( data(:, 6) == 0 , : );

    plot(f6aData(:,2), f6aData(:,3) , "color","red" );
    plot(f6aNData(:,2), f6aNData(:,3) , "color","blue" );
endfor


# % Opzionalmente, salva il grafico come immagine
# saveas(gcf, fullfile(directory_path, [files(k).name, ".png"]));


