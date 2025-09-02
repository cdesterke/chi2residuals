#' Preprocess a dataset by selecting two variables and removing missing values
#'
#' This function selects two specified columns from a dataset and removes rows with missing values.
#'
#' @param data A data frame. Default is \code{patients}, a sample dataset included in the package.
#' @param v1 A character string specifying the first variable to select.
#' @param v2 A character string specifying the second variable to select.
#'
#' @return A data frame with two columns and no missing values.
#' @examples
#' data(patients)
#' clean_data <- preProcess(patients, v1 = "AgeGroup", v2 = "PrimarySymptom")
#' head(clean_data)
#'
#' @export
preProcess <- function(data = patients, v1 = "AgeGroup", v2 = "PrimarySymptom") {
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is required but not installed.")
  }
  library(dplyr)

  data <- as.data.frame(data)

  sub <- data %>%
    select(all_of(c(v1, v2))) %>%
    na.omit()

  return(sub)
}
