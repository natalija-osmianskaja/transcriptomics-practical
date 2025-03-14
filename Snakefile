# find input files that match a specified pattern
# {sample} is a wildcard which represents a variable part of the filename
RNA_SAMPLE_DATA = glob_wildcards("resources/RNA-seq-sample-data/{sample}.fastq.gz").sample

rule all:
    input:
        #expand("results/fastqc/{sample}_fastqc.html", sample=RNA_SAMPLE_DATA)
        "results/multiqc/multiqc_report.html"
        #expand("data_output_bbduk_trimed/{sample}_bbduk.fastq", sample=RNA_SAMPLE_DATA)

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