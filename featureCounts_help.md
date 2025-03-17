# featureCount
The featureCounts program is designed to assign mapped reads or fragments (paired-end data) to genomic features such as genes, exons and promoters.

## Task 7.

Add a step that indexes the output bam with samtools index Add counting step with featureCounts http://bioinf.wehi.edu.au/featureCounts/

Use a command line like: “featureCounts -p -t exon -g gene_id -a annotation.gtf -o counts.txt mapping_results_PE.bam -s {1 or 2}.”

Please take note that either 1 or 2 value for -s is needed. That is due to strand specificity. Please google it ... check out https://www.ecseq.com/support/ngs/how-do-strand-specific-sequencing-protocols-work

In practice for each library test either 1 or 2. The “proper” value would the one giving higher count numbers. Which library in this set would be the special one and would be different from others?

Collect data on alignment rate per sample (look for fraction of uniquely mapped reads). Are there any differences that could be related to tissue types and/or sample preparation preparation methods?

What strand specificity settings should be used for each sample preparation method. Illustrate by one example what happens if a wrong setting are used?

NOTE on featureCounts: sorted by name bam might be needed. Use samtools sort -n. -s must be adjusted. Explore possibility to analyse multiple bams (all from the the same sample preparation method - don't mix different sample preparation methods as strandedness parameters might not match). Try to find solution to run analyses for all samples using one config file and one run (...how to deal with strandedness...) ---- Snakemake workflow up to here...--- after this point you can either do 8-11 steps as separate notebooks/ Rmarkdown files or integrate into the workflow.

## Command Line explanation
    featureCounts -p -t exon -g gene_id -a annotation.gtf -o counts.txt mapping_results_PE.bam -s {1 or 2}.
    
    featureCounts -p -t exon -g gene_id -O -T 8 -a {input.gtf} -o {output} {input.bam} -s 1

| Option | Description |
| ----------- | ----------- |
| -p | Specify that input data contain paired-end reads |
| -t | Specify the feature type(s). If more than one feature type is provided, they should be separated by ‘,’ (no space). Only rows which have a matched feature type in the provided GTF annotation file will be included for read counting. ‘exon’ by default. |
| -g | Specify the attribute type used to group features (eg. exons) into meta-features (eg. genes) when GTF annotation is provided. ‘gene id’ by default. This attribute type is usually the gene identifier. This argument is useful for the meta-feature level summarization. |
| -O | If specified, reads (or fragments) will be allowed to be assigned to more than one matched meta-feature (or feature if -f is specified). Reads/fragments overlapping with more than one meta-feature/feature will be counted more than once |
| -T | Number of the threads. The value should be between 1 and 32. |
| -a | Provide name of an annotation file. See -F option for file format. Gzipped file is accepted. |
| -o | name of the output file |


## Links
https://subread.sourceforge.net/featureCounts.html

https://subread.sourceforge.net/SubreadUsersGuide.pdf
