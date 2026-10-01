import sys,getopt,os
import matplotlib.pyplot as plt


def organise_data(file_path:str)->dict:
    data={}
    with open(file_path,"r") as file:
        for line in file:
            parts=line.strip().split(':')
            number=int(parts[0].strip())
            sample_name=str(parts[1].strip())
            data[sample_name]=number
    return data



def ensure_output_dir(output_dir):
    if output_dir and not os.path.exists(output_dir):
        os.makedirs(output_dir)
        else:None

def plot_initial_data(data:dict,output_dir:str=None):
    list_sample_name=list(data.keys())
    list_seq_nbr=list(data.values())
    fig=plt.figure(figsize=(14,7))
    plt.bar(list_sample_name,list_seq_nbr,color="blue",width=0.8)
    plt.xlabel("Sample Name",fontsize=14)
    plt.xticks(rotation=90,fontsize=14)
    plt.ylabel("Number of Reads",fontsize=14)
    plt.ylim(0,3000000)
    plt.title("Number of Reads Across Nanopore Samples")
    plt.tight_layout()
    if output_dir:
        ensure_output_dir(output_dir)
        plt.savefig(os.path.join(output_dir, "plot_initial_data.png"))
    else:
        plt.savefig("plot_initial_data.png")
    plt.close(fig)


def plot_run_data(data:dict,run_nbr:int,output_dir:str=None):
    list_sample_name=sorted([sample_name for sample_name in data.keys() if f'Run_{run_nbr}' in sample_name])
    list_seq_nbr=[data[sample_name] for sample_name in list_sample_name] fig=plt.figure(figsize=(14,7))
    plt.bar(list_sample_name ,list_seq_nbr ,color='blue',width=0.8) plt.xlabel('Sample Name',fontsize=14)
    plt.xticks(rotation=90,fontsize=10) plt.ylabel('Number of Reads',fontsize=14)
    plt.title(f'Number of Reads Across Nanopore Samples for Run_{run_nbr}') plt.ylim(0,3000000)
    plt.tight_layout() 
    if output_dir:
        ensure_output_dir(output_dir)
    plt.savefig(os.path.join(output_dir ,f'plot_run_{run_nbr}_data.png'))
    else:
        plt.savefig(f'plot_run_{run_nbr}_data.png')
    plt.close(fig)


def plot_period_data(data:dict,period:str,output_dir:str=None):
    list_sample_name = sorted([sample_name for sample_name in data.keys() if period in sample_name])
    list_seq_number = [data[sample_name] for sample_name in list_sample_name] fig = plt.figure(figsize=(14,7))
    plt.bar(list_sample_name ,list_seq_number ,color='blue',width=0.8) plt.xlabel('Sample Name',fontsize=14)
    plt.xticks(rotation=90,fontsize=10)
    plt.ylabel("Number of Reads",fontsize=14)
    plt.title(f"Number of Reads Across Nanopore Samples for {period}")
    plt.ylim(0,3000000) plt.tight_layout()
    if output_dir: 
        ensure_output_dir(output_dir)
        plt.savefig(os.path.join(output_dir ,f'plot_period_{period}_data.png')) 
    else:
        plt.savefig(f'plot_period_{period}_data.png') 
    plt.close(fig)


def plot_individual_data(data:dict,individual:str,output_dir:str=None):
    list_sample_name = sorted([sample_name for sample_name in data.keys() if individual in sample_name])
    list_seq_number = [data[sample_name] for sample_name in list_sample_name]
    fig = plt.figure(figsize=(14,7))
    plt.bar(list_sample_name ,list_seq_number ,color='blue',width=0.8)
    plt.xlabel("Sample Name",fontsize=14) plt.xticks(rotation=90,fontsize=10)
    plt.ylabel("Number of Reads",fontsize=14)
    plt.title(f"Number of Reads Across Nanopore Samples for {individual}")
    plt.ylim(0,3000000) plt.tight_layout()
    if output_dir: 
        ensure_output_dir(output_dir)
        plt.savefig(os.path.join(output_dir ,f'plot_individual_{individual}_data.png')) 
    else:
        plt.savefig(f'plot_individual_{individual}_data.png') 
    plt.close(fig)



def usage():
    print("Usage: plotting.py -o <outputfile > -v") print("Options:")
    print(" -i, --input specify input file")
    print(" -h, --help show this help message and exit")
    print(" -o, --output specify output file") print(" -v, --verbose enable verbose mode")

def main(): 
    try:
        opts,args=getopt.getopt(sys.argv[1:],"hi:o:v",["help","input=","output="]) 
    except getopt.GetoptError as error:
        print(error) usage ()
        sys.exit(2) 
    output=None
    verbose=False 
    file_path=None
    for o,a in opts:
        if o in ("-i","--input"):
            file_path=a 
        elif o=="-v":
            verbose=True
        elif o in ("-h","--help"):
            usage () 
            sys.exit()
        elif o in ("-o","--output"): 
            output_dir=a
        else:   
            assert False, "unhandled option"
    if file_path:
        data = organise_data(file_path)
        plot_initial_data(data,output_dir)
        for run_nbr in range(1,3):
            plot_run_data(data,run_nbr,output_dir)
        for month in ['Feb','July']:
            plot_period_data(data,month,output_dir)
        for individual in ['0476','0446','0428','0407','0350','0667','0199']:
            plot_individual_data(data,individual,output_dir)
        else:
            usage ()
            sys.exit(2)

if __name__ == "__main__": main ()