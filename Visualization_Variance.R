library(ggplot2) # Data visualization
library(readr) # CSV file I/O, e.g. the read_csv function

# Input data files are available in the "../input/" directory.
# For example, running this (by clicking run or pressing Shift+Enter) will list the files in the input directory

system("ls ../input")

cwurData <- read.csv("../input/cwurData.csv", stringsAsFactors=FALSE)
school_and_country_table <- read.csv("../input/school_and_country_table.csv", stringsAsFactors=FALSE)
shanghaiData <- read.csv("../input/shanghaiData.csv", stringsAsFactors=FALSE)
timesData <- read.csv("../input/timesData.csv", stringsAsFactors=FALSE)

index=match(shanghaiData$university_name,school_and_country_table$school_name)
shanghaiData$country=school_and_country_table[index,"country"]

library(dplyr)

shanghai100=head(shanghaiData,100)
times100=head(timesData,100)
cwur100=head(cwurData,100)

i1=match(shanghai100$university_name,times100$university_name)
i2=match(shanghai100$university_name,cwur100$institution)
shanghai100$times_rank=as.numeric(times100[i1,"world_rank"])
shanghai100$cwur_rank=as.numeric(cwur100[i2,"world_rank"])

#Among those consistenly ranked top 100 across all systems, which univ has largest variation in ranking across the three
rankdiff=shanghai100%>%
  select(world_rank,times_rank,cwur_rank,university_name,country)%>%
  mutate(shanghai_rank=as.numeric(world_rank))%>%
  na.omit()
#mutate(maxdiff=pmax(c(shanghai_rank,times_rank)))
#mutate(times_dif=shanghai_rank-times_rank)%>%
#mutate(cwur_dif=shanghai_rank-cwur_rank)%>%
#mutate(all_dif=abs(times_dif)+abs(cwur_dif))%>%
#pmax and pmin are row-level local maxima/minima where max and min will compare entire columns
rankdiff$maxrank=pmax(rankdiff$shanghai_rank,rankdiff$cwur_rank,rankdiff$times_rank)
rankdiff$minrank=pmin(rankdiff$shanghai_rank,rankdiff$cwur_rank,rankdiff$times_rank)
rankdiff$diff=rankdiff$maxrank-rankdiff$minrank
rankdiff=rankdiff[order(-rankdiff$diff),]
rankdiff$rownum=1:nrow(rankdiff)

#the variance plot
library(RColorBrewer)

palette(brewer.pal(8, "Set2"))
#set the palette

png(filename="variance1.png", width=700, height=1000, units="px", pointsize=20)
par(mar=c(4,10.5,3,1))
plot(rankdiff$maxrank,rankdiff$rownum,col=factor(rankdiff$country),pch=16,
     xlab="Ranking", yaxt='n',ann=F, xaxt='n',bty='n')
points(rankdiff$minrank,rankdiff$rownum,col=factor(rankdiff$country),pch=16)
title(main="Variance in University Rankings",sub="In Ascending Order")
segments(rankdiff$maxrank,rankdiff$rownum,rankdiff$minrank,rankdiff$rownum,
         col=factor(rankdiff$country))
axis(2, at=rankdiff$rownum,labels=rankdiff$university_name,las=2,
     cex.axis=0.5, tick=F)
axis(1, seq(0,100,10),cex.axis=0.5, tick=F)
mtext(side = 1,"Rank",cex=0.6,line=2)
cntry=unique(factor(rankdiff$country))
for (i in 0:20) {
  rect(0,i*2+0.5,100,i*2+1.5, col = rgb(190, 190, 190, alpha=30, 
                                        maxColorValue=255),border=0)}
legend("topright", legend=cntry, cex=0.5, pt.cex = 0.1,
       fill=cntry,bty="n")
dev.off()