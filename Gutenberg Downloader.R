library(dplyr)
library(stringr)
library(tidytext)
library(ggplot2)
library(gutenbergr)
library(tidyr)


quick_gutenberg <- function(guten_id, book_names) {
  a <- gutenberg_download(guten_id)
  
  b <- left_join(a, data.frame(gutenberg_id = guten_id, book = book_names))
}

bing_sentimental <- function(b, line_count = 80) {
  c <- b %>%
    group_by(book) %>%
    mutate(linenumber = row_number()) %>%
    ungroup()
  
  d <- c %>%
    unnest_tokens(word, text) %>%
    anti_join(stop_words)
  
  e <- d %>%
    inner_join(get_sentiments("bing")) %>%
    count(book, index = linenumber %/% line_count, sentiment) %>%
    spread(sentiment, n, fill = 0) %>%
    mutate(sentiment = positive - negative)
  
  f <- d %>%
    inner_join(get_sentiments("bing")) %>%
    count(sentiment, sort = T)
  
  ggplot(e, aes(index, sentiment, fill = book)) +
  geom_col(show.legend = F) +
  facet_wrap(~book, ncol = 2, scales = "free_x") +
  annotate("text", x = 0, y = 0, hjust = 0, label = paste0("Negative: ", f[1,2], "\nPositive: ", f[2,2]))
}

bom <- quick_gutenberg(17, "The Book of Mormon")
bing_sentimental(bom.1, 160)

View(bom)
bom.1 <- bom[!grepl("[1-4 ]*[A-Z]*[a-z]+ [0-9]+:[0-9]+", bom$text),]
View(bom.1[])


bible <- quick_gutenberg(10, "King James Version of Bible")
bing_sentimental(bible, 160)

kids <- quick_gutenberg(
  c(19033, 12, 289, 236, 501, 1154, 19, 47), 
  c("Alice's Adventures in Wonderland",
    "Through the Looking-Glass",
    "The Wind in the Willows",
    "The Jungle Book",
    "The Story of Doctor Dolittle",
    "The Voyages of Doctor Dolittle",
    "The Song of Hiawatha",
    "Anne of Avonlea"))

bing_sentimental(kids)

peter_pan <- gutenberg_download(16)
peter_pan$book = "Peter Pan"

unnest_pan %>% inner_join(get_sentiments("bing")) %>% count(sentiment)

tidy_pan <- peter_pan %>%
  mutate(linenumber = row_number())
  
unnest_pan <- tidy_pan %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

unnest_pan

afinn <- unnest_pan %>%
  inner_join(get_sentiments("afinn")) %>%
  group_by(index = linenumber %/% 80) %>%
  summarise(sentiment = sum(score)) %>%
  mutate(method = "AFINN")

bing_and_nrc <- bind_rows(
  unnest_pan %>%
    inner_join(get_sentiments("bing")) %>%
    mutate(method = "Bing et al."),
  unnest_pan %>%
    inner_join(get_sentiments("nrc")) %>%
    filter(sentiment %in% c("positive", "negative")) %>%
    mutate(method = "NRC")
  ) %>%
    count(method, index = linenumber %/% 80, sentiment) %>%
    spread(sentiment, n, fill = 0) %>%
    mutate(sentiment = positive - negative)

bind_rows(afinn, bing_and_nrc) %>%
  ggplot(aes(index, sentiment, fill = method)) +
  geom_col(show.legend = F) +
  facet_wrap(~method, ncol = 1, scales = "free_y") +
  ggtitle("Peter Pan")
