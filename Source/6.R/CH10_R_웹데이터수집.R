#21.02.18 R 웹 데이터수집

#################################
# # # 10장.  웹 데이터 수집 # # #
#################################
# 1. 정적 웹 크롤링 ; 단일 페이지 크롤링 (rvest 패키지 사용)
install.packages("rvest")
library(rvest)

url <- 'https://movie.naver.com/movie/point/af/list.nhn'
text <- read_html(url, encoding = 'CP949')
text
# 영화제목 ; .movie
nodes <- html_nodes(text, '.movie')
title <- html_text(nodes)


# 해당 영화 페이지
movieInfo <- html_attr(nodes, 'href')
movieInfo <- paste0(url, movieInfo)
movieInfo

# 평점 ; .list_netizen_score em
nodes <- html_nodes(text, ".list_netizen_score em")
nodes
point <- html_text(nodes)
point
# 영화 리뷰 ; .title
nodes <- html_nodes(text, '.title')
nodes
review <- html_text(nodes, trim=TRUE)
review
review <- gsub('\t','', review)
review <- gsub('\n', '', review)
review
review <- unlist(strsplit(review, '중[0-9]{1,2}'))[seq(2,20,2)]
review <- gsub('신고','',review)
review
page <- cbind(title, movieInfo)
page <- cbind(page, point)
page <- cbind(page, review)
View(page)

# csv 파일로 out
write.csv(page, "outData/movie_review.csv")
write.csv(page, "outData/movie_review1.csv", row.names = F)

# 여러 페이지 정적 웹 크롤링
home <- 'https://movie.naver.com/movie/point/af/list.nhn'
site <- 'https://movie.naver.com/movie/point/af/list.nhn?&page='
movie.review <- NULL

for(i in 1:100){
  url <- paste0(site, i);
  text <- read_html(url, encoding = 'CP949')
  # 영화제목 ; .movie
  nodes <- html_nodes(text, '.movie')
  title <- html_text(nodes)
  # 해당 영화 페이지
  movieInfo <- html_attr(nodes, 'href')
  movieInfo <- paste0(home, movieInfo)
  # 평점 ; .list_netizen_score em
  nodes <- html_nodes(text, ".list_netizen_score em")
  point <- html_text(nodes)
  # 영화 리뷰 ; .title
  nodes <- html_nodes(text, '.title')
  review <- html_text(nodes, trim=TRUE)
  review <- gsub('\t','', review)
  review <- gsub('\n', '', review)
  review <- unlist(strsplit(review, '중[0-9]{1,2}'))[seq(2,20,2)]
  review <- gsub('신고','',review)
  page <- cbind(title, movieInfo)
  page <- cbind(page, point)
  page <- cbind(page, review)
  movie.review <- rbind(movie.review, page)
}
View(movie.review)
write.csv(movie.review, 'outData/movie_review100page.csv')

# 1~100까지 크롤링 한 영화들 중 평점에 높은 10개를 시각화 하시오.
library(dplyr)
library(ggplot2)
library(KoNLP)
library(wordcloud)
movie <- as.data.frame(movie.review, stringsAsFactors = F)
str(movie)
# movie <- read.csv('outData/movie_review100page.csv', header = TRUE)
movie$point <- as.numeric(movie$point)

result <- movie %>% 
  group_by(title) %>% 
  summarise(point.mean = mean(point),
            point.sum  = sum(point),
            n=n()) %>% 
  arrange(desc(point.mean), desc(point.sum)) %>% 
  head(10)

ggplot(result, aes(x=point.sum, y=reorder(title, point.sum)), vjust=1) +
  geom_col(aes(fill=title)) +
  labs(title = "평점이 높은 top10", x="평점 총점")+
  geom_text(aes(label=paste('총점:',point.sum,'평균:',point.mean)), hjust=0) +
  coord_cartesian(xlim=c(0,120))  +
  theme(axis.title.y = element_blank(),
        legend.position = "none")
# 영화 리뷰 내용만 뽑아 최빈 단어 10개. 워드클라우드 시각화

useNIADic()
movie$review <- gsub('\\W',' ',movie$review)
movie$review <- gsub('[ㄱ-ㅎ]',' ',movie$review)
View(movie)
nouns <- extractNoun(movie$review)

wordcount <- table(unlist(nouns))
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word <- rename(df_word, word=Var1, freq=Freq)
View(df_word)
df_word <- filter(df_word, nchar(word)>1)

# 최빈 단어 top20 뽑고 그래프 그리기
top20 <- df_word[order(df_word$freq, decreasing = T),][1:20,]
top20
ggplot(top20, aes(x=freq, y=reorder(word, freq))) +
  geom_col() +
  geom_text(aes(label=freq), hjust=1, size=3, col='yellow')

# 워드클라우드 그리기

set.seed(1234)
display.brewer.all() # palette 이름과 색상들을 한꺼번에 봄
pal <- brewer.pal(8, 'Dark2')
wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 5,
          max.words = 200,
          random.order = F,
          rot.per = 0.1,
          scale = c(4,0.3),
          colors = pal)