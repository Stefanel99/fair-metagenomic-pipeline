import os
import matplotlib.pyplot as plt
import argparse


def show_directory_content(directory_path: str, extension: str) -> list: 
    list_of_file_paths = []
    for file_name in os.listdir(directory_path):
        file_path = os.path.join(directory_path , file_name)
        if os.path.isfile(file_path) and file_name.endswith(extension): 
            list_of_file_paths.append(file_path)
    return list_of_file_paths

def get_read_count_bracken(file_path: str) -> int: 
    total_read_count = 0
    with open(file_path , 'r') as file: 
        file.readline()
        for line in file:
            k2b_read_count = int(line.strip().split('\t')[4])
            total_read_count += k2b_read_count 
    return total_read_count

def get_read_count_kraken2(file_path: str) -> int:
    total_read_count = 0
    with open(file_path , 'r') as file:
        file.readline()
        for line in file:
            k2b_read_count = int(line.strip().split('\t')[3])
            total_read_count += k2b_read_count
    return total_read_count

def get_read_count_k2b(file_path: str) -> int: 
    total_read_count = 0
    with open(file_path , 'r') as file: 
        file.readline()
        for line in file:
            k2b_read_count = int(line.strip().split('\t')[5])
            total_read_count += k2b_read_count 
    return total_read_count

def get_sample_name(file_path: str) -> str:
    sample_name = file_path.split('\\')[-1].split('.')[0]
    if sample_name.startswith('k2b/'):
        sample_name = sample_name.replace('k2b/','')
    return sample_name

def get_species_count(file_path: str) -> int:
    with open(file_path , 'r') as file:
        file.readline() # Skip header line
        line_count = sum(1 for line in file)
    return line_count

def scatter_plot_reads_vs_species(directory_path: str, output_pic_before: str, output_pic_after: str):
    sample_names = [get_sample_name(file) for file in show_directory_content(directory_path, ' .bracken')]
    species_count = [get_species_count(file) for file in show_directory_content(directory_path , '.bracken')]
    read_count_before = [get_read_count_kraken2(file) for file in show_directory_content(directory_path , '.bracken')]
    
    plt.figure(figsize=(10, 6))
    plt.scatter(read_count_before , species_count , color='blue', label='Samples')
    for i, sample in enumerate(sample_names):
        plt.annotate(sample, (read_count_before[i], species_count[i]), fontsize=12, ha='right')

    plt.title('Species Count VS Number of Reads Per Sample Before Bracken')
    plt.xlabel('Number of Reads', fontsize=14) plt.xticks(fontsize=12)
    plt.ylabel('Number of Species', fontsize=14) plt.yticks(fontsize=12)
    plt.grid(True) plt.savefig(output_pic_before , dpi=300)
    
    read_count_after = [get_read_count_k2b(file) for file in show_directory_content(directory_path , '.bracken')]

    plt.figure(figsize=(10, 6))
    plt.scatter(read_count_after , species_count , color='green', label='Samples')
    for i, sample in enumerate(sample_names):
        plt.annotate(sample, (read_count_after[i], species_count[i]), fontsize=12, ha='right')

    plt.title('Species Count VS Number of Reads Per Sample After Bracken')
    plt.xlabel('Number of Reads', fontsize=14)
    plt.xticks(fontsize=12)
    plt.ylabel('Number of Species', fontsize=14)
    plt.yticks(fontsize=12)
    plt.grid(True)
    plt.savefig(output_pic_after , dpi=300)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Plot species count vs number of reads.')
    parser.add_argument('-d', '--directory', type=str, required=True, help='Directory path containing the .bracken files.')
    parser.add_argument('-b', '--output_before', type=str, required=True, help='Output PNG file to save the plot (before Bracken correction).')
    parser.add_argument('-a', '--output_after', type=str, required=True, help='Output PNG file to save the plot (after Bracken correction).')
    
    args = parser.parse_args()
    scatter_plot_reads_vs_species(args.directory , args.output_before , args.output_after)