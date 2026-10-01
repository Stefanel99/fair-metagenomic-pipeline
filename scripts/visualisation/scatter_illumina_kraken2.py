import os
import argparse
import matplotlib.pyplot as plt

def show_directory_content(directory_path: str, extension: str) -> list:
    list_of_file_paths = []
    for file_name in os.listdir(directory_path):
        file_path = os.path.join(directory_path , file_name)
        if os.path.isfile(file_path) and file_name.endswith(extension):
            list_of_file_paths.append(file_path)
    return list_of_file_paths


def count_species(file_path: str) -> int:
    species_count = 0
    with open(file_path , 'r') as file:
        for line in file:
            taxa_level = line.strip().split('\t')[3]
            if taxa_level == 'S': species_count += 1
    return species_count

def prepare_count_data(file_input: str, R_value: str) -> dict:
    data = {}
    with open(file_input , 'r') as file:
        for line in file:
            read_count = int(line.strip().split(' : ')[0])
            sample_name = str(line.strip().split(' : ')[1]) if sample_name.endswith(R_value):
                return data
            data[sample_name] = read_count
    return data

def get_sample_name(list_file_input: str) -> list:
    data = []
    for file in show_directory_content(list_file_input , '.bracken'):
        sample_name=file.split('\\')[-1].split('.')[0]
        if sample_name.startswith('k2b/'):
            sample_name=sample_name.replace('k2b/', '')
        data.append(sample_name)
    return data

def scatter_plot_reads_vs_species(count_file_input: str, directory_kreport_kraken: str, output_plot: str):
    forward_reads_count = list(prepare_count_data(count_file_input , 'R1').values()) 
    reverse_reads_count = list(prepare_count_data(count_file_input , 'R2').values())
    sample_names = get_sample_name(directory_kreport_kraken)
    species_count = [count_species(file) for file in show_directory_content(directory_kreport_kraken, '.kreport') if '_bracken' not in file]

    plt.scatter(forward_reads_count , species_count , color='blue', label='Forward Reads') 
    plt.scatter(reverse_reads_count , species_count , color='green', label='Reverse Reads')
    plt.xlabel('Number of Reads')
    plt.ylabel('Species Count')
    plt.title('Species Count VS Number of Reads per Sample')
    for _, sample in enumerate(sample_names):
        plt.annotate(sample + ' F', (forward_reads_count[_], species_count[_]), color='blue')
        plt.annotate(sample + ' R', (reverse_reads_count[_], species_count[_]), color='green')
    plt.legend()
    plt.savefig(output_plot)

def main():
    parser = argparse.ArgumentParser(description='Generate a scatter plot of species count versus number of reads per sample.')
    parser.add_argument('-r', '--read_file_input', required=True, help='Path to the read count input file')
    parser.add_argument('-d', '--directory_kraken', required=True, help='Path to the directory containing Kraken kreport files')
    parser.add_argument('-o', '--output_plot', required=True, help='Path to save the output plot ')
    args = parser.parse_args()
    scatter_plot_reads_vs_species(args.read_file_input , args.directory_kraken , args.output_plot)
    
if __name__ == "__main__":
    main()