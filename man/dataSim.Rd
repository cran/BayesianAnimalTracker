\name{dataSim}
\alias{dataSim}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Simulate data  to mimic the GPS observations and the DR path.
}
\description{
Simulate data from our Bayesian melding model with Brownian Bridge and Brownian Motion (See the model description in \code{\link{BMAnimalTrack}}).
}
\usage{
dataSim(T, K, s2H, s2D, s2G=0.01, 
  	gind=NULL, betaVec=NULL, dMx=NULL, A=0, B=0, scale=TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{T}{
Number of time points in the animal's path and DR path.
}
  \item{K}{
Number of GPS observations.
}
  \item{s2H}{
Variance parameter for Brownian Bridge.
}
  \item{s2D}{
Variance parameter for the Brownian motion.
}
 \item{s2G}{
Variance of the measurement error in the GPS observations.
}
 \item{gind}{
Optional. The time points where the GPS observations are obtained. Default is randomly generating from 1:T.
}
  \item{betaVec}{
Coefficients in the function \eqn{h(t)}. When unspecified, no parametric bias term is considered.
}
  \item{dMx}{
Design matrix of dimension T. Default the polynomials.
}
  \item{A}{
Start point of the path. Default 0.
}
  \item{B}{
End point of the path. Default 0.
}
  \item{scale}{
Logical (TRUE of FALSE). Whether to standardize the columns of \code{dMx} with \link{scale}.
}
}
\value{
A data list with the following elements:
\item{eta}{The simulated path of the animal,}
\item{Y}{The GPS observations,}
\item{Ytime}{The time points where the GPS observations are available,}
\item{X}{Dead-Reckoned path}
}
\references{
Liu, Y., Battaile, B. C., Zidek, J. V., and Trites, A. (2014). Bayesian melding of the Dead-Reckoned path and gps measurements for an accurate and high-resolution path of marine mammals. arXiv preprint arXiv: 1411.6683.
}
\author{
Yang (Seagle) Liu <yang.liu@stat.ubc.ca>
}
\examples{
set.seed(1)
#Generating data from our 
dlist <- dataSim(T=100, K=10, s2H=1, s2D=0.1, betaVec=c(1))
gpsObs <- dlist$Y
gpsTime <- dlist$Ytime
drPath <- dlist$X
wlist <- as.dataList(drPath, gpsObs, gpsTime, timeUnit=1, s2G=0.01, dUnit=1, betaOrder=1)
##Examples continues in function "as.dataList".
}
\keyword{simulation}
