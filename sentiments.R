library(dplyr)
library(stringr)
library(tidytext)
library(ggplot2)
library(gutenbergr)
library(tidyr)

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