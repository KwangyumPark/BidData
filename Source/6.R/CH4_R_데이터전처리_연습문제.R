#21.02.08 dplyr을 이용한 데이터 전처리 연습문제



###############################################
# # # # #  혼 자 서 해 보 기   (1)    # # # # # 
###############################################
mpg <- as.data.frame(ggplot2::mpg)
library(dplyr)
library(doBy)

# Q1. 자동차 배기량에 따라 고속도로 연비가 다른지 알아보려고 합니다. displ(배기량)이 
# 4 이하인 자동차와 5 이상인 자동차 중 어떤 자동차의 hwy(고속도로 연비)가 
# 평균적으로 더 높은지 알아보세요.

# (1) dplyr 패키지 이용
mpg %>% 
  mutate(group = ifelse(displ<=4, "배기량4이하", ifelse(displ>=5, "배기량5이상", NA))) %>% 
  group_by(group) %>% 
  summarise(mean_total=mean(hwy)) %>% 
  filter(!is.na(group))

mpg %>% 
  filter(displ<=4 | displ>=5) %>% 
  mutate(group = ifelse(displ<=4, "배기량4이하", ifelse(displ>=5, "배기량5이상", NA))) %>% 
  group_by(group) %>% 
  summarise(mean_total=mean(hwy))

# (2) apply계열 함수 이용 : tapply, by, summaryBy(doBy), aggregate
df <- mpg[(mpg$displ<=4 | mpg$displ>= 5),]

df$group <- ifelse(df$displ<=4, "배기량4이하", ifelse(df$displ>=5, "배기량5이상", NA))
head(df)
tapply(df$hwy, df$group, mean)
by(df$hwy, df$group, mean) # 다수개 열일때는 mean은 안되고 summary, sum 등 됨
summaryBy(hwy~group, df, FUN=mean) # 다수개 열과 다수개 함수 가능
aggregate(df$hwy, by=list(df$group), mean) 


# Q2. 자동차 제조 회사에 따라 도시 연비가 다른지 알아보려고 합니다. 
# "audi"와 "toyota" 중 어느 manufacturer(자동차 제조 회사)의 cty(도시 연비)가 
# 평균적으로 더 높은지 알아보세요.

#(1) 방법
mpg %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty = mean(cty)) %>% 
  filter(manufacturer %in% c("audi", "toyota"))

mpg %>% 
  filter(manufacturer %in% c("audi", "toyota")) %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty = mean(cty))

#(2) 방법
df <- mpg[mpg$manufacturer %in% c("audi", "toyota"),]
head(df)
tapply(df$cty, df$manufacturer, mean)
by(df$cty, df$manufacturer, mean) # 다수개 열 가능
summaryBy(cty~manufacturer, df, FUN=c(mean)) # 다수개 열과 다수개 함수
aggregate(df$cty, by=list(df$manufacturer), mean) #다수개열 가능


# Q3. "chevrolet", "ford", "honda" 자동차의 고속도로 연비 평균을 알아보려고 
# 합니다. 이 회사들의 자동차를 추출한 뒤 hwy 전체 평균을 구해보세요.
# (1) 방법
mpg %>% 
  filter(manufacturer %in% c("chevrolet", "ford", "honda")) %>% 
  group_by(manufacturer) %>% 
  summarise(mean_hwy = mean(hwy))

#(2) 방법
df <- mpg[mpg$manufacturer %in% c("chevrolet", "ford", "honda"),]
df <- subset(mpg, (mpg$manufacturer %in% c("chevrolet", "ford", "honda")) )
df <- subset(mpg, (manufacturer %in% c("chevrolet", "ford", "honda")) )
tapply(df$hwy, df$manufacturer, mean)
by(df$hwy, df$manufacturer, mean)
summaryBy(hwy~manufacturer, df, FUN=mean)
aggregate(df$hwy, by=list(df$manufacturer), mean)


###############################################
# # # # #  혼 자 서 해 보 기   (2)    # # # # # 
###############################################
# Q1. mpg 데이터는 11개 변수로 구성되어 있습니다. 
# 이 중 일부만 추출해서 분석에 활용하려고 합니다. 
# mpg 데이터에서 class(자동차 종류), cty(도시 연비) 변수를 추출해 새로운 데이터를 만드세요. 
# 새로 만든 데이터의 일부를 출력해서 두 변수로만 구성되어 있는지 확인하세요.

dim(mpg)
df <- mpg %>% select(class, cty)    
head(df)

mpg[,c('class','cty')]
subset(mpg, select=c('class','cty'))

# Q2. 자동차 종류에 따라 도시 연비가 다른지 알아보려고 합니다. 
# 앞에서 추출한 데이터를 이용해서 class(자동차 종류)가 "suv"인 자동차와 
# "compact"인 자동차 중 어떤 자동차의 cty(도시 연비)가 더 높은지 알아보세요.

table(mpg$class)

# (1) 방법
mpg %>% 
  filter(class %in% c('suv','compact')) %>% 
  group_by(class) %>% 
  summarise(mean_cty = mean(cty))

# (2) 방법
df <- mpg[mpg$class %in% c('suv','compact') ,]
df
tapply(df$cty, df$class, mean)
by(df$cty, df$class, mean)
summaryBy(cty~class, df, FUN=mean)
aggregate(df$cty, by=list(df$class), mean)

# Q3. "audi"에서 생산한 자동차 중에 어떤 자동차 모델의 hwy(고속도로 연비)가 
# 높은지 알아보려고 합니다. "audi"에서 생산한 자동차 중 
# hwy가 1~5위에 해당하는 자동차의 데이터를 출력하세요.

# 방법(1)
mpg %>% 
  filter(manufacturer=='audi') %>% 
  arrange(desc(hwy)) %>% 
  head(5)

# 방법(2)
df<- mpg[mpg$manufacturer=='audi',]
head(orderBy(~-hwy, df),5)
head(df1[order(df$hwy, decreasing = T),],5)

###############################################
# # # # #  혼 자 서 해 보 기   (3)    # # # # # 
###############################################
#Q1. mpg 데이터 복사본을 만들고, cty와 hwy를 더한 '합산 연비 변수'를 추가하세요.
# (1)방법
mpg %>% 
  mutate(total = cty+hwy)

# (2) 방법
df<-mpg
df$total <- df$cty + df$hwy
df

#Q2. 앞에서 만든 '합산 연비 변수'를 2로 나눠 '평균 연비 변수'를 추가세요.
# (1) 방법
mpg %>% 
  mutate(total = (cty+hwy)/2)

# (2) 방법
mpg$total <- (mpg$cty+mpg$hwy)/2

# Q3. '평균 연비 변수'가 가장 높은 자동차 3종의 데이터를 출력하세요.

# (1) 방법
mpg %>% 
  mutate(total = (cty+hwy)/2) %>% 
  arrange(desc(total)) %>% 
  head(3)

# (2) 방법
head(orderBy(~-total, mpg),3)
orderBy(~-total, mpg)[1:3,]
head(mpg[order(mpg$total, decreasing = T),],3)
head(mpg[order(-mpg$total),],3) 
# mpg$total앞에 -를 붙여 내림차순정렬을 할 수 있는 것은 total이 숫자이기 때문. 
# 문자나 logical일 경우 아래와 같이 desc이용
head(mpg[order(desc(mpg$total)),],3)

#Q4. 1~3번 문제를 해결할 수 있는 하나로 연결된 dplyr 구문을 만들어 출력하세요. 
# 데이터는 복사본 대신 mpg 원본을 이용하세요.

# (1) 방법
mpg %>% 
  mutate(total = (cty+hwy)/2) %>% 
  arrange(desc(total)) %>% 
  head(3)

# (2) 방법
head(orderBy(~-total, mpg),3)
head(mpg[order(mpg$total, decreasing = T),],3)

###############################################
# # # # #  혼 자 서 해 보 기   (4)    # # # # # 
###############################################
#Q1. mpg 데이터의 class는 "suv", "compact" 등 자동차를 특징에 따라 일곱 종류로 
# 분류한 변수입니다. 어떤 차종의 연비가 높은지 비교해보려고 합니다. 
# class별 cty 평균을 구해보세요.

table(mpg$class)

# (1) 방법
library(dplyr)
mpg %>% 
  group_by(class) %>% 
  summarise(mean_cty=mean(cty))

# (2) 방법
tapply(mpg$cty, mpg$class, mean)
by(mpg$cty, mpg$class, mean)
summaryBy(cty~class, mpg)
aggregate(mpg$cty, by=list(mpg$class), mean)

#Q2. 앞 문제의 출력 결과는 class 값 알파벳 순으로 정렬되어 있습니다. 
# 어떤 차종의 도시 연비가 높은지 쉽게 알아볼 수 있도록 
# cty 평균이 높은 순으로 정렬해 출력하세요.

# (1) 방법
mpg %>% 
  group_by(class) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  arrange(desc(mean_cty))

# (2) 방법 - tapply - sort
sort(tapply(mpg$cty, mpg$class, mean), decreasing = TRUE)

# (2) 방법 -  tapply - order
result <- tapply(mpg$cty, mpg$class, mean)
class(result) # array 형태
result[order(result, decreasing = T)]

tapply(mpg$cty, mpg$class, mean)[order(tapply(mpg$cty, mpg$class, mean), decreasing = T)]

# (2) 방법 - by -sort
sort(by(mpg$cty, mpg$class, mean), decreasing = T)

# (2) 방법 - by -order
by(mpg$cty, mpg$class, mean)[order(by(mpg$cty, mpg$class, mean), decreasing = T)] 
# 가독성을 올리려면 결과를 변수로 뺌

result <- by(mpg$cty, mpg$class, mean)
result[order(result, decreasing = T)]

# (2) 방법 - summaryBy - order
result <- summaryBy(cty~class, mpg)
result # result가 data.frame 형태
result[order(result$cty.mean, decreasing = T),]

# (2) 방법 - summaryBy - orderBy
orderBy(~-cty.mean, result)

# (2) 방법 - aggregate - order
result<-aggregate(mpg$cty, by=list(mpg$class), mean)
result
result[order(result$x, decreasing = T),]
orderBy(~-x, result)

#Q3. 어떤 회사 자동차의 hwy(고속도로 연비)가 가장 높은지 알아보려고 합니다. 
# hwy 평균이 가장 높은 회사 세 곳을 출력하세요.
# (1) 방법
mpg %>% 
  group_by(manufacturer) %>% 
  summarise(mean_hwy = mean(hwy)) %>% 
  arrange(desc(mean_hwy)) %>% 
  head(3)

# (2) 방법
result <-aggregate(mpg$hwy, by=list(mpg$manufacturer), mean)
result # result가 data.frame형태
head(result[order(result$x, decreasing = T),] , 3)
result[order(result$x, decreasing = T),][1:3,]
head(orderBy(~-x, result), 3)

# Q4. 어떤 회사에서 "compact"(경차) 차종을 가장 많이 생산하는지 알아보려고 합니다. 
# 각 회사별 "compact" 차종 수를 내림차순으로 정렬해 출력하세요.

# (1) 방법
mpg %>% 
  filter (class=='compact') %>% 
  group_by(manufacturer) %>% 
  summarise(cnt = n()) %>% 
  arrange(desc(cnt))

df <- mpg[mpg$class=='compact',]
df <- subset(mpg, mpg$class=='compact')
df <- subset(mpg, class=='compact')
df
sort(table(df$manufacturer), decreasing = T)



# 4. 데이터 합치기
# 열 합치기 : cbind, left_join
# 행 합치기 : rbind, bind_rows
# cf. merge

# 4.1 열 합치기(가로 합치기)
test1 <- data.frame(id=c(1,2,3,4,5),
                    midterm = c(70,80,90,95,99))
test2 <- data.frame(id=c(1,2,3,4,5),
                    final = c(90,80,70,60,99),
                    teacherid=c(1,1,2,2,3))
teacher <- data.frame(teacherid=c(1,2,3),
                      teachername=c('Kim','Park','Ryu'))
cbind(test1, test2)
merge(test1, test2)
left_join(test1, test2, by="id")
# cbind(test2, teacher) 불가
left_join(test2, teacher, by="teacherid")
merge(test2, teacher, by="teacherid", all=T)

test2 <- data.frame(id=c(1,2,3,4,5),
                    final = c(90,80,70,60,99),
                    teacherid=c(1,1,2,2,4))
teacher <- data.frame(teacherid=c(1,2,3),
                      teachername=c('Kim','Park','Ryu'))

left_join(test2, teacher, by="teacherid")
merge(test2, teacher, by="teacherid", all=T) # 다소 다름

# 4.2 행 합치기(세로 합치기)
group_a <- data.frame(id=c(1,2,3,4,5),
                      test=c(60,70,80,90,95))
group_b <- data.frame(id=c(6,7,8,9,10),
                      test=c(90,95,94,93,92))
rbind(group_a, group_b) # 두 데이터프레임의 변수가 같을 경우
bind_rows(group_a, group_b)

group_a <- data.frame(id=c(1,2,3,4,5),
                      test1=c(60,70,80,90,95))
group_b <- data.frame(id=c(6,7,8,9,10),
                      test2=c(90,95,94,93,92))
rbind(group_a, group_b) # 두 데이터 프레임의 변수가 일부 같지 않을 경우
bind_rows(group_a, group_b)
merge(group_a, group_b, all=T)
merge(group_a, group_b) # merge 수행 안 됨

# 5. 데이터 정제하기 - 결측치(NA), 이상치
# 5.1 결측치 정제하기
df <- data.frame(name=c('Kim','Yi','Yun','Ma','Park'),
                 gender=c('M','F', NA, 'M','F'),
                 score=c(5,4,3,4,NA),
                 income=c(2000,3000,4000,4500,4600))
df
is.na(df)
dim(df)
table(is.na(df))
table(is.na(df$gender))
table(is.na(df$score))

na.omit(df) # 결측치가 하나라도 있으면 그 행 모두 제거. 
# 간편하지만, 같은행의 분석에 필요한 열의 정보까지 손실된다는 단점이 있음

df %>% 
  filter(!is.na(score)) %>% 
  summarise(mean_score=mean(score))
mean(df$score, na.rm=T) # 결측치를 제거하고 평균을 냄
tapply(df$score, df$gender, mean, na.rm=T)

# 결측치를 대체하기(평균값, 중앙값)
x <- c(1,1,2,2,3,3,3,4,4,5,5,100)
mean(x)
median(x)

exam <- read.csv("inData/exam.csv", header=T)
exam

table(is.na(exam))
colnames(exam)
exam[c(3,8,15),'math'] <- NA #인위적으로 math에 결측치 넣기
exam[1:2,'english']    <- NA #인위적으로 english에 결측치 넣기

table(is.na(exam))
apply(exam[3:5], 2, mean, na.rm=T)
tapply(exam[,3], exam$class, mean, na.rm=T)

exam %>% 
  summarise(math = mean(math, na.rm=T),
            english = mean(english, na.rm=T),
            science = mean(science, na.rm=T))

# 결측치들을 중앙값 대체
exam$math # 결측치 확인
exam$math <- ifelse(is.na(exam$math), median(exam$math, na.rm=T), 
                    exam$math)#중앙값대체
exam$math 
  <- ifelse(is.na(exam$math), round(mean(exam$math, na.rm=T)), 
            exam$math)#평균대체

exam$math # 결측치 대체됨

exam$english # 결측치 확인인
exam$english <- ifelse(is.na(exam$english),round(median(exam$english, na.rm=T)), 
                       exam$english) # 중앙값으로 결측치 대체
exam$english

table(is.na(exam))

exam <- read.csv("inData/exam.csv")
exam[c(1,3,8),'math'] <- NA
exam[1:2, 'english'] <- NA
exam[1, 'science'] <- NA
head(exam)

median <- round(apply(exam[3:5], 2, median, na.rm=T))
median['math']; median['english']; median['science']
# 결측치 대체 방법1
exam <- within(exam, { # 결측치 대체하기 위한 블록
  math    <- ifelse(is.na(math), median['math'], math)
  english <- ifelse(is.na(english), median['english'], english)
  science <- ifelse(is.na(science), median['science'], science)
})
table(is.na(exam))   # exam안에 결측치 갯수 확인
colSums(is.na(exam)) # 변수별 결측치 갯수 확인

#결측치 대체 방법2 (dplyr 패키지 이용)
colSums(is.na(exam))
median['math']; median['english']; median['science']
exam <- exam %>% 
  mutate(
    math   = ifelse(is.na(math), median['math'], math),
    english = ifelse(is.na(english), median['english'], english),
    science = ifelse(is.na(science), median['science'], science)
  )
exam

# 5.2 이상치(=극단치) 정제
# 극단적인 이상치(정상범위 기준에서 벗어난 값)
# 논리적인 이상치(ex. 성별에 남여가 아닌 값)
# 이상치는 결측치로 대체

# (1) 논리적인 이상치
outlier <- data.frame(gender=c(1,2,1,3,2),
                      score=c(90,95,100,99,101))
table(outlier$gender)
# gender 1은 남, 2는 여, 3은 이상치 처리
outlier$gender <- ifelse(outlier$gender==3, NA, outlier$gender)
outlier$gender <- ifelse((outlier$gender!=1 & outlier$gender!=2), NA, 
                         outlier$gender)
outlier
# score 가 100초과하는 경우 이상치 처리
outlier$score <- ifelse(outlier$score>100, NA, outlier$score)
outlier

# (2) 정상범위 기준으로 많이 벗어난 이상치 : 상하위 0.3% 또는 평균+3*표준편차
mpg <- as.data.frame(ggplot2::mpg)
mpg$hwy
mean(mpg$hwy)+3*sd(mpg$hwy)
mean(mpg$hwy)-3*sd(mpg$hwy)
result <- boxplot(mpg$hwy)$stats
result[1]; result[5]
mpg$hwy <- ifelse(mpg$hwy>result[5] | mpg$hwy<result[1], NA, mpg$hwy)
table(is.na(mpg$hwy))

rm(list=ls())

###############################################
# # # # #  혼 자 서 해 보 기   (5)    # # # # # 
###############################################
mpg <- as.data.frame(ggplot2::mpg)
colnames(mpg)
mpg$fl
table(mpg$fl)
head(mpg,2)
fuel <- data.frame(fl=c('c','d','e','p','r'),
                   kind=c('CNG','diesel','ethanol E85','premium','regular'),
                   price_fl=c(2.35,2.38,2.11,2.76,2.22))

#Q1. mpg 데이터에는 연료 종류를 나타낸 fl 변수는 있지만 연료 가격을 나타낸 
# 변수는 없습니다. 
# 위에서 만든 fuel 데이터를 이용해서 mpg 데이터에 price_fl(연료 가격) 
# 변수를 추가하세요.

# 방법1
mpg <- left_join(mpg, fuel[,c('fl','price_fl')], by='fl')

# 방법2
mpg <- merge(mpg, fuel[,c('fl','price_fl')], by='fl')
head(mpg,2)

# Q2. 연료 가격 변수가 잘 추가됐는지 확인하기 위해서 model, fl, price_fl 변수를 
# 추출해 앞부분 5행을 출력해 보세요.
library(dplyr)
mpg %>% 
  select(model, fl, price_fl) %>% 
  head(5)

mpg[1:5, c('model','fl','price_fl')]

###############################################
# # # # #   분    석     도     전    # # # # # 
###############################################
# 문제1. popadults는 해당 지역의 성인 인구, poptotal은 전체 인구를 나타냅니다. 
# midwest 데이터에 '전체 인구 대비 미성년 인구 백분율' 변수를 추가하세요.

midwest <- as.data.frame(ggplot2::midwest)
colnames(midwest)

# 방법1
midwest <- midwest %>% 
  mutate(ratio_child = (poptotal-popadults)/poptotal *100)

# 방법2
midwest$ratio_child <- (midwest$poptotal-midwest$popadults)/midwest$poptotal *100
head(midwest, 2)

# 문제2. 미성년 인구 백분율이 가장 높은 상위 5개 county(지역)의 
# 미성년 인구 백분율을 출력하세요.

#방법1
midwest %>% 
  arrange(desc(ratio_child)) %>%  # ratio_child 내림차순 정렬
  select(county, ratio_child) %>%  # county, ratio_child 추출
  head(5)

# 방법2
head(midwest[order(midwest$ratio_child, decreasing = T),
             c('county','ratio_child')],5)
midwest[order(midwest$ratio_child, decreasing = T),
        c('county','ratio_child')][1:5,]
midwest[order(-midwest$ratio_child),c('county','ratio_child')][1:5,]


# 문제3. 분류표의 기준에 따라 미성년 비율 등급 변수를 추가하고, 
# 각 등급에 몇 개의 지역이 있는지 알아보세요.
# midwest에 grade 변수 추가
midwest <- midwest %>%
  mutate(grade = ifelse(ratio_child >= 40, "large",
                        ifelse(ratio_child >= 30, "middle", "small")))
head(midwest,10)

table(midwest$grade)


# 문제4. popasian은 해당 지역의 아시아인 인구를 나타냅니다. 
# '전체 인구 대비 아시아인 인구 백분율' 변수를 추가하고, 하위 10개 지역의 
# state(주), county(지역명), 아시아인 인구 백분율을 출력하세요.

# 방법1
midwest %>%
  mutate(ratio_asian = (popasian/poptotal)*100) %>%  # 백분율 변수 추가
  arrange(ratio_asian) %>%                           # 내림차순 정렬
  select(state, county, ratio_asian) %>%             # 변수 추출
  head(10)

# 방법2
midwest$ratio_asian <- midwest$popasian/midwest$poptotal*100
library(doBy)
orderBy(~ratio_asian, midwest)[1:10,c('state', 'county', 'ratio_asian')]


###############################################
# # # # #  혼 자 서 해 보 기   (6)    # # # # # 
###############################################
table(mpg$drv)
mpg <- as.data.frame(ggplot2::mpg) # mpg 데이터 불러오기
mpg[c(10, 14, 58, 93), "drv"] <- "k" # drv 이상치 할당
mpg[c(29, 43, 129, 203), "cty"] <- c(3, 4, 39, 42) # cty 이상치 할당

#	Q1. drv에 이상치가 있는지 확인하세요. 이상치를 결측 처리한 다음 이상치가 
# 사라졌는지 확인하세요. 결측 처리 할 때는 %in% 기호를 활용하세요.
table(mpg$drv) # 이상치 확인
mpg$drv <- ifelse(mpg$drv %in% c('4','f','r'), mpg$drv, NA)

colSums(is.na(mpg))
table(is.na(mpg$drv))
table(mpg$drv)
table(mpg$drv, useNA='ifany') # NA 갯수까지 나옴
table(mpg$drv, exclude = NULL)# NA 갯수까지 나옴

#	Q2. 상자 그림을 이용해서 cty에 이상치가 있는지 확인하세요. 상자 그림의 
# 통계치를 이용해 정상 범위를 벗어난 값을 결측 처리한 후 다시 상자 그림을 만들어 
# 이상치가 사라졌는지 확인하세요.

result <- boxplot(mpg$cty)$stats # 상자 그림 생성 및 통계치 산출
mpg$cty <- ifelse(mpg$cty < result[1] | mpg$cty > result[5], NA, mpg$cty)
table(is.na(mpg$cty))
boxplot(mpg$cty) # 이상치 boxplot에서 사라짐

#	Q3. 두 변수의 이상치를 결측처리 했으니 이제 분석할 차례입니다. 
# 이상치를 제외한 다음 drv별로 cty 평균이 어떻게 다른지 알아보세요. 
# 하나의 dplyr 구문으로 만들어야 합니다.

mpg %>%
  filter(!is.na(drv) & !is.na(cty)) %>%  # 결측치 제외
  group_by(drv) %>%                      # drv별 분리
  summarise(mean_hwy = mean(cty))        # cty 평균 구하기

tapply(mpg$cty, mpg$drv, mean, na.rm=T)
by(mpg$cty, mpg$drv, mean, na.rm=T)

library(doBy)
# summaryBy만 drv가 NA인 그룹도 평균을 내서 미리 NA 제외
summaryBy(cty~drv, mpg[!is.na(mpg$drv),], FUN=mean, na.rm=T)
aggregate(mpg$cty, by=list(mpg$drv), mean, na.rm=T)


