## ----echo = FALSE-------------------------------------------------------------
knitr::opts_chunk$set(warning = FALSE, message = FALSE)


## -----------------------------------------------------------------------------
library(tsfknn)
pred <- knn_forecasting(ts(1:8), h = 1, lags = 1:2, k = 2, transform = "none")
knn_examples(pred)

## -----------------------------------------------------------------------------
pred$prediction
plot(pred)

## -----------------------------------------------------------------------------
nearest_neighbors(pred)

## -----------------------------------------------------------------------------
library(ggplot2)
autoplot(pred, highlight = "neighbors")

## -----------------------------------------------------------------------------
pred <- knn_forecasting(USAccDeaths, h = 12, lags = 1:12, k = 2, msas = "MIMO")
autoplot(pred, highlight = "neighbors", faceting = FALSE)

## -----------------------------------------------------------------------------
timeS <- window(UKgas, start = c(1976, 1))
pred <- knn_forecasting(timeS, h = 2, lags = 1:4, k = 2, msas = "recursive")
library(ggplot2)
autoplot(pred, highlight = "neighbors")

## -----------------------------------------------------------------------------
pred <- knn_forecasting(ldeaths, h = 12, lags = 1:12, k = c(2, 4))
pred$prediction
plot(pred)

## -----------------------------------------------------------------------------
set.seed(5)
timeS <- ts(1:10 + rnorm(10, 0, .2))
pred <- knn_forecasting(timeS, h = 3, transform = "none")
plot(pred)
pred2 <- knn_forecasting(timeS, h = 3, transform = "additive")
plot(pred2)

## -----------------------------------------------------------------------------
timeS <- ts(c(1, 3, 7, 9, 10, 12))
model_n <- knn_forecasting(timeS, h = 1, lags = 1:2, k = 2, transform = "none")
knn_examples(model_n)
plot(model_n)

## -----------------------------------------------------------------------------
model_a <- knn_forecasting(timeS, h = 1, lags = 1:2, k = 2, transform = "additive")
knn_examples(model_a)
plot(model_a)

## -----------------------------------------------------------------------------
model_a$pred

## -----------------------------------------------------------------------------
pred <- knn_forecasting(ts(1:20), h = 4, lags = 1:2, k = 2)
ro <- rolling_origin(pred, h = 4)

## -----------------------------------------------------------------------------
print(ro$test_sets)

## -----------------------------------------------------------------------------
print(ro$predictions)

## -----------------------------------------------------------------------------
print(ro$errors)

## -----------------------------------------------------------------------------
ro$global_accu

## -----------------------------------------------------------------------------
ro$h_accu

## -----------------------------------------------------------------------------
plot(ro, h = 4)

## -----------------------------------------------------------------------------
ro <- rolling_origin(pred, h = 4, rolling = FALSE)
print(ro$test_sets)
print(ro$predictions)

