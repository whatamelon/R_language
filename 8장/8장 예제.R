#------------------텍스트마이닝-----------------

install.packages("rJava")

install.packages("memoise")

install.packages("KoNLP")  #-----------한글로 분석가능----------

library(KoNLP)  

library(dplyr)

useNIADic()

txt <- readLines("hiphop.txt")

head(txt)

#------------------특수문자 제거하기-----------------

library(stringr)

txt <- str_replace_all(txt, "\\W", " ")

#------------------가장 많이 사용된 단어 알아보기-----------------

extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다")

nouns <- extractNoun(txt)

wordcount <- table(unlist(nouns))

df_word <- as.data.frame(wordcount, stringsAsFactors = F)

df_word <- rename(df_word,
				word = Var1,
				freq = Freq)

df_word <- filter(df_word, nchar(word) >=2)

top_20 <- df_word %>%
	arrange(desc(freq)) %>%
	head(20)
top_20


#------------------워드 클라우드 만들기-----------------

install.packages("wordcloud")

library(wordcloud)

library(RColorBrewer)

pal <- brewer.pal(8, "Dark2")

set.seed(1234)

wordcloud(words = df_word$word,
		freq = df_word$freq,
		min.freq = 2,
		max.words = 200,
		random.order = F,
		rot.per = .1,
		scale = c(4, 0.3),
		colors = pal)

pal <- brewer.pal(9, "Blues")[5:9]
set.seed(1234)

wordcloud(words = df_word$word,
		freq = df_word$freq,
		min.freq = 2,
		max.words = 200,
		random.order = F,
		rot.per = .1,
		scale = c(4, 0.3),
		colors = pal)

#------------------국정원 트윗 텍스트 마이닝-----------------

library(KoNLP)

library(dplyr)

library(wordcloud)

library(wordcloud)

library(RColorBrewer)
twitter <- read.csv("twitter.csv",
				header = T,
				stringsAsFactors = F,
				fileEncoding = "UTF-8")

twitter <- rename(twitter,
				no = 번호,
				id = 계정이름,
				date = 작성일,
				tw = 내용)

head(twitter$tw)

#------------------단어 빈도표 만들기-----------------

nouns <- extractNoun(twitter$tw)

wordcount <- table(unlist(nouns))

df_word <- as.data.frame(wordcount, stringsAsFactors = F)

df_word <- rename(df_word, 
				word = Var1,
				freq = Freq)

df_word <- filter(df_word, nchar(word) >=2)

top20 <- df_word %>%
	arrange(desc(freq)) %>%
	head(20)

top20

library(ggplot2)

order <- arrange(top20, freq)$word
ggplot(data = top20, aes(x = word, y = freq) +
	ylim(0,2500) +
	geom_col() +
	coord_flip() + 
	scale_x_discrete(limit = order) +
	geom_text(aes(label = freq), hjust = -0.3)

pal <- brewer.pal(8,"Dark2")
set.seed(1234)
wordcloud(words = df_word$word,
		freq = df_word$freq,
		min.freq = 10,
		max.words = 200,
		random.order = F,
		rot.per = .1,
		scale = c(10, 0.5),
		colors = pal)

pal <- brewer.pal(9,"Blues")[5:9]
set.seed(1234)
wordcloud(words = df_word$word,
		freq = df_word$freq,
		min.freq = 10,
		max.words = 200,
		random.order = F,
		rot.per = .1,
		scale = c(10, 0.5),
		colors = pal)