## Function to cache and solve the inverse of a matrix

#To run this code ->  cacheSolve(makeCacheMatrix(InputMatrix))

## Create a cache matrix to store the partial results for 
## cache Solve() function calculate the inverse of a matrix

makeCacheMatrix <- function(input.matrix = matrix()) {
  #Input matrix x
  output.matrix <- NULL
  
  set <- function(y) {
    input.matrix <<- y
    output.matrix <<- NULL
  }
  # Func to get & set the cached results of a inv. matrix value
  get <- function() input.matrix
  # Use solve() to inverse the matrix
  setInverse <- function(solve) output.matrix <<- solve
  getInverse <- function() output.matrix
  
  list(set = set,get = get,
       setInverse = setInverse,
       getInverse = getInverse)
  
}


## Function to calculate the inverse of a matrix
## Uses the makeCacheMatrix() to solve the inverse
## Output returns the final inverse of the matrix

cacheSolve <- function(x, ...) {
  output.matrix <- x$getInverse()
  # Check if there is a cached matrix available
  if(!is.null(output.matrix)) {
    message("Retrieving cached matrix")
    return(output.matrix)
  }
  # Retrieve the cached / matrix for calculation
  temp.Matrix <- x$get()
  output.matrix <- solve(temp.Matrix)
  x$setInverse(output.matrix)
  #Print out results
  output.matrix
}


