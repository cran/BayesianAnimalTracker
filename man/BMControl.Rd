\name{BMControl}
\alias{BMControl}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Produce a list of arguements controlling \code{\link{BMAnimalTrack}}
}
\description{
This function include the defaul values of the parameters controls the \code{\link{BMAnimalTrack}} function and passes user-specified values into \code{\link{BMAnimalTrack}}.  
}
\usage{
BMControl(print = FALSE, zStepSize = 1, logPiTol = 3, 
        returnParam = FALSE, CILevel = 0.95, ...)
}
\arguments{
  \item{print}{
Logical. Whether to print the progress information to screen.
}
  \item{zStepSize}{
Positive number. Controls the stepsize in the search of grid points for numerical integratoin. More grid points will be consider with smaller \code{zStepSize}.
}
  \item{logPiTol}{
Positive number. Controls the tolerance the difference between log likelihoods at the grids points and grid center (empirical Bayesian estimates)  
}
  \item{returnParam}{
Logical. Decides whether the empirical Bayesian parameters estimates should be returned.
}
  \item{CILevel}{
The level of the Bayesian credible interval. Default values i 95\%.
}
  \item{\dots}{
Other arguments that you would like to pass into the \code{\link{BMAnimalTrack}} 
}
}
\value{
A list with the above arguments.
}
\references{
Liu, Y., Battaile, B. C., Zidek, J. V., and Trites, A. (2014). Bayesian melding of the Dead-Reckoned path and gps measurements for an accurate and high-resolution path of marine mammals. arXiv preprint arXiv: 1411.6683.
}
\author{
Yang (Seagle) Liu <yang.liu@stat.ubc.ca>
}
\seealso{
\code{\link{BMAnimalTrack}}
}
\examples{
set.seed(1)
#Generating data from our 
dlist <- dataSim(T=100, K=10, s2H=1, s2D=0.1, betaVec=c(1))
gpsObs <- dlist$Y
gpsTime <- dlist$Ytime
drPath <- dlist$X
wlist <- as.dataList(drPath, gpsObs, gpsTime, timeUnit=1, s2G=0.01,
          dUnit=1, betaOrder=1)
etaMar <- BMAnimalTrack(wlist, BMControl(print=TRUE))
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{control agruments}
