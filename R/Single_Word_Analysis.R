library(tidyverse)
library(wordcloud)
library(reshape2)
library(gutenbergr)
library(stringr)
library(tidytext)

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