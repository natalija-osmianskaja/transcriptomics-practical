## Install Java
sudo apt install default-jre

## Install FastQC
1. Download FastQC:
https://www.bioinformatics.babraham.ac.uk/projects/fastqc/ 

2. Install FastQC:
After downloading, unpack the archive and make the binary executable:

bash
~~~bash~~~
wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
unzip fastqc_v0.11.9.zip
cd FastQC
chmod +x fastqc
~~~

3. Add to PATH:
Add the FastQC directory to your PATH for easy command-line access:


bash
~~~bash~~~
export PATH=$PATH:$(pwd)
Add the above line to your ~/.bashrc or ~/.bash_profile to make it persistent across sessions:
~~~

bash
~~~bash~~~
echo 'export PATH=$PATH:/path/to/FastQC' >> ~/.bashrc
Replace /path/to/FastQC with the actual path to your FastQC directory.
~~~

## Install MultiQC
pip install multiqc

## Install BBTools
1. Download BBTools from https://sourceforge.net/projects/bbmap/
2. Extract:
~~~bash~~~
 tar -xvzf BBMap_39.19.tar.gz 
~~~
