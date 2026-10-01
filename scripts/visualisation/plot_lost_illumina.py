import re
import matplotlib.pyplot as plt
import numpy as np
import argparse


def prepare_data(file_path: str) -> dict: 
    data = {}
    with open(file_path , 'r') as file: 
        for line in file:
            read_count = line.strip().split(' : ')[0] 
            sample_name = line.strip().split(' : ')[1]
            data[sample_name] = read_count 
    return data

def calculate_read_variation(first_dataset: dict, second_dataset: dict, forward_reverse: bool)-> dict: data_input = {}
    for sample_name in first_dataset.keys(): 
        if not forward_reverse:
            data_input[sample_name] = int(first_dataset[sample_name]) - int(second_dataset[ sample_name])
        else:
            data_input[f'{sample_name}_R1'] = int(first_dataset[sample_name]) - int(second_dataset.get(f'{sample_name}_R1', 0))
            data_input[f'{sample_name}_R2'] = int(first_dataset[sample_name]) - int(second_dataset.get(f'{sample_name}_R2', 0)) 
        return data_input


def stacked_bar_plot(samples: list, lost_reads_mapping: list, lost_reads_trimming: list,output_file: str):
    fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True, figsize=(14, 10), gridspec_kw={'height_ratios': [2, 1]})
    bar_width = 0.5
    index = np.arange(len(samples))

    ax1.bar(index , lost_reads_mapping , bar_width , label='Lost Reads (Mapping)')
    ax1.bar(index , lost_reads_trimming , bar_width , bottom=lost_reads_mapping , label='Lost Reads (Trimming)')

    ax1.set_ylim(20000000, max(max(lost_reads_mapping), max(lost_reads_trimming)) + 1000000)
    ax2.set_ylim(0, 1000000)
    ax2.bar(index , lost_reads_mapping , bar_width , label='Lost Reads (Mapping)') 
    ax2.bar(index , lost_reads_trimming , bar_width , bottom=lost_reads_mapping , label='Lost Reads (Trimming)')

    ax1.spines['bottom'].set_visible(False) ax2.spines['top'].set_visible(False)
    ax1.tick_params(labeltop=False) ax2.xaxis.tick_bottom()

    d = .015
    kwargs = dict(transform=ax1.transAxes , color='k', clip_on=False)
    ax1.plot((-d, +d), (-d, +d), **kwargs) 
    ax1.plot((1 - d, 1 + d), (-d, +d), **kwargs)kwargs.update(transform=ax2.transAxes)
    
    ax2.plot((-d, +d), (1 - d, 1 + d), **kwargs) ax2.plot((1 - d, 1 + d), (1 - d, 1 + d), **kwargs)
    ax2.set_xlabel('Sample', fontsize=14)
    ax1.set_ylabel('Number of Lost Reads', fontsize=14) ax2.set_ylabel('Number of Lost Reads', fontsize=14)
    fig.suptitle('Lost Reads During Mapping and Trimming Steps', fontsize=12)

    ax2.set_xticks(index)
    ax2.set_xticklabels(samples, rotation=90, fontsize=14)
    
    ax1.legend()
    
    plt.tight_layout(rect=[0, 0.03, 1, 0.95])
    plt.savefig(output_file)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Plot lost reads during mapping and trimming steps.")
    parser.add_argument('-r', '--raw', required=True, help='Path to raw reads file')
    parser.add_argument('-u', '--unmap', required=True, help='Path to unmapped reads file')
    parser.add_argument('-t', '--trim', required=True, help='Path to trimmed reads file')
    parser.add_argument('-o', '--output', required=True, help='Output file for the figure')
   
    args = parser.parse_args()

    raw_reads_dict = prepare_data(args.raw)
    unmapp_reads_dict = prepare_data(args.unmap)
    trim_reads_dict = prepare_data(args.trim)

    samples = list(raw_reads_dict.keys())
    raw_reads = list(raw_reads_dict.values()) unmapp_reads = list(unmapp_reads_dict.values())
    trim_reads = list(trim_reads_dict.values())
    
    lost_mapping = [int(raw) - int(unmap) for raw, unmap in zip(raw_reads, unmapp_reads)] 
    lost_trimming = [int(unmap) - int(trim) for unmap, trim in zip(unmapp_reads, trim_reads)]
    stacked_bar_plot(samples , lost_mapping , lost_trimming , args.output)