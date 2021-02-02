# 21.02.02 R 데이터 종류 및 구조 실습

############################################
# # # # # 3장. R 데이터 종류 및 구조 # # # #
############################################

# 1. 데이터 종류 : 기본데이터타입(문자, 숫자, logical)=스칼라타입
# 팩터, 벡터, 리슽, 행렬, 배열, 데이터프레임, 날짜, 특별한값(결측치...)

# 2. 기본데이터 타입 : character, numeric, logical
a <- "Hello"
a <- "Hello
R"
cat(a) # print와 비슷, \n을 수행
cat('a 값은',a)
b <- 10.1
b <- 10
strB <- as.character(b) # as.*() : *타입으로 형변환
strB
c<-TRUE;
c
is.logical(c) # methods(is) -> is.*() : *형이나 값을 물어보는 함수


class(strB)
class(a)  # class()함수는 타입을 확인
class(b)
class(c)

str(a) # str() R의 내부 구조를 간결하게 표시
str(b)
str(c)

# 3. 특별한 값(Null, NA;결측치, NaN, Inf)
result <- 0
add <- function(a, b){
  result <<- a*5+b # 전역변수 result에 할당
  # return (result)
  return ()
}
(temp <- add(1,2)) # 일반변수 temp에 할당
(temp <- add(a=1, b=2))
(temp <- add(b=10, a=5))
(temp <- add(a=1, b=3)) # NULL ; Empty value
is.null(temp)

d <- c(2, 4, NA, 6, NaN, 10/0) # vector(동일자료형 집합)
d

# NA(결측치)관련 함수
# is.na(d) # 결측치인지 아닌지 NA가 있으면 TRUE
# complete.case(d) #NA가 없으면 TRUE
# na.omit(d) ; 결측치 제외
# na.pass(d) ; NA여부 상관없이 처리

is.na(d[3]) # 결측치 여부 TRUE/FALSE
is.na(d)
?is.na
complete.cases(d)
na.omit(d)
na.pass(d)
mean(d) # 평균값 계산시 NA가 있을 경우 NA
?mean
d<- c(2,3,4,5,NA,12)
mean(d, na.rm=TRUE)
boxplot(d)

# 4. 팩터(Factor) : 범주형데이터, 명명식, 순서식
gender1 <- c('남','남','여')
gender1[3]
class(gender1)
gender1[4] <- '중성'
gender1
gender <- factor(c('남','남','여'), levels=c('남','여'))
class(gender)
gender[3]
gender
str(gender)
gender[4] <- '중성'
gender

level <- factor(c('좋음','보통','보통'), levels = c('싫음','보통','좋음'), ordered=T)
level
level <- ordered(c('좋음','보통','보통'), levels=c('싫음', '보통','좋음'))
level
level[4] <- '몰라'
level
nlevels(level) # level변수의 범주 갯수수
nlevels(gender)
levels(level) # level변수의 범주들

gender1 <- c('남','남','여')
class(gender1)
gender1 <- as.factor(gender1) # 5장 전처리에서
gender1

# 5. 구조형 변수와 복합형 변수 ; 변수하나에 여러 값을 가져야
# (1)구조형 변수 : 동일자료형
#    ex. 벡터, 행렬(회귀식 용이), 배열
# (2)복합형 변수 : 서로 다른 자료형을 가질 수 있음
#    ex. 리스트, 데이터프레임(csv)

# 6. 벡터 : 동일자료형의 집합
data <- c(11,22,33, 'TEST') # 숫자, 문자 -> 문자
data <- c(11,22,33, TRUE)   # 숫자, logical -> 숫자 (T:1, F:0)
data <- c(TRUE, 'TEST')   # logical, 문자 -> 문자
data

data <- c(1,2,3) # 1 index부터 시작
data[4] <- 40
data

# 행과 열정 조회
NROW(data) # 항목갯수
length(data)# 항목갯수

data <- c(1:4)
data
names(data) <-c('A열','B열','C열','D열')
data
# 특정한 값 조회
data[1]     #첫번째 값 반환
data['A열'] #A열 값 반환
data[c(1,2)] #첫번째, 두번째 값 반환
data[c(1:2)] #첫번째부터 2번째까지의 값 반환
data[c('A열','B열')] #A열 B열 값 반환
data[-2] # 음수일 경우 2번째 제외외
data[data>2] # 2보다 큰 값만 반환
data[c(TRUE, FALSE, FALSE, TRUE)] # TRUE인 열만 값 반환 = 1, 4번째만 반환

2 %in% data # data에 2가 포함되어 있는지 여부 T/F

# Q. ①시험점수 변수들 만들어 출력하고 ②전체 평균을 구한 후 출력
# 80, 60,  70, 50, 90, 미응시
# yi, kim, yun, lim, lee, park
score <- c(80,60,70,50,90, NA)
cat(score)
(avg <- mean(score, na.rm = TRUE))
help(mean)  
names(score)
names(score) <- c('yi','kim','yun','lim','lee','park')
score  
score[score>80]
class(score) # class함수 이용시 벡터 요소 하나하나의 타입
is.vector(score)

# 6.1 character()
charArr <- character() #charArr length가 0인 벡터
is.vector(charArr)
length(charArr)
charArr <- character(5) # length가 5인 벡터
charArr[1] <- '안녕'; charArr[2]='R'; charArr[3]='수업중'
charArr[7] <- '테스트'
charArr

# 6.2 numeric()
intArr <- numeric()
class(intArr)
is.vector(intArr)
intArr[1] <- 1
intArr[3] <- 3
intArr

# 6.3 logical()
logicArr <- logical(2) # length가 2인 logical 벡터
logicArr[1] <- TRUE
logicArr[2] <- FALSE
logicArr[3] <- T
logicArr

# 6.4 seq() : 순서 객체를 만드는 함수
?seq
a <- seq(from=1,to=10)
a <- seq(from=1, to=10, by=2)
a <- 1:10
is.vector(a)
seq(10,-10,-2)
seq(0,1,0.1)
seq(1,9, by=pi)

# 6.5 rep() : 반복객체를 만드는 함수
rep(1:4, each=2) # 1 1 2 2 3  3 4 4
rep(1:4, c(1,2,3,4)) # 1 2 2 3 3 3 4 4 4 4 
rep(1:4, each=2, len=6)
rep(1:4, times=2) # 1 2 3 4 1 2 3 4 

# 6.6 벡터의 연산 (+,-,*,/, 결합, 교집합, 합집합, 차집합, 비교연산)
a <- c(1,2,3)
b <- c(10,20,30)
a+b
a-b
a^b
a*b
a%%b # 나머지 연산자
c(a,b) # 벡터의 결합

a<-c(1,2,3)
b<-c('Hell','R')
c<-c(TRUE, FALSE)
(z<-c(a, b, c)) # 다른 타입의 벡터 결합시 타입이 바뀜
a <- append(a, c(4,5,6))
a <- append(a, 7)
a[8] <- 8
a

# 벡터의 집합 연산 : 합집합, 교집합, 차집합, 비교
a<-c(1,2,3,4,5,6)
b<-c(2,4,6,8,10,12)
union(a, b) # 합집합  1  2  3  4  5  6  8 10 12
intersect(a, b) #교집합 2 4 6
setdiff(a, b) # 차집합 1 3 5
setequal(a, b) # 비교
setequal(a, c(intersect(a, b), setdiff(a, b)))

# 7. 리스트 
student <- list(name='홍길동', age=25)
student
studentVector <- unlist(student)
studentVector
s <- c('홍길동',25)
names(s) <- c('name','age')
student <- as.list(s) #as.list() : list형으로 형변환
student['name']
student$name
student[1] # $name [1] 홍길동
student[[1]] # [1] 홍길동
student$age <- NULL # student의 age 제거
student
NROW(student) # 항목의 갯수
length(student)# 항목의 갯수

# 8. 행렬
colMatrix <- matrix(1:15, nrow=5, ncol=3)
colMatrix
?matrix
colMatrix <- matrix(1:15, nrow=5, byrow = FALSE)
colMatrix
rowMatrix <- matrix(1:15, nrow=5, ncol=3, byrow = T,
                    dimnames = list(c("R1","R2","R3","R4","R5"),
                                    c('C1','C2','C3')))
rowMatrix
dim(rowMatrix) # 행과 열의 수
nrow(rowMatrix) # 행 수
NROW(rowMatrix)
ncol(rowMatrix) # 열 수
NCOL(rowMatrix)
dimnames(rowMatrix)
rownames(rowMatrix) # 행이름
colnames(rowMatrix) # 열이름
# 행이름과 열이름 수정
dimnames(rowMatrix) <- list(c('1월','2월','3월','4월','5월'),
                            c('kim','lee','choi'))
dimnames(rowMatrix)
rowMatrix

# 행렬의 곱을 이용하여 선형회귀식 도출
x <- c(2,4)   # 공부량
y <- c(40,60) # 점수
X <- matrix(c(x, rep(1, NROW(x))) , nrow = 2, ncol=2, byrow=FALSE)
X
Y = matrix(y, ncol=1)
Y
# X %*% ab = Y
# solve(X) %*% X %*% ab = solve(X) %*% Y
ab <- solve(X) %*% Y
ab
ab[1] # x의 기울기
ab[2] # 절편
plot(x, y)
lines(x, x*ab[1]+ab[2])

x <- c(32, 64, 96, 118, 126, 144, 152.5, 158) #독립변수
y <- c(18, 24, 61.5, 49, 52, 105, 130.3, 125)

X <- matrix(c(x, rep(1, NROW(x))), ncol=2)
X
Y <- matrix(y, ncol = 1)
Y
# X %*% ab = Y
# 전치행렬 곱해서 정방행렬
t(X)
t(X) %*% X # 2x8 %*% 8x2 => 2x2 정방행렬

# X %*% ab = Y
# t(X) %*% X %*% ab = t(X) %*% Y
# solve(t(X) %*% X) %*% t(X) %*% X %*% ab = solve(t(X) %*% X) %*% t(X) %*% Y
# ab = solve(t(X) %*% X) %*% t(X) %*% Y
ab = solve(t(X) %*% X) %*% t(X) %*% Y
ab
plot(x, y)
lines(x, x*ab[1]+ab[2])

# 다변량에서의 회귀분석 도출
x1 <- c(60,65,55) # 몸무게
x2 <- c(5.5, 5.0, 6.0) # 키
x3 <- c(1,0,1) #흡연유무
y <- c(66,74,78)
X <- matrix(c(x1, x2, x3), ncol = 3)
X
Y <- matrix(y, ncol=1)
Y
# X %*% ab = Y
# solve(X) %*% X %*% ab = solve(X) %*% Y
# ab = solve(X) %*% Y
ab = solve(X) %*% Y
ab

# 80Kg, 6.5ft, 금연 수명?
80*ab[1] + 6.5*ab[2] + 0*ab[3]

# 행렬 연산 (+,*,-,/,%%, .., %*%)
a <- matrix(1:4, nrow=2, ncol=2)
a
b <- matrix(seq(10,40,10), nrow=2, ncol=2)
b
a + b
a * b
a ^ b 
a %% b

## 행렬연산 중 행렬 곱(%*%)
payMatrix <- matrix(c(12000,26000,18000), ncol=3)
payMatrix # 1행 3열
dimnames(payMatrix) <- list(c('시간당수당'),c('철수','영희','말자'))
payMatrix
workerMatrix <- matrix(c(c(5,4,9),c(7,3,2)) , ncol=2)
workerMatrix # 3행 2열
dimnames(workerMatrix) <- list(c('철수','영희','말자'), c('1월','2월'))
workerMatrix

cost <- payMatrix %*% workerMatrix # 1x3 %* 3x2 => 1x2
cost
rownames(cost)<-c('인건비')
cost

# 9. 배열
dataArray <- array(1:24, dim=c(3,4,2)) # 3행4열2면 3차원배열
dataArray
dim(dataArray) # 차원의 크기 조회
nrow(dataArray) # 행수 조회
NROW(dataArray)
ncol(dataArray) # 열 수 조회
NCOL(dataArray)
length(dataArray) # 요소의 갯수
dimnames(dataArray) <- list(c('1행','2행','3행'),
                            c('1열','2열','3열','4열'),
                            c('x면','y면'))
dataArray
dim(dataArray) <- c(3,8) # 3x4x2=3x8
dataArray
dim(dataArray) <- c(8,3) # reshape
attr(dataArray, 'dim') <- c(3,8)  # reshape
dataArray

# 10. 데이터 프레임 ★ ★ ★ ★ ★ ★

# (1) 데이터 프레임 생성
student_id <- c('20211','20212','20213','20214')
student_name <- c('Jin','Eric','Den','Kei')
student_eng <- c(60,85,90,95)
student_kor <- c(100,95,95,80)
student_gender <- c('남','여','남','여')
student_data <- data.frame(student_id, student_name, student_eng, student_kor, student_gender)
student_data

# (2)데이터프레임에 열 추가 및 삭제
student_data$mat <- c(100,100,99,98) # 추가
student_data
class(student_data$student_gender)
student_data$student_id <- NULL # 열 삭제

# (3) 열의 형변환
student_data$student_gender <- as.factor(student_data$student_gender)
class(student_data$student_gender)
str(student_data) # 구조 보기
summary(student_data) 

# (4) 열이름 변경
student_data
install.packages("reshape")
library(reshape)
require("reshape")
student <- rename(student_data, c("student_name"="name"))
student <- rename(student, c("student_eng"="eng", "student_kor"="kor", "student_gender"="gender"))
student

names(student_data) <- c("name","eng","kor","gender","mat")
student_data

# (5) 데이터 프레임 합치기
# 행으로 합치기 rbind
newStudent <- rbind(student_data, student)
newStudent 
# 열로 합치기   cbind
student
id = data.frame(student_id)
id
student <- cbind(id, student)
student
names(student)<- c("id","name","eng","kor","gender","mat")
student
student

# 부분 데이터 조회
student <- rbind(student, student) # 2회 실행 -> 16행
nrow(student)
student[1,1] # 1행 1열
student[1,'id'] # 1행 'id'열
student[1,] # 1행 데이터 
student[,1] # 1열 데이터
student[c(1:3), ] # 1행부터 3행 데이터
student[, c(2,3,4,6)] # 2,3,4,5열 데이터
student[c(-2, -4, -6),] # 2,4,6행외의 모든 데이터
student[,c(-1,-5)] # 1열과 5열외 모든 데이터
student[c(1:3), c(-1,-5)] #1행부터 3행까지 1열과5열제외한 데이터

# 국어점수가 90점 이상인 데이터
subset(student, subset=(student$kor==100))
subset(student, student$mat>99)
subset(student, select=c(1,4)) # 1열과 4열 데이터
subset(student, select=c(-1,-4)) # 1열과 4열외 데이터
subset(student, select=c('name','kor','mat')) # 'name','kor','mat'열 만

# 수학점수가 99점이상인 여학생 만 출력
subset(student, subset=(student$mat>=99 & student$gender=='여'))

# 처음 5행만
student[c(1:5),]
head(student)
# 처음 3행만
head(student, 3)

edit(student)

# 문.
emp <- read.csv(file.choose()) # 탐색기에서 선택한 csv파일을 emp변수 할당
emp
head(emp)
class(emp)

#1. 직원이름만 
emp$ename
emp[,2]
emp[,2,drop=FALSE] # 데이터프레임 형태로 반환
emp[,'ename']
emp[,'ename',drop=FALSE] # 데이터프레임 형태로 반환

#2. 직원이름, job, sal
emp[,c(2,3,6)]
emp[,c('ename','job','sal')]
subset(emp, select=c(2,3,6))
subset(emp, select=c('ename','job','sal'))

# 3. 이름이 KING인 직원의 empno, job, hiredate, sal
subset(emp, subset=(emp$ename=='KING'), select=c('empno','job','hiredate','sal'))

# 4. sal이 2000이상 직원의 empno, ename, sal
subset(emp, subset=(emp$sal>=2000), select=c('empno','ename','sal'))

# 5. sal이 2000부터 3000사이인 직원의 ename, sal 
subset(emp, subset=(emp$sal>=2000 & emp$sal<=3000), select=c('ename','sal'))

# 11. 타입 판별 및 타입 변환
tail(emp,6)
tail(emp)
class(emp) # emp의 타입
str(emp)
emp$deptno <- as.factor(emp$deptno)
str(emp)

class(iris)
edit(iris)
str(iris)
iris$Species <- as.character(iris$Species) # factor를 character로 형변환
str(iris)
iris$Species <- as.factor(iris$Species) # character를 facoter로 형변환
str(iris)
levels(iris$Species)

# 타입판별
class(iris$Species)
is.factor(iris$Species)
str(iris$Species)

# 12. 문자열과 날짜
name <- "Eric"
length(name) # 요소갯수
nchar(name) #문자의 갯수

names <- c("Eric","Larray","Curly")
nchar(names) # 4 6 5
length(names) # 3

# 하위 문자열 추출하기 : substr
?substr
substr('ABCDEF',1,4) # 1~4번째 문자 추출
substr('ABCDEF',4,10) #4~10번째 문자 추출. 없는 번째 문자는 ""로 처리
substr(names, 1,2) #names 안에 각각의 문자 1~2번째 추출출

# names 안에 각각의 이름의 맨 마지막자리앞 글자, 맨마지막글자
# 결과 : "ic" "ay" "ly"
substr(names, nchar(names)-1, nchar(names))

# 문자열 연결하기 : paste, paste0
names <- c("Eric","Larray","Curly")
paste(names, 'loves', 'stars')
paste(names, 'loves', 'stars', sep = '_')
paste(names, 'loves', 'stars', sep = '_', collapse = ', and ')
paste0(names, 'loves', 'stars')

# 문.
name<-c("Yun","Lim","Lee"); hobby<-c("swim",'sleep','eat')
# 결과 Yun의 취미는 swim이고, Lim의 취미는 sleep이고, Lee의 취미는 eat
cat(paste(name, hobby, sep = '의 취미는 ', collapse='이고, '))

# 문자열 분할 (구분자 분할하기)
path <- 'home/hadoop/data/speech.csv'
strsplit(path, '/')
customerInfo <- 'jin@gmail.com,010-9999-8888,seoul Korea'
strsplit(customerInfo, ',010-9999-8888,')
customers <- c('jin@gmail.com,010-9999-8888,seoul Korea',
               'yun@naver.com,02-716-1006,pusan korea',
               'yun@naver.com,011-716-1006,pusan korea')
strsplit(customers, '[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}')

# 문자열 대체 : sub(oldStr, newStr, string)
# : gsub(oldStr, newStr, string)
s <- 'Curly is the smart one. Curly is funny, too.'
sub('Curly','Eric', s)
gsub('Curly', 'Eric', s)
gsub(' ','',s)