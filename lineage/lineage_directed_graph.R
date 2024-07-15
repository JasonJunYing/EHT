library(diagram)
library(pheatmap)
library(igraph)
library(dplyr)
library(tidyr)
library(fields)

data = res
isfiltered = '_filtered'

# Filter out nodes with fewer than 3 cells
cutoff = 0.2

if(isfiltered == '_filtered'){
  for(i in 1:nrow(data)){
    if(data$nto[i]<=2){
      data$p[i]<-NaN
    }
  }
}

# Select cell-types to plot
Day = 3
data = data[data$Day==Day,]
data <- data[startsWith(data$from,"EHT-3")|
                 startsWith(data$from,"EHT-4")|
                 startsWith(data$from,"B-")|
                 startsWith(data$from,"Endocardium")|
                 startsWith(data$from,"T-cells")|
                 startsWith(data$from,"Macrophage"),]
data <- data[startsWith(data$to,"EHT-3")|
                 startsWith(data$to,"EHT-4")|
                 startsWith(data$to,"B-")|
                 startsWith(data$to,"Endocardium")|
                 startsWith(data$to,"T-cells")|
                 startsWith(data$to,"Macrophage"),]

node <- data[,c("from","nfrom")]
node <- node[!duplicated(node$from),]
edge <- data[,c("from","to","p","nto")]
colnames(edge)[3]<-"weight"
edge <- edge[edge$weight>=cutoff,]
edge <- na.omit(edge)

gd1 = graph_from_data_frame(d=edge, vertices=node, directed=T)
l <- do.call("layout_on_grid", list(gd1))

hex = rgb(2/255,2/255,2/255)
pdf(paste0('DirectedGraph_',job,'_Day',Day,isfiltered,choice,'_cutoff',cutoff,'.pdf'),
    width = 5,height = 5)
plot(gd1,main=paste0('Day',Day),
     edge.arrow.size=0.7,
     vertex.size= 6,
     #edge.width = edge$nto/10,
     edge.width = 2,
     edge.color = rgb(1-edge$weight,1-edge$weight,1-edge$weight),
     layout = l,
     edge.curved=0.15,
     vertex.size=20, 
     vertex.frame.color="gray",
     vertex.label.color="black", 
     vertex.label.cex=1, 
     vertex.label.dist=2,
     vertex.label.degree=pi/2
)
colors = c("white","black")
RB <- colorRampPalette(colors = colors)
col <- RB(20)
dev.off()

# Legends
pdf(paste0('Weight_legend_cutoff',cutoff,'.pdf'),width = 4,height = 2.5)
filled.contour(z = as.matrix(cbind(edge$weight,edge$weight),2,2),frame.plot = F,
               col = col,
               key.title = 1)
dev.off()


