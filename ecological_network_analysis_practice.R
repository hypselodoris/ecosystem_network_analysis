# Ecological Network Analysis
# Authors of enaR package: Matthew K. Lau, David E. Hines, Pawandeep Singh, Stuart R. Borrett

# Load utility functions
source("/Volumes/workspaces/nate/public/coding_work/R/functions.R")
# Load packages
packages <- c("enaR", "network")
ipak(packages)

## Generate the flow matrix
flow.mat <- matrix( c(0,0,0,0,
                      10,0,2.026,1.4805,
                      0,6.7532,0,
                      0,1,0,2.7013,0), ncol = 4)
## Name the nodes
rownames(flow.mat) <- colnames(flow.mat) <- c("Primary Producer", "Detritus",
                                              "Detritivore", "Consumer")
## Generate the inputs
inputs <- c(100, 0, 0, 0)
## Generate the exports
exports <- c(89, 6.7532, 2.026, 2.2208)
## "Pack" the model into a network object
fake.model <- pack(flow = flow.mat,
                   input = inputs,
                   export = exports,
                   living = c(TRUE,FALSE,TRUE,TRUE))

## [1] "respiration" "storage"

## The model network object contents
fake.model

# extract specific network attributes as follows:
# is the network directed?
fake.model%n%"directed"
## [1] TRUE
# how many nodes are in the network?
fake.model%n%"n"
## [1] 4
# alternatively, we can use a different network package function to find the number of nodes
network.size(fake.model)
## [1] 4

# Similarly, we can pull out “vertex” (i.e. node) attributes as follows:
fake.model%v%'output'
## [1] 89.0000 6.7532 2.0260 2.2208
fake.model%v%'input'
## [1] 100 0 0 0
fake.model%v%'living'
## [1] TRUE FALSE TRUE TRUE

# The network flows are stored as edge weights in the network object, which lets users fully manipulate the
# network object with the network functions. The flow matrix can be extracted from the object with:
as.matrix(fake.model, attrname="flow")
#                  Primary Producer Detritus Detritivore Consumer
# Primary Producer                0  10.0000      0.0000   1.0000
# Detritus                        0   0.0000      6.7532   0.0000
# Detritivore                     0   2.0260      0.0000   2.7013
# Consumer                        0   1.4805      0.0000   0.0000

# There are times that it is useful to extract all of the ecosystem model data elements from the network data
# object. This can be accomplished using the unpack function. The unpack output is as follows:
unpack(fake.model)

## Import the model sets
data(enaModels)
data(bgcModels)
data(troModels)
## Find the names of the first few models
head(names(bgcModels))
head(names(troModels))

## Isolate a single model
x <- troModels[[35]]
x <- troModels$"Middle Atlantic Bight"
## Check out the model
summary(x)

## Visualize network
## Load data
data(oyster)
m <- oyster
# m <- x
## Set the random seed to control plot output
set.seed(2)
## Plot network data object (uses plot.network)
plot(m)

# Fancier plot:
## Set colors to use
my.col <- c('red','yellow',rgb(204,204,153,maxColorValue=255),'grey22')
## Extract flow information for later use.
F <- as.matrix(xattrname='flow')
## Get indices of positive flows
f <- which(F!=0, arr.ind=T)
opar <- par(las=1,bg=my.col[4],xpd=TRUE,mai=c(1.02, 0.62, 0.82, 0.42))
## Set the random seed to control plot output
set.seed(2)
plot(m,
     ## Scale nodes with storage
     vertex.cex=log(m%v%'storage'),
     ## Add node labels
     label= m%v%'vertex.names',
     boxed.labels=FALSE,
     label.cex=0.65,
     ## Make rounded nodes
     vertex.sides=45,
     ## Scale arrows to flow magnitude
     edge.lwd=log10(abs(F[f])),
     edge.col=my.col[3],
     vertex.col=my.col[1],
     label.col='white',
     vertex.border = my.col[3],
     vertex.lty = 1,
     xlim=c(-5.8,0.5),ylim=c(-2,-1))
## Lastly, remove changes to the plotting parameters
rm(opar)

