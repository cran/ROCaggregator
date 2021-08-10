
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ROCaggregator

<!-- badges: start -->
<!-- badges: end -->

Aggregates multiple Receiver Operating Characteristic (ROC) curves
obtained from different sources into one global ROC. Additionally, it’s
also possible to calculate the aggregated precision-recall (PR) curve.

## Motivation

The ROC and the AUC (Area Under the Curve) can be essential metrics when
evaluating a model. In situations where there is a parallelization of
the model development, such as federated learning, it becomes relevant
to obtain precise measures for these metrics. These approaches usually
produce partial results that require aggregation methods to get the
complete picture. The ROCaggregator appears in this context, allowing to
compute the precise ROC curve from the partial results.

## Installation

You can install the released version of ROCaggregator from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("ROCaggregator")
```

## Example

Check the complete example provided in the vignette.

Obtain the global ROC curve from different sources by providing: - the
false positive rate (fpr) - true positive rate (tpr) - thresholds
(thresh) - the total number of negative samples/control - the total
number of samples from each source

    library(ROCaggregator)

    y1 <- c(1, 0, 1, 1, 0, 0, 0, ...)
    # false positive rate values for each threshold
    fpr_1 <- c(0, 0, 0, 0, 0.002, ...)
    # true positive rate values for each threshold
    tpr_1 <- c(0, 0.004, 0.008, 0.012, 0.016, ...)
    # thresholds used
    thresh_1 <- c(0.9994038, 0.9986345, 0.99847864, 0.99575908, 0.99567612, ...)
    # count the number of negative labels
    negative_count_1 <- sum(y1 == 0)
    # total number of labels
    total_count_1 <- length(y1)
    ...
    # ROC curve
    roc <- roc_curve(
      list(fpr_1, fpr_2, ...),
      list(tpr_1, tpr_2, ...),
      list(thresh_1, thresh_2, ...),
      c(negative_count_1, negative_count_2, ...),
      c(total_count_1, total_count_2, ...)
    )

    # Precision-recall
    pre_recall <- precision_recall_curve(
      list(fpr_1, fpr_2, ...),
      list(tpr_1, tpr_2, ...),
      list(thresh_1, thresh_2, ...),
      c(negative_count_1, negative_count_2, ...),
      c(total_count_1, total_count_2, ...)
    )
