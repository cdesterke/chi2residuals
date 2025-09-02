#' Plot a network of significant residuals from a chi-squared test
#'
#' This function creates a bipartite network graph using \code{igraph}, where nodes represent two categorical variables
#' and edges represent residuals from a chi-squared test. Edge color and width reflect the direction and magnitude of residuals.
#'
#' @param residuals A data frame containing residuals, p-values, and the two categorical variables.
#' @param var1 A character string specifying the first variable (e.g., row variable).
#' @param var2 A character string specifying the second variable (e.g., column variable).
#' @param node_colors A named vector of colors for the two node types. Names must match \code{var1} and \code{var2}.
#' @param edge_colors A named vector of colors for edge types: \code{positive}, \code{negative}, and \code{nonsignificant}.
#'
#' @return A network plot is drawn to the current graphics device.
#' @examples
#' data(patients)
#' sub <- preProcess(patients, v1 = "AgeGroup", v2 = "PrimarySymptom")
#' residuals <- computeResiduals(sub, col1 = "AgeGroup", col2 = "PrimarySymptom")
#' plotNet(residuals,
#'         var1 = "AgeGroup",
#'         var2 = "PrimarySymptom",
#'         node_colors = c(AgeGroup = "green", PrimarySymptom = "skyblue"),
#'         edge_colors = c(positive = "blue", negative = "red", nonsignificant = "lightgrey"))
#'
#' @export
plotNet <- function(residuals,
                    var1 = "AgeGroup",
                    var2 = "PrimarySymptom",
                    node_colors = c(var1 = "orange", var2 = "lightblue"),
                    edge_colors = c(positive = "blue", negative = "red", nonsignificant = "grey")) {

  # Load required packages
  if (!requireNamespace("igraph", quietly = TRUE)) stop("Package 'igraph' is required.")
  if (!requireNamespace("dplyr", quietly = TRUE)) stop("Package 'dplyr' is required.")
  if (!requireNamespace("scales", quietly = TRUE)) stop("Package 'scales' is required.")
  library(igraph)
  library(dplyr)
  library(scales)

  # Check required columns
  required_cols <- c(var1, var2, "resid", "pval")
  if (!all(required_cols %in% names(residuals))) {
    stop("❌ The residuals dataframe must contain: ", paste(required_cols, collapse = ", "))
  }

  # Create nodes
  nodes <- unique(c(residuals[[var1]], residuals[[var2]]))
  node_type <- ifelse(nodes %in% residuals[[var1]], var1, var2)
  node_color <- ifelse(node_type == var1, node_colors[[var1]], node_colors[[var2]])

  # Create edges
  edges <- residuals %>%
    mutate(
      color = case_when(
        pval < 0.05 & resid > 0 ~ edge_colors["positive"],
        pval < 0.05 & resid < 0 ~ edge_colors["negative"],
        TRUE ~ edge_colors["nonsignificant"]
      ),
      width = rescale(abs(resid), to = c(1, 5))
    ) %>%
    select(from = all_of(var1), to = all_of(var2), color, width)

  # Build graph
  g <- graph_from_data_frame(edges,
                             vertices = data.frame(name = nodes, type = node_type),
                             directed = FALSE)

  # Assign node colors
  V(g)$color <- ifelse(V(g)$name %in% residuals[[var1]],
                       node_colors[[var1]],
                       node_colors[[var2]])

  # Layout: graph + legend
  layout(matrix(c(1, 2), nrow = 1), widths = c(4, 1))

  # Zone 1: Graph
  par(mar = c(1, 1, 2, 1))
  plot(
    g,
    vertex.color = V(g)$color,
    vertex.label = V(g)$name,
    vertex.label.color = "black",
    vertex.size = 30,
    vertex.label.cex = 0.9,
    edge.color = E(g)$color,
    edge.width = E(g)$width,
    edge.label = NA,
    layout = layout_with_fr,
    main = paste("Network of Significant Residuals:", var1, "vs", var2)
  )

  # Zone 2: Legend
  par(mar = c(0, 0, 0, 0))
  plot(0, type = "n", xlab = "", ylab = "", axes = FALSE)
  legend("center",
         legend = c(var1, var2,
                    "Positive Residual (p < 0.05)",
                    "Negative Residual (p < 0.05)",
                    "Non-significant"),
         col = c(node_colors[[var1]], node_colors[[var2]],
                 edge_colors["positive"], edge_colors["negative"], edge_colors["nonsignificant"]),
         pch = 15,
         pt.cex = 2,
         bty = "n",
         title = "Legend")
}
