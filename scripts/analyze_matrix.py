import pandas as pd
import sys
import scipy.stats as stats

# Load the data
matrix_filepath = sys.argv[1]
output_filepath = sys.argv[2]
df = pd.read_csv(matrix_filepath, sep='\t')

# with open(output_filepath, 'a') as output_file:
#     output_file.write(df.describe() + "\n")

sample_columns = df.columns[1:]  # Skip first column Geneid

# 1. Calculate Means and Variance
mean_values = df[sample_columns].mean()  # Calculate mean for each sample
variance_values = df[sample_columns].var()  # Calculate variance for each sample

# Prepare for statistical test
sample1 = df[sample_columns[0]]
sample2 = df[sample_columns[1]]

# 2. Statistical Testing: t-test for difference between two specific samples
t_stat, p_value = stats.ttest_ind(sample1, sample2, equal_var=False)  # assuming unequal variance

# Optionally, you can perform ANOVA if you want to compare more than two samples
anova_result = stats.f_oneway(*[df[sample] for sample in sample_columns])

# Prepare the report in string format
report_content = f"""
Gene Expression Data Analysis for {matrix_filepath}

1. Mean Values
{mean_values.to_string()}

2. Variance Values
   {variance_values.to_string()}

3. Statistical Testing
   - T-test between {sample_columns[0]} and {sample_columns[1]}:
     - T-statistic: {t_stat}, P-value: {p_value}
   - ANOVA result across samples:
     - F-statistic: {anova_result.statistic}, P-value: {anova_result.pvalue}

"""
with open(output_filepath, 'w') as report_file:
    report_file.write(report_content)


