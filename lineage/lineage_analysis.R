library(dplyr)
library(pheatmap)
library(limma)
library(ComplexHeatmap)
library(ggplot2)

# lineage tree ReadIn

job = 'CT_new2'
Job = paste0('Tree_results_',job)

ls <- list.files(paste0(Job,'/'))

TreeList <- list()
data0 <- readRDS('data0.rds') # meta

for(l in ls){
  sample_name <- strsplit(l,'_')[[1]][1]
  TreeList[[sample_name]][['metadata']] <- data0[[sample_name]]$metadata
  
  data <- read.csv(paste0(Job,'/',l))
  node <- data[!is.na(data$Freq),]
  cluster <- data[is.na(data$Freq),]
  node_name <- names(table(cluster$Parent))
  
  for(n in node_name){
    tmp <- cluster[cluster$Parent==n,]
    stat <- data.frame(table(tmp$Cell.type))
    stat$node <- n
    stat$Pct <- stat$Freq/nrow(tmp)
    stat$Sample <- sample_name
    Freqmat <- data.frame(stat$Var1,stat$Pct)
    colnames(Freqmat)[2] <- paste0(sample_name,'__',n)
    rownames(Freqmat) <- stat$Var1
    if(n==node_name[1]&&l==ls[1]){
      Freqmat0 <- Freqmat}
    if(n==node_name[1]){
      stat0 <- stat
      next}
    stat0 <- rbind(stat0,stat)
    Freqmat0 <- merge(Freqmat0,Freqmat,all=T)
  }
  names(stat0)<-c("Cell_type","Type_count","Node","Pct","Sample")
  stat0$Cell_type<-as.character(stat0$Cell_type)
  TreeList[[sample_name]]$Node_type_counts <- stat0
}

# Calculate transition probabilities
data = TreeList
celltypes = names(table(res$from))

  ## function definition
getProb = function(data_sub, t1, t2){
  dtab=do.call("rbind", lapply(data_sub, function(x){
    dn = x$Node_type_counts
    ncnt = table(dn$Node, dn$Type_count)
    ncnt = apply(ncnt, 1, function(x) sum(x*as.numeric(colnames(ncnt))))
    dn$ncnt = ncnt[match(dn$Node,names(ncnt))]
    dn$Freq = dn$Type_count*100/dn$ncnt
    ct = dn %>% 
      filter(Freq > cutoff) %>%
      filter(Cell_type == t1 | Cell_type == t2) %>%
      mutate(Fish = x$metadata$Name)
    return(ct)
  }))
  #print(table(dtab$Cell_type))
  dtab = dtab %>% filter(Node != "nd0")
  dtab$ID = paste(dtab$Node, dtab$Fish, sep="_")
  
  ID1 = dtab[dtab$Cell_type == t1, "ID"]
  ID2 = dtab[dtab$Cell_type == t2, "ID"]
  
  pt1tot2 = length(intersect(ID1, ID2))/length(ID2)
  pt2tot1 = length(intersect(ID1, ID2))/length(ID1)
  return(data.frame(from=c(t1,t2), to=c(t2,t1), p=c(pt1tot2,pt2tot1), nfrom=c(length(ID1), length(ID2)), nto=c(length(ID2), length(ID1))))
}

dpi = sapply(data, function(x){
  x$metadata$dpi[1]
})

cutoff = 1
ct = unique(unlist(sapply(data, function(x){
  unique(x$Node_type_counts$Cell_type)
})))

ctcomb = combn(ct, 2)

Day = "3"
sidx = dpi == Day
data_sub = data[sidx]
res3 = do.call("rbind",lapply(1:ncol(ctcomb), function(x){
  t1=ctcomb[1,x]
  t2=ctcomb[2,x]
  getProb(data_sub, t1,t2)
}))

Day = "7"
sidx = dpi == Day
data_sub = data[sidx]
res7 = do.call("rbind",lapply(1:ncol(ctcomb), function(x){
  t1=ctcomb[1,x]
  t2=ctcomb[2,x]
  getProb(data_sub, t1,t2)
}))

Day = "30"
sidx = dpi == Day
data_sub = data[sidx]
res30 = do.call("rbind",lapply(1:ncol(ctcomb), function(x){
  t1=ctcomb[1,x]
  t2=ctcomb[2,x]
  getProb(data_sub, t1,t2)
}))

res3$Day = "3"
res7$Day = "7"
res30$Day = "30"
res = rbind(res3, res7, res30)
res$Day = factor(res$Day, levels=c("3", "7", "30"))
