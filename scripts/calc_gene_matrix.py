import pandas as pd
import sys
from pathlib import Path

sample_files = sys.argv[1:-1]
matrix_file = sys.argv[-1]

print("input:",  sample_files)
print("output:",  matrix_file)

result_list = []


for sample_file in sample_files:

    sample_code = sample_file[sample_file.rfind('/') + 1:] # remove folders from file name
    sample_code = sample_code.replace("Collibri_", "").replace("-Collibri-", "").replace("standard_protocol-", "")
    sample_code = sample_code.replace("100_ng-", "").replace(".txt", "")
    sample_code = sample_code.replace("KAPA_mRNA_HyperPrep_-", "").replace("-KAPA-100_ng_total_RNA-", "")
    sample_code = sample_code.strip("-").strip()


    sample_data = pd.read_csv(sample_file, sep="\t", comment="#")
    Geneid = sample_data.iloc[:, 0] 
    count = sample_data.iloc[:, -1]  

    result_list.append(pd.DataFrame({"Geneid": Geneid, sample_code: count}))


# Loop through each DataFrame in result_matrix, starting from the second DataFrame and merge 
result_matrix = result_list[0]
for sample_df in result_list[1:]:
    result_matrix = pd.merge(result_matrix, sample_df, on="Geneid", how="outer")

# Modify result_matrix to set unique index on gene
result_matrix.set_index("Geneid", inplace=True)

# Save to output file
result_matrix.to_csv(matrix_file, sep="\t")
