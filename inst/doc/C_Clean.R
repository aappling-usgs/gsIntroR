## ----setup, echo=FALSE---------------------------------------------------
set.seed(3)
title="C. Clean"
gsIntroR::navigation_array(title)

## ----indexing_examp------------------------------------------------------
#Create a vector
x <- c(10:19)
x
#Positive indexing returns just the value in the ith place
x[7]
#Negative indexing returns all values except the value in the ith place
x[-3]
#Ranges work too
x[8:10]
#A vector can be used to index
#Can be numeric
x[c(2,6,10)]
#Can be boolean - will repeat the pattern 
x[c(TRUE,FALSE)]
#Can even get fancy
x[x %% 2 == 0]

## ----data_frame_index----------------------------------------------------
#Let's use one of the stock data frames in R, iris
head(iris)
#And grab a specific value
iris[1,1]
#A whole column
petal_len<-iris[,3]
petal_len
#A row
obs15<-iris[15,]
obs15
#Many rows
obs3to7<-iris[3:7,]
obs3to7

## ----more_data_frame_index-----------------------------------------------
#First, there are a couple of ways to use the column names
iris$Petal.Length
head(iris["Petal.Length"])
#Multiple colums
head(iris[c("Petal.Length","Species")])
#Now we can combine what we have seen to do some more complex queries
#Get all the data for flowers with a petal length less than 2
little_iris<-iris[iris$Petal.Length<=2,]
head(little_iris)
#Or maybe we want just the sepal widths of the virginica species
virginica_iris<-iris$Sepal.Width[iris$Species=="virginica"]
head(virginica_iris)

## ----setup_dplyr,eval=FALSE----------------------------------------------
#  install.packages("dplyr")
#  library("dplyr")

## ----more_data_frame_dplyr-----------------------------------------------
#First, select some columns
dplyr_sel<-select(iris,Sepal.Length,Petal.Length,Species)
#That's it.  Select one or many columns
#Now select some, like before
dplyr_big_iris<-filter(iris, Petal.Length>=6)
head(dplyr_big_iris)
#Or maybe we want just the virginica species
virginica_iris<-filter(iris,Species=="virginica")
head(virginica_iris)

## ----combine_commands----------------------------------------------------
#Intermediate data frames
#Select First: note the order of the output, neat too!
dplyr_big_iris_tmp1 <- select(iris, Species, Sepal.Length, Petal.Length)
dplyr_big_iris_tmp <- filter(dplyr_big_iris_tmp1, Petal.Length>=6)
head(dplyr_big_iris_tmp)

#Nested function
dplyr_big_iris_nest <- filter(
  select(iris,Species,Sepal.Length,Petal.Length),
  Species=="virginica")
head(dplyr_big_iris_nest)

#Pipes
dplyr_big_iris_pipe <-
  select(iris,Species,Sepal.Length,Petal.Length) %>%
  filter(Species=="virginica")
head(dplyr_big_iris_pipe)

## ----Exercise1, echo=FALSE-----------------------------------------------

## ----rbind_examp---------------------------------------------------------
#Let's first create a new small example data.frame
rbind_df <- data.frame(a=1:3, b=c("a","b","c"), c=c(T,T,F), d=rnorm(3))
#Now an example df to add
rbind_df2 <- data.frame(a=10:12, b=c("x","y","z"), c=c(F,F,F), d=rnorm(3))
rbind_df <- rbind(rbind_df, rbind_df2)
rbind_df

## ----merge_example-------------------------------------------------------
# Contrived data frame
rbind_df_merge_me <- data.frame(
  a=c(1,3,10,11,14,6,23), x=rnorm(7), 
  names=c("bob","joe","sue",NA,NA,"jeff",NA))
# Create merge of matches
rbind_df_merge_match <- merge(rbind_df, rbind_df_merge_me, by="a")
rbind_df_merge_match
# Create merge of matches and all of the first data frame
rbind_df_merge_allx <- merge(rbind_df, rbind_df_merge_me, by="a", all.x=TRUE)
rbind_df_merge_allx

# dplyr is faster
rbind_df_merge_allx_dplyr <- left_join(rbind_df, rbind_df_merge_me, by="a")
all.equal(rbind_df_merge_allx_dplyr, rbind_df_merge_allx)

## ----Exercise2, echo=FALSE-----------------------------------------------

## ----aggregate_examp-----------------------------------------------------
#Chained with Pipes
iris %>%
  group_by(Species) %>%
  summarize(mean(Sepal.Length),
            mean(Sepal.Width),
            mean(Petal.Length),
            mean(Petal.Width))

## ----arrange_example-----------------------------------------------------
head(mtcars)
# every function, including head(), can be chained
mtcars %>% head()
#ascending order is default
arrange(mtcars, mpg) %>% head()
#descending
arrange(mtcars, desc(mpg)) %>% head()
#multiple columns: most cyl with best mpg at top
arrange(mtcars, desc(cyl), desc(mpg)) %>% head()

## ----slice_example-------------------------------------------------------
#grab rows 3 through 10
slice(mtcars, 3:10)

## ----mutate_example------------------------------------------------------
mutate(mtcars, kml=mpg*0.425) %>% head()

## ----rowwise_examp-------------------------------------------------------
#First a dataset of temperatures, recorded weekly at 100 sites.
temp_df <- data.frame(
  id=1:100, week1=runif(100,20,25), week2=runif(100,19,24), 
  week3=runif(100,18,26), week4=runif(100,17,23))
head(temp_df)
#To add row means to the dataset, without the ID
temp_df2 <- temp_df %>% 
  rowwise() %>% 
  mutate(site_mean = mean(c(week1,week2,week3,week4)))
head(temp_df2)

## ----Exercise3, echo=FALSE-----------------------------------------------

## ----site_fix, eval=FALSE------------------------------------------------
#  gages_data <- mutate(gages_data, STAID=paste0("0", as.character(STAID)))

## ----date_fix, eval=FALSE------------------------------------------------
#  # install.packages('lubridate') # this might be necessary for you if you get errors
#  fix_wq_dates <- function(wq_dat) {
#    wq_dat %>% mutate(
#      sample_dt = switch(
#        class(sample_dt)[1],
#        Date = as.POSIXct(format(sample_dt, "%Y-%m-%d"), format="%Y-%m-%d", tz="MST7MDT"),
#        character = as.POSIXct(sample_dt, format="%Y-%m-%d", tz="MST7MDT"),
#        POSIXct = lubridate::with_tz(sample_dt, "MST7MDT")))
#  }
#  phos_nm <- fix_wq_dates(phos_nm)
#  temp_nm <- fix_wq_dates(temp_nm)
#  disch_nm <- fix_wq_dates(disch_nm)
#  spcond_nm <- fix_wq_dates(spcond_nm)

## ----echo=FALSE----------------------------------------------------------
gsIntroR::navigation_array(title)

