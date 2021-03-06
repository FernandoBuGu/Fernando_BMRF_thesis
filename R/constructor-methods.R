read.bmrf <- function(
  net.file,
  go.file,
  fd.file,
  verbose=FALSE,
  net.header=FALSE,
  go.header=FALSE,
  fd.header=FALSE,
  ...
) {
  neti <- read.net(net.file, verbose=verbose, header=net.header)
  go <- read.terms(go.file, neti$protein.idcs, verbose=verbose, header=go.header)
  fd <- read.terms(fd.file, neti$protein.idcs, verbose=verbose, header=fd.header)

  return(bmrf(neti$net, go$m, fd$m, ...))
}

bmrf <- function(
  net, ## network
  go, ## training data
  fd, ## functional domains
  minGOsize = 20,
  maxGOsize = (0.9 * nrow(net)),
  minFDsize = 20,
  maxFDsize = (0.9 * nrow(net)),
  verbose = FALSE
) {

  ## take the GO-terms that are neither very general nor very sparse
  go.cs <- colSums(go);
  stopifnot(sum(go.cs >= minGOsize & go.cs <= maxGOsize) > 0)
  go <- go[,go.cs >= minGOsize & go.cs <= maxGOsize]

  if(all(is.na(fd))) {
    warning("functional domains are not set", call.=FALSE)
  } else {
    ## take the functional domains that are neither very general nor very sparse
    fd.cs <- colSums(fd)
    stopifnot(sum(fd.cs >= minGOsize & fd.cs <= maxGOsize) > 0)
    fd <- fd[,fd.cs >= minFDsize & fd.cs <= maxFDsize]
  }

  u = which(rowSums(go) == 0);

  new("BMRF",
    net=net,
    go=go,
    fd=fd,
    maxGOsize=maxGOsize,
    minGOsize=minGOsize,
    maxFDsize=maxFDsize,
    minFDsize=minFDsize,
    unknown.idcs=u,
    verbose=verbose
  )
}

read.net <- function(f, header=FALSE, verbose=FALSE) {
	data = read.table(f, sep = "\t", header=header)
  protein.ids.uniq = sort(unique(c(levels(data[,1]), levels(data[,2]))))

  idcs = seq(along=protein.ids.uniq)
  names(idcs) = protein.ids.uniq
  l = length(protein.ids.uniq)

  protein.ids.a = as.character(data[,1]);
  protein.ids.b = as.character(data[,2]);

	net = sparseMatrix(
    i=idcs[protein.ids.a],
    j=idcs[protein.ids.b],
    x=1,
    dims=c(l,l)
  )

  ## In case it is not symmetric, symmetrize it
	net = net + t(net)
  ## In case it is not binary, binarize it.
  net@x[] = 1
	rownames(net) = protein.ids.uniq
	colnames(net) = protein.ids.uniq
  if(verbose)
    message("reading network OK")

	return(list(net=net, protein.idcs=idcs));
}


read.terms = function(f, p.idcs.net, header=FALSE, verbose=FALSE) {

  if(is.na(f))
    return(list(m=Matrix(data=NA), t.idcs=NA))

	data = read.table(f, sep = "\t", header=header)

  terms.uniq = sort(levels(data[,2]))

  t.idcs = seq(along=terms.uniq)
  names(t.idcs) = terms.uniq

  protein.ids = as.character(data[,1]);
  terms = as.character(data[,2]);

  p.ids.error <- setdiff(protein.ids, names(p.idcs.net))

  if(length(p.ids.error) > 0)
    stop("some IDs are not in the network: ", paste0(p.ids.error, collapse=", "))

	L = sparseMatrix(
    i = p.idcs.net[protein.ids],
    j = t.idcs[terms],
    x = 1,
    dims = c(length(p.idcs.net), length(t.idcs))
  )

  ## In case it is not binary, binarize it.
	L@x[] = 1

	rownames(L) = names(p.idcs.net)
	colnames(L) = names(t.idcs)

  if(verbose)
    message("reading terms OK")

	return(list(m=L, t.idcs=t.idcs));
}

setMethod("show", "BMRF", function(object) {

    fivenum_deg <- paste(fivenum(rowSums(object@net)), sep=" ", collapse=" ")
    diag_sum <- sum(diag(object@net))
    num_edges <- (sum(object@net > 0)-diag_sum)/2+diag_sum

    sep <- "------------------------------------------------------------------------------\n"
    cat("BMRF data set\n")
    cat(sep)
    cat("         No. of proteins: ", dim(object@net)[1],             "\n", sep="")
    cat("No. of unannot. proteins: ", length(object@unknown.idcs),    "\n", sep="")
    cat("      No. of connections: ", num_edges,                      "\n", sep="")
    cat("\n")
    cat(" Fivenum of node degrees: ", fivenum_deg,                    "\n", sep="")
    cat("    Mean of node degrees: ",  mean(rowSums(object@net)),     "\n", sep="")
    cat("\n")
    cat("GO size range: (", object@minGOsize, ",", object@maxGOsize, ")\n", sep="")
    cat("FD size range: (", object@minFDsize, ",", object@maxFDsize, ")\n", sep="")
    cat(sep)
    print.matrix.head("network", object@net)
    cat(sep)
    print.matrix.head("GO-terms", object@go)
    cat(sep)
    print.matrix.head("func. domains", object@fd)
  }
)

print.matrix.head <- function(name, mat) {
  d <- dim(mat)
  cat(name," (", d[1], ",", d[2], "):\n")
  numRows <- min(6, d[1])
  numCols <- min(6, d[2])
  print(mat[1:numRows, 1:numCols])
}
