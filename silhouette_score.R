## (C) 2016 -- Taylor G Smith. Adapted from sklearn.metrics.cluster.silhouette_score,
## for use with clust4j (github.com/tgsmith61591/clust4j). Computes the Silhouette score
## given a matrix X and a vector of labels, y.



## Rep a value N times
rep <- function(val, n) {
  if(n < 1)
    stop('n must be greater than 0')
  sapply(1:n, function(x) val)
}


## Row means
rowmean <- function(X) {
  X <- as.matrix(X)
  as.vector(apply(X, 1, mean))
}


## Row sums
rowsums <- function(X) {
  X <- as.matrix(X)
  as.vector(apply(X, 1, sum))
}


## Vector maximums
maximum <- function(x, y) {
  if(length(x) != length(y))
    stop('dim mismatch')
  
  sapply(1:length(x), function(i) max(x[i], y[i]))
}

## Vector minimums
minimum <- function(x, y) {
  if(length(x) != length(y))
    stop('dim mismatch')
  
  sapply(1:length(x), function(i) min(x[i], y[i]))
}


## Silhouette score
silhouette_score <- function(X, labels, samples = FALSE) {
  X <- as.matrix(X)
  y <- as.numeric(as.factor(labels))
  
  ## Check dims
  if(nrow(X) != length(y))
    stop('dim mismatch between X and y')
  
  # Get dist mat and labels
  distances <- as.matrix(dist(X, diag = T, upper = T))
  unique_labels <- unique(y)
  
  # For sample i, store the mean distance of the cluster to which
  # it belongs in intra_clust_dists[i]
  intra_clust_dists <- rep(1, nrow(distances))
  
  # For sample i, store the mean distance of the second closest
  # cluster in inter_clust_dists[i]
  inter_clust_dists <- Inf * intra_clust_dists
  
  for(curr_label in unique_labels) {
    # Find inter_clust_dist for all samples belonging to the same
    # label (extract the rows into current_distances).
    mask = y == curr_label
    current_distances = distances[mask,]
    
    # Leave out current sample.
    n_samples_curr_lab = sum(as.numeric(mask)) - 1
    if(n_samples_curr_lab != 0) {
      intra_clust_dists[mask] = rowsums(current_distances[,mask]) / n_samples_curr_lab
    }
    
    # Now iterate over all other labels, finding the mean
    # cluster distance that is closest to every sample.
    for(other_label in unique_labels) {
      if(other_label != curr_label) {
        other_mask = y == other_label
        other_distances = rowmean(current_distances[,other_mask])
        inter_clust_dists[mask] = minimum(inter_clust_dists[mask], other_distances)
      }
    }
  }
  
  sil_samples = inter_clust_dists - intra_clust_dists
  sil_samples = sil_samples / maximum(intra_clust_dists, inter_clust_dists)
  
  ## Return
  ifelse(samples, sil_samples, mean(sil_samples))
}


## EX:
sil_ex <- function() {
  X <- t(matrix(1:15, ncol=5))
  y <- c(0,0,0,1,1)
  silhouette_score(X, y)
}

