# 21.02.16 R t-test, ANOVA 분석

############################################
# # # 10장. t-test분석 vs. ANOVA분석 # # # #
############################################
# 두 그룹간 평균의 차이가 통계적으로 유의한지 검증 : t-test분석
# 세그룹 이상 집단의 평균 차이가 유의한지 검증 : ANOVA분석(분산분석)

# 1. 두 그룹간의 평균의 차이가 유의한지 분석
ToothGrowth
table(ToothGrowth$supp)
# (1) 도표로 차이의 유의성을 표현 (tapply, by, summaryBy, aggregate.. 평균, 분산)
# (2) 그래프로 시각화된 유의성 표현(바이올린도표, 산점도, 상자도표)
# (3) 통계적으로 유의한지 검증

### 비타민의 종류가 기니피크 치아 성장에 영향을 미치는지?
# 비밀리에 데이터 480개로 뻥튀기
ToothGrowth <- rbind(ToothGrowth, ToothGrowth) # 3번 => 480행
nrow(ToothGrowth)
table(is.na(ToothGrowth))
colSums(is.na(ToothGrowth))
# (1)
library(doBy)
summaryBy(len~supp, data=ToothGrowth, FUN=c(mean, sd))
library(dplyr)
ToothGrowth %>% 
  group_by(supp) %>% 
  summarise(len.mean = mean(len),
            len.sd = sd(len))
# (2)
ToothGrowth %>% 
  group_by(supp) %>% 
  summarise(len.mean = mean(len)) %>% 
  ggplot(aes(x=supp, y=len.mean)) +
  geom_col(aes(fill=supp), width=0.7)

ggplot(data=ToothGrowth, aes(x=supp, y=len)) +
  geom_violin() +
  geom_point(position = 'jitter', col='yellow', alpha=0.7) +
  geom_boxplot(aes(fill=supp), notch = T, width=0.4)

# (3) 통계적인 분석
# 일원표본 t-test
table(ToothGrowth$supp, useNA = "ifany") # 결측치 빈도까지 출력
table(ToothGrowth$supp, exclude = NULL)# 결측치 빈도까지 출력
a <- ToothGrowth[ToothGrowth$supp=='OJ','len']
b <- ToothGrowth[ToothGrowth$supp=='VC','len']
t.test(a-b)
t.test(a, b)
# p-value가 0.05보다 작은 경우 귀무가설(두 그룹의 평균이 같다)을 기각함
# p-value가 0.05보다 큰경우 귀무가설을 기각하지 못한다.

# 이원표본 t.test (등분산성 테스트 -> t-test분석)
var.test(len~supp, data=ToothGrowth)
# p-value가 0.05보다 작은 경우 귀무가설
# (두 그룹의 분산이 같다)을 기각함 - 등분산성이 성립되지 않음
# p-value가 0.05보다 큰경우 귀무가설을 기각하지 못한다. - 등분산 성립

t.test(len~supp, data=ToothGrowth, var.equal=F)
# var.equal=F : 두그룹의 등분산성이 성립되지 않는 경우
# var.equal=T : 두그룹의 등분산성이 성립되지 않는 경우
# p-value가 0.05보다 작은 경우 : 귀무가설을 기각
# p-value가 0.05보다 큰 경우 : 귀무가설을 기각할 수 없음

rm(list=ls())

####예제 : datasets:sleep : extra(수면량), group(수면제종류)
# 수면제 group에 따라 수면량의 변화가 있는지 분석하시오.
sleep <- rbind(sleep, sleep) # 4번 실행해서 데이터 뻥튀기. 320개
nrow(sleep)
head(sleep)
str(sleep)
table(sleep$group, useNA = "ifany")

# (1) 도표로 평균의 차이 나타내기
library(doBy)
summaryBy(extra~group, data=sleep, FUN=c(mean, sd))
library(dplyr)
sleep %>% 
  group_by(group) %>% 
  summarise(mean = mean(extra),
            sd = sd(extra))
# (2) 평균, 표본의 차이를 시각화하기
library(ggplot2)
result <- summaryBy(extra~group, data=sleep, FUN=c(mean, sd))
ggplot(result, aes(x=group, y=extra.mean)) +
  geom_col(aes(fill=group), width=0.7)

ggplot(data=sleep, aes(x=group, y=extra)) +
  geom_point(position = 'jitter', col='yellow', alpha=0.7) +
  geom_violin(width=0.7) +
  geom_boxplot(aes(fill=group), notch = T, width=0.5)

# (3) 통계적으로 유의미한 차이를 분석하기기
var.test(extra~group, data=sleep) # p-value가 0.05보다 큼
t.test(extra~group, data=sleep, var.equal=T)
# p-value가 0.05보다 작아 두 그룹사이의 평균이 같다는 귀무가설을 기각한다.

# 2. 3개 이상의 집단간 평균의 차이를 비교할 때는 분산분석(ANOVA)

# (1) aov()
# iris데이터 셋에서 종에 따라 Sepal.Length의 평균이 다른지 분석     
# Species : 독립변수 / Sepal.Length : 종송변수
result <- aov(Sepal.Length ~ Species, data=iris) # Species이 범주형, 연속형
summary(result) 
# F값이 0.05보다 작으면 귀무가설을 기각
# F값이 0.05보다 크면 귀무가설을 기각할 수 없다

# (2) anova()
# dataset::mtcars 데이터셋에서 cyl에 따라 mpg의 평균이 다른지
rm(list=ls())
str(mtcars$cyl)
table(mtcars$cyl, useNA = "ifany") # cyl의 가지수와 결측치 확인

# cyl에 따른 그룹이 3개 그룹이고 cyl변수 연속형 변수여서 

fit <- lm(mpg ~ cyl , data=mtcars)
fit
anova(fit)
# F값이 0.05보다 작으면 귀무가설을 기각
# F값이 0.05보다 크면 귀무가설을 기각할 수 없다

### 예제 : datasets::Orange ; 오렌지나무의 종류, 연령, 둘레
# 오렌지 나무의 연령에 따른 둘레의 평균이 상이한지 분석하시오.
head(Orange)
str(Orange$age)
nrow(Orange)
fit <- lm(circumference ~ age, data=Orange)
anova(fit)



