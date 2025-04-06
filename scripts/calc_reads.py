import pandas as pd
import os
import sys
import shutil

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

