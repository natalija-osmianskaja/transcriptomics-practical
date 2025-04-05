import pandas as pd
import os

def process_file(input_filepath, output_filepath):
    if os.path.exists(input_filepath):
        try:
            # read summary file, skipping first line
            with open(input_filepath, 'r') as input_file:
                next(input_file)  # Skip the first line
                #lines = [line.strip().split('\t') for line in input_file] 
                lines = input_file.readlines()
                keys = []
                values = []

                for line in lines:
                    parts = line.split()
                    keys.append(parts[0])
                    if len(parts) > 1:
                        values.append(parts[1])
                    else:
                        values.append('') 

                # Transpose the parsed data
                transposed = list(zip(keys, values))

                # Write the transposed data to a new file
                with open(output_filepath, 'w') as output_file:
                    for key, value in transposed:
                        output_file.write(f"{key}\t{value}\n")

            # # Load the data from a tab-separated text file, assuming the header is in the first row
            # df = pd.read_csv(file_path, sep='\t')
            # with open(output_file, 'w') as matrix:
            #     matrix.write(file_path)
            #     ## Iterate over each row and print
            #     for index, row in df.iterrows():
            #         # print(row.to_dict()) 
            #         matrix.write(row.to_dict())

        except Exception as e:
            print(f"An error occurred: {e}")

# Define the path to your text file
s1_dir = 'results/feature_count_s1/'
input_filename = 'Collibri_standard_protocol-HBR-Collibri-100_ng-2_S1_L001.txt.summary'
output_filepath = "results/feature_count/read_analysis.txt"

# Call the function
process_file(s1_dir + input_filename, output_filepath)
#print("check-ok")