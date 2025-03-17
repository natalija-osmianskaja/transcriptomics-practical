import pandas as pd

def sum_last_column(file_path):
    try:
        # Load the data from a tab-separated text file, assuming the header is in the first row
        data = pd.read_csv(file_path, sep='\t')

        # Sum the values in the last column (assuming it's the last column with data)
        total_count = data.iloc[:, -1].sum()

        print(f"Total uniquely mapped reads: {total_count}")
    except Exception as e:
        print(f"An error occurred: {e}")

# Define the path to your text file
file_path = 'your_data_file.txt'

# Call the function
sum_last_column(file_path)
