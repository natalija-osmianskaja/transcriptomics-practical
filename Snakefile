
rule extract_data:
    input:
        "resources/RNA-seq-sample-data/KAPA_mRNA_HyperPrep_-HBR-KAPA-100_ng_total_RNA-2_S5_L001_R1_001.fastq.gz"
    output:
        "resources/RNA-seq-sample-data/KAPA_mRNA_HyperPrep_-HBR-KAPA-100_ng_total_RNA-2_S5_L001_R1_001.fastq"
    shell:
        """
        mkdir -p data
        gzip -d {input} 
        """ 

 # Generalizing the read mapping rule
rule bwa_map:
    input:
        "ref/chr19_20Mb.fa",
        "resources/RNA-seq-sample-data/KAPA_mRNA_HyperPrep_-HBR-KAPA-100_ng_total_RNA-2_S5_L001_R1_001.fastq"
    output:
        "mapped_reads/KAPA_mRNA_HyperPrep_-HBR-KAPA-100_ng_total_RNA-2_S5_L001_R1_001.bam"
    shell:
        "bwa mem {input} | samtools view -Sb - > {output}" 

rule run_fastQC:
    input:
        "ref/chr19_20Mb.fa",
        "resources/RNA-seq-sample-data/KAPA_mRNA_HyperPrep_-HBR-KAPA-100_ng_total_RNA-2_S5_L001_R1_001.fastq"
    output:
        "mapped_reads/KAPA_mRNA_HyperPrep_-HBR-KAPA-100_ng_total_RNA-2_S5_L001_R1_001.bam"
    shell:
        "bwa mem {input} | samtools view -Sb - > {output}"           