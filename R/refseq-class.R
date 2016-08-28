#' The Refseq Class
#'
#' The Refseq class holds sequence information and data about those sequences. This
#' function creates that class and enforces the one-to-one mapping betweed the 'seqid'
#' column of refdata and the names of the dan sequences in the reference database.
#'
#' @param refdata. Required. A \code{\link[data.table]{data.table}} with serveral restictions.
#' It must contain a column named "seqid" and that value must contain unique names that match identically to
#' the names of the sequence in the refseq input.
#' 'seqid' and
#'
#' @param refseq. Required. A \code{\link[Biostrings]{DNAStringSet}} whose names must match the refdata 'seqid' column.
#' @export
#'
refseq <- function(refdata, refseq) {
  if (!is(refseq, "DNAStringSet"))  stop("refseq must be a DNAStringSet")
  if (!is(refdata, "data.table"))   stop("refdata must be a data.table")
  if (!"seqid" %in% names(refdata)) stop("refdata must have a column called 'seqid' ")
  if (is.null(names(refseq)))                         stop("refseq sequences must be named.")

  seqnames1 <- sort(names(refseq))
  seqnames2 <- sort(refdata$seqid)
  if (length(seqnames2) != length(unique(seqnames2))) stop("the refdata seqid must contain unique values")
  if (!isTRUE(all.equal(seqnames1, seqnames2)))       stop("there must be a one to one mapping of the seqid with refseq names")

  new("RefSeq", refdata=refdata, refseq=refseq)
}
