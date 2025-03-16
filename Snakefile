# find input files that match a specified pattern
# {sample} is a wildcard which represents a variable part of the filename
RNA_SAMPLE_DATA = glob_wildcards("resources/RNA-seq-sample-data/{sample}.fastq.gz").sample

rule all:
    input:
        # for fastqc
        #expand("results/fastqc/{sample}_fastqc.html", sample=RNA_SAMPLE_DATA)
        # for multiqc
        #"results/multiqc/multiqc_report.html"
        # for bbduk
        #expand("results/trimmed/{sample}.fastq.gz", sample=RNA_SAMPLE_DATA)
        # for fastqc_trimmed
        #expand("results/fastqc_trimmed/{sample}_fastqc.html", sample=RNA_SAMPLE_DATA)
        # for multiqc_trimmed
        "results/multiqc_trimmed/multiqc_report.html" 
 
rule fastqc:
    input:
        "resources/RNA-seq-sample-data/{sample}.fastq.gz"
    output:
        "results/fastqc/{sample}_fastqc.html"
    shell:
        "fastqc -o results/fastqc {input}"

rule multiqc:
    input:
        expand("results/fastqc/{sample}_fastqc.html", sample=RNA_SAMPLE_DATA)
    output:
        "results/multiqc/multiqc_report.html" 
    shell:
        "multiqc results/fastqc -o results/multiqc"      

rule bbduk:
    input:
        "resources/RNA-seq-sample-data/{sample}.fastq.gz"
    output:
        "results/trimmed/{sample}.fastq.gz"
    shell:
        "bbmap/bbduk.sh in={input} out={output} ref=resources/barcode_adaptor/adapters.fa ktrim=r k=23 mink=11 hdist=1 tpe tbo qtrim=r trimq=10"

rule fastqc_trimmed:
    input:
        "results/trimmed/{sample}.fastq.gz"
    output:
        "results/fastqc_trimmed/{sample}_fastqc.html"
    shell:
        "fastqc -o results/fastqc_trimmed {input}"     

rule multiqc_trimmed:
    input:
        expand("results/fastqc_trimmed/{sample}_fastqc.html", sample=RNA_SAMPLE_DATA)
    output:
        "results/multiqc_trimmed/multiqc_report.html" 
    shell:
        "multiqc results/fastqc_trimmed -o results/multiqc_trimmed"            