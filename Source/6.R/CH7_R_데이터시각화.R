# 21.02.10 R 데이터 시각화

################################
# # # 8장. 데이터 시각화 # # # #
################################
# 1. 시각화 개요 : 원본데이터, 분석된 결과 데이터를 그래프로 표현. 
# 사용자에게 효과적으로 정보전달이 목적

# 1.1 R의 그래픽 시스템
# (1) base graphics system - 전통적인 함수 이용. 
# 그래프 종류별 함수가 각기 달라 정교한 그래프 이용시 노력 필요

# (2) grid graphics system - base graphics system 한계 극복을 위해 
# 탄생한 패키지(ggplot2)
# 유연한 그래프 환경 제공. 
# ex.

library(ggplot2)
ggplot(data=mtcars, aes(x=wt, y=mpg)) +
  geom_point() +
  labs(title="그래프 첫 예제제") +
  geom_smooth()

# 1.2 그래프 함수
# 고수준 그래프 함수 : plot, barplot, boxplot, hist, pie, ....
# 그래프 함수를 호출할 때마다, 그래프 영역에 새로운 그래프를 시작
# 저수준 그래프 함수 : lines, abline(회귀라인), point, text, ...
# 새로운 그래프를 생성하지 않음. 이미 그려진 그래프 위에 점, 라인, 글씨..

# 1.3 그래프 파라미터 : bty(박스유형), ....
# (1) par() : 그래프를 조정하거나 특성을 지정. 
#  par()함수의 리턴값은 실행전의 특성을 리턴한다.

?cars # 차속도와 제동거리
plot(cars)
?par
oldPar <- par(bty=']') 
plot(cars)
plot(iris)
par(oldPar) # oldPar 설정으로 복귀
plot(cars) # 고수준 그래프 함수
# fit <- lm(cars$dist ~ cars$speed)
fit <- lm(dist ~ speed, data=cars)
fit
abline(fit, col="red") #저수준 그래프 함수

# par 함수의 다른 파라미터 사용 예
x <- 1:100
y1 <- rnorm(100) # 평균0이고 표준편차가 1인 수 100개 추출(표준정규분포)
y2 <- rnorm(100)+100 # 평균은 100이고 표준편차는 1인 수 100개(정규분포)

oldPar <- par(mar=c(5,5,5,5)) # 그래프 여백(하,좌,위,우)
?par
plot(x, y1, pch=0, type="b", col='deeppink4',
     ylim=c(-8,2), yaxt="n", bty="n", ylab="")
# pch ; 0:네모, 1:원, 2세모, 3:십자, 4:x, 5:다이아몬드 ...
#       문자해당문자
# type: p:점, l:선, b:점선동시, o:점선겹치면서동시, 
#       h:히스토그램, s:계단모양, n:좌표찍지않음
# col ; 1:black, 2:red, 3:green, 4:blue, 5:cyan, 6:purple, 7:yellow, 8:gray
# ylim, xlim ; y눈금, x눈금 조정
# yaxt : y축 눈금 없애기
# bty : 그래프 박스 타입 (o, L, 7, U, C, n)

axis(side=2, at=c(-2,0,2))
# side : 1하,2좌,3위,4우
# at : 위치

mtext("red line(y1)", side = 2, line = 2, at=0, col=2)

colors()

par(new=TRUE) #기존그래프영역을 지우지 않고 덧그림

plot(x, y2, pch=1, type='b', col="blue", yaxt="n", 
     ylim=c(98,108), ylab="", bty="n")

axis(side=4, at=c(98,100,102))

mtext("blue line(y2)", side=4, line=2, at=100, col="blue")

par(oldPar) # 그래프 영역 설정 원상 복구

# 2. 고수준 그래프 함수
# 2.1 plot : type에 따라 여러 유형의 그래프를 그림. 산점도 그래프 함수

?plot      
plot(cars, main="speed and Stopping Distance of cars",
     xlab="speed(mph)", ylab="stopping distances(ft)", las=1)
# las;축눈금라벨방향; 0:축과평행, 1:가로, 2:축과수직 3:세로

# 2행3열로 그래프영역분리하고 type속성에 따른 그래프 그리기
oldPar <- par(mfrow=c(2,3))
plot(cars, type="p", main="p타입") # 일반적 산점도
plot(cars, type="l", main="l타입") # 추세선
plot(cars, type="b", main="b타입") # 선점(겹치지 않게)
plot(cars, type="s", main="s타입") # 계단
plot(cars, type="n", main="n타입") # 산점도 안 그려
plot(cars, type="o", main="o타입") # 선과점겹치게 
par(oldPar)

# 2.2 barplot : 막대그래프
VADeaths
barplot(VADeaths, main="버지니아주 사망율", font=2,
        border="red", legend=rownames(VADeaths),
        angle=c(10,30,50,70,120),
        density=50, col=rainbow(5))
# legend ; 오른쪽 상단 범례 
# angle ; 막대그래프에 칠할 빗금의 각도
# density ; 막대그래프 안에 칠할 선 수
barplot(VADeaths, main="버지니아주 사망율", font=2,
        border="red", legend=rownames(VADeaths),
        angle=c(10,30,50,70,120),
        density=50, col=rainbow(5),beside=TRUE)

# 2.3 boxplot : 사분위수 그래프
InsectSprays
boxplot(InsectSprays$count)
boxplot(count~spray, data=InsectSprays, col="tomato4")
tapply(InsectSprays$count, InsectSprays$spray, median)
colors()

# 2.4 hist : 히스토그램(도수분포표)
x <- c(1, 1, 2, 2, 2, 3, 4, 4)
hist(x)
h <- hist(x, breaks=c(0,1,2,3,4))
# breaks ; 구간
h
text(h$mids, h$counts, h$counts, adj=c(0,-.5), col='black')
text(h$mids, h$counts, h$counts, adj=c(0,0), col='red')
text(h$mids, h$counts, h$counts, adj=c(1,0), col='blue')
text(h$mids, h$counts, h$counts, adj=c(0,1), col='green')
text(h$mids, h$counts, h$counts, adj=c(1,1), col='purple')
# adj 위치 재조정

islands # 1만 평방마일을 초과하는 주요대륙 넓이 정보
islands
class(islands)
is.vector(islands)
hist(sqrt(islands), breaks=c(2,35,70,100,140))

# 2.5 pie

pie.sales <- c(0.1,0.3,0.2,0.15,0.1,0.15)

sum(pie.sales)

names(pie.sales) <- c("c","java","python","R","oracle","hadoop")

pie.sales

pie(pie.sales) # 반시계방향으로 

pie(pie.sales, clockwise = T, 
    col=c('red','orange','yellow','green','white','cornsilk')) # 시계방향

pie(pie.sales, clockwise = T, col=rainbow(6)) 

# 2.6 mosaicplot

?Titanic
class(Titanic)
Titanic

mosaicplot(Titanic, color=T)
mosaicplot(~Sex+Age+Survived, data=Titanic, color=T)

# 3. 저수준 그래프 함수
# 3.1 points
plot(-4:4, -4:4, type="n")
points(rnorm(100),rnorm(100),col="brown", pch=3)
rnorm(100) # 평균이 0이고 표준편차가 1인 표준정규분포 데이터 100개 난수 생성성

# 3.2 lines : 선
plot(cars, main="speed & dostance")
fit <- lm(dist~speed, cars)
fit  # y = 3.932*x - 17.579
lines(cars$speed, 3.932*cars$speed-17.579, col='blue')

# 3.3 abline : 회귀식선
abline(fit, col="red", lty='dashed')
# lty : 라인의 스타일
?par

# 3.4 text(x, y, 출력할텍스트, 그외옵션들)
plot(1:5,1:5, type="n")
text(3,3, 'A', adj=c(0,0), col='red')
text(2,4, expression(hat(beta) == (X^t*X)^{-1} * X^t*y), cex=2,adj=c(0,0),)

# 4. ggplot2 패키지 함수
install.packages("ggplot2")
library(ggplot2)
# 1: 그래프초기화(데이터셋, 변수설정)하는 ggplot - 그 자체로는 그래프 표현X 
# 2: 그래프의 결과물에 대응하는 geom함수
# 3: 제목, 부제목, 캡션, 축이름 등 부가 요소를 추가 labs함수
# +기호를 이용해서 함수들을 연결하는 방식으로 그래프 생성

ggplot(data=mtcars, aes(x=wt, y=mpg)) + 
  geom_point(aes(size=mpg, color=cyl))+
  labs(title = "wt & Fuel consumpation",
       x = "weight(1,000lbs)",
       y = "Fuel consumption (miles per gallon)",
       subtitle = "(차량 무게와 연비와의 관계)",
       caption="source : mpg datasets")

# 4.1 산점도, 적합도, text...
# x축 iris$Petal.Length,  y축 iris$Petal.Width의 산점도
# 점의 색은 종에 따라 다르게 그리시오.
ggplot(data=iris, aes(x=Petal.Length, y=Petal.Width)) +
  geom_point(aes(color=Species))

head(airquality)
# airquality$Ozone과 airquality$Solar.R과의 관계를 표현하는 산점도
# 월별 점의 색깔을 달리 표현합니다
ggplot(data=airquality, aes(x=Ozone, y=Solar.R)) +
  geom_point(aes(color=Month)) +
  labs(title="오존량과 태양복사량과의 관계") +
  geom_smooth(method="lm")

ggplot(data=mtcars, aes(x=wt, y=mpg)) +
  geom_point(shape=25, color="blue", bg="red", size=2, stroke=2) +
  # shape = par에서 pch와 같음. stroke 테두리 두께, size 점크기
  geom_smooth(method="lm", color="red", size=2, linetype=2) +
  geom_text(label=rownames(mtcars), hjust=0, vjust=0, size=3, nudge_y = 0.5) +
  labs(x = "차량 무게 (1,000lbs)",
       y="연비",
       title="차량 무게와 연비와의 관계",
       subtitle="(부제목)",
       caption = "참조:datasets의 mtcats")

?geom_text
mtcars
?geom_smooth

# 4.2 히스토그램
head(mtcars)
dim(mtcars)
str(mtcars)
mtcars$cyl <- factor(mtcars$cyl, levels = c(4,6,8),
                     labels=c('4 cylinders',
                              '6 cylinders',
                              '8 cylinders'))
head(mtcars)
str(mtcars$cyl)

ggplot(data=mtcars, aes(x=mpg)) +
  geom_histogram() +
  facet_grid(cyl~.) + # 3개의 패널에 그리는 함수
  labs(title="cyl에 따른 연비 히스토그램",
       x="연비", y="횟수")