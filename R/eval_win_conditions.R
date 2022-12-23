
#' Evaluate Win Conditions
eval_win_conditions <- function(player1, player2, quiet = FALSE, names = NULL) {

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

  win_logic <- case_when(
    # player 1 win scenarios
    player1 == '✂️' & player2 == '📝' ~ 'Scissors ✂️️ cuts Paper 📝',
    player1 == '📝' & player2 == '🪨' ~ 'Paper 📝 covers Rock 🪨',
    player1 == '🪨' & player2 == '🦎' ~ 'Rock 🪨 crushes Lizard 🦎',
    player1 == '🦎' & player2 == '🖖' ~ 'Lizard 🦎 poisons Spock 🖖',
    player1 == '🖖' & player2 == '✂️' ~ 'Spock 🖖 smashes Scissors ✂️',
    player1 == '✂️' & player2 == '🦎' ~ 'Scissors ✂️ decapitates Lizard 🦎',
    player1 == '🦎' & player2 == '📝' ~ 'Lizard 🦎 eats Paper 📝',
    player1 == '📝' & player2 == '🖖' ~ 'Paper 📝 disproves Spock 🖖',
    player1 == '🖖' & player2 == '🪨' ~ 'Spock 🖖 vaporizes Rock 🪨',
    player1 == '🪨' & player2 == '✂️' ~ 'Rock 🪨 crushes Scissors ✂️',

    # player 2 win scenarios
    player2 == '✂️' & player1 == '📝' ~ 'Scissors ✂️️ cuts Paper 📝',
    player2 == '📝' & player1 == '🪨' ~ 'Paper 📝 covers Rock 🪨',
    player2 == '🪨' & player1 == '🦎' ~ 'Rock 🪨 crushes Lizard 🦎',
    player2 == '🦎' & player1 == '🖖' ~ 'Lizard 🦎 poisons Spock 🖖',
    player2 == '🖖' & player1 == '✂️' ~ 'Spock 🖖 smashes Scissors ✂️',
    player2 == '✂️' & player1 == '🦎' ~ 'Scissors ✂️ decapitates Lizard 🦎',
    player2 == '🦎' & player1 == '📝' ~ 'Lizard 🦎 eats Paper 📝',
    player2 == '📝' & player1 == '🖖' ~ 'Paper 📝 disproves Spock 🖖',
    player2 == '🖖' & player1 == '🪨' ~ 'Spock 🖖 vaporizes Rock 🪨',
    player2 == '🪨' & player1 == '✂️' ~ 'Rock 🪨 crushes Scissors ✂️'
  )

  if (! quiet) {

    # print messages without names
    if (missing(names)) {
      if (winner %in% c('Player 1', 'Player 2')) {
        cat(paste0(winner, " wins!\n"))
      } else if (winner == 'tie') {
        cat("Player 1 and Player 2 tie!\n")
      }

    # print messages with names
    } else if (! missing(names)) {
      if (winner == 'tie') {
        cat(paste0(names[1], " and ", names[2], " tie!\n"))
      } else if (winner == 'Player 1') {
        cat(paste0(win_logic, " → ", names[1], " wins!\n"))
      } else if (winner == 'Player 2') {
        cat(paste0(win_logic, " → ", names[2], " wins!\n"))
      }
    }
  }

  return(invisible(winner))
}
