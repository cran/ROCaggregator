globalVariables(".")

#' Shift a vector left or right according to the value provided
#'
#' @param x the vector
#' @param n shift
#'
#' @return the vector shifted
#' @export
#'
#' @examples
#' shift_vector(c(1,2,3,4), 1)
#' shift_vector(c(1,2,3,4), -1)
shift_vector <- function(x, n) if (n == 0) x else c(tail(x, n), head(x, -n))

#' Compute the global confusion matrix from the FPR and TPR obtained from each node
#'
#' @param fpr list - False positive rates for each individual ROC
#' @param tpr list - True positive rates for each individual ROC
#' @param thresholds list - Thresholds used to compute the fpr and tpr
#' @param negative_count list - Total number of samples corresponding to the
#' negative case
#' @param total_count list - Total number of samples
#' @param descending thresholds in descending order?
#'
#' @return global confusion matrix and thresholds
#' @export
#' @importFrom magrittr %>%
#' @importFrom utils head tail
partial_cm <- function(fpr, tpr, thresholds, negative_count, total_count, descending=FALSE) {
  # Arrange the necessary parameters
  node_indexes <- rep.int(1:(length(thresholds)), c(lengths(thresholds)))
  thresholds_stack <- unlist(thresholds)
  shift <- 0
  acc <- matrix(0, length(thresholds_stack), 2)

  for (i in seq_along(thresholds)){
    node_thresholds <- thresholds[[i]]
    # Shift the index and thresholds according to the node
    # Necessary to guarantee that the current node thresholds
    # are always consider first when sorted
    node_indexes_shifted <- shift_vector(node_indexes, shift)
    thresholds_stack_shifted <- shift_vector(thresholds_stack, shift)
    # Sort all the thresholds
    sorted_thresholds_ix <- sort(thresholds_stack_shifted, decreasing = TRUE, index.return = TRUE)$ix
    # Build an index list based on the i node values by doing a cumulative sum
    sum <- cumsum((node_indexes_shifted == i)[sorted_thresholds_ix]) + 1
    # Calculating and sort by threshold the tp and fp for the node
    cm <- sweep(cbind(fpr[[i]], tpr[[i]]), MARGIN=2, c(negative_count[[i]], total_count[[i]] - negative_count[[i]]), '*')
    sorted_cm_ix <- sort(node_thresholds, decreasing = TRUE, index.return = TRUE)$ix
    cm_sorted <- cm[sorted_cm_ix,]
    # Add the tp and fp values to the global array
    acc <- acc + (rbind(c(cm_sorted[1,1], cm_sorted[1,2]), cm_sorted))[sum,]
    # Increment the shift
    shift <- shift - length(node_thresholds)
  }
  # Remove duplicated thresholds
  thresholds_stack_sorted <- sort(thresholds_stack, decreasing = TRUE)
  unique_thresholds <- !duplicated(thresholds_stack_sorted)
  # Provide the result following the order indicated by the 'descending' argument
  result <- list(
    "cm" = acc[unique_thresholds,] %>% { if (descending) . else apply(., 2, rev) },
    "thresholds" = thresholds_stack_sorted[unique_thresholds] %>% { if (descending) . else rev(.) }
  )
}
