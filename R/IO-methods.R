#' Load Blast Tabular Outputl Files.
#'
#' Loading blast data into R and returning a \code{\link{[data.table] data.table}} and
#' creating an index on the indexcolumns
#' keys on the QueryI and SubjectID
#'
#' @param blastfile. Required. Path location of a blastfile.
#' @param indexcols. Optional. List of columnvalues to set the index on.
#' @importFrom data.table fread
#' @importFrom data.table setkeyv
#'
#' @export
load_blast <- function(blastfile, indexcols = c("QueryID")) {
  column_names <- c("QueryID",  "SubjectID", "Perc.Ident",
                    "Alignment.Length", "Mismatches", "Gap.Openings", "Q.start", "Q.end",
                    "S.start", "S.end", "E", "Bits")

  # check index columns
  for (ival in indexcols) {
    if (!ival %in% column_names) {
      stop(paste("bad values in the indexcols. only valid column names can be used:", paste(column_names, collapse = " ")))
    }
  }

  dt <- fread(input=blastfile, header=FALSE, col.names = column_names)
  setkeyv(dt, cols = indexcols)

  return(dt)
}
#' Read Useach/Vsearch UC Files
#'
#' UC files are output from Robert Edgar's USEARCH program as well as the USEARCH clone,
#' VSEARCH. The UC output file can be used as outpuf for blast-like searches as well as
#' clustering. Each of those has slighly different usages of the output columns and users are
#' encouraged to consult the documentation \url{http://drive5.com/usearch/manual/opt_uc.html}.
#' This function imports all fields except columns 6 and 7 which are dummy columns preserved in
#' the UC file for backwards compatability.
#'
#'
#' @importFrom data.table fread
#' @seealso \url{http://drive5.com/usearch/manual/opt_uc.html}
#' @export
load_uc_file <- function(ucfile) {
  columns <- c("record.type", "cluster.number", "seqlength.or.clustersize", "percent.id", "strand", "compressed.alignment", "QueryID", "TargetID")
  dt <- fread(ucfile, drop = c(6,7))
  names(dt) <- columns
  return(dt)
}
