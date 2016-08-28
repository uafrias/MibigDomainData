################################################################################
# Use testthat to test basic blasting
################################################################################
library("esnapd"); packageVersion("esnapd")
library("Biostrings"); packageVersion("Biostrings")
library("data.table"); packageVersion("data.table")
library("testthat"); packageVersion("testthat")
context('Checking basic Blasting works')


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
