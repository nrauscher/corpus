#' @include partition_class.R generics.R session_methods.R
NULL

setGeneric("size", function(x){UseMethod("size")})


#' @rdname partition-class
#' @exportMethod size
setMethod("size", "partition", function(x) sum(x@cpos[,2]-x@cpos[,1]+1))




#' @exportMethod show
#' @docType methods
#' @noRd
setMethod("show", "partition",
function(object){
  cat("** partition object **\n")
  cat(sprintf("%-20s", "CWB-corpus:"), object@corpus, "\n")
  cat(sprintf("%-20s", "Name:"), object@name, "\n")
  if (length(object@sAttributes)==0) {
    cat(sprintf("%-20s", "S-Attributes:"), "no specification\n")
  } else {
    s <- unlist(lapply(
      names(object@sAttributes),
      function(x) {paste(x, "=", paste(object@sAttributes[[x]], collapse="/"))}
      ))
    cat(sprintf("%-20s", "S-attributes:"), s[1], '\n')
    if (length(s)>1) {for (i in length(s)){cat(sprintf("%-20s", " "), s[i], '\n')}}
  } 
  cat(sprintf("%-21s", "Corpus positions:"))
  if (nrow(object@cpos)==0) {cat("not available\n")}
  else {cat(nrow(object@cpos), "pairs of corpus positions\n")}
  cat(sprintf("%-21s", "Partition size:"))
  if (is.null(object@size)) {cat("not available\n")}
  else {cat(object@size, "tokens\n")}
  cat(sprintf("%-21s", "Term frequencies:"))
  if (is.null(dim(object@stat))) {cat("not available\n")}
  else {cat("available for ", object@pAttribute, "\n")}
})




#' @exportMethod [
#' @rdname partition-class
setMethod('[', 'partition', function(x,i) tf(x, query=i, method="grep"))

#' @exportMethod [[
#' @rdname partition-class
setMethod("[[", "partition", function(x,i){
  kwic(object=x, i)
})

#' split partition into partitionBundle
#' 
#' Split a partition object into a partition Bundle if gap between strucs
#' exceeds a minimum number of tokens specified by 'gap'. Relevant to 
#' split up a plenary protocol into speeches. Note: To speed things up, the
#' returned partitions will not include frequency lists. The lists can be
#' prepared by applying \code{enrich} on the partitionBundle object that
#' is returned.
#' 
#' @param x a partition object
#' @param gap an integer specifying the minimum gap for performing the split
#' @param drop not yet implemented
#' @param ... further arguments
#' @return a partitionBundle
#' @aliases split,partition
#' @rdname split-partition-method 
#' @exportMethod split
#' @docType methods
setMethod("split", "partition", function(x, gap, drop=FALSE, ...){
  # if (length(x@metadata) == 0) warning("no metadata, method potentially fails -> please check what happens")
  cpos <- x@cpos
  if (nrow(cpos) > 1){
    distance <- cpos[,1][2:nrow(cpos)] - cpos[,2][1:(nrow(cpos)-1)]
    beginning <- c(1, ifelse(distance>gap, 1, 0))
    no <- vapply(1:length(beginning), FUN.VALUE=1, function(x) ifelse (beginning[x]==1, sum(beginning[1:x]), 0))
    for (i in (1:length(no))) no[i] <- ifelse (no[i]==0, no[i-1], no[i])
    strucsClassified <- cbind(x@strucs, no)
    strucList <- split(strucsClassified[,1], strucsClassified[,2])
    cposClassified <- cbind(cpos, no)
    cposList1 <- split(cposClassified[,1], cposClassified[,3])
    cposList2 <- split(cposClassified[,2], cposClassified[,3])
    bundleRaw <- lapply(c(1:length(strucList)), function(i) {
      p <- new("partition")
      p@strucs <- strucList[[i]]
      p@cpos <- cbind(cposList1[[i]], cposList2[[i]])
      p@corpus <- x@corpus
      p@encoding <- x@encoding
      p@sAttributes <- x@sAttributes
      p@explanation <- c("partition results from split, sAttributes do not necessarily define partition")
      p@xml <- x@xml
      p@sAttributeStrucs <- x@sAttributeStrucs
      p@name <- paste(x@name, i, collapse="_", sep="")
      if (is.null(names(x@metadata))){
        meta <- NULL
      } else {
        meta <- colnames(x@metadata$table)
      }
      p <- enrich(
        p, size=TRUE,
        tf=NULL,
        meta=meta,
        verbose=TRUE
      )
      p
    })
  } else {
    bundleRaw <- list(x)
  }
  names(bundleRaw) <- unlist(lapply(bundleRaw, function(y) y@name))
  bundle <- as.partitionBundle(bundleRaw)
  bundle
})

#' @rdname partition-class
setMethod("pAttribute", "partition", function(object, from, to, mc=TRUE, verbose=TRUE){
  if (verbose == TRUE) message("... preparing cpos information")
  cpos <- unlist(apply(object@cpos, 1, function(x) c(x[1]:x[2])))
  if (verbose == TRUE) message("... extracting information from corpus")
  bag <- matrix(
    data=c(
      cqi_cpos2id(paste(object@corpus, '.', to, sep=''), cpos),
      pos=cqi_cpos2id(paste(object@corpus, '.', from, sep=''), cpos)
    ),
    ncol=2, nrow=length(cpos), dimnames=list(NULL,c(to, from))
  )
  if (verbose == TRUE) message("... splitting data for evaluation")
  idVectorList <- split(x=bag[,to], f=bag[,from])
  if (verbose == TRUE) message("... doing calculations")
  .id2stat <- function(idVector){
    tabulatedIdVector <- tabulate(idVector + 1)
    decreasing <- order(tabulatedIdVector, decreasing = TRUE)
    occurring <- which(tabulatedIdVector > 0)
    decreasingAndOccurring <- decreasing[which(decreasing %in% occurring)]  
    shares <- round(tabulatedIdVector[decreasingAndOccurring] / sum(tabulatedIdVector[decreasingAndOccurring]), 2)
    token <- cqi_id2str(paste(object@corpus, '.', to, sep=''), decreasingAndOccurring - 1)
    Encoding(token) <- object@encoding
    setNames(shares, token)
  }
  if (mc == FALSE){
    statList <- lapply(idVectorList, .id2stat)
  } else {
    statList <- mclapply(idVectorList, .id2stat)
  }
  if (verbose == TRUE) message("... id to string for keys")
  keyAsString <- cqi_id2str(paste(object@corpus, '.', from, sep=''), as.integer(names(statList)))
  Encoding(keyAsString) <- object@encoding
  names(statList) <- keyAsString
  statList
})



#' @rdname partition-class
setMethod("name", "partition", function(x) x@name)

#' @rdname partition-class
#' @exportMethod name<-
setReplaceMethod("name", signature=c(x="partition", value="character"), function(x, value) {
  x@name <- value
  x
})

#' @rdname partition-class
setMethod("dissect", "partition", function(object, dim, verbose=FALSE){
  if ( is.null(names(object@metadata))) {
    if (verbose == TRUE) message("... required metadata missing, enriching partition")
    object <- enrich(object, meta=dim, verbose=verbose)
  }
  strucSize <- object@cpos[,2] - object@cpos[,1] + 1
  tab <- data.frame(
    strucSize,
    rows=object@metadata$table[,dim[1]],
    cols=object@metadata$table[,dim[2]]
  )
  ctab <- xtabs(strucSize~rows+cols, data=tab)
  ctab <- as.matrix(unclass(ctab))
  colnames(ctab)[which(colnames(ctab) == "NA.")] <- "NA"
  rownames(ctab)[which(colnames(ctab) == "NA.")] <- "NA"
  attr(ctab, "call") <- NULL
  dimnames(ctab) <- setNames(list(rownames(ctab), colnames(ctab)), dim)
  ctab
})

#' @exportMethod length
#' @rdname partition-class
setMethod("length", "partition", function(x) x@size)


#' @exportMethod as.data.frame
#' @rdname partition-class
setMethod("as.data.frame", "partition", function(x) as.data.frame(tf(x)) )

setAs("partition", "data.table", function(from) data.table(tf(from)) )


#' @exportMethod hist
#' @rdname partition-class
setMethod("hist", "partition", function(x, ...){hist(x@tf[,"tf"], ...)})