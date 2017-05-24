#Function "sumamatrices" takes a matrix and performs 4 things on it
Suma_Matrices <- function(windowsize, inputseq)
{
  starts <- seq(1, length(inputseq)-windowsize, by = windowsize)
  n <- length(starts)
  chunkbps <- numeric(n)
  chunkstats <- numeric(n)
  for (i in 1:n){
    chunk <- inputseq[starts[i]:(starts[i]+windowsize-1)] 
    chunkmean <- mean(chunk)
    chunkstdv <- sd(chunk)
    chunkbps[i] <- chunkmean
    chunkstats[i] <- chunkstdv
  }
  return (list(starts,chunkbps,chunkstats))
}