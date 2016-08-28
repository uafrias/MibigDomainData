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
