#' UI for the RPSLS Shiny App
ui <- function() {
  fluidPage(
    theme = bslib::bs_theme(bootswatch = "darkly"),
    titlePanel("Rock Paper Scissors Lizard Spock 🪨📝✂️🦎🖖"),

    sidebarLayout(
      sidebarPanel(
        h2("Explanation"),
        p(HTML("The <i>Rock, Paper, Scissors, Lizard, Spock</i> game is a variant of <i>Rock, Paper, Scissors</i> game. The game was first invented by Sam Kass and Karen Bryla and later popularized on the Big Bang Theory.  Read more about it <a href='https://bigbangtheory.fandom.com/wiki/Rock,_Paper,_Scissors,_Lizard,_Spock'>here</a>. Diagram below from <a href='https://en.wikipedia.org/wiki/Rock_paper_scissors#/media/File:Pierre_ciseaux_feuille_l%C3%A9zard_spock_aligned.svg'>here</a>.")),
        HTML("<center><img width='100%' style='max-width: 400px;' src='https://upload.wikimedia.org/wikipedia/commons/a/ad/Pierre_ciseaux_feuille_l%C3%A9zard_spock_aligned.svg' alt='A resolution diagram of the game Rock, Paper, Scissors, Lizard, Spock.'></center>"),
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
                    tabPanel("Game Summary",
                             br(),
                             grVizOutput('play_diagram', height = "800px", width = "80%"))
        )
      )
    )
  )
}

#' Server for the RPSLS Shiny App
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

    if (! is.null(values$games[[paste0('game', n_of_rounds_needed())]]$play_event_messages)) {

      last_round_messages <- values$games[[paste0('game', n_of_rounds_needed())]]$play_event_messages
      tournament_over_msg <- "<span style='color: red;'>The tournament is already over</span>"

      if (last(last_round_messages) != tournament_over_msg) {
        values$games[[paste0('game', n_of_rounds_needed())]]$play_event_messages[
          length(last_round_messages) + 1
        ] <- tournament_over_msg
      }

      return(NULL)
    } else {

    # these are our players
    current_players <- values$games[[paste0('game', values$current_game)]]$players

    # setup messages structure
    play_event_messages <- c()

    # setup a list of winners
    winners <- c()
    winners_long <- c()

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

      # store winners for every player
      winners_long <- c(winners_long,
                        case_when(winner_msg == 'Player 1' ~ c(current_players[2 * i - 1], current_players[2 * i - 1]),
                  winner_msg == 'Player 2' ~ c(current_players[2 * i], current_players[2 * i])))
    }

    # if there's an 'odd one out' who should automatically advance, advance them
    if (length(current_players) %% 2 == 1) {
      winners[length(winners)+1] <- current_players[length(current_players)]
      winners_long[length(winners_long)+1] <- current_players[length(current_players)]
    }

    # if there is only one winner remaining, announce that they've won
    if (length(winners) == 1) {
      play_event_messages[length(play_event_messages)+1] <-
        paste0("<h2 class='text-info'>", player_namer()[winners], " has won the tournament! 🎉🥳🎁 </h2>")
    }

    # store play_event_messages in the games object
    values$games[[paste0('game', values$current_game)]]$play_event_messages <- play_event_messages
    values$games[[paste0('game', values$current_game)]]$winners_long <- winners_long

    # store the list of players
    winners <- winners[sample.int(n = length(winners), size = length(winners))]
    values$games[[paste0('game', values$current_game+1)]] <- list(players = winners)

    # setup next game with players
    if (length(winners) > 1) {

      # create their pair structure
      values$games[[paste0('game', values$current_game + 1)]][['pairs']] <-
        purrr::map(1:(floor(length(winners) / 2)),
                   ~ winners[c(2 * . - 1, 2 * .)])


      # if there's an "odd one out" make sure they're automatically advanced
      if (length(winners) %% 2 == 1) {
        values$games[[paste0('game', values$current_game + 1)]][['pairs']][
          length(values$games[[paste0('game', values$current_game + 1)]][['pairs']]) + 1] <-
          winners[length(winners)]
      }

    }
    # increment the current game counter
    values$current_game <- values$current_game + 1

    }
  })

  # create an output for the gameplay log
  gameplay_text <- reactive({


    # setup messages object
    messages <- c()

    # record messages for gameplay
    for (i in 1:min(values$current_game, n_of_rounds_needed())) {

      # create printout for round i matchup
      messages[length(messages)+1] <- paste0("<h2>Round ", i, " Matchup&#58;</h2>")

      for (j in 1:length(values$games[[paste0('game', i)]]$pairs)) {
        pair <- values$games[[paste0('game', i)]]$pairs[[j]]
        if (length(pair) == 2) {
          messages[[length(messages)+1]] <- paste0(player_namer()[pair[1]], " plays ", player_namer()[pair[2]])
        } else if (length(pair) == 1) {
          messages[[length(messages)+1]] <- paste0(player_namer()[pair[1]], " automatically advances")
        }
      }
      # add a line break after round 1 matchups
      messages[length(messages)+1] <- '<br>'

      # if round i has been played, print the play event messages
      if (! is.null(values$games[[paste0('game', i)]]$play_event_messages)) {
        messages <- c(messages, paste0("<h2>Round ", i, " Results&#58;</h2>"), values$games[[paste0('game', i)]]$play_event_messages)
      }
    }

    # final output
    paste0(messages, collapse='<br>')
  })

  # print gameplay text to UI
  output$gameplay <- renderText({
    paste0(
      gameplay_text()
    )
    })

  # create the tournament style brackets
  output$play_diagram <- renderGrViz({
    grViz_instructions <-
      paste0(
      c("digraph {
       graph [rankdir = LR];
      ",
      # this creates labels for all the players
      # this might look a little complicated, but basically it says:
      # for each round that's been played, create nodes where the letter
      # corresponds to the round (e.g., A for round 1, B for round 2, etc.)
      # and the number is the player ID.
      purrr::map_chr(1:values$current_game, function(game_i) {

        paste0(
      purrr::map_chr(values$games[[paste0('game', game_i)]]$players,
                 ~ paste0("node [shape = rectangle, label = '",
                          stringr::str_replace_all(player_namer()[.], "[^[:alnum:]^[:space:]]", ""), "'] ", LETTERS[game_i], ., ";")),
      collapse = '\n'
      )

      }),

      # create arrows for all the games
      #
      # this might look a little complicated, but basically it says: for each
      # round starting from round 2 that's been played (where winners have been
      # determined), create nodes where the letter use the
      # values$games$gameXX$winners_long data to determine how to write the
      # arrows; so for example if players 1 and 2 head-off and player 2 wins in
      # round 1, the two arrows will be written A1 -> B2; A2 -> B2.
      paste0(
        if (values$current_game > 1) {
      purrr::map_chr(1:(values$current_game-1), function(game_i) {
        paste0(
          purrr::map_chr(1:length(values$games[[paste0('game', game_i)]]$players),
                         ~ paste0(LETTERS[game_i], values$games[[paste0('game', game_i)]]$players[.], "->", LETTERS[game_i+1], values$games[[paste0('game', game_i)]]$winners_long[.])),
          collapse = '\n'
        )
      })
      } else { NULL }, collapse='\n'),
      "}")
      )

    grViz(grViz_instructions)
  })

}

#' Run the RPSLS Tournament Simulator Shiny App
app <- function() {
  shiny::shinyApp(ui = ui, server = server)
}
