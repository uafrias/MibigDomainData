#' RefSeq Class
#'
#' Class to hold sequence data and
#'
#'
#' @importClassesFrom Biostrings DNAStringSet
#' @importClassesFrom data.table data.table
#' @name RefSeq
#' @rdname RefSeq-class
#' @exportClass RefSeq
setClass(Class="RefSeq",
         representation=representation(
           refdata="data.table",
           refseq = "DNAStringSet"))
