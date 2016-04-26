## silhouetteR
A mechanism by which to compute the Euclidean silhouette score for a matrix, given a set of labels. Useful for assessing the efficacy of a *k* value.

To include in your project, first clone the project:

```bash
cd $PROJECT_HOME
git clone https://github.com/tgsmith61591/silhouetteR.git
```

Then source the script in your R script:

```R
source('silhouette/silhouette_score.R')

## Use as follows:
> silhouette_score(iris[,1:4], iris$Species)
[1] 0.5034774
```
