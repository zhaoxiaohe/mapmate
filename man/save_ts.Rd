% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{save_ts}
\alias{save_ts}
\title{Save time series plots}
\usage{
save_ts(data, x, y, id, cap, dir = ".", col = "black", xlm, ylm,
  axes.only = FALSE, axes.space = TRUE, file = "Rplot",
  png.args = list(width = 1920, height = 1080, res = 300, bg = "transparent"),
  save.plot = TRUE, return.plot = FALSE, overwrite = FALSE,
  num.format = 4)
}
\arguments{
\item{data}{data frame containing the \code{x} and \code{y} plotting variables.}

\item{x}{character, the column name in \code{data} for the variable plotted along the x axis.}

\item{y}{character, the column name in \code{data} for the variable plotted along the y axis.}

\item{id}{character, column name referring to column of \code{data} representing frame sequence integer IDs.}

\item{cap}{time index/frame ID used to subset \code{data}.
The rows of data retained are all those where \code{p <= cap}, where \code{p} represents the frame ID values in column \code{id}. Defaults to all data if missing.}

\item{dir}{png output directory. Defaults to working directory.}

\item{col}{color of the time series line or the axes lines, ticks, and text. Defaults to black.}

\item{xlm}{x axis limits.}

\item{ylm}{y axis limits.}

\item{axes.only}{only plot axis information, no data. Defaults to \code{FALSE}.}

\item{axes.space}{if \code{axes.only=TRUE}, leave room for x and y axes in plot window when \code{axes.space=TRUE}.
Remove this marginal area so that data are plotted over the full canvas when \code{axes.space=FALSE}.
Defaults to \code{TRUE}. Ignored when \code{axes.only=TRUE} because of the explicit intent to draw axes.}

\item{file}{character, output filename pattern preceeding the image sequence numbering and file extension. Defaults to \code{"Rplot"}.}

\item{png.args}{a list of arguments passed to \code{png}.}

\item{save.plot}{save the plot to disk. Defaults to \code{TRUE}. Typically only set to \code{FALSE} for demonstrations and testing.}

\item{return.plot}{return the ggplot object. Defaults to \code{FALSE}. Only intended for single-plot demonstrations and testing, not for still image sequence automation.}

\item{overwrite}{logical, overwrite existing files. Defaults to \code{FALSE}. If file exists and \code{return.plot=TRUE} the plot is still returned. Otherwise returns \code{NULL}.
This is a frame by frame check on each file. File writing is simply skipped for existing files when \code{overwrite=FALSE}. No error or warning is thrown.}

\item{num.format}{number of digits including any leading zeros for image sequence frame numbering. Defaults to 4, i.e. \code{0001, 0002, ...}.}
}
\value{
usually returns NULL after writing file to disk. May return a ggplot object with or without the file writing side effect.
}
\description{
Save a time series plot to disk intended to be part of a as a still image sequence of a growing time series.
}
\details{
For  \code{id} column frame ID values \code{i}, \code{cap} subsets \code{data} to rows where \code{i <= cap}.
Sequential application of \code{save_ts} should involve iterating \code{cap} over the values \code{i}.
A data frame passed to \code{save_map} need not be subset based on the current frame ID in advance so providing \code{cap} values is important. See example.

When calling \code{save_ts} iteratively from the \code{save_seq} wrapper function, \code{save_ts} is applied over a list of sequentially subsetted data frames based on the frame IDs.
In this case, specifying \code{cap} is not needed and an error will be thrown if provided.

Fixed axis limits must be established in advance by computing the max range or other desired range for the x and y variables that are to be plotted.
}
\examples{
\dontrun{
library(dplyr)
library(purrr)
data(annualtemps)
temps <- mutate(annualtemps, frameID = Year - min(Year) + 1) \%>\%
  group_by(Year, frameID) \%>\% summarise(z=mean(z))
xlm <- range(temps$Year)
ylm <- range(temps$z)

# should specify a dir or set working dir for file output
# consider running over a smaller subset of frame IDs
walk(temps$frameID, ~save_ts(temps, x="Year", y="z", id="frameID",
  cap=.x, col="blue", xlm=xlm, ylm=ylm))
}
}
