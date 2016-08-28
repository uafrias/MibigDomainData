#' Boundaries of Mibig Proteins defined by PFAM-A domains and the nucleotide sequences that encode them.
#'
#' A dataset containing the nucleotide sequences of the PFAM-A-defined proteins domains found in the Mibig dataset. The build scripts to
#' obtain the data can be found in the data-raw directory, but the basic idea is straightforward:
#'
#'  1. download the PFAM-A hmms.
#'  2. download the Mibig GBKs
#'  3. parse the Mibig GBKs and write out both Nucleotide and Protein fastas for each CDS.
#'  4. use hmmmer to obtian the boundaries of the PFMA hmms on the proteins
#'  5. extract the nucleotide seqeunces corresponding to protein domains and save the file.
#'  6. extract molecule info and biosynthetic class info from the JSON files
#'  7. merge and save as an RDA file.
#'
#'  The resulting dataset is provided as a table with the following fields
#'
#' @format A data frame with 23362 rows and 9 variables:
#' \describe{
#'   \item{PFAM_ID}{PFAM accession id}
#'   \item{Mibig_ID}{Mibig accession id}
#'   \item{gene_ID}{id of gene obtained from the mibig CDS feature table.}
#'   \item{protein_accession}{accession of the CDS obtained from teh Mibig feature table}
#'   \item{dnastart}{beginning of the DNA region encoding the protein domain of interest}
#'   \item{dnaend}{end of the DNA region encoding the protein domain of interest}
#'   \item{dnasequence}{the nucleotide sequence corresponding to the PFAM domain of interest}
#'   \item{biosynthetic_class}{the nucleotide sequence corresponding to the PFAM domain of interest}
#'   \item{molecule}{the molecule encoded by this cluster}
#' }
#' @source \url{http://mibig.secondarymetabolites.org/}
#' @source \url{http://pfam.xfam.org/}
"mibigdomains"

