import pandas as pd
import os
import sys
import shutil

def add_matrix_row(matrix, s1, s2, s3, s4):
    m_row = []
    m_row.append(s1) 
    m_row.append(s2) 
    m_row.append(s3) 
    m_row.append(s4) 
    matrix.append(m_row)

def process_file(input_filepath, m):
    if os.path.exists(input_filepath):
        try:
            input_file = pd.read_csv(input_filepath, sep="\t", index_col=0, header=0)

            assigned = input_file.loc["Assigned"].values[0]
            unassigned_mm = input_file.loc["Unassigned_MultiMapping"].values[0]
            unassigned_nf = input_file.loc["Unassigned_NoFeatures"].values[0]
        
            add_matrix_row(m, input_file, assigned, unassigned_mm, unassigned_nf)

        except Exception as e:
            print(f"An error occurred: {e}")

def write_matrix(matrix, output_filepath):
    # Write the transposed data to a new file
    with open(output_filepath, 'w') as output_file:
        for i in range(len(matrix)):
            output_file.write(f"\t{matrix[i],[0]}\t{matrix[i],[1]}\t{matrix[i],[2]}\t{matrix[i],[3]}\n")


def choose_best_assigned (s1, s2):
    # Check the pair of files, compare Assigned value and select the best

    s1_file = pd.read_csv(s1, sep="\t", index_col=0, header=0)
    assigned_s1 = s1_file.loc["Assigned"].values[0]   
    s2_file = pd.read_csv(s2, sep="\t", index_col=0, header=0)
    assigned_s2 = s2_file.loc["Assigned"].values[0]    
    if assigned_s1 > assigned_s2:
        best_assigned = "s1"
    else:
        best_assigned = "s2"     
    return best_assigned

# Start analysis
print("new run")
s1_filepath = sys.argv[1]
s2_filepath = sys.argv[2]
s1_summary_filepath = s1_filepath + ".summary"
s2_summary_filepath = s2_filepath + ".summary"

print("Input file 1:", s1_filepath)

output_filepath = sys.argv[3]
report_filepath = os.path.dirname(output_filepath) + "/" + "report_txt"
print("Report:",  report_filepath)

# analyze summary file
best_assigned = choose_best_assigned(s1_summary_filepath, s2_summary_filepath)
# put choice to report
if best_assigned == "s1":
    best_assigned_filepath = s1_filepath 
else:
    best_assigned_filepath = s2_filepath 
with open(report_filepath, 'a') as output_file:
    output_file.write(best_assigned + "\t" + best_assigned_filepath + "\n")

# copy file to further analysis
shutil.copy (best_assigned_filepath, output_filepath)

