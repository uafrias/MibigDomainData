################################################################################
# Use testthat to test basic blasting
################################################################################
library("esnapd"); packageVersion("esnapd")
library("Biostrings"); packageVersion("Biostrings")
library("data.table"); packageVersion("data.table")
library("testthat"); packageVersion("testthat")
context('Checking basic Blasting works')


generate_seq <- function(seqlength=200) {
  paste(sample(c("C","G","T","A"), size=seqlength, replace=TRUE), collapse = "")
}

test_that("run-blast works on DNAStringSets", {
  s1 <- "GCTCATTCCCAGAATTTGTGGCATTTTGTGTGGCGTCTTATTATCGGATATTTAGATTTTAACTGTAATAAGAACAGGGATAACACGATGCTGAGCCGCAAGCGCCGGGCGAGCAGCATATCCAGCCGGCAGGACGAGGATCCGCTGCAGCTGGACGACTCGACGCCGGAGCAGTCACCGGTGCAGCAGACGACGACACAATCGGCGCGAAAAAAGCGCCGTCTCGATCCCACAGAACTGTGCCAGCAATTGTACGATTCCATAAGGAACATAAAGAAGGAGGACGGTTCAATGCTGTGCGACACCTTCATCCGCGTGCCGAAGCGCCGGCAAGAGCCCTCGTACTATGA"
  refs1 <- DNAStringSet(list(DNAString(s1), DNAString("CTCTTTTTCGTGTGTGTGTGTGTTGTGTGT")))
  refs2 <- DNAStringSet(list(DNAString(s1), DNAString("CTCTTTTTCGTGTGTGGTGTGTGTGTGTGT")))
  expect_error(run_blast(refs1,refs2), "DNAStringSets must have names")
  names(refs1) <- c("test1", "test2")
  names(refs2) <- c("test3", "test4")

  blasttable <- run_blast(refs1,refs2)
  expect_is(blasttable, "data.table")
})

test_that("run-blast can use GNU Parallel", {
  seqs1 <- lapply(1:100, function(x) {DNAString(x=generate_seq())})
  seqs1 <- DNAStringSet(seqs1)
  names(seqs1) <- paste("Seq_", 1:100)
  blasttable <- run_blast(seqs1, seqs1, parallel = TRUE)
  expect_is(blasttable, "data.table")
})

