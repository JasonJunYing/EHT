library(ggplot2)
library(dplyr)
library(ggpubr)
library(rstatix)
library(reshape2)
library(pheatmap)
library("ggsci")

Study="bridge_Combined"

tab2 <- read.csv(paste0('tab2_',Study,'.csv'),row.names = 1)
print(head(tab2))

tab2[,c("EtoT", "TtoM","EtoM")] = tab2[,1:3]*100/tab2$Con.1
print(head(tab2))
tab2$Day = gsub("(.*)_.*", "\\1", rownames(tab2))
tab2$Study = gsub(".*_(.*)", "\\1", rownames(tab2))

DF = melt(tab2[5:8], id=c("Day"), variable.name="LC", value.name="Percentage")
print(head(DF))

DF$Day = factor(DF$Day, levels=c("0", "2", "3", "7", "14", "30"))

for(ct in c("EtoT", "TtoM","EtoM")){
  DFsub = DF[DF$LC==ct,]
  p = ggplot(DFsub, aes(x=Day, y=Percentage)) +
    ggtitle(ct)+
    geom_boxplot(position = position_dodge(width = 0.9)) +
    geom_point() +
    #facet_wrap(~LC) + 
    theme_classic()
    #scale_color_nejm() 
  ggsave(paste0('Boxplot_',Study,'_',ct,'.pdf'), useDingbats=F, 
         width=3, height=3)
  p
}
