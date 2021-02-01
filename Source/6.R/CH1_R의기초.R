############################################
# # # # # # 2장. R Language 기초 # # # # # #
############################################

# 1. 도움말 기능
# 1.1 도움말
iris
edit(iris)
?iris #도움말 출력
help(iris) # 도움말 출력

# 1.2 검색기능
?? iris
help.search('iris')

# 1.3 패키지 도움말 
library(help="datasets")

# 1.4 함수 도움말
methods(as) # 형변환함수들
as.integer(1.25)
?as.integer
example(as.integer) # 예제 출력하기

data <- c(10,20,30)
mean(data)
?mean
example(mean) # 열이름, 행이름, 타입

# 6. 주석과 자동완성
# 주석 
# 자동완성 : Tab
R.version

# 1.5 정보조회
edit(iris)
attributes(iris)

## 2. 패키지
# R내에 기본패키지외의 패키지는 다운받음.
# 1. 패키지 설치
# 설치 : install.package("패키지명")
# 설치된 패키지를 메모리에 로드 library("패키지명")
# 패키지 내의 데이터나 함수들 막 사용
# 패키지 언로드 : detach("package:패키지명", unload=TRUE)
iris
detach("package:datasets", unload=TRUE)
iris
install.packages("arules")
library("arules")
?apriori
detach("package:arules", unload=TRUE)

# 데이터의 경우는 메모리에 패키지 로드없이 사용가능
data(iris, package="datasets")
iris

## 3. 변수
# 변수 : 특수문자 중 ., _ 사용가능
# 할당 : <-, <<-
result <- 0 # 전역변수 result
class(result) # 타입
add <- function(a, b){
  # result <- a+b # 지역변수
  result <<- a+b  # 전역변수에 할당
  return(result)
}
add(10,20)
result

# 변수목록 조회
x<-10
y<-10
(z<-x+y)
ls() # 변수들 출력(시스템 히든 변수는 제외)
?ls
ls(all.names = TRUE) # 히든 변수 포함해서 출력

# 4. 출력
result
print(result)
(z <- z+10)

paste('Hello', 'world') # hello world
paste('result 값은',result)
#print('result 값은 '+result) 에러
paste('Hello', 'world', sep=',')
1:3
paste(c(1,2,3), c('하나','둘','셋'), sep='은 ')
paste(c(1,2,3),c('하나','둘','셋'), sep='은 ', collapse=' / ')

month.name
(nth<-paste(1:12, c('st','nd','rd', rep('th',9) ), sep=''))
paste(month.name, nth, sep = '은 ', collapse=" ; ")

# 5. 변수 삭제
rm(z) # z변수 한 개삭제
rm(list=ls()) # 히든변수외 일반 변수 삭제제
rm(list=ls(all.names = TRUE)) # 히든변수까지 삭제

# 6. 
# ~.R : R 스크립트 파일(R실행코드 저장)
# ~.RData : R작업공간
# ~.Rhistory : 콘솔창에 실행한 R명령어들의 history 저장 

# 문1.  kor에 '한국','일본','미국
# usa에 'Korea', 'Japen', 'Ameria'
#출력은 한국:Korea, 일본:Japen, 미국:Ameria
#    "한국:Korea" "일본:Japen" 미국:Ameria
kor <- c('한국','일본','미국') #동질자료형
usa <- c('Korea','Japen','Ameria')
(str <- paste(kor, usa, sep = ':', collapse = ', '))

(strVector <- paste(kor, usa, sep = ':'))

# 문2. MASS::Cars93 데이터를 출력해 보세요
Cars93 # 안되면 : 패키지 로드하기
library(MASS) # 안되면 : 패키지 설치하기
install.packages("MASS")
library(MASS)
Cars93
edit(Cars93)
head(Cars93) # 1~5행까지만