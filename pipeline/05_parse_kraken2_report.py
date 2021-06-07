import numpy as np
import pandas as pd
import os
from pathlib import Path


def parser(file_list, input_dir, rank='species'):
    """
    Parses Kraken2 output files according to taxonomic rank of choice.

    Args:
        list containing paths of output files (created using --report-files in krakenuniq),
        base directory containing reports
        taxonomic rank of choice


    returns: dataframe with runid as row index and taxons as column index
    """
    # For testing
    # base_dir = Path.cwd() / 'datasets/kapusta_reports'
    # # file_list = os.listdir(base_dir)
    # # file_name = file_list[1]
    # rank = 'G'

    problem_files = []
    df_full = pd.DataFrame(columns=[rank])
    for file_name in file_list:
        try:
            df = pd.read_csv(input_dir / file_name, sep='\t', header=None)
            df.columns = ['%', 'cum_reads', 'reads', 'rank', 'taxID', 'taxName']
            run_names = file_name.split("_")
            runid = run_names[0] + '_' + run_names[1]

            # Retrieve taxa rank of choice
            assert rank in df['rank'].unique()
            rank_df = df[df['rank'] == rank]
            rank_df = rank_df[['taxName', 'reads']]

            # Strip whitespace
            rank_df.loc[:, 'taxName'] = rank_df.loc[:, 'taxName'].str.strip()

            # Drop unknown taxa
            rank_df = rank_df.loc[rank_df.taxName != 'uncultured', :]
            rank_df = rank_df.loc[rank_df.taxName != 'Incertae Sedis', :]

            # Check for duplicate genera
            assert rank_df.duplicated().sum() == 0

            # Rename columns
            rank_df.columns = [rank, runid]
            rank_df.loc[:, runid] = rank_df.loc[:, runid].astype('int32')

            # # Set taxa as index
            # rank_df = rank_df.set_index(rank)

            # Outer join to get most taxa
            df_full = df_full.merge(rank_df, how='outer', on=rank)

        except:
            problem_files.append(file_name)

    print("These files were in an invalid format:")
    print(*problem_files, sep='\n')

    df_full = df_full.set_index(rank)
    df_full = df_full.T

    # Replace Nans with zeros
    df_full = df_full.replace({np.nan: 0})

    return df_full

#### USER INPUT ####
# Get Paths
base_dir = Path('/mnt/c/Users/Cedric/Desktop/year_3/BIOC0023/BIOC0023_dissertation/data/')
input_dir = base_dir / '04_kraken2_output'
output_dir = base_dir / '05_abundance_matrices'
outfile = 'gosiewski.family.tsv'
rank = 'F'
####################

file_list = os.listdir(input_dir)
print(file_list)

# Make directory if !exist
if input_dir.exists():
    print('Input directory exists...')

if base_dir.exists() and not output_dir.exists():
    os.mkdir(output_dir)
elif base_dir.exists() and output_dir.exists():
    print('Output directory exists.')
else:
    raise FileNotFoundError('Base directory supplied does not exists')

# Parse reports
df = parser(file_list, input_dir, rank=rank)
df = df.rename({'index': 'run'}, axis=1)

# Add metadata
#meta = pd.read_csv(datasets/ 'kapusta_metadata_290620.tsv', sep='\t')
#meta = meta.set_index('SAMPLE_ID')
#meta = meta.GROUP
#meta.name = 'y'
#df = df.join(meta)
#df = df.replace({'control': 'healthy', 'sample': 'septic'})

# Drop zero columns
df = df.loc[:, df.any(0)]   # Remove zero columns

# Manipulating column names to fit xgboost requirements
df.columns = df.columns.str.replace('>', '')
df.columns = df.columns.str.replace(']', '')
df.columns = df.columns.str.replace('[', '')

# Reset index
df = df.reset_index(drop=False).rename({'index':'sample'}, axis=1)
print(df.shape)

df.to_csv(output_dir / outfile, index=False)

