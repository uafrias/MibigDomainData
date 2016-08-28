#' Create A RefSeq from Mibig Data
#'
#' Use a PFAM Id to subset the Mibig data and create a reference sequence.
#'
#' @param pfamid. Required. PFAM-A id corresponding to Mibig Reference data.
#'
#' @importFrom Biostrings DNAString
#' @importFrom Biostrings DNAStringSet
#' @export
create_refseq_Mibig <- function(pfamid) {

  #Load the reference data
  data("mibigdomains")

  # check if the domain is found
  if (!pfamid %in% unique(mibigdomains$PFAM_ID)) stop("This pfamid is not found in the mibig dataset")
  targetdomains <- copy(mibigdomains[PFAM_ID == pfamid])

  #remove the mibigdomains from the global namespace
  rm(list = c("mibigdomains"), pos = ".GlobalEnv")

  #create  the seqid columns
  targetdomains$seqid <- as.character(
    mapply(
      function(x,y,z,a){ paste(x,y,z,a, sep="_")},
      targetdomains$Mibig_ID,
      targetdomains$protein_accession,
      targetdomains$dnastart,
      targetdomains$dnaend))

  sequences <- DNAStringSet(lapply(targetdomains$dnasequence, DNAString))
  names(sequences) <- targetdomains$seqid
  tokeep <- names(targetdomains)[names(targetdomains) != "dnasequence"]

  return(refseq(refdata = targetdomains[ ,tokeep, with=FALSE], refseq=sequences))
}

