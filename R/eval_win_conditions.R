
#' Evaluate Win Conditions
eval_win_conditions <- function(player1, player2, quiet = FALSE, names) {

  if (! (missing(names) | (is.character(names) & length(names) == 2))) {
    stop("The names argument must be either missing or a length 2 character vector.")
  }

  winner <- case_when(
    player1 == player2 ~ 'tie',
    player1 == '🪨' & player2 %in% c('✂️', '🦎') ~ 'Player 1',
    player1 == '📝' & player2 %in% c('🖖', '🪨') ~ 'Player 1',
    player1 == '✂️' & player2 %in% c('🦎', '📝') ~ 'Player 1',
    player1 == '🦎' & player2 %in% c('📝', '🖖') ~ 'Player 1',
    player1 == '🖖' & player2 %in% c('🪨', '🖖') ~ 'Player 1',
    TRUE ~ 'Player 2'
  )

  # TODO: it would be amazing if this printed the "Spock vaporizes Rock!" messages too
  if (! quiet) {

    if (missing(names)) {
      if (winner %in% c('Player 1', 'Player 2')) {
        cat(paste0(winner, " wins!\n"))
      } else if (winner == 'tie') {
        cat("Player 1 and Player 2 tie!\n")
      }
    } else if (! missing(names)) {
      if (winner == 'tie') {
        cat(paste0(names[1], " and ", names[2], " tie!\n"))
      } else if (winner == 'Player 1') {
        cat(paste0(names[1], " wins!\n"))
      } else if (winner == 'Player 2') {
        cat(paste0(names[2], " wins!\n"))
      }
    }
  }

  return(invisible(winner))
}
