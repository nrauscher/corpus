% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/templates_method.R
\docType{methods}
\name{getTemplate}
\alias{getTemplate}
\alias{getTemplate,character-method}
\alias{getTemplate,missing-method}
\alias{setTemplate}
\alias{setTemplate,character-method}
\alias{setTemplate,missing-method}
\title{Manage templates.}
\usage{
getTemplate(x)

\S4method{getTemplate}{character}(x)

\S4method{getTemplate}{missing}()

setTemplate(x, ...)

\S4method{setTemplate}{character}(x, template)

\S4method{setTemplate}{missing}()
}
\arguments{
\item{x}{either a "character" vector, if missing, the names of available templates will be returned}

\item{...}{further parameters}

\item{template}{template to assign (a list)}
}
\description{
When the polmineR package is loaded, an environment .templates will be assigned to the global 
environment that will is used when preparing the html output for reading the text in a partition.
The
}

