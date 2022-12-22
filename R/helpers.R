# Helper Data Structures

#' Emojis for Each of Rock, Paper, Scissors, Lizard, Spock
rpsls_emojis <- c('🪨', '📝', '✂️', '🦎', '🖖')

#' A Named Vector for Rock, Paper, Scissors, Lizard, Spock Emojis
rpsls_names <- c(
  '🪨' = 'rock',
  '📝' = 'paper',
  '✂️' = 'scissors',
  '🦎' = 'lizard',
  '🖖' = 'spock'
)


#' Explain the Game
explain_the_game <- function() {
  cat("Scissors ✂️️ cuts Paper 📝\n")
  cat("Paper 📝 covers Rock 🪨\n")
  cat("Rock 🪨 crushes Lizard 🦎\n")
  cat("Lizard 🦎 poisons Spock 🖖\n")
  cat("Spock 🖖 smashes Scissors ✂️️\n")
  cat("Scissors ✂️ decapitates Lizard 🦎\n")
  cat("Lizard 🦎 eats Paper 📝\n")
  cat("Paper 📝 disproves Spock 🖖\n")
  cat("Spock 🖖 vaporizes Rock 🪨\n")
  cat("(and as it always has) Rock 🪨 crushes Scissors ✂️\n")
}
