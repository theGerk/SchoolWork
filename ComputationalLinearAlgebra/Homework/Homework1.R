#Homework 1 for computational Linear Algebra
#
#Offie space problem
#Problem 1
print("Problem 1:")
accounts=floor(runif(10000,10000,10000000))#deal with cents, should work better
mysecretaccount = 0
days = 0
while(mysecretaccount < 100000000)
{
  days = days + 1
  tmpBal = accounts * (1 + .05 / 365)
  accounts = floor(tmpBal)
  funnledMoney = tmpBal - accounts
  mysecretaccount = mysecretaccount + sum(funnledMoney)
}
print(sprintf("%d days to millionare status.", days))
print('')
print("Problem 2:")
print("  Part A")
print(sprintf("Should take %d bisections to get 8 decimal digits of percision", ceiling(log2(10 ^ 8))))

print("  Part B")
#Benji's bisection function
#Finds a zero (within certain error) in a function given some bounds using bisection method
# f is a function, f: R-> R where R is the set of real numbers (it should work on some other functions but be careful)
# lowerBound is a bound, doesn't really mater if it's lower then upperBound
# upperBound is another bound
#   There is a reqiurement that f(upperBound) * f(lowerBound) <= 0
# a maximal number of iterations (optional)
# desired error (defaults to 10^-10)
#Output of function is a data enviroment with the following paramaters
# $value is a dataframe with $x and $y containing an x and y value of my guess for a root respecivly
# $iterations is an non-negative integer, representing the number of bisections used
# $error is the amount of error (upper bound - lower bound) for my guess
BenjiBisect = function(f, lowerBound, upperBound, iterations=Inf, targetError = 10^-10)
{
  #helper function to handle points in R^2 more easily and avoid possibly costly calls of the f function
  #Returns a data frame with x and y component, both of which will be floating point numbers
  get = function(p){
    out = new.env()
    out$x = p
    out$y = f(p)
    return(out)
  }
  
  #set l and u to lower and upper bound so they may be easier to use
  #note: the program doesn't actually care which is the upper or lower bound, it makes no assumption that you passed in arguments in the correct order.
  l = get(lowerBound)
  u = get(upperBound)
  
  #counts the number of iterations
  i = 0
  
  #check to see if we don't need to do any work
  if(u$y == 0)
  {
    output = new.env()
    output$iterations = 0
    output$error = 0
    output$value = u
    return(output)
  }
  else if(l$y == 0)
  {
    output = new.env()
    output$iterations = 0
    output$error = 0
    output$value = l
    return(output)
  }
  
  
  c = get((u$x + l$x) / 2)
  while(iterations > i && targetError < abs(l$x - u$x))
  {
    if(c$y == 0)
    {
      output = new.env()
      output$iterations = i
      output$error = 0
      output$value = c
      return(output)
    }
    else if(u$y * c$y > 0)
      u = c
    else
      l = c
    
    c = get((u$x + l$x) / 2)
    i = i + 1
  }
  
  output = new.env()
  output$value = new.env()
  output$value = c
  output$iterations = i
  output$error = abs(l$x - u$x)
  return(output)
}

#actually run bisection code in one god-awful line of R
test = BenjiBisect(function(x){return((cos(x))^2+sin(x)-1)}, 2.5, 3.5, Inf, 10 ^ -8)
#print beatiful results with sprintf, an elegant function for a more civilized age.
print(sprintf("It took %d iterations to get an error of %.3e.",test$iterations, test$error))

print("  Part C")
print("See attached LaTeX generated PDF") #See attached pretty Latex generated PDF
print("  Part D")

f = function(x) { return((cos(x))^2 + sin(x) - 1) }
fprime = function(x) { return(-2*sin(x)*cos(x) + cos(x)) }

#does a newtonian thing
getNewton = function(f, x0, target, steps = 50, p = FALSE)
{
  newton = matrix(nrow = steps + 1, ncol = 3) #First row is x_{i-1} value, second row is e_{i-1} value, and third row is e_i/e_{i-1}
  newton[1,1] = x0
  i = 1
  while(i < steps + 1)
  {
    last <- newton[i, 1]
    i <- i + 1
    newton[i,1] = f(last)
  }
  newton[,2] = abs(newton[,1] - target)
  newton[2:(steps+1),3] = newton[2:(steps+1),2] / newton[1:steps,2]
  if(p)
    print(newton)
  output = new.env()
  output$x= newton[,1]
  output$error = newton[,2]
  output$errorRatio = newton[,3]
  return(output)
}

fNext = function(x){return(x - (f(x))/(fprime(x)))}

newton = getNewton(fNext, 4.25,pi, p= TRUE)



print("Seems to converge by step 8, well 7 because x_0 = 4.25 so theres an offset, but I guess everything is one-indexed now so who even knows...")
print("To find convergence lets look at e_i/e_{i-1}^2")
quadraticConvergence = newton$error[2:7]/newton$error[1:6]^2
print(quadraticConvergence)
print("That looks like convergence to 1 to me, so lets call it quadratic convergence.")
print("  Part E")
newton = getNewton(fNext, 1.5,pi/2, p=TRUE)
print("seems to just be constant here, so lets call it linear then shall we?")
print("differences between this and the last try can be chalked up to where we start")


print("Question 3")

makeMatrix = function(x)
{
  A = matrix(nrow=4,ncol=4)
  value = 1
  i = 1
  while(i <= 4)
  {
    j = 1
    while(j <= 4)
    {
      if(i == 5 - j)
      {
        A[i,j] = x
      }
      else
      {
        A[i,j] = value
        value = value + 1
      }
      j = j + 1
    }
    i = i + 1
  }
  return(A)
}

f= function(x){
  if(length(x) > 1)
  {
    o <- vector(, length(x))
    for(r in 1:length(x))
      o[r] = f(x[r])
    return(o)
  }
  else
    return(det(makeMatrix(x)) - 1000)
}

print("lets get a look at this function")
plot.function(f, -100, 100, n = 1000)
plot.function(f, -10, 20, n = 1000)
print("seems to cross the origin at least once between -10 and 20")
plot.function(f, 3.5, 6, n = 1000)
plot.function(f, 9, 10, n=10000)
plot.function(f, -10000, 10000, n=100000)
plot.function(f, -13, -8, n=100000)
plot.function(f, -20, -13, n=100000)
print("Seems to cross also once between -20 and 13")
Q3 = new.env()
Q3$a = BenjiBisect(f, -10, 20)
Q3$b = BenjiBisect(f, -20, -13)

print("Lets see how close our guesses were.")
print("trial 1")
print(sprintf("For the range -10 to 20 we got x = %f", Q3$a$value$x))
print(sprintf("Determinant when x = %f is: %f, about %e away from our expected answer of 1000", Q3$a$value$x, det(makeMatrix(Q3$a$value$x)), det(makeMatrix(Q3$a$value$x)) - 1000))
print("trial 2")
print(sprintf("For the range -20 to -13 we got x = %f", Q3$b$value$x))
print(sprintf("Determinant when x = %f is: %f, about %e away from our expected answer of 1000", Q3$b$value$x, det(makeMatrix(Q3$b$value$x)), det(makeMatrix(Q3$b$value$x)) - 1000))

print("Question 4")

makeHilbert = function(x)
{
  h = matrix(, 5, 5)
  i = 0
  while(i < 5)
  {
    i = i + 1
    j = 0
    while(j < i)
    {
      j = j + 1
      h[j,i] = h[i,j] = 1/(i + j - 1)
    }
  }
  h[1,1] = x
  return(h)
}

f = function(x)
{
  if(length(x) > 1)
  {
    o <- vector(, length(x))
    for(r in 1:length(x))
      o[r] = f(x[r])
    return(o)
  }
  else
  {
    m = makeHilbert(x)
    return(max(eigen(m, TRUE)$values)-pi)
  }
}

print("we start again by looking for a zero.")
plot.function(f, -100, 100, n =1000)
plot.function(f, -100, -10,n=1000)
print("The first graph obviously is above 0 at 100 and the second graph is clearly below zero at -100 so we should have a 0 between there.")
Q4 = BenjiBisect(f,100,-100,Inf,10^-6)
print(sprintf("Oh, looks like there is one at (or more accuratly around) %.6f.", Q4$value$x))
