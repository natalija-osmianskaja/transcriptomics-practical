# find input files that match a specified pattern
# {sample} is a wildcard which represents a variable part of the filename
RNA_SAMPLE_DATA = glob_wildcards("resources/RNA-seq-sample-data/{sample}.fastq.gz").sample

rule all:
    input:
        #expand("results/fastqc/{sample}_fastqc.html", sample=RNA_SAMPLE_DATA)
        #"results/multiqc/multiqc_report.html"
        expand("results/trimmed/{sample}.fastq.gz", sample=RNA_SAMPLE_DATA),
 
rule fastqc:
    input:
        "resources/RNA-seq-sample-data/{sample}.fastq.gz"
    output:
        "results/fastqc/{sample}_fastqc.html", 
    shell:
        "fastqc -o results/fastqc {input}"

rule multiqc:
    input:
        expand("results/fastqc/{sample}_fastqc.html", sample=RNA_SAMPLE_DATA)
    output:
        "results/multiqc/multiqc_report.html", 
    shell:
        "multiqc results/fastqc -o results/multiqc"      

rule bbduk:
    input:
        "resources/RNA-seq-sample-data/{sample}.fastq.gz"
    output:
        "results/trimmed/{sample}.fastq.gz"
    shell:
        "bbmap\bbduk.sh in={input} out={output} ref=barcode_adaptor/adapters.fa ktrim=r k=23 mink=11 hdist=1 tpe tbo qtrim=r trimq=10"
     