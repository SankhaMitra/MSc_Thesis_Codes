The following are the codes for replication of results of my M.Sc.
Thesis

Kindly note that the results are preliminary, and therefore, not to be
cited or shared

Kindly note that codes for replication are not to be shared with others
or posted in public domain

Thank you.

Here, I run a regression on a panel dataset that spans over 29 years
(1991-2019) and consists of 17 Indian states. The regression
specification is given by:
*Y*<sub>*s**y*</sub> = *α*<sub>0*s*</sub> + *α*<sub>1*s*</sub>*y* + *β*<sub>*y*</sub> + *γ***R**<sub>**s****y**</sub> + *δ***P**<sub>**s****y**</sub> + *ψ***P**<sub>**s****y****\***</sub> + *ϕ***X**<sub>**s****y**</sub> + *λ**R*<sub>*s**y*</sub><sup>*S**C*</sup>*P*<sub>*s**y*</sub><sup>*S**C*</sup> + *σ**R*<sub>*s**y*</sub><sup>*S**T*</sup>*P*<sub>*s**y*</sub><sup>*S**T*</sup> + *ε*<sub>*s**y*</sub>

*α*<sub>0*s*</sub> - state fixed effects

*a**l**p**h**a*<sub>1*s*</sub>*y* - state-specific time trends

*β*<sub>*y*</sub> - time fixed effects

**R**<sub>**s****y**</sub> - reservation shares for the Scheduled Castes
and Scheduled Tribes in State Legislative Assemblies

**P**<sub>**s****y**</sub> - current year population shares of the
Scheduled Castes and Scheduled Tribes

**P**<sub>**s****y****\***</sub> - census year population shares of the
Scheduled Castes and Scheduled Tribes

**X**<sub>**s****y**</sub> - controls

*R*<sub>*s**y*</sub><sup>*S**C*</sup>*P*<sub>*s**y*</sub><sup>*S**C*</sup>
- interaction between SC reservation shares and SC current population
shares

*R*<sub>*s**y*</sub><sup>*S**T*</sup>*P*<sub>*s**y*</sub><sup>*S**T*</sup>
- interaction between ST reservation shares and ST current population
shares

I install the necessary libraries first and then, import the dataset

``` r
library(haven)
library(sandwich)
library(stargazer)
library(multiwayvcov)
library(plm)
library(lmtest)
```

The dataset is cleaned beforehand; it spans over 29 years and takes into
account 17 Indian states

``` r
setwd("D:/Semester4_Courses/HSP620/Results_Replication_R")
data_regression_1991to2019 <- read_dta("PanelData_1991to2019.dta")
```

The datasets contains variables that are reported in fractions (or
shares), like SC/ST-reservation shares, population shares, etc. For
better interpretation, we convert these variables in percentages

``` r
data_regression_new_1991to2019 <- data_regression_1991to2019  

data_regression_new_1991to2019$SC_res <- (data_regression_new_1991to2019$SC_res*100)
data_regression_new_1991to2019$ST_res <- (data_regression_new_1991to2019$ST_res*100)
data_regression_new_1991to2019$female_win_prop <- (data_regression_new_1991to2019$female_win_prop*100)
data_regression_new_1991to2019$SC_curr_share <- (data_regression_new_1991to2019$SC_curr_share*100)
data_regression_new_1991to2019$ST_curr_share <- (data_regression_new_1991to2019$ST_curr_share*100)
data_regression_new_1991to2019$sc_census_share <- (data_regression_new_1991to2019$sc_census_share*100)
data_regression_new_1991to2019$st_census_share <- (data_regression_new_1991to2019$st_census_share*100)
data_regression_new_1991to2019$ST_res_inter_ST_curr_share <- (data_regression_new_1991to2019$ST_curr_share * data_regression_new_1991to2019$ST_res)
data_regression_new_1991to2019$SC_res_inter_SC_curr_share <- (data_regression_new_1991to2019$SC_res)*(data_regression_new_1991to2019$SC_curr_share)
```

There are 4 outcome variables in our regression analysis. I therefore
would run 4 regression models. In the estimation, clustered standard
errors (clustered at state-level) are used. In R, clustering of standard
errors cannot be done using a simple one line command like vce(cluster
clusterid) like STATA. Therefore, we define a function to calculate
standard errors (se_cluster_1to4) and the p-values corresponding to such
standard errors. The regression output is derived in .txt and .tex
format. The latter can be later uploaded on $\\LaTeX$.

``` r
fit_a <- lm(schools_established ~ SC_res + ST_res + Elec_Yrs_ECI + female_win_prop + SC_curr_share + ST_curr_share + sc_census_share + st_census_share + (SC_res_inter_SC_curr_share) + (ST_res_inter_ST_curr_share) + Population_Density_SqKm + (as.factor(statecode) - 1) + (as.factor(Year) - 1) + ((as.factor(statecode) - 1)*Year), data = data_regression_new_1991to2019)                                 
fit_b <- lm(sc_schools ~ SC_res + ST_res + Elec_Yrs_ECI + female_win_prop + SC_curr_share + ST_curr_share + sc_census_share + st_census_share + (SC_res_inter_SC_curr_share) + (ST_res_inter_ST_curr_share) + Population_Density_SqKm + (as.factor(statecode) - 1) + (as.factor(Year) - 1) + (as.factor(statecode) - 1)*Year, data = data_regression_new_1991to2019)                                 
fit_c <- lm(st_schools ~ SC_res + ST_res + Elec_Yrs_ECI + female_win_prop + SC_curr_share + ST_curr_share + sc_census_share + st_census_share + (SC_res_inter_SC_curr_share) + (ST_res_inter_ST_curr_share) + Population_Density_SqKm + (as.factor(statecode) - 1) + (as.factor(Year) - 1) + (as.factor(statecode) - 1)*Year, data = data_regression_new_1991to2019)                                 
fit_d <- lm(tot_min_schools ~ SC_res + ST_res + Elec_Yrs_ECI + female_win_prop + SC_curr_share + ST_curr_share + sc_census_share + st_census_share + (SC_res_inter_SC_curr_share) + (ST_res_inter_ST_curr_share) + Population_Density_SqKm + (as.factor(statecode) - 1) + (as.factor(Year) - 1) + (as.factor(statecode) - 1)*Year, data = data_regression_new_1991to2019)                                 

### A list containing the regression models is created 

models_a_to_d <- list(fit_a, fit_b, fit_c, fit_d)

### Creating functions for calculating clustered standard errors and p-values corresponding to such standard errors 
### I can use lapply function to apply the functions on the list of regression models 

se_cluster_a_to_d <- function(x){
  coeftest(x, vcov = vcovCL, cluster = ~data_regression_new_1991to2019$statecode)[,"Std. Error"]
  
}

p_cluster_a_to_d <- function(x){
  coeftest(x, vcov = vcovCL, cluster = ~data_regression_new_1991to2019$statecode)[, "Pr(>|t|)"]
}


stargazer(models_a_to_d, se = lapply(models_a_to_d, se_cluster_a_to_d), p = lapply(models_a_to_d, p_cluster_a_to_d), keep = c('SC_res','ST_res', 'SC_curr_share', 'ST_curr_share', 'SC_res_inter_SC_curr_share', 'ST_res_inter_ST_curr_share'), dep.var.labels = c("Total Number of Schools Established", "Schools established in high SC-population share districts", "Schools established in high ST-population share districts", "Schools established in high SC/ST-population share districts") ,covariate.labels = c("SC-reservation", "ST-reservation", "SC Current Population Share", "ST Current Population Share" , "SC-reservation*SC Current Population Share", "ST-reservation*ST Current Population Share") , type = "text", out = "Regressions_PolRes_Project.txt")

stargazer(models_a_to_d, se = lapply(models_a_to_d, se_cluster_a_to_d), p = lapply(models_a_to_d, p_cluster_a_to_d), keep = c('SC_res','ST_res', 'SC_curr_share', 'ST_curr_share', 'SC_res_inter_SC_curr_share', 'ST_res_inter_ST_curr_share'), dep.var.labels = c("Total Number of Schools Established", "Schools established in high SC-population share districts", "Schools established in high ST-population share districts", "Schools established in high SC/ST-population share districts") ,covariate.labels = c("SC-reservation", "ST-reservation", "SC Current Population Share", "ST Current Population Share" , "SC-reservation*SC Current Population Share", "ST-reservation*ST Current Population Share") , type = "text", out = "Regressions_PolRes_Project.tex")
```

There is another method for obtaining clustered standard errors using R
and presenting the results neatly using Stargazer table. We use the
\`\`multiwayvcov" library for that purpose.

``` r
fit_1 <- lm(schools_established ~ SC_res + ST_res + Elec_Yrs_ECI + female_win_prop + SC_curr_share + ST_curr_share + sc_census_share + st_census_share + (SC_res_inter_SC_curr_share) + (ST_res_inter_ST_curr_share) + Population_Density_SqKm + (as.factor(statecode) - 1) + (as.factor(Year) - 1) + ((as.factor(statecode) - 1)*Year), data = data_regression_new_1991to2019)                                 
fit_2 <- lm(sc_schools ~ SC_res + ST_res + Elec_Yrs_ECI + female_win_prop + SC_curr_share + ST_curr_share + sc_census_share + st_census_share + (SC_res_inter_SC_curr_share) + (ST_res_inter_ST_curr_share) + Population_Density_SqKm + (as.factor(statecode) - 1) + (as.factor(Year) - 1) + (as.factor(statecode) - 1)*Year, data = data_regression_new_1991to2019)                                 
fit_3 <- lm(st_schools ~ SC_res + ST_res + Elec_Yrs_ECI + female_win_prop + SC_curr_share + ST_curr_share + sc_census_share + st_census_share + (SC_res_inter_SC_curr_share) + (ST_res_inter_ST_curr_share) + Population_Density_SqKm + (as.factor(statecode) - 1) + (as.factor(Year) - 1) + (as.factor(statecode) - 1)*Year, data = data_regression_new_1991to2019)                                 
fit_4 <- lm(tot_min_schools ~ SC_res + ST_res + Elec_Yrs_ECI + female_win_prop + SC_curr_share + ST_curr_share + sc_census_share + st_census_share + (SC_res_inter_SC_curr_share) + (ST_res_inter_ST_curr_share) + Population_Density_SqKm + (as.factor(statecode) - 1) + (as.factor(Year) - 1) + (as.factor(statecode) - 1)*Year, data = data_regression_new_1991to2019)                                 


#### Create variance-covariance matrix with clustering at state-level for each of the models  

clcov_fit1 <- cluster.vcov(fit_1, data_regression_1991to2019$statecode)
clcov_fit2 <- cluster.vcov(fit_2, data_regression_1991to2019$statecode)
clcov_fit3 <- cluster.vcov(fit_3, data_regression_1991to2019$statecode)
clcov_fit4 <- cluster.vcov(fit_4, data_regression_1991to2019$statecode)

#### Extract the diagonal elements of the variance-covariance matrices created above and take square root of it to obtain the clustered standard errors

rse_fit1 <- sqrt(diag(clcov_fit1))
rse_fit2 <- sqrt(diag(clcov_fit2))
rse_fit3 <- sqrt(diag(clcov_fit3))
rse_fit4 <- sqrt(diag(clcov_fit4))


stargazer(fit_1, fit_2, fit_3, fit_4, se = list(rse_fit1, rse_fit2, rse_fit3, rse_fit4), keep = c('SC_res', 'ST_res', 'SC_curr_share','ST_curr_share','SC_res_inter_SC_curr', 'ST_res_inter_ST_curr_share'), dep.var.labels = c("Total Number of Schools Established", "Schools established in high SC-population share districts", "Schools established in high ST-population share districts", "Schools established in high SC/ST-population share districts") ,covariate.labels = c("SC-reservation", "ST-reservation", "SC Current Population Share", "ST Current Population Share" , "SC-reservation*SC Current Population Share", "ST-reservation*ST Current Population Share"),type = "text", out = "Regression_PolRes_clustered_se_multiwayvcov.tex")

stargazer(fit_1, fit_2, fit_3, fit_4, se = list(rse_fit1, rse_fit2, rse_fit3, rse_fit4), keep = c('SC_res', 'ST_res', 'SC_curr_share','ST_curr_share','SC_res_inter_SC_curr', 'ST_res_inter_ST_curr_share'), dep.var.labels = c("Total Number of Schools Established", "Schools established in high SC-population share districts", "Schools established in high ST-population share districts", "Schools established in high SC/ST-population share districts") ,covariate.labels = c("SC-reservation", "ST-reservation", "SC Current Population Share", "ST Current Population Share" , "SC-reservation*SC Current Population Share", "ST-reservation*ST Current Population Share"), type = "text", out = "Regression_PolRes_clustered_se_multiwayvcov.txt")
```

There is another way for estimating clustered standard errors in R. One
can use the coeftest function from “lmtest” library. However, stargazer
does not work on coeftest objects. Hence, presenting the results neatly
using coeftest would be a challenge.

I export the dataset used here in dta format for further (primarily
descriptive) analysis using STATA. Library “foreign” comes in handy for
exporting files in dta format.

``` r
library(foreign)
write.dta(data_regression_new_1991to2019, file = "PanelData_1991to2019_Varsinpercent.dta")
```

We now replicate figures 1 and 2 of my M.Sc. Thesis

``` r
statecodes <- unique(data_regression_new_1991to2019$statecode)

years <- unique(data_regression_new_1991to2019$Year)

for(j in 1:length(years)){
  data <- subset(data_regression_new_1991to2019, data_regression_new_1991to2019$Year == years[j])
  assign(paste("data_y",j, sep = "_"), data)
}

### We use library dplyr for easier manipulation of datasets 

library(dplyr)



outcome1_mean_df <- aggregate(data_regression_new_1991to2019$schools_established, list(data_regression_new_1991to2019$Year), FUN = mean)
outcome2_mean_df <- aggregate(data_regression_new_1991to2019$sc_schools, list(data_regression_new_1991to2019$Year), FUN = mean)
outcome3_mean_df <- aggregate(data_regression_new_1991to2019$st_schools, list(data_regression_new_1991to2019$Year), FUN = mean)
outcome4_mean_df <- aggregate(data_regression_new_1991to2019$tot_min_schools, list(data_regression_new_1991to2019$Year), FUN = mean)

outcome1_mean_df
outcome1_mean <- round(outcome1_mean_df$x)
outcome2_mean <- round(outcome2_mean_df$x)
outcome3_mean <- round(outcome3_mean_df$x)
outcome4_mean <- round(outcome4_mean_df$x)

library(tseries)
outcome1_mean.ts <- ts(outcome1_mean, start = c(1991), end = c(2019), frequency = 1)
outcome2_mean.ts <- ts(outcome2_mean, start = c(1991), end = c(2019), frequency = 1)
outcome3_mean.ts <- ts(outcome3_mean, start = c(1991), end = c(2019), frequency = 1)
outcome4_mean.ts <- ts(outcome4_mean, start = c(1991), end = c(2019), frequency = 1)

#### We export these outcome variables as .ts objects in one data-set (in .csv format) for creating the same plots in STATA
```

We use the ts objects to create our plot We create figure 1 using the
following chunk of code It gives us average number of schools
constructed across the states, or high SC/ST population share districts
of all the states, on the years between 1991 to 2019

``` r
par(mfrow = c(2,2))
plot(outcome1_mean.ts, main = "States", ylim = c(0,2500) , ylab = "Average Number of Schools", xlab = "Year", type = "l", lty = 1)
plot(outcome2_mean.ts, main = "SC-dominated Districts of the States", ylim = c(0,800) , ylab = "Average Number of Schools", xlab = "Year", type = "l", lty = 2)
plot(outcome3_mean.ts, main = "ST-dominated Districts of the States", ylim = c(0,800) ,ylab = "Average Number of Schools", xlab = "Year", type = "l", lty = 3)
plot(outcome4_mean.ts, main = "SC/ST-dominated Districts of the States", ylim = c(0,1000) ,ylab = "Average Number of Schools", xlab = "Year", type = "l", lty = 4)
```

![](Replication_PolRes_R-_updated_files/figure-markdown_github/plot%201-1.png)

Similarly, for figure 2, we create the ts objects and use them to plot
the average reservation shares for SC/ST communities in state
legislative assemblies for the years between 1991 and 2019

``` r
SCReser_mean_df <- aggregate(data_regression_new_1991to2019$SC_res, list(data_regression_new_1991to2019$Year), FUN = mean)
STReser_mean_df <- aggregate(data_regression_new_1991to2019$ST_res, list(data_regression_new_1991to2019$Year), FUN = mean)


SCReser_mean_df

SCReser_mean <- (SCReser_mean_df$x)
STReser_mean <- (STReser_mean_df$x)

library(tseries)

SCReser_mean.ts <- ts(SCReser_mean, start = c(1991), end = c(2019), frequency = 1)
STReser_mean.ts <- ts(STReser_mean, start = c(1991), end = c(2019), frequency = 1)
```

We use the ts objects to plot the average reservation shares

``` r
par(mfrow = c(1,1))
plot(SCReser_mean.ts, ylim = c(0,20) , ylab = "Reservation Shares (in per cent)", xlab = "Year", type = "l", lty = 1)
lines(STReser_mean.ts, ylim = c(0,20)  ,ylab = "Reservation Shares (in per cent)", xlab = "Year", type = "l", lty = 2)
legend("bottomleft", legend = c("SC-Reservation","ST-Reservation"), lty = 1:2)
```

![](Replication_PolRes_R-_updated_files/figure-markdown_github/plot%202-1.png)

**Citation for Stargazer**

Hlavac, Marek (2018). stargazer: Well-Formatted Regression and Summary
Statistics Tables. R package version 5.2.2.
<https://CRAN.R-project.org/package=stargazer>

**Please refer to the STATA codes for replication of Margin Plots and Choropleth maps**

**Thank You**
