% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pAttributes_method.R
\docType{methods}
\name{pAttributes}
\alias{pAttributes}
\alias{pAttributes,character-method}
\title{Get p-attributes.}
\usage{
pAttributes(.Object)

\S4method{pAttributes}{character}(.Object)
}
\arguments{
\item{.Object}{a character vector (length 1) or partition object}
}
\description{
In a CWB corpus, every token has positional attributes. While s-attributes
cover a range of tokens, every single token in the token stream of a corpus
will have a set of positional attributes (such as part-of-speech, or lemma).
The available p-attributes are returned by the pAttributes-method.
}
\examples{
\dontrun{
   use("polmineR.sampleCorpus")
   pAttributes("PLPRBTTXT")
}
}
\references{
Stefan Evert & The OCWB Development Team, CQP Query Language Tutorial, http://cwb.sourceforge.net/files/CQP_Tutorial.pdf.
}

