# Build the examples.
#
# Build the examples for a KNN model to forecast a time series using
# lags values of the series as autoregressive features.
#
# @param timeS The time series.
# @param lags An integer vector with the lags used as feature vector in
#             decreasing order.
# @param nt The number of targets.
#
# @return A list with two fields: 1) a matrix with the features of the
#         examples and 2) a matrix with the targets of the examples
# @examples
# build_examples(ts(1:5), lags = 2:1)
# build_examples(ts(1:5), lags = 2:1, nt = 2)
# @export
build_examples <- function(timeS, lags, nt = 1, transform) {
  # MAXLAG   <- lags[1]
  # NCOL     <- length(lags)
  # NROW     <- length(timeS) - MAXLAG - nt + 1
  # patterns <- matrix(0, nrow = NROW, ncol = NCOL)
  # targets  <- matrix(0, nrow = NROW, ncol = nt)
  # row <- 1
  # for (ind in seq(MAXLAG + nt, length(timeS))) {
  #   the_mean <- mean(timeS[ind - nt + 1 - lags])
  #   patterns[row, ] <- timeS[ind - nt + 1 - lags] / the_mean
  #   targets[row, ] <- timeS[(ind - nt + 1):ind] / the_mean
  #   row <- row + 1
  # }
  if (transform == "none") {
    r <- build_examples2(timeS, lags, nt)
  } else if (transform == "multiplicative") {
    r <- build_examples_m(timeS, lags, nt)
  }else if (transform == "additive") {
    r <- build_examples_a(timeS, lags, nt)
  }
  colnames(r$patterns) <- paste0("Lag", lags)
  colnames(r$targets)  <- paste0("H", 1:nt)
  r
  # list(
  #   patterns = patterns,
  #   targets = targets
  # )
}

# Create a KNN model.
#
# Build a KNN model to forecast a time series using autoregressive features.
#
# @param timeS The time series.
# @param lags An integer vector with the lags used as feature vector in
#             increasing order.
# @param k The k parameter.
# @param nt The number of targets (amount of horizons to be forecast).
# @param cf The combination function used to aggregate the targets of
#     the nearest neighbors.
# @return An object of type knnModel.
#
# @export
knn_model <- function(timeS, lags, k, nt = 1, cf = "mean", transform) {
  lags <- rev(lags)
  stopifnot(utils::tail(lags, 1) >= 1)
  MAXLAG <- lags[1]
  if (MAXLAG + nt > length(timeS)) stop("Impossible to create one example")
  examples <- build_examples(timeS, lags, nt, transform)
  if (utils::tail(k, 1) > nrow(examples$patterns))
    stop("k > number of examples")
  structure(
    list(
      ts = timeS,
      lags = lags,
      examples = examples,
      k = k,
      cf = cf
    ),
    class = "knnModel"
  )
}

# Predicts one example doing KNN regression.
#
# @param model The KNN model (its class should be knnModel).
# @param ex The features of the example whose target is to be predicted.
#
# @export
# @examples
# model <- knn_model(ts(c(2, 3, 1, 5, 4, 0, 7, 1, 2)), lags = 1:2, k = 2)
# regression(model, c(1, 2), k = 2)
regression <- function(model, example, k) {
  r <- first_n(model$examples$patterns, example, k)
  values <- model$examples$targets[r$indexes, , drop = F]
  if (model$cf == "mean") {
    prediction <- unname(colMeans(values))
  } else if (model$cf == "median") {
    prediction <- apply(values, 2, stats::median)
  } else if (model$cf == "weighted") {
    if (r$distances[r$indexes[1]] == 0) {
      prediction <- unname(values[1, ])
    } else {
      reciprocal_d <- 1 / sqrt(r$distances[r$indexes])
      prediction <- numeric(ncol(model$example$targets))
      for (k_ in seq(k)) {
        prediction <- prediction + values[k_, ] * reciprocal_d[k_]
      }
      prediction <- prediction / sum(reciprocal_d)
    }
  }
  list(
    prediction = prediction,
    neighbors = model$examples$targetsI[r$indexes]
  )
}

#' Predict method for KNN models for time series forecasting.
#'
#' Predicted values based on a KNN model for time series forecasting.
#'
#' If the models uses the MIMO strategy for multiple-step ahead prediction,
#' the forecasting horizon is fixed to the model forecasting horizon.
#'
#' @param object a \code{knnForecast} object obtained by a call to the
#'    \code{\link{knn_forecasting}} function.
#' @param h an integer. The forecasting horizon.
#' @param ... further arguments passed to or from other methods.
#'
#' @return a \code{knnForecast} object with the prediction and information
#' about the KNN model, see the documentation of \code{\link{knn_forecasting}}
#' for the structure of \code{knnForecast} objects.
#'
#' @examples
#' pred <- knn_forecasting(UKgas, h = 4, k = 1, msas = "recursive")
#' new_pred <- predict(pred, h = 6)
#' print(new_pred$prediction)
#' plot(new_pred) # To see a plot with the forecast
#'
#' @importFrom stats predict
#' @export
predict.knnForecast <- function(object, h, ...) {
  # Check h parameter
  stopifnot(is.numeric(h), length(h) == 1, h >= 1)

  k <- object$model$k
  ts <- object$model$ts
  if (object$msas == "recursive") {
    p <- numeric(h)
    for (value in k) {
      pred <- recPrediction(object, h = h, k = value)
      p <- p + pred$prediction
    }
    prediction <- p / length(k)
    neighbors <- pred$neighbors
  } else { # MIMO
    hor = ncol(object$model$examples$targets)
    if (h != hor)
      stop(paste("The model only predicts horizon", hor))
    example <- as.vector(ts[(length(ts) + 1) - object$model$lags])
    if (object$transformation != "none") {
      the_mean <- mean(example)
      if (object$transformation == "multiplicative")
        example <- example / the_mean
      else
        example <- example - the_mean
    }
    p <- numeric(h)
    for (value in k) {
      reg <- regression(object$model, example, k = value)
      if (object$transformation != "none") {
        if (object$transformation == "multiplicative")
          reg$prediction <- reg$prediction * the_mean
        else
          reg$prediction <- reg$prediction + the_mean
      }
      p <- p + reg$prediction
    }
    prediction <- p / length(k)
    neighbors <- reg$neighbors
  }
  temp <- stats::ts(1:2,
                    start = stats::end(ts),
                    frequency = stats::frequency(ts)
  )
  prediction <- stats::ts(prediction,
            start = stats::end(temp),
            frequency = stats::frequency(ts)
  )
  r <- object
  r$prediction = prediction
  r$neighbors = neighbors
  r
}

recPrediction <- function(object, h, k) {
  model <- object$model
  prediction <- numeric(h)
  neighbors <- matrix(nrow = h, ncol = k)
  values <- as.vector(model$ts)
  for (hor in 1:h) {
    example <- values[(length(values) + 1) - model$lags]
    if (object$transformation != "none") {
      the_mean <- mean(example)
      if (object$transformation == "multiplicative")
        example <- example / the_mean
      else
        example <- example - the_mean
    }
    reg <- regression(model, example, k)
    prediction[hor] <- reg$prediction
    if (object$transformation != "none") {
      if (object$transformation == "multiplicative")
        prediction[hor] <- prediction[hor] * the_mean
      else
        prediction[hor] <- prediction[hor] + the_mean
    }
    neighbors[hor, ] <- reg$neighbors
    values <- c(values, prediction[hor])
  }
  return(list(
    prediction = prediction,
    neighbors = neighbors
  ))
}
