################################################################################
# Use testthat to test basic mibig_refseq_creation
################################################################################
library("esnapd"); packageVersion("esnapd")
library("Biostrings"); packageVersion("Biostrings")
library("data.table"); packageVersion("data.table")
library("testthat"); packageVersion("testthat")
context('Checking Mibig Refseq Creation')


test_that("create_refseq_Mibig works", {
  refseq1 <- create_refseq_Mibig(pfamid = "PF00005")
  expect_is(refseq1, "RefSeq")
  expect_error(create_refseq_Mibig(pfamid = "PF000"), "This pfamid is not found in the mibig dataset")
})

