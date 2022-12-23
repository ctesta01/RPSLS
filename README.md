Rock Paper Scissors Lizard Spock 🪨📝✂️🦎🖖
================

## Intro

A friendly R package for simulating rock-paper-scissors-lizard-spock
games!

``` r
# To Install
devtools::install_github("ctesta01/RPSLS")
```

## Try out the app!

The app is live on <https://ctesta.shinyapps.io/RPSLS/> 🌱🌏🎉

## Explanation

The *Rock, Paper, Scissors, Lizard, Spock* game is a variant of *Rock,
Paper, Scissors* game invented by Sam Kass and Karen Bryla with Spock
signified using the Star Trek Vulcan salute, and lizard sometimes shown
in diagrams by forming the hand into a sock-puppet-like mouth [^1]. The
following diagram from Wikimedia[^2] explains how each game is resolved.
See the output of `explain_the_game()` below for the logic behind the
diagram.

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

    ## You got Paper 📝

``` r
sample_rpsls(2)
```

    ## Your samples:
    ## Sample 1: Scissors ✂️
    ## Sample 2: Lizard 🦎

# Playing a Game

Two players can use the `sample_rpsls_pair` function to simulate a
single-game between two people. The result can be that player 1 wins,
player 2 wins, or they tie.

``` r
sample_rpsls_pair()
```

    ## Player 1 chooses: Paper 📝
    ## Player 2 chooses: Rock 🪨
    ## Player 1 wins!

## Tournaments

The app can be run after installing the package, loading it, and calling
`RPSLS::app()`.

Watch the explanation video on YouTube:

[![Explanation on
YouTube](images/youtube.png)](https://www.youtube.com/watch?v=fR90EA7FTV8)

![Use the builtin app to run tournaments of RPSLS](images/animation.gif)

## Links

[^1]: Rock, Paper Scissors.
    <https://en.wikipedia.org/wiki/Rock_paper_scissors>

[^2]: A resolution diagram of the game *Rock, Paper, Scissors, Lizard,
    Spock*.
    <https://en.wikipedia.org/wiki/File:Pierre_ciseaux_feuille_l%C3%A9zard_spock_aligned.svg>
