import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import os import argparse

def parse_args():
    parser = argparse.ArgumentParser(description='Generate boxplots for phylum percentages.') 
    parser.add_argument('-d', '--directory', type=str, required=True, help='Directory containing .krona files')
    parser.add_argument('-o', '--output', type=str, required=True, help='Path to save the output plot')
    return parser.parse_args()

def show_directory_content(directory_path: str, extension: str) -> list:
    list_of_file_paths = []
    for file_name in os.listdir(directory_path):
        file_path = os.path.join(directory_path , file_name)
        if os.path.isfile(file_path) and file_name.endswith(extension): 
            list_of_file_paths.append(file_path)
    return list_of_file_paths


def get_phylum_all_count(sample_path: str) -> dict: 
    data = {}
    with open(sample_path , 'r') as file:
        sample_name = '_'.join(sample_path.split('/')[-1].split('.')[0].split('_')[2:4])
        line_count = len(file.readlines()[1:-1]) 
        data[sample_name] = line_count
    return data

def get_phylum_count(directory_path: str, phylum: str) -> dict: 
    data = {}
    for sample in show_directory_content(directory_path , '.krona'): 
        phylum_count = 0
        sample_name = '_'.join(sample.split('/')[-1].split('.')[0].split('_')[2:4])
        with open(sample , 'r') as file:
            lines = file.readlines()[1:-1]
            for line in lines:
                taxa_phylum = line.strip().split('\t')[2].split('__')[1]
                if taxa_phylum == phylum:
                    phylum_count += 1
        total_count = list(get_phylum_all_count(sample).values())[0]
        data[sample_name] = round(phylum_count / total_count * 100, 2) 
    return data

def main():
    args = parse_args ()

    data1 = get_phylum_count(args.directory , 'Bacteroidota') 
    data2 = get_phylum_count(args.directory , 'Firmicutes')
    data3 = get_phylum_count(args.directory , 'Proteobacteria') 
    data4 = get_phylum_count(args.directory , 'Actinobacteria')

    df = pd.DataFrame({
        'Bacteroidota': list(data1.values()), 
        'Firmicutes': list(data2.values()),
        'Proteobacteria': list(data3.values()), 
        'Actinobacteria': list(data4.values())
    })

    df_melted = df.melt(var_name='Phylum', value_name='Percentage')

    plt.figure(figsize=(12, 8))
    sns.boxplot(x='Phylum', y='Percentage', data=df_melted , palette='viridis',hue='Phylum', legend=False)
    
    plt.title('Distribution of Phylum Percentages', fontsize=16)
    plt.xlabel('Phylum', fontsize=14) 
    plt.ylabel('Percentage', fontsize=14)
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)
    
    plt.savefig(args.output)
    print(f"Plot saved to {args.output}")

if __name__ == '__main__':
    main()