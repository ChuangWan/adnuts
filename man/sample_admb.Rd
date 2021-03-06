% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sample_admb.R
\name{sample_admb}
\alias{sample_admb}
\title{Bayesian inference of an ADMB model using the no-U-turn sampler.}
\usage{
sample_admb(model, path = getwd(), iter = 2000, init = NULL, chains = 3,
  warmup = NULL, seeds = NULL, thin = 1, mceval = FALSE,
  duration = NULL, parallel = FALSE, cores = NULL, control = NULL,
  algorithm = "NUTS", ...)
}
\arguments{
\item{model}{Name of model (i.e., model.tpl)}

\item{path}{Path to model executable. Defaults to working
directory. Often best to have model files in a separate subdirectory,
particularly for parallel.}

\item{iter}{The number of samples to draw.}

\item{init}{A list of lists containing the initial parameter vectors,
one for each chain or a function. It is strongly recommended to
initialize multiple chains from dispersed points. A of NULL signifies
to use the starting values present in the model (i.e., \code{obj$par})
for all chains.}

\item{chains}{The number of chains to run.}

\item{warmup}{The number of warmup iterations.}

\item{seeds}{A vector of seeds, one for each chain.}

\item{thin}{The thinning rate to apply to samples. Typically not used
with NUTS.}

\item{mceval}{Whether to run the model with \code{-mceval} on samples
from merged chains.}

\item{duration}{The number of minutes after which the model will quit
running.}

\item{parallel}{A boolean for whether to use parallel cores. The package
snowfall is used if TRUE.}

\item{cores}{The number of cores to use for parallel execution.}

\item{control}{A list to control the sampler. See details for further
use.}

\item{algorithm}{Which algorithm to use, either "NUTS" or "RWM".}

\item{...}{Further arguments to be passed to the algorithm. See help
files for the samplers for further arguments.}
}
\description{
Draw Bayesian posterior samples from an AD Model Builder (ADMB) model
using an MCMC algorithm. This function generates posterior samples from
which inference can be made. Adaptation schemes are used so
specifying tuning parameters is not necessary, and parallel
execution reduces overall run time.
}
\details{
This function implements algorithm 6 of Hoffman and Gelman (2014),
and loosely follows package \code{rstan}. The step size can be
  adapted or specified manually. The metric (i.e., mass matrix) can be
  unit diagonal, adapted diagonal (default and recommended), or a dense
  matrix specified by the user. Further control of algorithms can be
  specified with the \code{control} argument.  Elements are:
\describe{
\item{adapt_delta}{The target acceptance rate. D}
\item{metric}{The mass metric to use. Options are: "unit" for a unit diagonal
  matrix; \code{NULL} to estimate a diagonal matrix during warmup; a matrix
  to be used directly (in untransformed space).}
\item{adapt_delta}{Whether adaptation of step size is turned on.}
\item{adapt_mass}{Whether adaptation of mass matrix is turned
  on. Currently only allowed for diagonal metric.}
\item{max_treedepth}{Maximum treedepth for the NUTS algorithm.}
\item{stepsize}{The stepsize for the NUTS algorithm. If \code{NULL} it
  will be adapted during warmup.}
}
}
\section{Warning}{

The user is responsible for specifying the model properly (priors,
  starting values, desired parameters fixed, etc.), as well as assessing
  the convergence and validity of the resulting samples (e.g., through
  the \code{coda} package), or with function
  \code{\link{launch_shinytmb}} before making inference. Specifically,
  priors must be specified in the template file for each
  parameter. Unspecified priors will be implicitly uniform.
}

\examples{
\dontrun{
## This is the packaged simple regression model
path.simple <- system.file('examples', 'simple', package='adnuts')
## It is best to have your ADMB files in a separate folder and provide that
## path, so make a copy of the model folder locally.
path <- 'simple'
dir.create(path)
trash <- file.copy(from=list.files(path.simple, full.names=TRUE), to=path)
## Compile and run model
oldwd <- getwd()
setwd(path)
system('admb simple.tpl')
system('simple')
setwd('..')
init <- function() rnorm(2)
## Run NUTS with defaults
fit <- sample_admb(model='simple', init=init, path=path)
unlink(path, TRUE) # cleanup folder
setwd(oldwd)
}

}
\author{
Cole Monnahan
}
