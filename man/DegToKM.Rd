\name{DegToKM}
\alias{DegToKM}
\alias{KMToDeg}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Convert between the latitude and longitude in degrees and Northing and Easting in kilometers (KM).
}
\description{
Based on functions from \code{TrackReconstruction}, convert the longitude and latitude degrees into easting and northing in kilometer or vice versa.
}
\usage{
DegToKM(gpsformat)
KMToDeg(cPath, iniDeg)
}
\arguments{
  \item{gpsformat}{Output from \code{\link{GPStable}}, including the latitude, longitude in degrees and between GPS great circle distance and Bearing degree, etc.}
  \item{cPath}{A matrix with two columns, the corrected path from \code{\link{BMAnimalTrack}}, first column should be easting in KM and second column should be northing in KM.}
  \item{iniDeg}{The longitude and latitude in degree of the starting point of the path}
}
\details{
Please make sure you organize \code{cPath} and \code{iniDeg} as the function requires.
}
\value{
\code{DegToKM} returns a data frame with date-time and the converted easting and northing in km.
\code{KMToDeg} returns a matrix with two columns. The first column is longitude in degree of the corrected path and the second column is the latitude. 
}
\references{
Liu, Y., Battaile, B. C., Zidek, J. V., and Trites, A. (2014). Bayesian melding of the Dead-Reckoned path and gps measurements for an accurate and high-resolution path of marine mammals. arXiv preprint arXiv: 1411.6683.
}
\author{
Yang (Seagle) Liu <yang.liu@stat.ubc.ca>
}
\seealso{
\code{\link{BMAnimalTrack}},  \code{\link{GPStable}}
}
\examples{
data(Trip1GPS)
GPSformat <- GPStable(Trip1GPS)
GPSinKM <- DegToKM(GPSformat)
#Convert the degree into kilometers.
GPSdeg <- KMToDeg(GPSinKM[, 2:3], GPSformat[1, c(3, 2)])
#Convert the kilometers back into degrees.
#More comprehensive examples can be found by help(Trip1)
}
\keyword{degree}
\keyword{northing}
\keyword{easting}
