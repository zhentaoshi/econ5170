# this is the script that generates "DF3_Yangli.Rdata"

rm(list=ls())
library(knitr)
library(ggplot2)
library(dplyr)
library(RColorBrewer)
library(rworldmap)
library(ggthemes)
library(rgdal)
library(corrplot)
library(reshape2)
library(gridExtra)
library(lubridate)
library(caret)
library(psych)
library(reshape2)

df<-read.csv("new.csv",stringsAsFactors=F)


df$floor <- as.numeric(sapply(df$floor, function(x) strsplit(x,' ')[[1]][2]))
head(table(df$floor))
df$DOM<- ifelse(is.na(df$DOM),median(df$DOM,na.rm=T),df$DOM)
df2 <- data.frame(df %>% dplyr::select(-url, -id, -Cid))

df2$livingRoom <- as.numeric(df2$livingRoom)
df2$bathRoom <- as.numeric(df2$bathRoom)
df2$drawingRoom <- as.numeric(df2$drawingRoom)
df2$district <- as.factor(df2$district)
df2$elevator <- ifelse(df2$elevator==1,'has_elevator','no_elevator')
df2$constructionTime <-as.numeric(df2$constructionTime)

df2$district <-as.factor(df2$district)
df2$subway <- ifelse(df2$subway==1,'has_subway','no_subway')

df2$fiveYearsProperty <- ifelse(df2$fiveYearsProperty==1,'owner_less_5y','owner_more_5y')



makeBuildingType <- function(x){
  if(!is.na(x)){
    if(x==1){
      return('Tower')
    }
    else if (x==2){
      return('Bungalow')
    }
    else if (x==3){
      return('Mix_plate_tower')
    }
    else if (x==4){
      return('plate')
    }
    else return('wrong_coded')
  }
  else{return('missing')}
}
df2$buildingType <- sapply(df2$buildingType, makeBuildingType)

df2 <- data.frame(df2 %>% filter(buildingType != 'wrong_coded' & buildingType !='missing'))

makeRenovationCondition <- function(x){
  if(x==1){
    return('Other')
  }
  else if (x==2){
    return('Rough')
  }
  else if (x==3){
    return('Simplicity')
  }
  else if (x==4){
    return('Hardcover')
  }
}
df2$renovationCondition <- sapply(df2$renovationCondition, makeRenovationCondition)

makeBuildingStructure <- function(x){
  if(x==1){
    return('Unknown')
  }
  else if (x==2){
    return('Mix')
  }
  else if (x==3){
    return('Brick_Wood')
  }
  else if (x==4){
    return('Brick_Concrete')
  }
  else if (x==5){
    return('Steel')
  }
  else if (x==6){
    return('Steel_Concrete')
  }
}
df2$buildingStructure <- sapply(df2$buildingStructure, makeBuildingStructure)



df3 <- data.frame(df2 %>% na.omit())
df3$buildingType <- as.factor(df3$buildingType)
df3$buildingStructure <- as.factor(df3$buildingStructure)
df3$elevator <- as.factor(df3$elevator)
df3$fiveYearsProperty <- as.factor(df3$fiveYearsProperty)
df3$subway <- as.factor(df3$subway)
df3$district <- as.factor(df3$district)
df3$renovationCondition <- as.factor(df3$renovationCondition)



str(df3)
summary(df3)
