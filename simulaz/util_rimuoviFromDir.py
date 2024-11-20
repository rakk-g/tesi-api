import os
import random

def remove_random_files(directory, percentage=80):
    """
    Rimuove casualmente una percentuale specificata di file da una directory.

    :param directory: Il percorso della directory da cui rimuovere i file.
    :param percentage: Percentuale di file da rimuovere (default: 90%).
    """
    if not os.path.isdir(directory):
        print(f"Errore: {directory} non è una directory valida.")
        return

    # Ottieni l'elenco di tutti i file nella directory
    files = [f for f in os.listdir(directory) if os.path.isfile(os.path.join(directory, f))]

    if not files:
        print("La directory è vuota o non contiene file.")
        return

    # Calcola il numero di file da rimuovere
    num_files_to_remove = int(len(files) * percentage / 100)
    files_to_remove = random.sample(files, num_files_to_remove)

    print(f"Rimuoverò {num_files_to_remove} file da '{directory}': {files_to_remove}")

    # Rimuovi i file selezionati
    for file in files_to_remove:
        file_path = os.path.join(directory, file)
        try:
            os.remove(file_path)
            print(f"Rimosso: {file_path}")
        except Exception as e:
            print(f"Errore durante la rimozione di {file_path}: {e}")

# Esegui la funzione
directory_path = input("Inserisci il percorso della directory: ")
remove_random_files(directory_path)
