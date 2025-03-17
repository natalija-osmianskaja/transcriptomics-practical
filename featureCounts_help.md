# featureCount

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

## Links
https://subread.sourceforge.net/featureCounts.html
https://subread.sourceforge.net/SubreadUsersGuide.pdf
