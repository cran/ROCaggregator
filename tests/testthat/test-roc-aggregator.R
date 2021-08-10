TOTAL_COUNT <- c(8, 10)
NEGATIVE_COUNT <- c(2, 5)

TPR <- list(c(0, 3/6, 1), c(0, 0, 1/5, 3/5, 3/5, 1))
FPR <- list(c(0, 1/2, 1), c(0, 2/5, 2/5, 2/5, 4/5, 5/5))
THRESHOLDS <- list(c(1.3, 0.3, 0.1), c(1.4, 0.4, 0.35, 0.3, 0.2, 0.1))

THRESHOLDS_STACKED <- c(0.1, 0.2, 0.3, 0.35, 0.4, 1.3, 1.4)
PARTIAL_CM <- rbind(c(7, 11), c(5, 6), c(3, 6), c(2, 1), c(2, 0), c(0, 0), c(0, 0))

test_that("Test ROC curve", {
  m <- mock(list("cm"=apply(PARTIAL_CM, 2, rev), "thresholds"=rev(THRESHOLDS_STACKED)))
  with_mock(partial_cm = m, {
    r <- roc_curve(FPR, TPR, THRESHOLDS, NEGATIVE_COUNT, TOTAL_COUNT)

    expect_call(m, 1, partial_cm(
      fpr, tpr, thresholds, negative_count, total_count, descending = TRUE
    ))
    expect_equal(r$fpr, c(0, 0, 2/7, 2/7, 3/7, 5/7, 1))
    expect_equal(r$tpr, c(0, 0, 0, 1/11, 6/11, 6/11, 1))
    expect_equal(r$thresholds, rev(THRESHOLDS_STACKED))
  })
})

test_that("Test Precision Recall curve", {
  m <- mock(list("cm"=PARTIAL_CM, "thresholds"=THRESHOLDS_STACKED))
  with_mock(partial_cm = m, {
    r <- precision_recall_curve(FPR, TPR, THRESHOLDS, NEGATIVE_COUNT, TOTAL_COUNT)

    expect_call(m, 1, partial_cm(
      fpr, tpr, thresholds, negative_count, total_count
    ))
    expect_equal(r$pre, c(11/18, 6/11, 6/9, 1/3, 0, 1, 1))
    expect_equal(r$recall, c(1, 6/11, 6/11, 1/11, 0, 0, 0))
    expect_equal(r$thresholds, THRESHOLDS_STACKED)
  })
})
