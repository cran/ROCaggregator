#' Compute Receiver operating characteristic (ROC)
#'
#' @param fpr list - False positive rates for each individual ROC
#' @param tpr list - True positive rates for each individual ROC
#' @param thresholds list - Thresholds used to compute the fpr and tpr
#' @param negative_count vector - Total number of samples corresponding to the
#' negative case
#' @param total_count vector - Total number of samples
#'
#' @return list with the global fpr, tpr, and thresholds (decreasing)
#' @export
roc_curve <- function(fpr, tpr, thresholds, negative_count, total_count) {
  # Obtain the partial confusion matrix (tp and fp)
  result <- partial_cm(fpr, tpr, thresholds, negative_count, total_count, descending=TRUE)

  # Compute the global fpr and tpr
  fpr_global = result$cm[, 1] / sum(negative_count)
  tpr_global = result$cm[, 2] / (sum(total_count) - sum(negative_count))

  list("fpr"=fpr_global, "tpr"=tpr_global, "thresholds"=result$thresholds)
}

#' Compute the precision recall curve
#'
#' @param fpr list - False positive rates for each individual ROC.
#' @param tpr list - True positive rates for each individual ROC.
#' @param thresholds list - Thresholds used to compute the fpr and tpr.
#' @param negative_count vector - Total number of samples corresponding to the
#' negative case.
#' @param total_count vector - Total number of samples.
#'
#' @return list with the global precision, recall, and thresholds (increasing)
#' @export
precision_recall_curve <- function(fpr, tpr, thresholds, negative_count, total_count) {
  # Obtain the partial confusion matrix (tp and fp)
  result <- partial_cm(fpr, tpr, thresholds, negative_count, total_count)

  # Compute the tpr/recall and precision
  pre_dividend <- result$cm[, 1] + result$cm[, 2]
  pre <- replace(result$cm[, 2] / pre_dividend, pre_dividend == 0, 1)
  recall <- result$cm[, 2] / (sum(total_count) - sum(negative_count))

  list("pre"=pre, "recall"=recall, "thresholds"=result$thresholds)
}
