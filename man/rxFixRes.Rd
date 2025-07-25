% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ui-fix.R
\name{rxFixRes}
\alias{rxFixRes}
\title{Literally fix residual parameters}
\usage{
rxFixRes(ui, returnNull = FALSE)
}
\arguments{
\item{ui}{rxode2 ui function}

\item{returnNull}{boolean for if unchanged values should return the
original ui (\code{FALSE}) or null (\code{TRUE})}
}
\value{
model with residual parameters literally fixed in the model
}
\description{
Literally fix residual parameters
}
\examples{

One.comp.transit.allo <- function() {
 ini({
   # Where initial conditions/variables are specified
   lktr <- log(1.15)  #log k transit (/h)
   lcl  <- log(0.15)  #log Cl (L/hr)
   lv   <- log(7)     #log V (L)
   ALLC <- 0.75  #allometric exponent cl
   ALLV <- 1.00  #allometric exponent v
   prop.err <- fix(0.15)   #proportional error (SD/mean)
   add.err <- fix(0.6)     #additive error (mg/L)
   eta.ktr ~ 0.5
   eta.cl ~ 0.1
   eta.v ~ 0.1
 })
 model({
   #Allometric scaling on weight
   cl <- exp(lcl + eta.cl + ALLC * logWT70)
   v  <- exp(lv + eta.v + ALLV * logWT70)
   ktr <- exp(lktr + eta.ktr)
   # RxODE-style differential equations are supported
   d/dt(depot)   = -ktr * depot
   d/dt(central) =  ktr * trans - (cl/v) * central
   d/dt(trans)   =  ktr * depot - ktr * trans
   ## Concentration is calculated
   cp = central/v
   # And is assumed to follow proportional and additive error
   cp ~ prop(prop.err) + add(add.err)
 })
}

m <- rxFixRes(One.comp.transit.allo)
}
\author{
Matthew L. Fidler
}
