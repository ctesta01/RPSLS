#' Sample one of Rock, Paper, Scissors, Lizard, or Spock
#'
#' @examples
#' sample_rpslz()
#' sample_rpslz(n=5)
sample_rpsls <- function(n = 1, probs = rep(.2, 5), replace = TRUE, quiet = FALSE) {
  sample <- rpsls_emojis[sample.int(n = 5, size = n, replace = replace, prob = probs)]

  if (! quiet) {
    if (n == 1) {
      cat(paste0("You got ", rpsls_names[sample], ' ', sample, '\n'))
    } else if (n >= 1) {
      cat("Your samples:\n")
      for (i in 1:n)
      cat(paste0("Sample ", i, ": ", rpsls_names[sample[i]], ' ', sample[i], '\n'))
    }
  }

  return(invisible(sample))
}

#' Sample a Pair for Rock, Paper, Scissors, Lizard Spock
#'
#' Designed to facilitate playing Rock Paper Scissors Lizard Spock (RPSLZ),
#' this function samples two of
#'
#' @examples
sample_rpsls_pair <- function() {
  sample <- sample_rpsls(2, quiet = TRUE)

  cat(paste0("Player 1 chooses: ", rpsls_names[sample[1]], ' ', sample[1], '\n'))
  cat(paste0("Player 2 chooses: ", rpsls_names[sample[2]], ' ', sample[2], '\n'))
  eval_win_conditions(sample[1], sample[2])
}
