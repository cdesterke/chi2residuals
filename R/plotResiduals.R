#' Plot standardized residuals from a chi-squared test
#'
#' This function creates a heatmap-style visualization of standardized residuals from a chi-squared test,
#' highlighting significant cells (p < 0.05) with custom labels and colors.
#'
#' @param residuals A data frame containing the residuals, p-values, and labels. Must include columns: \code{resid}, \code{pval}, \code{label}, and the two categorical variables.
#' @param col1 A character string specifying the variable to use on the x-axis.
#' @param col2 A character string specifying the variable to use on the y-axis.
#' @param themeSize Numeric. Base font size for the plot theme.
#' @param labelSize Numeric. Font size for the residual labels.
#' @param colorLow Color for negative residuals.
#' @param colorHigh Color for positive residuals.
#' @param colorLabels Color for the text labels.
#' @param title Title of the plot.
#'
#' @return A ggplot object.
#' @examples
#' data(patients)
#' sub <- preProcess(patients, v1 = "AgeGroup", v2 = "PrimarySymptom")
#' residuals <- computeResiduals(sub, col1 = "AgeGroup", col2 = "PrimarySymptom")
#' plotResiduals(residuals,
#'               col1 = "PrimarySymptom",
#'               col2 = "AgeGroup",
#'               themeSize = 20,
#'               labelSize = 4.5,
#'               colorLow = "pink",
#'               colorHigh = "purple",
#'               colorLabels = "white",
#'               title = "Significant residuals p<0.05")
#'
#' @export
plotResiduals <- function(residuals,
                          col1 = "PrimarySymptom",
                          col2 = "AgeGroup",
                          themeSize = 16,
                          labelSize = 4,
                          colorLow = "cyan",
                          colorHigh = "purple",
                          colorLabels = "gold",
                          title = "Significant residuals p<0.05") {

  if (!requireNamespace("ggplot2", quietly = TRUE)) stop("Package 'ggplot2' is required.")
  if (!requireNamespace("scales", quietly = TRUE)) stop("Package 'scales' is required.")
  if (!requireNamespace("dplyr", quietly = TRUE)) stop("Package 'dplyr' is required.")

  library(ggplot2)
  library(scales)
  library(dplyr)

  required_cols <- c(col1, col2, "resid", "label", "pval")
  if (!all(required_cols %in% names(residuals))) {
    stop("❌ Required columns are missing from the residuals dataframe.")
  }

  ggplot(residuals, aes_string(x = col1, y = col2, fill = "resid")) +
    geom_tile(color = "white") +
    geom_text(
      data = residuals %>% filter(pval < 0.05),
      aes_string(x = col1, y = col2, label = "label"),
      size = labelSize,
      fontface = "bold",
      color = colorLabels
    ) +
    scale_fill_gradientn(
      colours = c(colorLow, "grey90", colorHigh),
      values = rescale(c(-max(abs(residuals$resid), na.rm = TRUE), 0, max(abs(residuals$resid), na.rm = TRUE))),
      limits = c(-max(abs(residuals$resid), na.rm = TRUE), max(abs(residuals$resid), na.rm = TRUE)),
      name = "Residuals\nChi²"
    ) +
    theme_minimal(base_size = themeSize) +
    theme(
      axis.text.x = element_text(angle = 90, hjust = 1),
      legend.position = "right"
    ) +
    labs(title = title) +
    coord_flip()
}
