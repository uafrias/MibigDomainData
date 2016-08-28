################################################################################
# Use testthat to test basic RefSes construction
################################################################################
library("esnapd"); packageVersion("esnapd")
library("Biostrings"); packageVersion("Biostrings")
library("data.table"); packageVersion("data.table")
library("testthat"); packageVersion("testthat")
context('Checking basci RefSeq class construction')



test_that("RefSeqs can be constructed and basic violations are caught", {
  dt  <- data.table(seqid=c("seq1","seq2"), info=c("cool seq", "another cool seq"))
  refs <- DNAStringSet(list(DNAString("ACTCATC"), DNAString("CTCTTTTTC")))
  # names mismatch
  expect_error(refseq(refdata=dt, refseq=refs), "refseq sequences must be named.")
  #add wrong names
  names(refs) <- c("seq0", "seq2")
  expect_error(refseq(refdata=dt, refseq=refs), "there must be a one to one mapping of the seqid with refseq names")
  #correct names
  names(refs) <- c("seq1", "seq2")
  expect_is(refseq(refdata=dt, refseq=refs), "RefSeq")

  #use dt without eqid
  dt1 <- data.table(seqif=c("seq1","seq2"), info=c("cool seq", "another cool seq"))
  expect_error(refseq(refdata=dt1, refseq=refs), "refdata must have a column called 'seqid' ")
})
