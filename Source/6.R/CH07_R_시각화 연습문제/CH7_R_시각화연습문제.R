# 21.02.16 시각화 연습문제

library(ggplot2)
library(dplyr)
library(gapminder)


# 연습문제 1. datasets::cars데이터 셋을 이용하여 속도에 대한 제동거리의 산점도와 
# 적합도(신뢰구간 그래프)를 나타내시오
# (단, 속도가 5부터 20까지 제동거리 0부터 100까지만 그래프에 나타냄).

?cars
ggplot(cars, aes(x=speed, y=dist)) +
  geom_point() +
  geom_smooth(method="lm") +
  coord_cartesian(xlim=c(5, 20), ylim=c(0,100))

ggsave('ex01.png')


# 연습문제 2. gapminder::gapminder 데이터 셋을 이용하여 1인당국내총생산에 대한 
# 기대수명의 산점도를 대륙별 다른 색으로 나타내시오.

head(gapminder)
ggplot(data=gapminder, aes(x=gdpPercap, y=lifeExp)) +
  geom_point(aes(col=continent))

ggsave('ex02.png')


# 연습문제 3. gapminder::gapminder 데이터 셋을 이용하여 개대 수명이 70을 
# 초과하는 데이터에 대해 대륙별 데이터 갯수

gapminder %>% 
  filter(lifeExp>70) %>% 
  group_by(continent) %>% 
  summarise(n = n()) %>% 
  ggplot(aes(x=continent, y=n, fill=continent)) +
  geom_bar(stat = 'identity') +
  labs(title="연습문제 3.",
       subtitle="기대수명이 70을 초과하는 데이터 빈도(대륙별)", 
       x ="대륙", y="빈도")

ggsave('ex03.png')

# 연습문제 4. gapminder::gapminder 데이터 셋을 이용하여 기대수명이 70을 
# 초과하는 데이터에 대해 대륙별 나라 갯수.

gapminder %>% 
  filter(lifeExp>70) %>% 
  group_by(continent) %>% 
  summarise(n = n_distinct(country)) %>% 
  ggplot(aes(x=continent, y=n, fill=continent)) +
  geom_bar(stat="identity") +
  labs(title="연습문제 4.",
       subtitle="기대수명이 70을 초과하는 대륙별 나라 빈도",  y="나라 빈도")

ggsave('ex04.png')


# 연습문제 5. gapminder::gapminder 데이터 셋을 이용하여 대륙별 기대수명의 사분위수를 시각화

ggplot(gapminder, aes(x=continent, y=lifeExp, col=continent)) +
  geom_boxplot() +
  coord_cartesian(ylim=c(40,85)) +
  labs(title="연습문제 5.",
       subtitle="대륙별 기대수명의 사분위수")

ggsave('ex05.png')


# 연습문제 6. gapminder::gapminder 데이터 셋을 이용하여 년도별로 gdp와 
# 기대수명과의 관계를 산점도를 그리고 대륙별 점의 색상을 달리 시각화

ggplot(gapminder, aes(x=gdpPercap, y=lifeExp, col=continent))+
  geom_point(alpha=0.5)+
  facet_wrap(~year) +
  coord_cartesian(xlim=c(1e+02, 1e+04))+
  labs(title="연습문제 6.",
       subtitle="GDP와 기대수명과의 관계")

ggsave('ex06.png')


# 연습문제 7.gapminder::gapminder 데이터 셋에서 북한과 한국의 년도별 GDP 변화를 
# 산점도로 시각화하시오
# (북한:Korea, Dem. Rep.  한국:Korea, Rep.  substr(str, start, end)함수 이용)

table(gapminder$country)

gapminder %>% 
  filter(substr(country,1,5)=='Korea') %>% 
  ggplot(aes(x=year, y=gdpPercap, col=country, shape=country))+
  geom_point() +
  scale_shape_manual(values = c(3, 16)) +
  scale_color_manual(values = c('red','blue'))+
  labs(title="연습문제 7.",
       subtitle="GDP의 변화(한국과 북한)") +
  theme(legend.position = c(0.3, 0.8)) 

ggsave('ex07.png')


# 연습문제 8. gapminder::gapminder 데이터 셋을 이용하여 한중일 4개국별 
# GDP 변화를 산점도와 추세선으로 시각화 하시오.

table(gapminder$continent)

gapminder %>% 
  filter(substr(country,1,5)=='Korea' | country=='China' | country == 'Japan') %>% 
  ggplot(aes(x=year, y=gdpPercap, col=country)) +
  geom_point() +
  geom_line() +
  labs(title="연습문제 8.",
       subtitle="한중일 4개국의 GDP변화의 산점도와 추세선") 

ggsave('ex08.png')


# 연습문제 9. gapminder::gapminder 데이터 셋에서 한중일 4개국별 인구변화 변화를 
# 산점도와 추세선으로 시각화 하시오

gapminder %>% 
  filter(substr(country,1,5)=='Korea' | country=='China' | country == 'Japan') %>% 
  ggplot(aes(x=year, y=pop, col=country)) +
  geom_point() +
  geom_line() +
  labs(title="연습문제 9.",
       subtitle="한중일 4개국의 인구 변화의 산점도와 추세선") +
  scale_y_continuous(labels = scales::comma)

ggsave('ex09.png')


# 연습문제 10. Ggplot2::economic 데이터 셋의 개인 저축률(psavert)가 시간에 따라 
# 어떻게 변해 왔는지 알아보려 한다. 
# 시간에 따른 개인 저축률의 변화를 나타낸 시계열 그래프와 추세선을 시각화하시오

ggplot(economics, aes(x=date, y=psavert)) +
  geom_line(color='red', size=2) +
  geom_smooth(col="#FF3333") +
  labs(title="연습문제 10.",
       subtitle="개인저축률 시계열 그래프")

ggsave('ex10.png')


# 연습문제 11. x=date, y=psavert 시계열그래프+추세선(적합도선) 
#              x=date, y=unemploy

economics[1:5, c('date','psavert','unemploy')]

ggplot(data=economics) +
  geom_line(aes(x=date, y=psavert), col='#FF0000', size=2) +
  geom_smooth(aes(x=date, y=psavert), col='pink') +
  geom_line(aes(x=date, y=unemploy*0.001)) +
  geom_smooth(aes(x=date, y=unemploy*0.001), col='dimgray') +
  scale_y_continuous(sec.axis = sec_axis(~.*1000, name="unemploy"))

ggsave('ex11.png')





