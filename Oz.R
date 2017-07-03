library(dplyr)
library(stringr)
library(tidytext)
library(ggplot2)
library(gutenbergr)
library(tidyr)


oz_books <- data.frame(
  "gutenberg_id" = c(55, 
                     55, 
                     420, 
                     419,
                     517,
                     486,
                     485,
                     955,
                     957),
  "book" = c("The Wonderful Wizard of Oz",
             "The Marvelous Land of Oz",
             "Dorothy and the Wizard",
             "The Magic of Oz",
             "The Emerald City of Oz",
             "Ozma of Oz",
             "The Road to Oz",
             "The Patchwork Girl of Oz",
             "The Scarecrow of Oz"))

oz <- gutenberg_download(oz_books$gutenberg_id)

oz <- left_join(oz, oz_books, "gutenberg_id")

oz <- oz %>%
  group_by(book) %>%
  mutate(linenumber = row_number()) %>%
  ungroup()

tidy_oz <- oz %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_oz %>%
  count(word, sort = T)

tidy_oz %>%
  count(word, sort = T) %>%
  filter(n > 500) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()

sentiment_oz <- tidy_oz %>% 
  inner_join(get_sentiments("bing")) %>%
  count(book, index = linenumber %/% 40, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative)

ggplot(sentiment_oz, aes(index, sentiment, fill = book)) +
  geom_col(show.legend = F) +
  facet_wrap(~book, ncol = 2, scales = "free_x")
