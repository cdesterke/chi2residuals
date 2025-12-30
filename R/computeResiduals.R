#' Compute standardized residuals and p-values from a chi-squared test
#'
#' This function performs a chi-squared test on two categorical variables from a data frame,
#' and returns a data frame of standardized residuals, associated p-values, and formatted labels.
#'
#' @param sub A data frame containing the variables to test.
#' @param col1 A character string specifying the first variable (e.g., row variable).
#' @param col2 A character string specifying the second variable (e.g., column variable).
#'
#' @return A data frame with columns: \code{col1}, \code{col2}, \code{resid}, \code{pval}, and \code{label}.
#' @examples
#' data(patients)
#' sub <- preProcess(patients, v1 = "AgeGroup", v2 = "PrimarySymptom")
#' residuals <- computeResiduals(sub, col1 = "AgeGroup", col2 = "PrimarySymptom")
#' head(residuals)
#'
#' @export
computeResiduals <- function(sub, col1 = "AgeGroup", col2 = "PrimarySymptom") {

  # --- Vérifications préliminaires ---
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is required but not installed.")
  }

  data <- as.data.frame(sub)

  if (!(col1 %in% names(data)) || !(col2 %in% names(data))) {
    stop("❌ One or both columns do not exist in the dataset.")
  }

  if (!is.character(data[[col1]]) || !is.character(data[[col2]])) {
    stop("⚠️ Both columns must be of type character.")
  }

  if (any(is.na(data[[col1]])) || any(is.na(data[[col2]]))) {
    stop("🚫 Missing values detected in one or both columns.")
  }

  message("✅ Columns are valid: character type and no missing values.")

  # --- Table de contingence ---
  tab <- table(data[[col1]], data[[col2]])
  chi2 <- chisq.test(tab)

  print(tab)
  print(chi2)

  # --- Résidus standardisés ---
  residuals_df <- as.data.frame(as.table(chi2$residuals))
  colnames(residuals_df) <- c(col1, col2, "resid")
  residuals_df$resid <- as.numeric(as.character(residuals_df$resid))

  # --- Calcul p-value + label multi-ligne ---
  residuals_df <- residuals_df %>%
    dplyr::mutate(
      pval = 2 * (1 - pnorm(abs(resid))),
      label = ifelse(
        pval < 0.05,
        paste0(
          "r=", sprintf("%.2f", resid), "\n",
          "p=", sprintf("%.3f", pval)
        ),
        ""
      )
    )

  print(residuals_df)
  return(residuals_df)
}


