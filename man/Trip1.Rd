\name{Trip1}
\alias{Trip1GPS}
\alias{Trip1DR}
\alias{Trip1}
\docType{data}
\title{
GPS observation and DR path from a foraging trip of northern fur seal
}
\description{
This foraging trip lasted from 21-Jul-2009 09:30:00 to 28-Jul-2009 09:49:00. It started from and ended at Bogsolof island. This is a thinned version of the full data sets used in Liu et al. (2014a, 2014b). We thinned the original 1Hz DR path into once observation per 10 minutes.
}
\usage{
data("Trip1GPS")
data("Trip1DR")
}
\format{
  \code{Trip1GPS} is a data frame with 274 observations on the following 3 variables.
  \describe{
    \item{\code{DateTime}}{Date and time of the observation, character vector}
    \item{\code{Latitude}}{a numeric vector of the latitude observed by GPS}
    \item{\code{Longtitude}}{a numeric vector of the longitude observed by GPS}
  }
  \code{Trip1DR} is a data frame with 1187 observations (one observation per 10 minutes plus the points at the GPS observations) with the following variables
  \describe{
    \item{\code{DateTime}}{Date and time of the observation, character vector}
    \item{\code{Xdim}}{a numeric vector of easting in meters (longitude) from the Dead-Reckoning algorithm}
    \item{\code{Ydim}}{a numeric vector of northing in meters (latitude) from the Dead-Reckoning algorithm}
  }
}
\details{
The \code{Trip1DR} is reconstructed by \code{\link{TrackReconstruction}}. Plots produced from this data set can be found in Liu et al. (2014a, 2014b).
}
\source{
Liu, Y., Battaile, B. C., Zidek, J. V., and Trites, A. (2014a). Bayesian melding of the Dead-Reckoned path and gps measurements for an accurate and high-resolution path of marine mammals. arXiv preprint arXiv: 1411.6683.

Liu, Y., Battaile, B. C., Zidek, J. V., and Trites, A. (2014b). Bias Correction and Uncertainty Characterization of Dead-Reckoned Paths of Marine Mammals. submitted to Animal Bio-telemetery (Proceedings of the 5th Bio-logging Science Symposium).
}
\examples{
data(Trip1GPS)
data(Trip1DR)
###Bayesian Melding correction of DR path for this data set.
\dontrun{
###Additional File for Animal Bio-telemetry
###Working with a thinned version of Trip 1 data set.
#First install our R package
install.packages("BayesianAnimalTracker")

#Load the package
library(BayesianAnimalTracker)
#Require version 1.1 or higher.

##Load the uncorrected DR path
data(Trip1DR) 
  #this result is produced by the TrackReconstruction package

##Load the GPS observations
data(Trip1GPS) 

##Processng the GPS observations to get northing and easting in KM
Trip1GPSformat <- GPStable(Trip1GPS)
	#GPStable is from TrackReconstruction
Trip1GPSinKM <- DegToKM(Trip1GPSformat)
	#Get the northing and easting in km

###Analyze the Northing direction
##Prepare the data list that will be used in our Baysian Melding
ndl <- as.dataList(Trip1DR$Ydim/1000, Trip1GPSinKM$Northing, 
                   Ytime=strptime(Trip1GPS$DateTime, "\%d-\%b-\%Y \%H:\%M:\%S"), 
                   Xtime=strptime(Trip1DR$DateTime, "\%d-\%b-\%Y \%H:\%M:\%S"), 
                   s2G=0.0625, timeUnit=60, betaOrder=1)
	#Please notice that the DR is in meter.
	#Need to convert it into kilometer.
	#Notice here the Xtime is not regularly spaced.
	#It must be converted to the dateTime format
	#Before further operations.
##The Bayesian Melding to correct bias and qualify uncertianty	
nPost <- BMAnimalTrack(ndl, BMControl(print=TRUE, returnParam=TRUE))
	#nPost is a list with two components
	#first is the parameter estimates of sigma^2_D and sigma^2_H
	#second is a matrix of the posterior mean and variance of eta. 
	#If only eta is needed, you can chagne returnParam into FALSE.

##Plot the results in Easting direction.
##Produce Figure 4 in our paper	
nYlim <- c(min(min(ndl$XMx[, 1]),min(nPost$etaMar[,1])),  
           max(max(ndl$XMx[, 1]),max(nPost$etaMar[,1])))
	#Find the limits in y-axis.
par(mar=c(4, 4, 1, 1))
plot(ndl$XMx[, 2], ndl$XMx[, 1], col="blue", 
		xlab="Time (min)", ylab="Northing (KM)", 
     type="l", lwd=2, ylim=nYlim)
	#Plot the uncorrected DR path
lines(ndl$XMx[, 2], nPost$etaMar[,1], lwd=2)
	#Add the posterior mean of eta
	#the corrected path from our Bayesian Melding approach
lines(ndl$XMx[, 2], nPost$etaMar[,1] +
		1.96*sqrt(nPost$etaMar[,2]), lwd=2, col="grey70")
	#Add the upper bound of the 95\% credible interval
lines(ndl$XMx[, 2], nPost$etaMar[,1] - 
		1.96*sqrt(nPost$etaMar[,2]), lwd=2, col="grey70")
	#Add the lower bound
legend("topleft", bty="n", legend=c("Posterior Mean", 
	"95\% Credible Interval", "GPS Observations", 
	"Uncorrected DRA Results"),text.col=c(1, "grey70", 2, 4), 
	lty=c(1, 1, -1, 1), pch=c(-1, -1, 16, -1), 
	col=c(1, "grey70", 2, 4))
	#Add a legend
points(ndl$glist$Gtime, ndl$g$Y, col="red", pch=16, cex=0.7)
	#Add the original GPS observations.
	
	
###Analyze the Easting direction	
##Prepare the data list that will be used in our Baysian Melding
edl <- as.dataList(Trip1DR$Xdim/1000, Trip1GPSinKM$Easting, 
                   Ytime=strptime(Trip1GPS$DateTime, "\%d-\%b-\%Y \%H:\%M:\%S"), 
                   Xtime=strptime(Trip1DR$DateTime, "\%d-\%b-\%Y \%H:\%M:\%S"), 
                   s2G=0.0625, timeUnit=60, betaOrder=1)

##The Bayesian Melding to correct bias and qualify uncertianty	
ePost <- BMAnimalTrack(edl, BMControl(print=TRUE, returnParam=TRUE))
	#A list similar to nPost

##Plot the results in Easting direction.
##Produce a plot similar to Figure 4 in our paper
eYlim <- c(min(min(edl$XMx[, 1]),min(ePost$etaMar[,1])),  
           max(max(edl$XMx[, 1]),max(ePost$etaMar[,1])))
	#Find the limits in y-axis.
par(mar=c(4, 4, 1, 1))
plot(edl$XMx[, 2], edl$XMx[, 1], col="blue", 
		xlab="Time (min)", ylab="Easting (KM)", 
     type="l", lwd=2, ylim=eYlim)
	#Plot the uncorrected DR path
lines(edl$XMx[, 2], ePost$etaMar[,1], lwd=2)
	#Add the posterior mean of eta
	#the corrected path from our Bayesian Melding approach
lines(edl$XMx[, 2], ePost$etaMar[,1] +
		1.96*sqrt(ePost$etaMar[,2]), lwd=2, col="grey70")
	#Add the upper bound of the 95\% credible interval
lines(edl$XMx[, 2], ePost$etaMar[,1] - 
		1.96*sqrt(ePost$etaMar[,2]), lwd=2, col="grey70")
	#Add the lower bound
legend("bottomright", bty="n", legend=c("Posterior Mean", 
	"95\% Credible Interval", "GPS Observations", 
	"Uncorrected DRA Results"),text.col=c(1, "grey70", 2, 4), 
	lty=c(1, 1, -1, 1), pch=c(-1, -1, 16, -1), 
	col=c(1, "grey70", 2, 4))
	#Add a legend
points(edl$glist$Gtime, edl$g$Y, col="red", pch=16, cex=0.7)
	#Add the original GPS observations.

###Combine the results in both dimensions,
###and calculate the corrected path in degrees.
cPathInKM <- cbind(ePost$etaMar[,1], nPost$etaMar[,1])
	#first column is easting and second column northing in  KM.
cPathInDeg <- KMToDeg(cPathInKM, Trip1GPSformat [1, c(3, 2)])
	#Get the longitude and latitude of the starting points
	#first longitude and then latitude.

##Produce a plot similar to Figure 2 of Liu et al. (2014b)	
plot(cPathInDeg[, ], type="l", lwd=2)
	#plot the corrected path
points(Trip1GPSformat [, c(3, 2)], col="red", pch=16)
	#add the original GPS observations.


}
}
\keyword{datasets}
