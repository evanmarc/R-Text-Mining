library(dplyr)
library(stringr)
library(janeaustenr)
library(tidytext)
library(ggplot2)

original_books <- austen_books() %>% 
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]", ignore_case = T)))) %>%
  ungroup()

tidy_books <- original_books %>%
  unnest_tokens(word, text)

data("stop_words")

tidy_books <- tidy_books %>%
  anti_join(stop_words)

tidy_books %>%
  count(word, sort = T) %>%
  filter(n > 500) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()
