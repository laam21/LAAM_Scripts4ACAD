reddit <-  read.csv('reddit.csv')
str(reddit)
View(reddit)
table(reddit$employment.status)
summary(reddit)

levels(reddit$age.range)
library(ggplot2)
qplot(data = reddit, x = age.range)
is.factor(reddit$age.range)
reddit$age.range<-ordered(reddit$age.range, levels = c("Under 18","18-24","25-34","35-44","45-54","55-64","65 or Above"))

levels(reddit$income.range)
qplot(data = reddit, x = income.range)
reddit$income.range <- ordered(reddit$income.range, levels = c( "Under $20,000","$20,000 - $29,999","$30,000 - $39,999","$40,000 - $49,999","$50,000 - $69,999","$70,000 - $99,999","$100,000 - $149,999","$150,000 or more"))

levels(reddit$cheese)






#####Ordering factors
set.seed(124)
schtyp <- sample(0:1,20,replace = TRUE)
schtyp

is.factor(schtyp)
is.numeric(schtyp)

schtyp.f <- factor(schtyp, labels = c("private", "public"))
schtyp.f

is.factor(schtyp.f)

ses <- c("low", "middle", "low", "low", "low", "low", "middle", "low", "middle",
         "middle", "middle", "middle", "middle", "high", "high", "low", "middle",
         "middle", "low", "high")

is.factor(ses)
is.character(ses)

ses.f.bad.order <- factor(ses)
is.factor(ses.f.bad.order)

levels(ses.f.bad.order)

ses.f <- factor(ses, levels=c("low", "middle","high"))
is.factor(ses.f)

levels(ses.f)

ses.order <- factor(ses, levels=c("low", "middle", "high")) 
ses
ses.order

ses.f[21] <- "very.high"
ses.f

ses.f <- factor (ses.f, levels = c(levels(ses.f), "very.high"))
ses.f[21]<-"very.high"
ses.f
levels(ses.f)

ses.f.new <-ses.f[ses.f != "very.high"]
ses.f.new

ses.f.new <- factor(ses.f.new)
ses.f.new
levels(ses.f.new)

ses.f <- ses.f.new
read <- c(34, 39, 63, 44, 47, 47, 57, 39, 48, 47, 34, 37, 47, 47, 39, 47,
          47, 50, 28, 60)

# combining all the variables in a data frame
combo <- data.frame(schtyp, schtyp.f, ses, ses.f, read)

table(ses,schtyp)
table (ses.f,schtyp.f)

library(lattice)
bwplot(schtyp ~ read | ses, data = combo, layout = c(2, 2))
bwplot(schtyp.f ~ read | ses.f, data = combo, layout = c(2, 2))


#####Tydying data
raw <-read.csv("~/Desktop/04_Workshops-Courses-Conferences/eda-course-materials/lesson2/Test_tidy.txt",sep = ",")
head(raw)
