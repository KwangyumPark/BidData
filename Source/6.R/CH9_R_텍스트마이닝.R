# 21.02.18 R 텍스트 마이닝

################################
# # # 9장.  텍스트 마이닝 # # #
################################
# 문자로 된 비정형 데이트로부터 가치있는 정보를 얻어내는 분석 : 텍스트 마이닝 시 가장 먼저 할 일은 형태소 분석

install.packages("rJava")
install.packages("memoise")

# google에서 KoNLP를 검색하면 "CRAN - Package KoNLP" 결과가 나타남. "CRAN - Package KoNLP"클릭 ->  "archive." 클릭 후 "KoNLP_0.80.2.tar.gz" 다운로드

# 우측의 Pakages->install 도구를 이용해서 install하기 위해
install.packages("devtools")

# KoNLP가 의존하는 package 미리 install
install.packages("hash")
install.packages("tau")
install.packages("Sejong")
install.packages("KoNLP")


# pakages->install 도구를 이용하여 KoNLP 패키지를 install

# C:/Users/tjoeun/Documents/R/win-library/4.0/KoNLP/java폴더에 "scala-library-2.11.8.jar"복사

library(KoNLP)
Sys.getenv("JAVA_HOME")

useNIADic() # 사전 설정하기
extractNoun('대한민국의 영토는 한반도와 그 부속 도서로 한다')
extractNoun('의미있는 하루 하루, 알차고 환희찬 하루 감사해요')

# 1. 힙합 가사 텍스트 마이닝
# 1.1 텍스트 마이닝 할 텍스트 로드(필요한 data 확보)
txt <- readLines('inData/hiphop.txt') # 비정형 데이터
txt
head(txt)

# 1.2 특수문자 제거
# gsub(oldStr, newStr, string)
# str_replace_all(string, oldStr, newStr)
library(stringr)
temp <- gsub('\\W',' ',txt)
txt  <- str_replace_all(txt, '\\W',' ')
table(temp==txt)

# 1.3 명사 추출
head(txt)
nouns <- extractNoun(txt) # 명사만 추출하여 list형태로 반환
class(nouns)
head(unlist(nouns))
wordcount <- table(unlist(nouns)) # 워드카운트(단어별 빈도표) 생성
class(wordcount)
sort(wordcount)
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
# stringsAsFactors = F : 문자를 factor타입으로 안 하고자
head(df_word,20)
str(df_word)
library(dplyr)
df_word <- rename(df_word, word=Var1, freq=Freq)
str(df_word)
head(df_word)
nrow(df_word)

df_word <- df_word %>% 
  filter(nchar(word)>=2) # nchar문자수 반환

df_word <- filter(df_word, nchar(word)>=2)
head(df_word)

# 자주 사용되는 단어 빈도표 top20 만들기
top20 <- df_word[order(-df_word$freq),][1:20,]
top20$word

top20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)
top20$word

# 자주 사용되는 단어 top20 그래프 그리기
library(ggplot2)
ggplot(data=top20, aes(x=freq, y=reorder(word, freq))) +
  geom_col() +
  geom_text(aes(label=freq), col='red')

# 워드클라우드
# 1. 비정형 text 데이터 확보
# 2. 패키지 설치 및 로드(KoNLP, wordcloud)
# 3. 확보된 text 데이터 읽어오기
# 4. 명사 추출
# 5. 필요없는 데이터 삭제(특수문자, zz, ㅋㅋ, ㅎㅎ, ...)
# 6. 워드카운트 생성
# 7. wordcloud함수 이용해서 워드클라우드 생성

install.packages("wordcloud")
library(wordcloud)

set.seed(1234) # 난수 생성 결과를 일치시키려고.
round(runif(6, min=1, max=45)) # 확인

display.brewer.all()
pal <- brewer.pal(8, 'Dark2')

set.seed(1234)

?wordcloud
wordcloud(words = df_word$word, # 뿌려질 단어
          freq = df_word$freq,  # 단어 빈도
          min.freq = 2,         # 최소 단어 빈도
          max.words = 200,      # 표현될 최대 단어 수
          random.order = F,     # 최빈 단어를 중앙 배치
          rot.per = 0.1,        # 회전 단어 비율
          scale = c(2,0.3),     # 단어 크기 범위
          colors = pal)         # 단어 색상

display.brewer.all() # palette 이름과 색상들을 한꺼번에 봄
pal <- brewer.pal(9,'Blues')[5:9] # 색상 목록 생성
set.seed(1234)
wordcloud(words = df_word$word, # 뿌려질 단어
          freq = df_word$freq,  # 단어 빈도
          min.freq = 3,         # 최소 단어 빈도
          max.words = 100,      # 표현될 최대 단어 수
          random.order = F,     # 최빈 단어를 중앙 배치
          rot.per = 0.1,        # 회전 단어 비율
          scale = c(2,0.7),     # 단어 크기 범위
          colors = topo.colors(16))         # 단어 색상

# 2. 국정원 트윗 데이터 텍스트 마이닝
rm(list=ls())
twitter <- read.csv('inData/twitter.csv',
                    header = TRUE,
                    stringsAsFactors = F,
                    fileEncoding = 'UTF-8')
head(twitter)
View(twitter)
class(twitter)
library(dplyr)
twitter <- rename(twitter,
                  no=번호, id=계정이름, date=작성일, tw=내용)
View(twitter)

# 필요없는 문자, 단어 삭제하기
twitter$tw <- str_replace_all(twitter$tw, '\\W',' ')
twitter$tw <- str_replace_all(twitter$tw, '[ㄱ-ㅎ]',' ')
View(twitter)
head(twitter)

nouns <- extractNoun(twitter$tw)

class(nouns)
nouns
wordcount <- table(unlist(nouns))
class(wordcount)
df_word <- as.data.frame(wordcount, stringsAsFactors = FALSE)
str(df_word)

df_word <- rename(df_word, word=Var1, freq=Freq)
head(df_word)
str(df_word)

# 출현단어 중 2글자 이상만 분석
df_word <- filter(df_word, nchar(word)>1)
head(df_word)

# 최빈 단어 top20 뽑고 그래프 그리기
top20 <- df_word[order(df_word$freq, decreasing = T),][1:20,]
top20
library(ggplot2)

top20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20) 
ggplot(top20, aes(x=freq, y=reorder(word, freq))) +
  geom_col() +
  geom_text(aes(label=freq), hjust=1, size=3, col='yellow')

# 워드클라우드 그리기

set.seed(1234)
display.brewer.all() # palette 이름과 색상들을 한꺼번에 봄
pal <- brewer.pal(9, 'Blues')[5:9]
wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 5,
          max.words = 200,
          random.order = F,
          rot.per = 0.1,
          scale = c(3,0.3),
          colors = pal)


twitter <- read.csv('inData/twitter.csv',
                    header = TRUE,
                    stringsAsFactors = F,
                    fileEncoding = 'UTF-8')
twitter <- rename(twitter,
                  no=번호, id=계정이름, date=작성일, tw=내용)
sort(table(twitter$id))

# 글 게시 수가 150회이상 트윗한 게시물에 대해 최빈 top20개 단어를 출력, 시각화하고 워드 클라우드를 완성하시오.

idCount <- as.data.frame(table(twitter$id))

idCount <- rename(idCount, id=Var1, count=Freq)

head(idCount)

twitter <- left_join(twitter, idCount, by="id")
View(twitter)

sampleId <- idCount[idCount$count<150, 'id']
sampleId
twitter1 <- subset(twitter, subset = id %in% sampleId)
View(twitter1)


# 필요없는 문자, 단어 삭제하기
twitter1$tw <- str_replace_all(twitter1$tw, '\\W',' ')
twitter1$tw <- str_replace_all(twitter1$tw, '[ㄱ-ㅎ]',' ')
View(twitter1)
head(twitter1)

nouns <- extractNoun(twitter1$tw)

#워드카운드 생성
wordcount <- table(unlist(nouns))

df_word <- as.data.frame(wordcount, stringsAsFactors = FALSE)
str(df_word)

df_word <- rename(df_word, word=Var1, freq=Freq)
head(df_word)
str(df_word)

# 출현단어 중 2글자 이상만 분석
df_word <- filter(df_word, nchar(word)>1)
head(df_word)

# 최빈 단어 top20 뽑고 그래프 그리기
top20 <- df_word[order(df_word$freq, decreasing = T),][1:20,]
top20

top20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20) 

ggplot(top20, aes(x=freq, y=reorder(word, freq))) +
  geom_col() +
  geom_text(aes(label=freq), hjust=1, size=3, col='yellow')

# 워드클라우드 그리기

set.seed(1234)
pal <- brewer.pal(9, 'Blues')[5:9]
wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 5,
          max.words = 200,
          random.order = F,
          rot.per = 0.1,
          scale = c(3,0.3),
          colors = pal)