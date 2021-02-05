# 21.02.05 R dplyr을 이용한 데이터 전처리

###############################################################################
# # # # # # # # # # # # 5-1. dplyr 패키지를 이용한 전처리 # # # # # # # # # # #
###############################################################################

# 1. 외부파일 read / write
# 1.1 엑셀파일 읽어오기 - readxl 패키지 이용
library(readxl)  #require(readxl)
install.packages("readxl")
library("readxl")
getwd()

exam <- read_excel("C:\\big\\src\\07_R\\inData\\exam.xlsx")
exam <- read_excel("inData/exam.xlsx")
exam <- as.data.frame(exam)
head(exam)
nrow(exam)
exam[21,] <- data.frame(id=1, class=1, math=90, english=90, science=99)
tail(exam)
exam$tot <- exam$math + exam$english + exam$science # 파생변수 추가
mean(exam$tot)
exam$grade <- ifelse(exam$tot>mean(exam$tot), '상','하') # 파생변수
apply(exam[,3:6], 2, mean)

# 데이터 파일에 컬럼명이 없는 경우
data <- read_excel("inData/data_ex.xls", col_names = FALSE)
data  
colnames(data) <- c('id','gender','age','area')
data  

# 1.2 데이터 쓰기 (파일(csv)로 쓰기 vs. 변수만 쓰기)
write.csv(exam, "outData/exam.csv", row.names = TRUE) # 파일로 쓰기

save(exam, file="outData/exam.rda") # exam 변수를 파일로 저장
rm(list=ls(all.names = TRUE)) # 모든 변수 삭제
exam  

load('outData/exam.rda')   # 환경창에도 뜸
exam  

# 2. 데이터 파악하기
mpg <- as.data.frame(ggplot2::mpg)

# head() 앞부분 tail() 뒷부분 View() = edit() 뷰창에서 데이터 확인용
# dim() 차원 str() 구조 summary()

head(mpg)
tail(mpg)
edit(mpg) #뷰창
View(mpg) #뷰창
dim(mpg)  #차원
summary(mpg) # 최소값, 1사분위수, 중위수, 3사분위수, 최대값

# 변수명 바꾸기 (cty -> city, hwy->highway)
install.packages("dplyr")
library(dplyr)

mpg <- rename(mpg, city=cty)
mpg <- rename(mpg, highway=hwy)
colnames(mpg)

# 파생변수 (계산식으로)
mpg$total = (mpg$city + mpg$highway)/2
head(mpg, 3)
# 파생변수 (조건식으로)
boxplot(mpg$total) # (1)박스플롯
hist(mpg$total)    # (2)히스토그램
install.packages("vioplot")
library(vioplot)
vioplot(mpg$total, col="red") # (3) 바이올린플롯

par(mfrow=c(1,3)) # 시각화 그래프를 1행3열로 출력
boxplot(mpg$total) # (1)박스플롯
hist(mpg$total)    # (2)히스토그램
vioplot(mpg$total, col="red") # (3) 바이올린플롯
par(mfrow=c(1,1)) # 플롯 공간을 원상복귀

mean(mpg$total)
mpg$test <- ifelse(mpg$total>= mean(mpg$total), "pass","fail")
table(mpg$test) # 빈도표 출력
library(ggplot2)
?qplot
qplot(mpg$test, color=mpg$test) # 빈도그래프
hist(mpg$total)
# (혼자분석하기)
midwest <- as.data.frame(ggplot2::midwest)
#(1) 데이터 특성 파악하기
head(midwest)
View(midwest)
dim(midwest)
str(midwest)
summary(midwest)
#(2) 변수명 수정(poptotal -> total, popasian->asian)
colnames(midwest)
midwest <- rename(midwest, total=poptotal)
midwest <- rename(midwest, asian=popasian)
colnames(midwest)
# (3) 전체 인구대비 아시아 인구 백분율 파생변수 
midwest$ratioasian <- midwest$asian / midwest$total * 100
midwest[,c('total','asian','ratioasian')]
# (4) "large", "small"
boxplot(midwest$ratioasian)
mean(midwest$ratioasian)
midwest$group <- ifelse(midwest$ratioasian>mean(midwest$ratioasian),"large","small")
head(midwest[,c('total','asian','ratioasian','group')])
dim(midwest)
#(5) "large"와 "small"에 해당하는 지역이 얼마나 되는지 = 빈도표 확인
table(midwest$group)
nrow(midwest)
# 3. 파악한 데이터를 dplyr 패키지를 이용하여 전처리 및 분석하기
# 3.1 조건에 맞는 데이터 추출하기 : filter() '%>%'의 ctrl+shift+m
exam <- read.csv("inData/exam.csv", header=T)
exam  
library(dplyr)
exam  %>%        # dplyr 패키는 %>% 기호를 이용해서 함수들을 나열하는 방식 코딩
  filter(class==1) 
# class가 1이거나 2이거나 3인 데이터 추출
exam %>% 
  filter(class==1 | class==2 | class==3)
exam %>% 
  filter (class %in% c(1,2,3))
# class가 1이고 english가 80이상인 데이터 추출
exam1 <- exam %>% 
  filter(class==1 & english>=80)
exam1

# 3.2 필요한 변수 추출하기 : select()
exam %>% 
  select(class, english, math) # 추출하고자 하는 변수만 select함수안에
exam %>% 
  select(-math) # math 변수만 제외하고 다 출력
# class가 1과 2의 행중에서 영어, 수학 데이터 만 출력
exam %>% 
  filter(class %in% c(1,2)) %>% 
  select(english, math)
# class가 1,2,3행에서 영,수 데이터만 앞 5개 추출
exam %>% 
  filter(class %in% c(1,2,3)) %>% 
  select(english, math) %>% 
  head(5)  # 앞 6개일 경우 숫자 가능
exam %>% 
  filter(class %in% c(1,2,3)) %>% 
  select(english, math) %>% 
  head  # 앞 6개

# 3.3 정렬하기 : arrange()
exam %>% arrange(math)       # 오름차순 정렬
exam %>% arrange(desc(math)) #내림차순 정렬
exam %>% arrange(-math)      #내림차순 정렬
exam %>% arrange(class, desc(math) ) # class오름차순, class가 같은 경우 math내림차순
exam %>% arrange(class, -math) 

# id가 1부터 10인 학생의 영어, 수학성적을 영어성적 기준으로 
# 오름차순 정렬하고 top 6만
exam %>% 
  filter(id %in% 1:10) %>% 
  select(english, math) %>% 
  arrange(english) %>% 
  head

# 3.4 파생변수 추가 : mutate()
exam %>% 
  mutate(total = math + english +science) %>% 
  filter(total>=150)
exam %>%  # 파생변수를 한꺼번에 두개 이상 추가해서 분석하기
  mutate(total = math + english +science,
         avg = round((math + english +science)/3)) %>% 
  head

head(exam)
# 추가한 파생변수를 dplyr 코드에 바로 활용
exam %>% 
  mutate(total = math + english +science,
         avg = round((math + english +science)/3)) %>% 
  select(-id) %>% 
  arrange(desc(total)) %>% 
  head(3)

# 3.5 요약하기 : summarise() 
# summarise안에 들어갈 수 있는 요약함수들 : mean, sd, sum, min, max, median, n
exam %>% 
  summarise(mean_math=mean(math))
exam %>% 
  summarise(mean_math = mean(math),
            mean_eng  = mean(english),
            sd_math = sd(math),
            sd_eng = sd(english))

# 3.6 집단별로 요약하기 group_by() + summarise() 
exam %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math),
            n=n(),
            max_eng = max(english)) %>% 
  arrange(mean_math)

# 클래스별 수학, 영어, 과학의 평균
exam %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math),
            mean_eng  = mean(english),
            mean_sci  = mean(science))

library(doBy)
summaryBy(math+english+science ~ class, exam)

# 예제문제
mpg <- as.data.frame(ggplot2::mpg)
nrow(mpg)
table(mpg$class)

mpg %>% 
  filter(class=='suv') %>% 
  group_by(manufacturer) %>% 
  mutate(total = (cty+hwy)/2) %>% 
  summarise(tot_mean = mean(total)) %>% 
  arrange(desc(tot_mean)) %>% 
  head(5)









