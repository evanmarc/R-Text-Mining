library(dplyr)
library(stringr)
library(tidytext)
library(ggplot2)
library(gutenbergr)
library(tidyr)
library(wordcloud)
library(reshape2)

gather_gutenberg_books <- function(gutenberg_id, book_names) {
  text_from_books <- gutenberg_download(gutenberg_id)
  
  gutenberg_books <- left_join(text_from_books, data.frame(gutenberg_id = gutenberg_id, book = book_names))
  
  return(gutenberg_books)
}

single_word_unnested <- function(gutenberg_books) {
  line_number_added <- gutenberg_books %>%
    group_by(book) %>%
    mutate(linenumber = row_number(),
           chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]", ignore_case = T)))) %>%
    ungroup()
  
  books_tidied <- line_number_added %>%
    unnest_tokens(word, text) %>%
    anti_join(stop_words)
  
  return(books_tidied)
}

single_word_review <- function(books_tidied, show_top_words = 15, number_of_columns = 2) {
  prepare_for_sort <- books_tidied %>%
    group_by(book) %>%
    count(word)
  
  prepare_for_ggplot <- prepare_for_sort %>%
    group_by(book) %>%
    top_n(show_top_words) %>%
    ungroup() %>%
    arrange(book, n) %>%
    mutate(order = row_number())
  
  books_charted <- ggplot(prepare_for_ggplot, aes(order, n)) +
    geom_col(show.legend = F) +
    xlab("Words") +
    ylab("Occurrances") +
    facet_wrap(~ book, ncol = number_of_columns, scales = "free_y") +
    scale_x_continuous(
      breaks = prepare_for_ggplot$order,
      labels = prepare_for_ggplot$word,
      expand = c(0,0)
    ) +
    coord_flip()
  
  return(books_charted)
}

single_word_sentiment_cleaning <- function(books_tidied, sentiment_type = "bing", remove_words = NULL, words_shown = 15, number_of_columns = 2) {
  book_sentiment <- books_tidied %>%
    inner_join(get_sentiments(sentiment_type)) %>%
    filter(!word %in% c(remove_words)) %>%
    group_by(book) %>%
    count(word, sentiment, sort = T)
  
  prepare_for_ggplot <- book_sentiment %>%
    group_by(book) %>%
    top_n(words_shown) %>%
    ungroup() %>%
    arrange(book, n) %>%
    mutate(order = row_number())
  
  top_words <- ggplot(prepare_for_ggplot, aes(order, n, fill = sentiment)) +
    geom_col() +
    xlab("Words") +
    ylab("Occurrances") +
    facet_wrap(~ book, ncol = number_of_columns, scales = "free_y") +
    scale_x_continuous(
      breaks = prepare_for_ggplot$order,
      labels = prepare_for_ggplot$word,
      expand = c(0,0)
    ) +
    theme(legend.position = "bottom") +
    coord_flip()
  
  return(top_words)
}

single_word_sentiment <- function(books_tidied, sentiment_type = "bing", remove_words = NULL, line_count = 80, number_of_columns = 2) {
  books_sentiment <- books_tidied %>%
    inner_join(get_sentiments("bing")) %>%
    filter(!word %in% c(remove_words)) %>%
    count(book, index = linenumber %/% line_count, sentiment) %>%
    spread(sentiment, n, fill = 0) %>%
    mutate(sentiment = positive - negative)
  
  books_sentiment %>% 
    ggplot(aes(index, sentiment, fill = book)) +
    geom_col(show.legend = F) +
    facet_wrap(~book, ncol = number_of_columns, scales = "free_x")
}

single_word_cloud <- function(books_tidied, remove_words = NULL, number_of_words = 100) {
  books_tidied %>%
    filter(!word %in% remove_words) %>%
    count(word) %>%
    with(wordcloud(word, n, max.words = number_of_words))
}

peter <- gather_gutenberg_books(16, "Peter Pan")
peter <- single_word_unnested(peter)
single_word_review(peter, 25)
single_word_sentiment_cleaning(peter, words_shown = 20, remove_words = c("darling", "pan", "lost"))
single_word_sentiment(peter, remove_words = c("darling", "pan", "lost"))
single_word_cloud(peter)

bible <- gather_gutenberg_books(10, "King James Version of Bible")
bible <- single_word_unnested(bible)
single_word_review(bible)
single_word_sentiment_cleaning(bible, words_shown = 50)
single_word_sentiment(bible, line_count = 250)
single_word_cloud(bible, remove_words = 0:100)

alice <- single_word_unnested(gather_gutenberg_books(
  c(19033, 12),
  c("Alice's Adventures in Wonderland","Through the Looking-Glass")))
single_word_review(alice)
single_word_sentiment_cleaning(alice, words_shown = 15)
single_word_sentiment(alice)
single_word_cloud(alice)

kids <- single_word_unnested(gather_gutenberg_books(
  c(19033, 12, 289, 236, 501, 1154, 19, 47), 
  c("Alice's Adventures in Wonderland", "Through the Looking-Glass", "The Wind in the Willows", "The Jungle Book", "The Story of Doctor Dolittle", "The Voyages of Doctor Dolittle", "The Song of Hiawatha", "Anne of Avonlea")))
single_word_review(kids, show_top_words = 5)
single_word_sentiment_cleaning(kids, words_shown = 10, remove_words = c("miss"))
single_word_sentiment(kids, remove_words = c("miss"))
single_word_cloud(kids)

oz <- single_word_unnested(gather_gutenberg_books(
  c(55, 55, 420, 419, 517, 486, 485, 955, 957, 956, 25581, 24459, 30852, 961),
  c("The Wonderful Wizard of Oz", "The Marvelous Land of Oz", "Dorothy and the Wizard", "The Magic of Oz", "The Emerald City of Oz", "Ozma of Oz", "The Road to Oz", "The Patchwork Girl of Oz", "The Scarecrow of Oz", "Tik-Tok of Oz", "Rinkitink in Oz", "The Lost Princess of Oz", "The Tin Woodman of Oz", "Glinda of Oz")))
single_word_review(oz, show_top_words = 10, number_of_columns = 3)
single_word_sentiment_cleaning(oz, remove_words = c("cowardly", "wicked", "witch", "magic"), words_shown = 5, number_of_columns = 3)
single_word_sentiment(oz, number_of_columns = 3, remove_words = c("cowardly", "wicked", "witch", "magic"))
single_word_cloud(oz)

oz %>%
  filter(!word %in% NULL) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))

oz %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = T) %>%
  filter(!word %in% c("cowardly", "wicked", "witch", "magic")) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("red", "blue"), max.words = 50)