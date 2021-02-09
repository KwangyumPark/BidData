# 21.02.09 R Oracle, MySQL DB 연결

####################################
# # # 6장. 데이터베이스 이용 # # # #
####################################

# 이장의 내용 : SQL문으로 데이터프레임과 DB 테이블 이용
rm(list=ls(all.names = T))
# 1 SQL문을 이용한 데이터 프레임 처리
install.packages("sqldf")
# fastmap, bit, cachem... 등을 의존합니다.
library(sqldf) # sqldf()함수를 통해 데이터프레임을 DB의 테이블처럼 사용가능
sqldf("select * from iris")

# 중복행 제거하여 한번만 출력 (irir의 종을 출력)
sqldf("select distinct Species from iris")

names(table(iris$Species))
library(dplyr)
iris %>% 
  group_by(Species) %>% 
  summarise()

# 행 제한 조건 설정 (virginica종만 출력)
sqldf("select * from iris where species=='virginica'")

iris[iris$Species=='virginica',]
iris %>% 
  filter(Species=='virginica')

# 컬럼에 .이 내포한 경우 : ``
# virginica종이면서 Sepal.Length가 7.5 초과하는 데이터 출력
sqldf("select * from iris where Species=='virginica' and `Sepal.Length`>7.5")

iris[iris$Species=='virginica' & iris$Sepal.Length>7.5,]
iris %>% 
  filter(Species=='virginica' & Sepal.Length>7.5)

# 종별 Sepal.Length의 합을 출력
sqldf("select Species, sum(`Sepal.Length`) from iris group by Species")

tapply(iris$Sepal.Length, iris$Species, mean)
by(iris$Sepal.Length, iris$Species, mean)
library(doBy)
summaryBy(Sepal.Length~Species,iris, FUN=mean)
aggregate(iris$Sepal.Length, by=list(iris$Species), mean)

# 정렬 (Sepal.Length가 1~5등, 6~10등)
sqldf("select * from iris order by `Sepal.Length` limit 5") # 0번째부터 5개
sqldf("select * from iris order by `Sepal.Length` limit 5, 5") # 5번째부터 5개

# sql함수(mySQL함수) 사용 : Petal.Length, Petal.Width의 평균과 표준편차
sqldf("select avg(`Petal.Length`) as mean_Length , stdev(`Petal.Length`) 
      as st_Length, avg(`Petal.Width`) as mean_Width, stdev(`Petal.Width`) 
      as st_Width from iris")
apply(iris[,c('Petal.Length','Petal.Width')], 2, mean)
apply(iris[,c('Petal.Length','Petal.Width')], 2, sd)
apply(iris[,3:4],2, mean); apply(iris[,3:4],2, sd)

# sql함수(mySQL함수) 사용 : 종에 따른 Petal.Length, Petal.Width의 평균과 표준편차
sqldf("select Species, avg(`Petal.Length`) as mean_Length , 
      stdev(`Petal.Length`) as st_Length, avg(`Petal.Width`) 
      as mean_Width, stdev(`Petal.Width`) as st_Width 
      from iris group by Species")

summaryBy(Petal.Length+Petal.Width~Species, iris, FUN=c(mean, sd))

sqldf("select round(avg(`Petal.Length`),2) from iris")

iris %>% 
  summarise(mean = round(mean(Petal.Length),2))

# 조인
getwd() # 작업디렉토리 출력
setwd('c:/big/src/07_R') # 작업디렉토리 변경
getwd() # 변경된 작업디렉토리 확인
emp <- read.csv("inData/emp.csv", header=TRUE)
head(emp)
dept <- read.csv("inData/dept.csv")
head(dept)
# 사번, 이름, 직책, 월급, 부서번호, 부서이름
sqldf("select empno, ename, job, sal, emp.deptno, dname from emp, dept 
      where emp.deptno=dept.deptno")
sqldf("select empno, ename, job, sal, e.deptno, dname from emp e, dept d 
      where e.deptno=d.deptno")

# 사번, 이름, 부서번호, 부서이름
sqldf("select empno, ename, e.deptno, dname 
      from emp e join dept d on e.deptno=d.deptno")
rm(list=ls())
emp
dept
# 2. 오라클 데이터 베이스 연결
# 전작업: 자바를 설치하고 환경설정(JAVA_HOME), 작업디렉토리(getwd())에 ojdbc6.JAR 
getwd()
# 패키지 설치 및 로드 : RJDBC
install.packages("RJDBC")
library(RJDBC)

# 드라이버 클래스 로드
drv <- JDBC("oracle.jdbc.driver.OracleDriver", classPath = "ojdbc6.jar")
drv
# 데이터베이스 연결
con <- dbConnect(drv, "jdbc:oracle:thin:@127.0.0.1:1521:xe", "scott","tiger")
con
# SQL전송(select)+결과 받기
emp <- dbGetQuery(con, "select * from emp")
emp
class(emp)
summary(emp)
tail(emp)
emp[1:2,'EMPNO']

# 테이블 전체 데이터 조회
dept <- dbReadTable(con,"dept")
dept

# SQL전송(update, insert, delete) - DB 데이터 수정
dbSendUpdate(con, "insert into dept values (60,'it','PUSAN')")
dbSendUpdate(con, "UPDATE DEPT SET LOC='HONGONG' WHERE DEPTNO=60")
dbSendUpdate(con, "DELETE FROM DEPT WHERE DEPTNO>=50")

# 데이터베이스 연결 해제
dbDisconnect(con)

# 드라이버 언로드 : DB연결 해제시 자동 언로드 됨
dbUnloadDriver(drv)
detach("package:RJDBC", unload = TRUE)

# 3. MySql 데이터 베이스 연결
# MySQL Workbench에서 
# ALTER USER '아이디'@'localhost' IDENTIFIED WITH mysql_native_password BY '비밀번호';
# ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mysql';
install.packages("RMySQL")
library(RMySQL)
drv <- dbDriver("MySQL")
con <- dbConnect(drv, host="127.0.0.1", dbname="kimdb", 
                 user="root", password="mysql")
rs <- dbSendQuery(con, "select * from personal")

personal <- fetch(rs, n=-1)

personal

class(personal)
dbDisconnect(con)
dbUnloadDriver(drv)
personal