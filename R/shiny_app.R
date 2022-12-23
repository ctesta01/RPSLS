ui <- function() {
  fluidPage(
    theme = bslib::bs_theme(bootswatch = "darkly"),
    titlePanel("Rock Paper Scissors Lizard Spock 🪨📝✂️🦎🖖"),

    sidebarLayout(
      sidebarPanel(
        h2("Explanation"),
        p(HTML("The <i>Rock, Paper, Scissors, Lizard, Spock</i> game is a variant of <i>Rock, Paper, Scissors</i> game. The game was first invented by Sam Kass and Karen Bryla and later popularized on the Big Bang Theory.  Read more about it <a href='https://bigbangtheory.fandom.com/wiki/Rock,_Paper,_Scissors,_Lizard,_Spock'>here</a>.")),
        HTML("<img width='100%' src='https://upload.wikimedia.org/wikipedia/commons/a/ad/Pierre_ciseaux_feuille_l%C3%A9zard_spock_aligned.svg' alt='A resolution diagram of the game Rock, Paper, Scissors, Lizard, Spock.'>"),
        p(HTML(paste0(c("<center>", capture.output(explain_the_game()), "</center>"), collapse='<br>'))),
        h3("Settings"),
        numericInput(inputId = 'n_players', label = 'Number of Players',
                     min = 2, value = 10),
      ),
      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("Player Names",
                             div(
                               style='color: black !important;',
                               rHandsontableOutput('playerNames'),
                             )
                             ),
                    tabPanel("Game Play",
                             htmlOutput('gameplay'),
                             br(),
                             actionButton('runMatchup', 'Run Round!')
                             ),
                    tabPanel("Game Summary")
        )
      )
    )
  )
}


server <- function(input, output, session) {

  # determine number of rounds needed
  n_of_rounds_needed <- reactive({
    ceiling(log(input$n_players, base = 2))
  })

  # create dataframe for player information (names)
  players <- reactive({
    data.frame(
      name = paste0("Player ", 1:input$n_players)
    )
  })

  # create a reactive object that functions as a lookup for
  # player names based on their number
  player_namer <- reactive({
    setNames(hot_to_r(input$playerNames)$name, 1:input$n_players)
  })

  # render player information (editable) so players can enter names
  output$playerNames <- renderRHandsontable({
    rhandsontable(players()) %>%
      hot_cols(colWidths=400)
  })

  # use reactiveValues to store the games
  values <- reactiveValues(games = list(), current_game = 1)

  # put the games in a list structure
  observeEvent(n_of_rounds_needed(), {

    # determine pairing order for the first game
    pairing_order <- sample.int(n = input$n_players, size = input$n_players)

    # match up pairs
    pairs <- purrr::map(1:floor(length(pairing_order)/2),
                    ~ pairing_order[c(2*.-1, 2*.)])

    # if there are an odd number of players, there 1 person who automatically advances
    # to the next round
    if (input$n_players %% 2 == 1) {
      pairs[length(pairs)+1] <- pairing_order[length(pairing_order)]
    }

    # store the pairs in the games structure
    values$games$game1 <- list(players = pairing_order, pairs = pairs)
  })

  # run game
  observeEvent(input$runMatchup, {

    # these are our players
    current_players <- values$games[[paste0('game', values$current_game)]]$players

    # setup messages structure
    play_event_messages <- c()

    # setup a list of winners
    winners <- c()

    # determine winners
    for (i in 1:floor(length(current_players)/2)) {

      # record the gameplay messages
      winner_msg <- 'tie'

      # get the player names for the current pair
      player_names <- player_namer()[current_players[c(2*i-1, 2*i)]]

      while(winner_msg == 'tie') { # until a non-tie is reached, repeat each game

        play_event_messages <- c(play_event_messages, capture.output({
          winner_msg <-
            sample_rpsls_pair(names = player_names)
        }))
      }
      # store the winners
      winners[length(winners) + 1] <-
        case_when(winner_msg == 'Player 1' ~ current_players[2 * i - 1],
                  winner_msg == 'Player 2' ~ current_players[2 * i])
    }

    # if there's an 'odd one out' who should automatically advance, advance them
    if (length(current_players) %% 2 == 1) {
      winners[length(winners)+1] <- current_players[length(current_players)]
    }

    # if there is only one winner remaining, announce that they've won
    if (length(winners) == 1) {
      play_event_messages[length(play_event_messages)+1] <-
        paste0(player_namer()[winners], " has won the tournament!")
    }

    # store play_event_messages in the games object
    values$games[[paste0('game', values$current_game)]]$play_event_messages <- play_event_messages

    # setup next game with players
    if (length(winners) > 1) {
      # store the list of players
      values$game[[paste0('game', values$current_game+1)]] <- list(players = winners)

      # create their pair structure
      values$game[[paste0('game', values$current_game + 1)]][['pairs']] <-
        purrr::map(1:(floor(length(winners) / 2)),
                   ~ winners[c(2 * . - 1, 2 * .)])

      # if there's an "odd one out" make sure they're automatically advanced
      if (length(winners) %% 2 == 1) {
        values$game[[paste0('game', values$current_game + 1)]][['pairs']][
          length(values$game[[paste0('game', values$current_game + 1)]][['pairs']]) + 1] <-
          winners[length(winners)]
      }

      # increment the current game counter
      values$current_game <- values$current_game + 1
    }
  })

  # create an output for the gameplay log
  gameplay_text <- reactive({

    # setup messages object
    messages <- c()

    # create printout for round 1 matchup
    messages[1] <- r"(<h2>Round 1 Matchup&#58;</h2>)"
    for (i in 1:length(values$games$game1$pairs)) {
      pair <- values$games$game1$pairs[[i]]
      if (length(pair) == 2) {
        messages[[length(messages)+1]] <- paste0(player_namer()[pair[1]], " plays ", player_namer()[pair[2]])
      } else if (length(pair) == 1) {
        messages[[length(messages)+1]] <- paste0(player_namer()[pair[1]], " automatically advances")
      }
    }
    # add a line break after round 1 matchups
    messages[length(messages)+1] <- '<br>'

    # if round1 has been played, print the play event messages
    if (! is.null(values$games$game1$play_event_messages)) {
      messages <- c(messages, r"(<h2>Round 1 Results&#58;</h2>)", values$games$game1$play_event_messages)
    }

    # final output
    paste0(messages, collapse='<br>')
  })

  output$gameplay <- renderText({
    paste0(
      gameplay_text()
    )
    })

  pairings <- {}
}

app <- function() {
  shiny::shinyApp(ui = ui, server = server)
}
