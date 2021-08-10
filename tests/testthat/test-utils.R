TOTAL_COUNT <- c(8, 10)
NEGATIVE_COUNT <- c(2, 5)

TPR <- list(c(3/6, 1, 0), c(0, 1, 0, 1/5, 3/5, 3/5))
FPR <- list(c(1/2, 1, 0), c(0, 1, 2/5, 2/5, 2/5, 4/5))
THRESHOLDS <- list(c(0.3, 0.1, 1.3), c(1.4, 0.1, 0.4, 0.35, 0.3, 0.2))

THRESHOLDS_STACKED <- c(0.1, 0.2, 0.3, 0.35, 0.4, 1.3, 1.4)
PARTIAL_CM <- rbind(c(7, 11), c(5, 6), c(3, 6), c(2, 1), c(2, 0), c(0, 0), c(0, 0))

test_that("Test partial CM function", {
  r <- partial_cm(FPR, TPR, THRESHOLDS, NEGATIVE_COUNT, TOTAL_COUNT)

  expect_equal(r$cm, PARTIAL_CM)
  expect_equal(r$thresholds, THRESHOLDS_STACKED)
})

test_that("Test partial CM function with descending flag", {
  r <- partial_cm(
    FPR, TPR, THRESHOLDS, NEGATIVE_COUNT, TOTAL_COUNT, descending = TRUE)

  expect_equal(r$cm, apply(PARTIAL_CM, 2, rev))
  expect_equal(r$thresholds, rev(THRESHOLDS_STACKED))
})

test_that("Shift vector with positive shift", {
  v <- shift_vector(c(1,2,3,4), 3)

  expect_equal(v, c(2,3,4,1))
})

test_that("Shift vector with negative shift", {
  v <- shift_vector(c(1,2,3,4), -3)

  expect_equal(v, c(4,1,2,3))
})

test_that("Shift vector with no shift", {
  v <- shift_vector(c(1,2,3,4), 0)

  expect_equal(v, c(1,2,3,4))
})
