# 21.02.10 R 데이터 시각화 ggplot2

################################
# # # 8장. 데이터 시각화 # # # #
################################

# 4. ggplot2 패키지 함수
install.packages("ggplot2")
library(ggplot2)
# 1: 그래프초기화(데이터셋, 변수설정)하는 ggplot - 그 자체로는 그래프 표현X 
# 2: 그래프의 결과물에 대응하는 geom함수
# 3: 부가 요소를 추가 함수
# +기호를 이용해서 함수들을 연결하는 방식으로 그래프 생성

#ggplot(data, aes(x=, y=, )) +
#  geom함수() + #어떤 그래프를 그릴지
#  labs(제목, x축 , y축에 label) +
#  scale함수() +
#  theme() +
#  coord_cartesian()
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
library(ggplot2)
ggplot(data=iris, aes(x=Petal.Length, y=Petal.Width)) +
  geom_point(aes(color=Species)) +
  scale_color_manual(values=c('black','red','orange')) +
  labs(title = "iris 데이터의 산점도",
       x = "꽃잎 길이", y="꽃잎 너비") +
  coord_cartesian(ylim=c(0,2)) +
  geom_smooth()

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
rm(list=ls())
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

# 히스토그램은 연속형 자료형에서 도수분포표(범주형의 도수분포는 불가)
ggplot(data=mtcars, aes(x=cyl)) +
  geom_histogram() # cyl 데이터는 연속형이 아니므로 에러

# ggplot2::mpg 데이터셋에서 displ도수분포표 (class에 따라 그래프의 색상을 달리 표현함)
str(mpg$displ)
ggplot(mpg, aes(x=displ)) +
  geom_histogram(aes(fill=class)) +
  theme(axis.text.x = element_text(color='red', size=15),
        axis.line = element_line(color='black', size=2),
        axis.text.y = element_blank(),
        panel.background = element_rect(fill='lightblue',
                                        linetype = 'dotted',
                                        color="black"),
        plot.background = element_rect(fill='lightgreen'))

ggplot(mpg, aes(x=displ)) +
  geom_histogram(aes(fill=class), 
                 binwidth = 0.1) + # binwidth 빈의 넓이
  labs(title="Histogra with Auto Bining",
       subtitle = "(Engine Displacement across Vehicle Classes)")+
  theme(legend.position = "bottom")

ggplot(mpg, aes(x=displ)) +
  geom_histogram(aes(fill=class),
                 bins=5, color="black") # 빈의 갯수(지정하지 않으면 30개)
# binwidth를 지정하면 bins는 무시
# 4.3 상자도표 (boxplot)
boxplot(iris$Sepal.Length)$stat # 이상치 처리하기 위해 

ggplot(iris, aes(y=Sepal.Length)) +
  geom_boxplot()

# 종별 Sepal.Length의 차이가 있는지를 보고 싶을 때
tapply(iris$Sepal.Length, iris$Species, mean) # 도표 표현
ggplot(iris, aes(y=Sepal.Length, x=Species)) + # 시각화 표현
  geom_boxplot(aes(fill=Species), col="dimgray") +
  scale_fill_manual(values=c('#FF0000','yellow','green'))

library(RColorBrewer)
display.brewer.all()
pal <- brewer.pal(8, 'Set2')
ggplot(iris, aes(y=Sepal.Length, x=Species))  +
  geom_boxplot(aes(fill=Species), col='dimgray') +
  scale_fill_manual(values=pal)

install.packages("gapminder")
library(gapminder) 
table(gapminder$country)  
dim(gapminder) # gapminder 대륙별, 나라별, 인구와 GDP 데이터
# 대륙별 GDP 차이가 있는지
table(gapminder$continent)
ggplot(gapminder, aes(x=continent, y=gdpPercap)) +
  geom_boxplot(aes(fill=continent)) +
  coord_cartesian(ylim=c(0, 30000))

# 교수의 직급별(조교수, 부교수, 정교수) 연봉의 상의한지
install.packages("car")
library(car)
Salaries
dim(Salaries)
colnames(Salaries)

ggplot(Salaries, aes(x=rank, y=salary)) +
  geom_boxplot(aes(col=rank), fill="lightyellow", notch = T) +
  # notch = T : 중위수에 대해서 95% 신뢰구간 표현, 신뢰구간이 겹치는지 파악
  geom_point(position = 'jitter', col='brown', alpha=0.3, pch=2) +
  # position = 'jitter' : 산점도를 분산해서 
  geom_rug(col='dimgray', sides="l") # 관측값의 밀도 상태 표현      
# 데이터가 많은 곳은 빽빽하게, 데이터가 적은 곳은 하얗게

# mtcars데이터 cyl개수에 따른 연비 mpg의 95% 중위수 신뢰구간을 표현 상자도표를 시각화하시오.
head(mtcars)
?mtcars
str(mtcars$cyl)

ggplot(data=mtcars, aes(y=cyl, x=mpg, fill=cyl)) +
  geom_boxplot(notch = T)

# 4.4 바이올린 도표 ; boxplot과 밀도도표를 합쳐
# 합창부 단원의 키와 성악부part의 관계

singer <- lattice::singer
head(singer)
View(singer)
str(singer)  

ggplot(data = singer, aes(x=voice.part, y=height)) +
  geom_boxplot()

ggplot(data = singer, aes(x=voice.part, y=height)) +
  geom_violin(fill='honeydew2') +
  geom_boxplot(width=0.3, fill='green')


# 4.5 밀도도표
head(mtcars, 1)
# 실린더수(cyl)에 따른 연비(mpg)의 밀도도표
ggplot(data=mtcars, aes(x=mpg, fill=cyl)) +
  geom_density() + 
  labs(title="밀도도표",
       x = "Miles per Gallon") +
  theme(legend.position = c(0.7,0.8))

# 4.6 추세선  (시계열에서 데이터의 흐름 표현)
economics
colnames(economics)
# 시간(date)에 따른 실업률(unemploy)
ggplot(data=economics, aes(x=date, y=unemploy)) +
  geom_line() + # 추세선
  geom_smooth(method="lm") # 적합도선

# 4.7 막대도표(geom_bar함수, geom_col함수)
# 도수분포표 ; 막대도표, 히스토그램 모두 
# 히스토스램 : 연속형 자료를 계급으로 나누어 계급별 도수를 나타냄
# geom_histogram()함수
# 막대도표 : 범주형 자료의 빈도를 나타냄
# geom_bar(), geom_col()함수


# mpg데이터셋에서 제조회사(manufacturer)별로 빈도표를 나타내고자
str(mpg$manufacturer)
ggplot(data = mpg, aes(x=manufacturer)) + geom_histogram() #불가능
ggplot(data=mpg, aes(x=manufacturer)) +
  geom_bar(stat = "count") # stat = "count" 빈도를 시각화

str(mpg$class)

ggplot(data=mpg, aes(x=manufacturer, fill=class)) +
  geom_bar() +
  theme(legend.position = "bottom",
        axis.text.x = element_text(angle=60, vjust=0.7))+
  scale_fill_manual(values=topo.colors(7)) + # pt 16page
  labs(title="제조사 별 class 빈도표")

# 다이아몬드 품질별 데이터
head(diamonds)
str(diamonds)
dim(diamonds)
table(diamonds$cut)
# 다이아몬두 품질(cut)별 빈도수 시각화
ggplot(diamonds, aes(x=cut, fill=cut, col=cut)) +
  geom_bar(stat="count") +
  scale_fill_manual(values=topo.colors(5)) +
  scale_color_manual(values=rainbow(5))

# 다이아몬두 품질별 색상 갯수
table(diamonds$cut, diamonds$color)
table(diamonds$color)  

library(dplyr)
diamonds %>% 
  group_by(cut, color) %>% 
  summarise( n = n() ) %>% 
  ggplot(aes(x=cut, fill=color, y=n))+
  geom_bar(stat="identity")
# 위와 아래는 같은 수행
diamonds %>% 
  group_by(cut, color) %>% 
  summarise(n = n()) %>% 
  ggplot(aes(x=cut, fill=color, y=n)) +
  geom_col()

# cut별, color별 막대그래프
diamonds %>% 
  group_by(cut, color) %>% 
  summarise( n = n() ) %>% 
  ggplot(aes(x=cut, fill=color, y=n))+
  geom_bar(stat="identity", position = 'dodge')
diamonds %>% 
  group_by(cut, color) %>% 
  summarise(n = n()) %>% 
  ggplot(aes(x=cut, fill=color, y=n)) +
  geom_col(position = 'dodge')

# 다이아몬도의 품질별, table별 빈도수 시각화
diamonds %>% 
  group_by(cut, table) %>% 
  summarise(n = n()) %>% 
  ggplot(aes(x=table, y=n)) +
  geom_bar(stat = "identity") +
  facet_wrap(~cut) + # cut별로 시각화를 달리 그림
  coord_cartesian(ylim=c(0, 3000), xlim=c(50,80))


# 다이아몬드 품질(cut)별 table의 종류 갯수
diamonds %>% 
  group_by(cut, table) %>% 
  summarise(n = n()) %>% 
  group_by(cut) %>% 
  summarise(n = n()) %>% 
  ggplot(aes(x=cut, y=n, fill=cut)) +
  #geom_bar(stat="identity")
  geom_col()

diamonds %>% 
  group_by(cut) %>% 
  summarise(n = n_distinct(table)) %>% # cut별 table종류수
  ggplot(aes(x=cut, y=n, fill=cut)) +
  #geom_bar(stat="identity")
  geom_col()

# 4.8 그래프를 파일에 저장
# (1) basic 그래프, ggplot2 그래프 모두 저장
jpeg('iris.jpg') # iris.jpg 그림파일 생성
boxplot(iris$Sepal.Length)
dev.off()
getwd()

png('iris.png', width=300, height=150)
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width)) +
  geom_point() +
  facet_wrap(~Species)
dev.off()

# (2) ggplot2 그래프에서만 저장할 수 있는 방법
ggplot(iris, aes(x=Petal.Width, y=Petal.Length, col=Species)) +
  geom_point(aes(size=Petal.Width), pch=2, alpha=0.5)
ggsave('outData/iris.jpg')


# 4.9 차트 분할 출력
install.packages("gridExtra")
library(gridExtra)
g1 <- ggplot(iris, aes(x=Petal.Width, y=Petal.Length)) +
  geom_point()
g1
g2 <- ggplot(iris, aes(x=Sepal.Width, y=Sepal.Length)) +
  geom_point()
g2  

grid.arrange(g1, g2, ncol=2)  


# 5. 산점도 행렬
plot(iris[-5])
pairs(iris[-5], panel=panel.smooth)
# panel=panel.smooth 추세선 추가
