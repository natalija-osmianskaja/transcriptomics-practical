
rule fastqc:
    input:
        "data/raw/{sample}.fastq"
    output:
        "results/fastqc_reports/{sample}_fastqc.html",
        "results/fastqc_reports/{sample}_fastqc.zip"
    conda:
        "envs/fastqc.yaml"
    shell:
        """
        mkdir -p results/fastqc_reports
        fastqc {input} --outdir results/fastqc_reports
        """