
# Peter Pan
peter <- gather_gutenberg_books(16, "Peter Pan")
peter <- single_word_unnested(peter)
single_word_review(peter, 25)
single_word_sentiment_cleaning(peter, words_shown = 20, remove_words = c("darling", "pan", "lost", "cry"))
single_word_sentiment(peter, remove_words = c("darling", "pan", "lost", "cry"))
single_word_cloud(peter)

# Bible
bible <- gather_gutenberg_books(10, "King James Version of Bible")
bible <- single_word_unnested(bible)
single_word_review(bible)
single_word_sentiment_cleaning(bible, words_shown = 50)
single_word_sentiment(bible, line_count = 250)
single_word_cloud(bible, remove_words = 0:100)

# Alice's Adventures in Wonderland
alice <- single_word_unnested(gather_gutenberg_books(
  c(19033, 12),
  c("Alice's Adventures in Wonderland","Through the Looking-Glass")))
single_word_review(alice)
single_word_sentiment_cleaning(alice, words_shown = 15)
single_word_sentiment(alice)
single_word_cloud(alice)

# Kids books
kids <- single_word_unnested(gather_gutenberg_books(
  c(19033, 12, 289, 236, 501, 1154, 19, 47), 
  c("Alice's Adventures in Wonderland", "Through the Looking-Glass", "The Wind in the Willows", "The Jungle Book", "The Story of Doctor Dolittle", "The Voyages of Doctor Dolittle", "The Song of Hiawatha", "Anne of Avonlea")))
single_word_review(kids, show_top_words = 5)
single_word_sentiment_cleaning(kids, words_shown = 10, remove_words = c("miss"))
single_word_sentiment(kids, remove_words = c("miss"))
single_word_cloud(kids)

# Wizard of Oz Series
oz <- gather_gutenberg_books(
  c(55, 55, 420, 419, 517, 486, 485, 955, 957, 956, 25581, 24459, 30852, 961),
  c("The Wonderful Wizard of Oz", "The Marvelous Land of Oz", "Dorothy and the Wizard", "The Magic of Oz", "The Emerald City of Oz", "Ozma of Oz", "The Road to Oz", "The Patchwork Girl of Oz", "The Scarecrow of Oz", "Tik-Tok of Oz", "Rinkitink in Oz", "The Lost Princess of Oz", "The Tin Woodman of Oz", "Glinda of Oz"))

class(oz)

saveRDS(oz, "Data/Oz.RData")

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

# Anne of Green Gables
anne <- gather_gutenberg_books(c(47, 45, 51, 544, 5343, 3796), c("Anne of Avonlea", "Anne of Green Gables", "Anne of the Island", "Anne's House of Dreams", "Rainbow Valley", "Rilla of Ingleside"))
anne <- single_word_unnested(anne)
single_word_review(anne)
single_word_sentiment_cleaning(anne, remove_words = c("miss", "dick"))
single_word_sentiment(anne, remove_words = c("miss", "dick"))
single_word_cloud(anne, number_of_words = 250, remove_words = c("miss"))

