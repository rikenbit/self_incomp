# options(repos="https://cran.ism.ac.jp/")
# if (!requireNamespace("BiocManager", quietly = TRUE))
# install.packages("BiocManager",update = TRUE)
# BiocManager::install("archR",update = FALSE)
install.packages("remotes")
remotes::install_github("snikumbh/archR")
library(archR)

#### Examples####
fname <- system.file("extdata", 
    "example_data.fa", 
    package = "archR", 
    mustWork = TRUE)

# mononucleotides feature matrix
rawSeqs <- prepare_data_from_FASTA(fasta_fname = fname,
                        sinuc_or_dinuc = "sinuc")

# dinucleotides feature matrix
rawSeqs <- prepare_data_from_FASTA(fasta_fname = fname,
                        sinuc_or_dinuc = "dinuc")
                       
# FASTA sequences as a Biostrings::DNAStringSet object
rawSeqs <- prepare_data_from_FASTA(fasta_fname = fname,
                        raw_seq = TRUE)
#### Sample Data####
fname <- ("data/test.fa")
# mononucleotides feature matrix
rawSeqs <- prepare_data_from_FASTA(fasta_fname = fname,
                        sinuc_or_dinuc = "sinuc")

# dinucleotides feature matrix
rawSeqs <- prepare_data_from_FASTA(fasta_fname = fname,
                        sinuc_or_dinuc = "dinuc")
                       
# FASTA sequences as a Biostrings::DNAStringSet object
rawSeqs <- prepare_data_from_FASTA(fasta_fname = fname,
                        raw_seq = TRUE)