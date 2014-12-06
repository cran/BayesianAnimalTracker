\name{as.dataList}
\alias{as.dataList}
\title{
Convert the GPS observations and DR path into a data list
}
\description{
The data list prepared by this function will be the input to the \code{\link{BMAnimalTrack}} function.
}
\usage{
as.dataList(X, Y, Ytime, Xtime=NULL, s2G, timeUnit=1, dUnit=1,
  	 dMx=NULL, betaOrder=1, scale=TRUE)
}
\arguments{
  \item{X}{
DR path. The length of it is \code{T}.
}
  \item{Y}{
GPS observations.
}
  \item{Ytime}{
  The time points where the GPS observations are obtained. It has to be a subset of \code{Xtime}. See details for more.
}
  \item{Xtime}{The time points where the DR path is obtained. When unspecified taken to be 1:T. See details for more.
}  
 \item{s2G}{
The variance of the measurement errors in the GPS observations.
}
 \item{timeUnit}{
Optional. If provided, the working time points become 1:T/timeUnit, which can be used to stablize the estimates of s2H.
}
  \item{dUnit}{
Optional. Distance unit. It can be used to scale \code{X, Y}.
}
 \item{dMx}{
  The design matrix of the parametric bias \eqn{h(t)} in the DR path.
}
  \item{betaOrder}{
  Only used when \code{dMx} is not specified. Decide the degree of the polynomial \eqn{h(t) = \sum{q=1}^Q \beta_i t^{q-1}}.
}
  \item{scale}{
Logical. Whether to scale the design matrix \code{dMx}. Recommend to be TRUE.
}
}
\details{
If \code{dMx} is not specified. The \eqn{h(t)} is chosen to be polynomial of order \code{betaOrder}.

For \code{Xtime} and \code{Ytime}, they can either be vectors of POSIXlt/POSIXt time points from \code{\link{strptime}} or character or numeric vectors. But they must be POSIXlt/POSIXt time points when the \code{Xtime} are not regularly spaced. See the example in \code{\link{Trip1}}.
}
\value{
A list of the following values
\item{XMx}{A matrix with \code{T} rows. The first column of it is scaled \code{X}, second column is \code{1:T/timeUnit} (used in the calculation), and the remaining columns are the scaled design matrix \code{dMx}.}
\item{glist}{A list with of the data on the GPS time points}. 
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
#Example continuous in "BMAnimalTrack".
}
\keyword{DR path}
