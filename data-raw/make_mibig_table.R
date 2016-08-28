#' Read hmmdomtbl file
#'
#' hmmer produces domaintable outputs withthe --hmmdomtbl flag. Returns a datatalbe iwth the following headers:
#'
#' \describe{
#'   \item{target_name}{The name of the target sequence or profile}
#'   \item{target_accession}{Accession of the target sequence or profile, or ’-’ if none is available.}
#'   \item{tlen}{Length of the target sequence or profile, in residues. This (together with the query length) is
#'              useful for interpreting where the domain coordinates (in subsequent columns) lie in the sequence.}
#'   \item{query_name}{Name of the query sequence or profile.}
#'   \item{query_accession}{Accession of the target sequence or profile, or ’-’ if none is available}
#'   \item{qlen}{ Length of the query sequence or profile, in residues.}
#'   \item{evalue}{E-value of the overall sequence/profile comparison (including all domains).}
#'   \item{score}{Bit score of the overall sequence/profile comparison (including all domains), inclusive of a
#'                null2 bias composition correction to the score.}
#'   \item{bias}{ The biased composition score correction that was applied to the bit score.}
#'   \item{number}{This domain’s number (1..ndom).}
#'   \item{ndom}{ The total number of domains reported in the sequence, ndom}
#'   \item{c.evalue}{ he “conditional E-value”, a permissive measure of how reliable this particular domain may be.}
#'   \item{i.evalue}{ The “independent E-value”, the E-value that the sequence/profile comparison would have received if this
#'                    were the only domain envelope found in it, excluding any others.}
#'   \item{score_domain}{ The bit score for this domain.}
#'   \item{bias_domain}{ The biased composition (null2) score correction that was applied to the domain bit score.}
#'   \item{from_hmm}{ The start of the MEA alignment of this domain with respect to the profile, numbered 1..N for a profile of N consensus positions.}
#'   \item{to_hmm}{ The end of the MEA alignment of this domain with respect to the profile, numbered 1..N for a profile of N consensus positions.}

#'   \item{from_aln}{ The start of the MEA alignment of this domain with respect to the sequence,numbered 1..L for a sequence of L residues.}
#'   \item{to_aln}{ to (ali coord): The end of the MEA alignment of this domain with respect to the sequence, numbered 1..L for a sequence of L residues.}
#'   \item{from_env}{ The start of the domain envelope on the sequence, numbered 1..L for a sequence
#'                    of L residues. The envelope defines a subsequence for which their is substantial probability
#'                    mass supporting a homologous domain, whether or not a single discrete alignment can be identified.
#'                    The envelope may extend beyond the endpoints of the MEA alignment, and in fact often does, for
#'                    weakly scoring domains.}
#'   \item{to_env}{ The end of the domain envelope on the sequence, numbered 1..L for a sequence of L residues.}
#'   \item{acc}{  The mean posterior probability of aligned residues in the MEA alignment; a measure of how reliable the overall alignment is
#'                  (from 0 to 1, with 1.00 indicating a completely reliable alignment according to the model).}
#'   \item{description_of_target}{  The remainder of the line is the target’s description line, as free text.}
#'
#' @seealso \url{http://eddylab.org/software/hmmer3/3.1b2/Userguide.pdf}
#' @export
load_hmmdomtbl <- function(fname) {

  colnames <- c("target_name", "target_accession", "tlen", "query_name", "query_accession", "qlen", "evalue", "score", "bias",
                "number", "ndom", "c.evalue", "i.evalue",  "score_domain", "bias_domain", "from_hmm", "to_hmm",  "from_aln", "to_aln", "from_env", "to_env", "acceptance", "description")

  read.table(fname, col.names = colnames, stringsAsFactors = FALSE)
}
#' Pull out a sequence fram a DNAStringset given a name, start and stop position
#'
#' @importFrom Biostrings subseq
extract_DNA_sequence <- function(dnastrings, seqname, start, end) {
  seq <- dnastrings[[seqname]]
  seq <- subseq(seq, start=start, end=end)
  return(as.character(seq))
}
#' Create a sequence table from an HMMM file and an FNA file
#'
#' In order to obtain the DNA sequences corresponding to a conserved Domain we must
#' match the HMM information back to the gene names
#'
#' @importFrom Biostrings readDNAStringSet
#' @export
create_Mibig_table <- function(fnafile, domtblfile) {
  tbl   <- load_hmmdomtbl(domtblfile)
  tbl$dnastart <- 3 * (tbl$from_env - 1) - 1 #(n-1 * 3) -1
  tbl$dnaend   <- 3 * tbl$to_env             #(n * 3)

  genes <- readDNAStringSet(fnafile)
  dnasequences <- mapply(
    function(seqname, start, end){ extract_DNA_sequence(genes, seqname=seqname, start=start, end=end)},
    tbl$target_name, tbl$from_env, tbl$to_env)

  tbl$PFAM_ID <- gsub("\\..*$", "", tbl$query_accession)
  tbl$Mibig_ID <- as.character(lapply(tbl$target_name, function(s){strsplit(s,"_")[[1]][[1]]}))
  tbl$gene_ID <- as.character(lapply(tbl$target_name, function(s){strsplit(s,"_")[[1]][[2]]}))
  tbl$protein_accession <- as.character(lapply(tbl$target_name, function(s){strsplit(s,"_")[[1]][[3]]}))

  tbl$dnasequence <- as.character(dnasequences)
  return(tbl)
}

library(Biostrings)
library(dplyr)
library(devtools)
library(data.table)

print("Generating the Mibig data.")
genetbl <- create_Mibig_table(fnafile="genes/genes.fna", domtblfile = "proteins/proteinhmmtbl.txt")
mibigdomains <- genetbl %>% select(PFAM_ID,   Mibig_ID, gene_ID, protein_accession, dnastart, dnaend, dnasequence) %>%
  arrange(PFAM_ID< Mibig_ID, protein_accession, dnastart)

mibigdomains <- data.table(mibigdomains)
setkey(mibigdomains, "PFAM_ID")


print("Saving the Mibig data.")
devtools::use_data(mibigdomains, pkg = "../", overwrite = TRUE)
