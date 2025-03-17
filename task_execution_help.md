
## Markdown
You can also open an existing Markdown file and start working with it. To switch between views, press Ctrl+Shift+V in the editor. You can view the preview side-by-side (Ctrl+K V) with the file you are editing and see changes reflected in real-time as you edit.

## Install Java
sudo apt install default-jre

## Install FastQC
1. Download FastQC:
https://www.bioinformatics.babraham.ac.uk/projects/fastqc/ 

2. Install FastQC:
After downloading, unpack the archive and make the binary executable:

~~~bash~~~
wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
unzip fastqc_v0.11.9.zip
cd FastQC
chmod +x fastqc
~~~

3. Add to PATH:
Add the FastQC directory to your PATH for easy command-line access:


~~~bash~~~
export PATH=$PATH:$(pwd)
Add the above line to your ~/.bashrc or ~/.bash_profile to make it persistent across sessions:
~~~


~~~bash~~~
echo 'export PATH=$PATH:/path/to/FastQC' >> ~/.bashrc
# Replace /path/to/FastQC with the actual path to your FastQC directory.
~~~

## Install MultiQC
pip install multiqc

## Install BBTools
1. Download BBTools from https://sourceforge.net/projects/bbmap/
2. Extract:
~~~bash~~~
 tar -xvzf BBMap_39.19.tar.gz 
~~~

## Install STAR
1. Download https://github.com/alexdobin/STAR/tree/master/bin/Linux_x86_64_static
2. Run 
~~~bash~~~
sudo apt-get update
sudo apt-get install g++
sudo apt-get install make
cd star
chmod +x ./STAR
./STAR # to check if it works
~~~

## Install featureCounts
~~~bash~~~
sudo apt install subread
~~~