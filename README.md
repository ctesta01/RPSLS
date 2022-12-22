Rock Paper Scissors Lizard Spock 🪨📝✂️🦎🖖
================

## Intro

A friendly R package for simulating rock-paper-scissors-lizard-spock
games!

``` r
# To Install
devtools::install_github("ctesta01/RPSLS")
```

## Explanation

The *Rock, Paper, Scissors, Lizard, Spock* game is a variant of *Rock,
Paper, Scissors* game invented by Sam Kass and Karen Bryla with Spock
signified using the Star Trek Vulcan salute, and lizard sometimes shown
in diagrams by forming the hand into a sock-puppet-like mouth [^1]. The
following diagram is from Wikimedia[^2].

![A resolution diagram of the game *Rock, Paper, Scissors, Lizard,
Spock*](https://upload.wikimedia.org/wikipedia/commons/a/ad/Pierre_ciseaux_feuille_l%C3%A9zard_spock_aligned.svg)

``` r
library(RPSLS)
```

``` r
explain_the_game()
```

    ## Scissors ✂️️ cuts Paper 📝
    ## Paper 📝 covers Rock 🪨
    ## Rock 🪨 crushes Lizard 🦎
    ## Lizard 🦎 poisons Spock 🖖
    ## Spock 🖖 smashes Scissors ✂️️
    ## Scissors ✂️ decapitates Lizard 🦎
    ## Lizard 🦎 eats Paper 📝
    ## Paper 📝 disproves Spock 🖖
    ## Spock 🖖 vaporizes Rock 🪨
    ## (and as it always has) Rock 🪨 crushes Scissors ✂️

## Sampling the Elements

``` r
sample_rpsls()
```

    ## You got rock 🪨

``` r
sample_rpsls(2)
```

    ## Your samples:
    ## Sample 1: lizard 🦎
    ## Sample 2: rock 🪨

# Playing a Game

Two players can use the `sample_rpsls_pair` function to simulate a
single-game between two people. The result can be that player 1 wins,
player 2 wins, or they tie.

``` r
sample_rpsls_pair()
```

    ## Player 1 chooses: lizard 🦎
    ## Player 2 chooses: rock 🪨
    ## Player 2 wins!

## Citations

[^1]: Rock, Paper Scissors.
    <https://en.wikipedia.org/wiki/Rock_paper_scissors>

[^2]: A resolution diagram of the game *Rock, Paper, Scissors, Lizard,
    Spock*.
    <https://en.wikipedia.org/wiki/File:Pierre_ciseaux_feuille_l%C3%A9zard_spock_aligned.svg>
