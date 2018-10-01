setwd(normalizePath(dirname(
  R.utils::commandArgs(asValues = TRUE)$"f"
)))
source("../../scripts/h2o-r-test-setup.R")

# Tests parsing with skipped columns
test.parseSkippedColumnsNameType <- function() {
  browser()
  csvWithHeader <-
    h2o.importFile(locate("smalldata/airlines/allyears2k_headers.csv"))
  allColnames <- h2o.names(csvWithHeader)
  allTypeDict <- h2o.getTypes(csvWithHeader)
  pathHeader <- locate("smalldata/airlines/allyears2k_headers.csv")
  
  # upload file with  no header but fixed column types.
  csvWithNoHeader <-
    h2o.uploadFile(locate("smalldata/airlines/allyears2k.csv"))
  allNewColnames <- h2o.names(csvWithNoHeader)
  allNewTypeDict <- h2o.getTypes(csvWithNoHeader)
  pathNoHeader <- locate("smalldata/airlines/allyears2k.csv")
  
  browser()
  skip_front <- c(1)
  skip_end <- c(h2o.ncol(csvWithHeader))
  set.seed <- 12345
  onePermute <- sample(h2o.ncol(csvWithHeader))
  skipall <- onePermute
  skip50Per <- onePermute[1:floor(h2o.ncol(csvWithHeader) * 0.5)]

  # skip 50% of the columns randomly
  print("Testing skipping 50% of columns")
  assertCorrectSkipColumnsNamesTypes(csvWithHeader, pathNoHeader, skip50Per, allColnames, allTypeDict,0, h2o.getTypes(csvWithHeader)) 
  assertCorrectSkipColumnsNamesTypes(csvWithHeader, pathNoHeader, skip50Per, allColnames, allTypeDict,1, h2o.getTypes(csvWithHeader)) 
  assertCorrectSkipColumnsNamesTypes(csvWithHeader, pathNoHeader, skip50Per, allColnames, allTypeDict,2, h2o.getTypes(csvWithHeader)) 
}

doTest("Test Orc Parse with skipped columns", test.parseSkippedColumnsNameType)