A couple weeks ago I came across [Text Mining with
R](http://tidytextmining.com) by Julia Silge and David Robinson. Since I
played with latent semantic analysis a few years ago, I thought it would
be fun to learn about text mining. Because I wanted to do more than just
work through the examples in the book, I decided to apply the principals
to [*The Wonderful Wizard of
Oz*](https://en.wikipedia.org/wiki/List_of_Oz_books) series. As such,
this will be the first of several posts where I apply the concepts from
Text Mining with R to the Oz series. Hope you enjoy!

Text Mining the Oz Series {#text-mining-the-oz-series}
=========================

Thanksfully, I was able to download all the Oz books from Project
Gutenberg and was surprised to learn that the author, L. Frank Baum, had
written a total of 14 Oz books. The table below lists each book, the
year it was published, the estimated number of pages, total words in the
book, and the remaining words after common words (such as "the", "and",
"a", etc.) have been removed.[^1]

| book                       | year published | est. number of pages | total words | remaining words |
|:---------------------------|:--------------:|:--------------------:|:-----------:|:---------------:|
| The Wonderful Wizard of Oz |      1900      |          119         |    39,704   |      12,309     |
| The Marvelous Land of Oz   |      1904      |          119         |    39,704   |      12,309     |
| Ozma of Oz                 |      1907      |          126         |    39,450   |      13,916     |
| Dorothy and the Wizard     |      1908      |          133         |    42,273   |      14,261     |
| The Road to Oz             |      1909      |          129         |    39,999   |      14,288     |
| The Emerald City of Oz     |      1910      |          174         |    54,037   |      18,664     |
| The Patchwork Girl of Oz   |      1913      |          185         |    57,820   |      19,607     |
| Tik-Tok of Oz              |      1914      |          156         |    48,795   |      17,335     |
| The Scarecrow of Oz        |      1915      |          140         |    46,180   |      15,964     |
| Rinkitink in Oz            |      1916      |          148         |    49,674   |      18,057     |
| The Lost Princess of Oz    |      1917      |          152         |    47,859   |      16,139     |
| The Tin Woodman of Oz      |      1918      |          140         |    44,803   |      15,358     |
| The Magic of Oz            |      1919      |          123         |    39,625   |      13,684     |
| Glinda of Oz               |      1920      |          120         |    40,130   |      14,010     |
| TOTAL WORDS                |                |                      |   630,053   |     215,901     |

Comparison of Total Words vs Stop Words {#comparison-of-total-words-vs-stop-words}
---------------------------------------

I'll admit that I was a little suprised seeing a total of 630,053 words
in the Oz series. Even after pulling out the common words, or stop
words, there are still 215,901 words left. I figure it is helpful to
show the top 32 words in these two sets of data just to get an idea of
the benefits of pulling out stop words.

<img src="Oz_Blog_Post_files/figure-markdown_phpextra+backtick_code_blocks/Table of top 32 words-1.png" width="960" />

I specifically picked the top 32 words because this is the first time I
see Dorothy in both the total words and remaining words. This simple
example highlights the scale of how many, and how common the stops words
are in the Oz series. The next two charts also highlight the
differences. The first chart shows the total words and the second chart
shows the remaining words. Both charts follw the trend that the most
used words are on the left and quickly drop off to the less used words.
While both charts follow a similar pattern, notice that the total words
chart starts at over 40,000 occurances while the remaining words is just
under 3,000.

<img src="Oz_Blog_Post_files/figure-markdown_phpextra+backtick_code_blocks/Total Words by Rank in Oz Series-1.png" width="960" />

<img src="Oz_Blog_Post_files/figure-markdown_phpextra+backtick_code_blocks/Remaining Words by Rank in Oz Series-1.png" width="960" />

Zipf's Law {#zipfs-law}
----------

In 1935 George Kingsley Zipf, proposed the rule [Zipf's
Law](https://simple.wikipedia.org/wiki/Zipf%27s_law). This rule states
that with a large set of words, the frequency of any word is inversely
proportional to its rank in the frequency table. The formula, word
number N has a frequency of 1/N. This is an interesting rule, and is
fairly consisent across multiple languages. So I decided I would go
ahead and include a chart of Zipf's Law applied to the Oz series.

<img src="Oz_Blog_Post_files/figure-markdown_phpextra+backtick_code_blocks/Oz Series Zipf's Law on Total Words-1.png" width="960" />

Comparing the Remaining Words {#comparing-the-remaining-words}
-----------------------------

While the charts above provide some insights about the Oz series, I
really want to look at the remaining words. The following two charts
provide that breakdown. The first chart shows the top 25 words in all
the books, while the second chart shows the top 5 works within each
book. A quick review shows that the top remaining words are often proper
nouns. For example, Dorothy, Oz, Ozma, and Scarecrow are the most common
words in the first chart; while additional proper nouns, such as Zeb,
Rinkitink, Jim, or Nimmie, show up in the second chart.

<img src="Oz_Blog_Post_files/figure-markdown_phpextra+backtick_code_blocks/Top 25 Words-1.png" width="960" />

<img src="Oz_Blog_Post_files/figure-markdown_phpextra+backtick_code_blocks/Top 5 Words per Book-1.png" width="960" />

Word Cloud {#word-cloud}
----------

Because the post is getting pretty long, I think I'll close up with a
basic word cloud of the top 100 remaining words. It makes for a fun
visualization.

<img src="Oz_Blog_Post_files/figure-markdown_phpextra+backtick_code_blocks/Word Cloud of Oz Series-1.png" width="960" />

To Be Continued {#to-be-continued}
---------------

I think this is a good starting point for my first text mining post.
There are a couple other text mining concepts I still want to work
through and so expect to see another post in the near future!

[^1]: Commonly removed words are also known as stop word, which I will
    use throughout the rest of these posts.
