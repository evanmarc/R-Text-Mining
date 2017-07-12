library(dplyr)
library(stringr)
library(tidytext)
library(ggplot2)
library(gutenbergr)
library(tidyr)

sherlock <- c(
  48320, # Adventures of Sherlock Holmes
  834, #   The Memoirs of Sherlock Holmes
  108, #   The Return of Sherlock Holmes
  2350, #  His Last Bow
   #       The Case-Book of Sherlock Holmes
  244, #   A Study in Scarlet
  2097, #  The Sign of the Four
  2852, #  The Hound of the Baskervilles
  3289 #   The Valley of Fear
)

sherlock_books <- data.frame("gutenberg_id" = c(48320, 834, 108, 2350, 244, 2097, 2852, 3289),"book" = c("Adventures of Sherlock Holmes","The Memoirs of Sherlock Holmes","The Return of Sherlock Holmes","His Last Bow","A Study in Scarlet","The Sign of the Four","The Hound of the Baskervilles","The Valley of Fear"))

doyle <- gutenberg_download(sherlock)

doyle <- left_join(doyle, sherlock_books, "gutenberg_id")

doyle_books <- doyle %>%
  group_by(book) %>%
  mutate(linenumber = row_number()) %>%
  ungroup()

tidy_doyle <- doyle_books %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_doyle %>%
  count(word, sort = T)

tidy_doyle %>%
  count(word, sort = T) %>%
  filter(n > 500) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

sentiment_doyle <- tidy_doyle %>% 
  inner_join(get_sentiments("bing")) %>%
  count(book, index = linenumber %/% 80, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative)

ggplot(sentiment_doyle, aes(index, sentiment, fill = book)) +
  geom_col(show.legend = F) +
  facet_wrap(~book, ncol = 2, scales = "free_x")
