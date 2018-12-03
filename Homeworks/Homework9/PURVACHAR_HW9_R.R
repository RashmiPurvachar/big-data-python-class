library(RCurl)

existing_cases_file <- getURL("https://docs.google.com/spreadsheets/d/1X5Jp7Q8pTs3KLJ5JBWKhncVACGsg5v4xu6badNs4C7I/pub?gid=0&output=csv")
existing_df <- read.csv(text = existing_cases_file, row.names=1, stringsAsFactor=F)
existing_df[c(1,2,3,4,5,6,15,16,17,18)] <- 
  lapply( existing_df[c(1,2,3,4,5,6,15,16,17,18)], 
          function(x) { as.integer(gsub(',', '', x) )})

pca_existing <- prcomp(existing_df, scale. = TRUE)

plot(pca_existing)

scores_existing_df <- as.data.frame(pca_existing$x)
# Show first two PCs for head countries
head(scores_existing_df[1:2])

plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid")
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8)

library(scales)
ramp <- colorRamp(c("yellow", "blue"))
colours_by_mean <- rgb( 
  ramp( as.vector(rescale(rowMeans(existing_df),c(0,1)))), 
  max = 255 )
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=colours_by_mean)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=colours_by_mean)

ramp <- colorRamp(c("yellow", "blue"))
colours_by_sum <- rgb( 
  ramp( as.vector(rescale(rowSums(existing_df),c(0,1)))), 
  max = 255 )
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=colours_by_sum)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=colours_by_sum)

existing_df_change <- existing_df$X2007 - existing_df$X1990
ramp <- colorRamp(c("yellow", "blue"))
colours_by_change <- rgb( 
  ramp( as.vector(rescale(existing_df_change,c(0,1)))), 
  max = 255 )
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=colours_by_change)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=colours_by_change)

# K clustering

set.seed(1234)
existing_clustering <- kmeans(existing_df, centers = 3)

existing_cluster_groups <- existing_clustering$cluster
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=existing_cluster_groups)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=existing_cluster_groups)

set.seed(1234)
existing_clustering <- kmeans(existing_df, centers = 4)
existing_cluster_groups <- existing_clustering$cluster
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=existing_cluster_groups)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=existing_cluster_groups)

set.seed(1234)
existing_clustering <- kmeans(existing_df, centers = 5)
existing_cluster_groups <- existing_clustering$cluster
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=existing_cluster_groups)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=existing_cluster_groups)

set.seed(1234)
existing_clustering <- kmeans(existing_df, centers = 6)
existing_cluster_groups <- existing_clustering$cluster
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=existing_cluster_groups)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=existing_cluster_groups)

set.seed(1234)
existing_clustering <- kmeans(existing_df, centers = 5)
existing_cluster_groups <- existing_clustering$cluster
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=existing_cluster_groups)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=existing_cluster_groups)

#Cluster Interpretation

existing_df$cluster <- existing_clustering$cluster
table(existing_df$cluster)

xrange <- 1990:2007
plot(xrange, existing_clustering$centers[1,], 
     type='l', xlab="Year", 
     ylab="New cases per 100K", 
     col = 1, 
     ylim=c(0,1000))
for (i in 2:nrow(existing_clustering$centers)) {
  lines(xrange, existing_clustering$centers[i,],
        col = i)
}
legend(x=1990, y=1000, 
       lty=1, cex = 0.5,
       ncol = 5,
       col=1:(nrow(existing_clustering$centers)+1),
       legend=paste("Cluster",1:nrow(existing_clustering$centers)))

# Cluster 1
# Cluster 1 contains just 16 countries. These are:
rownames(subset(existing_df, cluster==1))

# The centroid that represents them is:
existing_clustering$centers[1,]

# Cluster 2
# Cluster 2 contains 30 countries. These are:
rownames(subset(existing_df, cluster==2))
  
# The centroid that represents them is:
existing_clustering$centers[2,]

# Cluster 3
# This is an important one. Cluster 3 contains just 20 countries. These are:
rownames(subset(existing_df, cluster==3))  

# The centroid that represents them is:
existing_clustering$centers[3,]

# Cluster 4
# The fourth cluster contains 51 countries.
rownames(subset(existing_df, cluster==4))

# The centroid that represents them is:
existing_clustering$centers[4,]

# Cluster 5
# The last and bigger cluster contains 90 countries.
rownames(subset(existing_df, cluster==5))

# The centroid that represents them is:
existing_clustering$centers[5,]

# A Second Level of Clustering  
# subset the original dataset
cluster5_df <- subset(existing_df, cluster==5)
# do the clustering
set.seed(1234)
cluster5_clustering <- kmeans(cluster5_df[,-19], centers = 2)
# assign sub-cluster number to the data set for Cluster 5
cluster5_df$cluster <- cluster5_clustering$cluster

xrange <- 1990:2007
plot(xrange, cluster5_clustering$centers[1,], 
     type='l', xlab="Year", 
     ylab="Existing cases per 100K", 
     col = 1, 
     ylim=c(0,200))
for (i in 2:nrow(cluster5_clustering$centers)) {
  lines(xrange, cluster5_clustering$centers[i,],
        col = i)
}
legend(x=1990, y=200, 
       lty=1, cex = 0.5,
       ncol = 5,
       col=1:(nrow(cluster5_clustering$centers)+1),
       legend=paste0("Cluster 5.",1:nrow(cluster5_clustering$centers)))

rownames(subset(cluster5_df, cluster5_df$cluster==2))
rownames(subset(cluster5_df, cluster5_df$cluster==1))

