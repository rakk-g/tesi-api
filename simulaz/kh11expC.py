import os
from math import sqrt

# Specifica la directory con i file di input
directory_path = "output"
# Specifica il file di output
output_file = "output_concatenato.dat"

# Apri il file di output in modalità scrittura
with open(output_file, "w") as outfile:
    # Scrivi l'intestazione nel file di output
    outfile.write("# Ultimo_Param\tPrima Riga t, H, F\tUltima Riga t, H, F\n")

    # Itera su tutti i file nella directory
    for filename in os.listdir(directory_path):
        file_path = os.path.join(directory_path, filename)

        # Verifica se è un file
        if os.path.isfile(file_path):
            # print("Processing ", file_path)
            with open(file_path, "r") as infile:
                lines = infile.readlines()

                # Estrai il parametro dalla seconda riga commentata
                params_line = lines[1].strip()
                [ w, L, alpha, sigma, m ] = [ float(x) for x in ( params_line.split() )[-5:] ]


                # Estrai la prima e l'ultima riga dei dati: t, H, F
                fdl = [ float(x) for x in lines[3].strip().split() ]      # Prima riga di dati
                ldl = [ float(x) for x in lines[-1].strip().split() ]      # Ultima riga di dati

                # # Concatenare e salvare i risultati nel file di output
                # output_line = f"{ultimo_param}\t{first_data_line}\t{last_data_line}\n"
                # outfile.write(output_line)

                # wanna do some more calculations. I will save a row for each file
                # m A B C
                #
                # A = H0+F0
                # B = same for last data line. This should give a sense of smth
                # C = cond (6b)

                A = fdl[1] + fdl[2]
                B = ldl[1] + ldl[2]
                # clipping
                A = int(A)
                B = int(B)

                C = (alpha - L/w >0) and 1 or -1
                out_line = f"{m}\t{A}\t{B}\t{C}\n"
                outfile.write(out_line)

print(f"Risultati salvati in {output_file}")
