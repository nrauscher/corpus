% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cooccurrences_method.R
\docType{methods}
\name{cooccurrences}
\alias{cooccurrences}
\alias{cooccurrences,character-method}
\alias{cooccurrences,partition-method}
\alias{cooccurrences,partitionBundle-method}
\title{Get cooccurrence statistics.}
\usage{
cooccurrences(.Object, ...)

\S4method{cooccurrences}{character}(.Object, keep = NULL, cpos = NULL,
  pAttribute = "word", window = 5, method = "new", verbose = TRUE)

\S4method{cooccurrences}{partition}(.Object, window = 5, keep = list(pos =
  c("NN", "ADJA")), method = "ll", big = FALSE, tcm = FALSE, mc = FALSE,
  progress = TRUE, verbose = TRUE, ...)

\S4method{cooccurrences}{partitionBundle}(.Object,
  mc = getOption("polmineR.mc"), ...)
}
\arguments{
\item{.Object}{a partition object}

\item{...}{further parameters that will be passed into bigmatrix (applies only of big=TRUE)}

\item{keep}{list with tokens to keep}

\item{cpos}{integer vector with corpus positions, defaults to NULL - then the corpus positions for the whole corpus will be used}

\item{pAttribute}{the pAttribute of the tokens}

\item{window}{no of tokens to the left and to the right of nodes}

\item{method}{statistical test to use (defaults to "ll")}

\item{verbose}{logical, whether to be verbose}

\item{big}{logical, whether to use bigmatrix}

\item{tcm}{logical, if TRUE, a term-cooccurrence matrix (sparse matrix, simple_triplet_matrix) will be returned}

\item{mc}{whether to use multicore}

\item{progress}{logical, whether to be verbose}
}
\value{
a cooccurrences-class object
}
\description{
Get cooccurrence statistics.
}
\examples{
\dontrun{
  use(polmineR.sampleCorpus)
  merkel <- partition("PLPRBTTXT", text_type = "speech", text_name = ".*Merkel", regex = TRUE)
  merkel <- enrich(merkel, pAttribute = "word")
  cooc <- cooccurrences(merkel, keep = NULL)
  cooc <- cooccurrences(merkel, keep = NULL, big = TRUE)
}
}
\author{
Andreas Blaette
}

