library(Sim.DiffProc)

# 1. Euler Method ----
f <- expression ( ( 1+2*x))
g <- expression (0.5*x^0.3 )
sim <- snssde1d(drift=f, diffusion=g, x0=2, M=1, N=10000, Dt=0.0001)
names(sim)
mydata <- sim$X
mydata
plot(mydata, type="l")

fx <- expression( theta[1]+theta[2]*x ) ## drift coefficient of model (9)
gx <- expression( theta[3]*x^theta[4] ) ## diffusion coefficient of model (9)
fitmod <- fitsde(data=mydata,drift=fx,diffusion=gx,start = 
            list(theta1=1, theta2=1,theta3=1,theta4=1),pmle="euler")

coef(fitmod)
summary(fitmod)
plot(fitmod$data)


length(fitted)
length(fitmod$data)
vcov(fitmod)
AIC(fitmod)
confint(fitmod, level=0.95)

# 2. Ozaki Method ----
f <- expression( 3*(2-x) )
g <- expression( 0.5 )
sim <- snssde1d(drift=f,diffusion=g,x0=5,Dt=0.01)
HWV <- sim$X
fx <- expression( theta[1]*(theta[2]- x) ) ## drift coefficient of model (13)
gx <- expression( theta[3] )               ## diffusion coefficient of model (13)
fitmod <- fitsde(data=HWV,drift=fx,diffusion=gx,start = 
          list(theta1=1,theta2=1,theta3=1),pmle="ozaki")
summary(fitmod)
confint(fitmod,parm=c("theta1","theta2"),level=0.95)

# 3. Shoji-Ozaki Method ----
f <- expression(-2*x*t)
g <- expression(0.2*x)
sim <- snssde1d(drift=f,diffusion=g,N=1000,Dt=0.001,x0=10)
mydata <- sim$X
fx <- expression( theta[1]*x*t ) ## drift coefficient of model (17)
gx <- expression( theta[2]*x ) ## diffusion coefficient of model (17)
fitmod <- fitsde(data=mydata,drift=fx,diffusion=gx, start = 
                   list(theta1=1,theta2=1),pmle="shoji")
summary(fitmod)
vcov(fitmod)
logLik(fitmod)
confint(fitmod,level=0.9)

# 4. Kessler Method ----
f <- expression(3*t*(sqrt(t)-x))
g <- expression(0.3*t)
sim <- snssde1d(drift=f,diffusion=g,M=1,N=1000,x0=2,Dt=0.001)
mydata <- sim$X
## drift coefficient of model (20)
fx <- expression( theta[1]*t* ( theta[2]*sqrt(t) - x ) )
## diffusion coefficient of model (20)
gx <- expression( theta[3]*t )
fitmod <- fitsde(data=mydata,drift=fx,diffusion=gx,start = 
                   list(theta1=1, theta2=1,theta3=1),pmle="kessler")
summary(fitmod)


# fitsde ----
theta1 = 5; theta2 = 1; theta3 = 0.2
f <- expression( ((0.5*theta3^2 *x^(theta2-1) - theta1)/ x^theta2) )
g <- expression( theta3 )
sim <- snssde1d(drift=f,diffusion=g,M=1,N=1000,x0=3,Dt=0.001)
mydata <- sim$X

fx <- expression( ((0.5*theta[3]^2 *x^(theta[2]-1) - theta[1])/ x^theta[2]) )
gx <- expression(theta[3])
fitmod <- fitsde(mydata,drift=fx,diffusion=gx, start = 
          list(theta1=1,theta2=1,theta3=1),pmle="euler")
coef(fitmod)
true <- c(theta1,theta2,theta3) ## True parameters
bias <- true-coef(fitmod)
bias
confint(fitmod)


 # Model Selection via AIC ----
f <- expression( 2*x )
g <- expression( 0.3*x^0.5 )
sim <- snssde1d(drift=f,diffusion=g,M=1,N=1000,x0=2,Dt=0.001)
mydata <- sim$X
# True model
fx <- expression( theta[1]*x )
gx <- expression( theta[2]*x^theta[3] )
truemod <- fitsde(data=mydata,drift=fx,diffusion=gx,start = 
                    list(theta1=1, theta2=1,theta3=1),pmle="euler")
# competing model 1
fx1 <- expression( theta[1]+theta[2]*x )
gx1 <- expression( theta[3]*x^theta[4] )
mod1 <- fitsde(data=mydata,drift=fx1,diffusion=gx1,start = 
                 list(theta1=1, theta2=1,theta3=1,theta4=1),pmle="euler")
# competing model 2
fx2 <- expression( theta[1]+theta[2]*x )
gx2 <- expression( theta[3]*sqrt(x) )
mod2 <- fitsde(data=mydata,drift=fx2,diffusion=gx2,start = 
                 list(theta1=1, theta2=1,theta3=1),pmle="euler")
## competing model 3
fx3 <- expression( theta[1] )
gx3 <- expression( theta[2]*x^theta[3] )
mod3 <- fitsde(data=mydata,drift=fx3,diffusion=gx3,start = 
                   list(theta1=1, theta2=1,theta3=1),pmle="euler")
#  Computes AIC
AIC <- c(AIC(truemod),AIC(mod1),AIC(mod2),AIC(mod3))
Test <- data.frame(AIC,row.names = c("True mod","Comp mod1","Comp mod2", "Comp mod3"))
Test
Bestmod <- rownames(Test)[which.min(Test[,1])]
Theta1 <- c(coef(truemod)[[1]],coef(mod1)[[1]],coef(mod2)[[1]],coef(mod3)[[1]])
Theta2 <- c(coef(truemod)[[2]],coef(mod1)[[2]],coef(mod2)[[2]],coef(mod3)[[2]])
Theta3 <- c(coef(truemod)[[3]],coef(mod1)[[3]],coef(mod2)[[3]],coef(mod3)[[3]])
Theta4 <- c("",coef(mod1)[[4]],"","")
Parms <- data.frame(Theta1,Theta2,Theta3,Theta4,
            row.names = c("True mod","Comp mod1","Comp mod2","Comp mod3"))
Parms


