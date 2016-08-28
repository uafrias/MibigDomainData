################################################################################
# Use testthat to test basic vsearch global
################################################################################
library("esnapd"); packageVersion("esnapd")
library("Biostrings"); packageVersion("Biostrings")
library("data.table"); packageVersion("data.table")
library("testthat"); packageVersion("testthat")
context('Checking basic Blasting works')


generate_seq <- function(seqlength=200) {
  paste(sample(c("C","G","T","A"), size=seqlength, replace=TRUE), collapse = "")
}

test_that("run_vserach_global works on DNAStringSets", {
  s1 <- "GCTCATTCCCAGAATTTGTGGCATTTTGTGTGGCGTCTTATTATCGGATATTTAGATTTTAACTGTAATAAGAACAGGGATAACACGATGCTGAGCCGCAAGCGCCGGGCGAGCAGCATATCCAGCCGGCAGGACGAGGATCCGCTGCAGCTGGACGACTCGACGCCGGAGCAGTCACCGGTGCAGCAGACGACGACACAATCGGCGCGAAAAAAGCGCCGTCTCGATCCCACAGAACTGTGCCAGCAATTGTACGATTCCATAAGGAACATAAAGAAGGAGGACGGTTCAATGCTGTGCGACACCTTCATCCGCGTGCCGAAGCGCCGGCAAGAGCCCTCGTACTATGA"
  refs1 <- DNAStringSet(list(DNAString(s1), DNAString("CTCTTTTTCGTGTGTGTGTGTGTTGTGTGT")))
  refs2 <- DNAStringSet(list(DNAString(s1), DNAString("CTCTTTTTCGTGTGTGGTGTGTGTGTGTGT")))
  expect_error(run_vsearch_global(refs1,refs2), "DNAStringSets must have names")
  names(refs1) <- c("test1", "test2")
  names(refs2) <- c("test3", "test4")

  blasttable <- run_vsearch_global(refs1,refs2)
  expect_is(blasttable, "data.table")
})


