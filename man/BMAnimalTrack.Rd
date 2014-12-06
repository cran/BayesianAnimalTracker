\name{BMAnimalTrack}
\alias{BMAnimalTrack}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Bayesian melding bias correction and uncertainty characterization of DR path with GPS observations.
}
\description{
This is a wrapper function of function \code{nllh.BB.Phi_XY}, \code{zSearch}, and \code{postMar.BB.Eta}. It first estimate the parameters \eqn{\sigma^2_H, \sigma^2_D} by numerical maximizing \code{nllh.BB.Phi_XY} based on the GPS observations and DR path at the GPS time points. Then the grid of numerical integration of searched by \code{zSearch}. Finally, the posterior mean and variance of \eqn{\eta} is computed by \code{postMar.BB.Eta}. The posterior mean can be used as the corrected path. The posterior credible intervals are also calculated.
}
\usage{
BMAnimalTrack(dataList, controlList=BMControl())
}
%- maybe also 'usage' for other objects documented here.
\arguments{
\item{dataList}{A list produced by \code{\link{as.dataList}}
}
\item{controlList}{A list of parameters controls the whole calculation. Details are in \code{\link{BMControl}}
}
}
\details{
This function carries out the Bayesian inference for the following model proposed in Liu et al.(2014):

\eqn{\eta(t)}, the animal's path (one dimensional, northing or easting), is assumed to a   Brownian Bridge process with variance parameter \eqn{\sigma^2_H}.(\code{s2H})

\eqn{Y}, GPS observations observated at a subset of the time points of the path. Conditioning on \eqn{\eta(t)}, the GPS observations \eqn{Y(t)} are unbiased iid normal observations of  
  \deqn{Y(t) = \eta(t) + \epsilon(t)} ,
  where the measurment errors \eqn{\epsilon(t) iid N(0, \sigma^2_G)}. The \eqn{\sigma^2_G} (\code{s2G}) can be obtained from the manual of the GPS tags and is an input to this model.

\eqn{X}, Dead-Reckoned path, is assumed to be 
  \deqn{X(t) = \eta(t) + h(t) + \xi(t),}
  where \eqn{h(t) = \sum_{q=1}^Q d_q(t)\beta_q} is a parametric function. Users can specify the design matrix \eqn{[d_q(t)]} or take the default polynomial \eqn{d_q(t) = t^{q-1}} and specify the order of it. \eqn{\xi(t)} is a zero-mean Brownian motion process, whose variance parameter is \eqn{\sigma^2_D}(\code{s2D}).    
}
\value{
When \code{controlList$returnParam} is false. Returns a \eqn{T * 4} matrix. \eqn{T} is the number of times points in the path and the four columns of this matrix are:
\item{Mean}{Posterior mean of \eqn{\eta}}
\item{Variance}{Posterior variance of \eqn{\eta}}
\item{CI.lower}{The lower bound of the Bayesian credible intervals}
\item{CI.upper}{The upper bound of the Bayesian credible intervals}
When \code{controlList$returnParam} is true. The empirical Bayesian estimates of \eqn{\sigma^2_H, \sigma^2_D}(s2H, s2D) will also be returned.
}
\references{
Liu, Y., Battaile, B. C., Zidek, J. V., and Trites, A. (2014). Bayesian melding of the Dead-Reckoned path and gps measurements for an accurate and high-resolution path of marine mammals. arXiv preprint arXiv: 1411.6683.
}
\author{
Yang (Seagle) Liu <yang.liu@stat.ubc.ca>
}
\note{
The current version cannot consider multiple initial values for the numerical maximization nor pass control parameters to the \code{nlm} used to perform the maximization.
}
\examples{
set.seed(1)
#Generating data from our model
dlist <- dataSim(T=100, K=10, s2H=1, s2D=0.1, betaVec=c(1))
gpsObs <- dlist$Y
gpsTime <- dlist$Ytime
drPath <- dlist$X
#Produce the data list required by BMAnimalTrack
wlist <- as.dataList(drPath, gpsObs, gpsTime, 
            timeUnit=1, s2G=0.01, dUnit=1, betaOrder=1)
#Calculate the posterior of eta with our Bayesian Melding approach
etaMar <- BMAnimalTrack(wlist, BMControl(print=TRUE))

\dontrun{
## A real data example from package TrackReconstruction.
## Example from TrackReconstruction package.
## library(TrackReconstruction)
betas<-Standardize(1,1,-1,1,1,1,-57.8,68.76,-61.8,64.2,
    -70.16,58.08, -10.1,9.55,-9.75,9.72, -9.91,9.43)
#get declination and inclination data for study area
decinc<-c(10.228,65.918)
#data set with 6 associated GPS fixes in the "gpsdata" data set
data(rawdata)
#Perform the Dead-Reckoning of the raw accelerometer and 
# magnetometer data
DRoutput<-DeadReckoning(rawdata,betas,decinc,Hz=16,
            RmL=2,DepthHz=1,SpdCalc=3,MaxSpd=3.5)
#prepare GPS data
data(gpsdata02)
#matching time of the GPS and DR
gpsdata <- gpsdata02[gpsdata02$DateTime \%in\% DRoutput$DateTime, ]
gpsformat<-GPStable(gpsdata)
K <- nrow(gpsformat)
T <- nrow(gpsformat)
#Cut out the periods of DR path with the GPS
DRstart <- min(which(DRoutput$DateTime==gpsformat$DateTime[1]))
DRend <- max(which(DRoutput$DateTime==gpsformat$DateTime[K]))
#Thin the data (Original 16Hz, for now only working with 1Hz)
DRworking <- DRoutput[c(DRstart:DRend)[c(DRstart:DRend)\%\%16==1], ]

#Calculate the northing in km##
GPSnorthing=c(0, cumsum(gpsformat$DistanceKm[-1]*cos(gpsformat$BearingRad[-T])))
DRnorthing <- (DRworking$Ydim - DRworking$Ydim[1])/1000 
#Original unit of DR is in meters

#Data preparation for BM bias correction
ndl <- as.dataList(DRnorthing, GPSnorthing, 
    Ytime=gpsformat$DateTime, 
    Xtime=DRworking$DateTime, 
    s2G=0.0625, timeUnit=60, betaOrder=1)
#Bayesian Melding calculation.
nEtaMar <- BMAnimalTrack(ndl, BMControl(print=TRUE, returnParam=TRUE))
		
#Plots.
plot(ndl$XMx[,2], ndl$XMx[,1], type="l", col="blue", ylim=c(0, 2.5)) 
#uncorrected DR path
points(ndl$glist$Gtime, ndl$glist$Y, col="red", pch=16) #GPS points
lines(ndl$XMx[,2], nEtaMar$etaMar[,1], type="l") #Corrected path
lines(ndl$XMx[,2], nEtaMar$etaMar[,3], type="l", col="grey70") #Lower bound of CI
lines(ndl$XMx[,2], nEtaMar$etaMar[,4], type="l", col="grey70") #Upper bound of CI.
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.

\keyword{Bias Correction}
