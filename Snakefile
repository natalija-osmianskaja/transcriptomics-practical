# find input files that match a specified pattern
# {sample} is a wildcard which represents a variable part of the filename
RNA_SAMPLE_DATA = glob_wildcards("resources/RNA-seq-sample-data/{sample}.fastq.gz").sample
TRIMMED_DATA = glob_wildcards("results/trimmed/{trimmed}_R1_001.fastq.gz").trimmed
COLLIBRI_DATA = glob_wildcards("resources/RNA-seq-sample-data/Collibri_{collibri}_R1_001.fastq.gz").collibri
KAPA_DATA = glob_wildcards("resources/RNA-seq-sample-data/KAPA_{KAPA}_R1_001.fastq.gz").KAPA

#print(TRIMMED_DATA)
#print(expand("results/trimmed/{trimmed}_R1_001.fastq.gz", trimmed=TRIMMED_DATA))


rule all:
    input:
        # fastqc
        expand("results/fastqc/{sample}_fastqc.html", sample=RNA_SAMPLE_DATA),
        # multiqc
        "results/multiqc/multiqc_report.html",
        # bbduk
        expand("results/trimmed/{sample}.fastq.gz", sample=RNA_SAMPLE_DATA),
        # fastqc_trimmed
        expand("results/fastqc_trimmed/{sample}_fastqc.html", sample=RNA_SAMPLE_DATA),
        # multiqc_trimmed
        "results/multiqc_trimmed/multiqc_report.html",
        # star_genome_index
        "results/genome_indices/Genome",
        # star_mapping
        expand("results/star_mapping/{trimmed}_Aligned.sortedByCoord.out.bam", trimmed=TRIMMED_DATA),
        # index_bam
        expand("results/samtools_indexed/{trimmed}.bam.bai", trimmed=TRIMMED_DATA),
        # featureCounts_s1
        expand("results/feature_count_s1/{trimmed}.txt", trimmed=TRIMMED_DATA),
        # featureCounts_s2
        expand("results/feature_count_s2/{trimmed}.txt", trimmed=TRIMMED_DATA),
        # analyze_features
         expand("results/feature_count_choice/{trimmed}.txt", trimmed=TRIMMED_DATA),
        # collibri_matrix
        "results/gene_matrix/Collibri.txt",
         # kapa_matrix
        "results/gene_matrix/KAPA.txt"       

rule fastqc:
    input:
        "resources/RNA-seq-sample-data/{sample}.fastq.gz"
    output:
        "results/fastqc/{sample}_fastqc.html"
    shell:
        "fastqc -o results/fastqc {input}"

rule multiqc:
    input:
        expand("results/fastqc/{sample}_fastqc.html", sample=RNA_SAMPLE_DATA),
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
        expand("results/fastqc_trimmed/{sample}_fastqc.html", sample=RNA_SAMPLE_DATA),
    output:
        "results/multiqc_trimmed/multiqc_report.html" 
    shell:
        "multiqc results/fastqc_trimmed -o results/multiqc_trimmed"         

rule star_genome_index:
    input:
        "resources/ref/chr19_20Mb.fa"
    output:
        "results/genome_indices/Genome",
    shell:
        """
        star/STAR \
            --runThreadN 8 \
            --runMode genomeGenerate \
            --genomeDir results/genome_indices \
            --genomeFastaFiles {input} \
            --sjdbGTFfile resources/ref/chr19_20Mb.gtf \
            --genomeSAindexNbases 11 \
            --outFileNamePrefix star
        """

rule star_mapping:
    input:
        read1="results/trimmed/{trimmed}_R1_001.fastq.gz",
        read2="results/trimmed/{trimmed}_R2_001.fastq.gz"
    output:
        "results/star_mapping/{trimmed}_Aligned.sortedByCoord.out.bam"
    # threads: 1
    shell:
        """
        star/STAR \
            --runThreadN 8 \
            --genomeDir results/genome_indices \
            --readFilesIn {input.read1} {input.read2} \
            --readFilesCommand zcat \
            --outSAMtype BAM SortedByCoordinate \
            --outFileNamePrefix results/star_mapping/{wildcards.trimmed}_
        """

rule index_bam:
    input:
        "results/star_mapping/{trimmed}_Aligned.sortedByCoord.out.bam"
    output:
        "results/samtools_indexed/{trimmed}.bam.bai"
    shell:
        "samtools index {input} -o {output}"

rule featureCounts_s1:
    input:
        bam="results/star_mapping/{trimmed}_Aligned.sortedByCoord.out.bam",
        gtf="resources/ref/chr19_20Mb.gtf"
    output:
        "results/feature_count_s1/{trimmed}.txt"    
    shell:
        "featureCounts -p -t exon -g gene_id -O -T 8 -a {input.gtf} -o {output} {input.bam} -s 1" 

rule featureCounts_s2:
    input:
        bam="results/star_mapping/{trimmed}_Aligned.sortedByCoord.out.bam",
        gtf="resources/ref/chr19_20Mb.gtf"
    output:
        "results/feature_count_s2/{trimmed}.txt"    
    shell:
        "featureCounts -p -t exon -g gene_id -O -T 8 -a {input.gtf} -o {output} {input.bam} -s 2" 

# Q: Which library in this set would be the special one and would be different from others?
# Analyze summary counts
#According to summary select the best
rule analyze_summary:
    input:
        "results/feature_count_s1/{trimmed}.txt",
        "results/feature_count_s2/{trimmed}.txt"
    output:
        "results/feature_count_choice/{trimmed}.txt"
    shell:
        "python3 scripts/calc_reads.py {input} {output}" 


# 
# 2 Count matrix - KAPA vs Colibri
# X - sample, X - Gene, 

# Q: Collect data on alignment rate per sample (look for fraction of uniquely mapped reads)      
#    Are there any differences that could be related to tissue types and/or sample preparation preparation methods?
# A

rule collibri_matrix:
    input:
        expand("results/feature_count_choice/Collibri_{collibri}.txt", collibri=COLLIBRI_DATA)
    output:
        "results/gene_matrix/Collibri.txt"    
    shell:
        "python3 scripts/calc_gene_matrix.py {input} {output}" 

rule kapa_matrix:
    input:
        expand("results/feature_count_choice/KAPA_{kapa}.txt", kapa=KAPA_DATA)
    output:
        "results/gene_matrix/KAPA.txt"   
    shell:
        "python3 scripts/calc_gene_matrix.py {input} {output}" 