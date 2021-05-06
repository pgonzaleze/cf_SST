"
Author: Pedro Gonzalez
Date: April 8th 2021
University of British Columbia
"

################# ================== ###################
###### Mixed Effects Regression | R Data Analysis ######
################# ================== ###################

require(ggplot2) # to plot 
#require(lme4) # to perform mixed effect models
#library(stargazer) # to make table 
library(MuMIn) # to compute r2
library(lmerTest) # to get the p-value
library(sjPlot) # to plot estimates
library(sjlabelled)
library(sjmisc)
library(ncf) # to compute MORAN's Index and Mantel test

# Load the database
hdp <- read.csv("df_sst_clouds.csv")

# perform a simple lm (to compare outputs)
basic.lm <- lm(SEVERITY_CODE ~ DHW * CF_a_runmean30, data = hdp)
summary(basic.lm)
#plot qq plot
plot(basic.lm, which = 2)

########## =============== ##########
### Perform a mixed effects model ###
########## =============== ##########

# lmerTESt::lmer 
m <- lmer(SEVERITY_CODE ~ DHW * CF_a_runmean30 +
            (1 | lat:YEAR), data = hdp)
summary(m)

# plot estimates
theme_set(theme_sjplot2())
plot_model(m, sort.est = TRUE,
           show.values = TRUE, value.offset = .3)

# Reference: Kutner, et al. (2005). Applied Linear Statistical Models. McGraw-Hill. (Ch. 8)

#plot qq plot
library("car")
qqPlot(hdp$CF_a_runmean30, line = "none",
       envelope = FALSE, grid = FALSE, id = FALSE)

qqnorm(resid(m))
qqline(resid(m))
plot(m, which = 2) 

# plot results in a nice table 
# Use this only with "lmer" and not with lmerTest 
stargazer(m, type = "text",
          digits = 3,
          star.cutoffs = c(0.05, 0.01, 0.001),
          digit.separator = "")

# to get the r2; will returns the marginal and the conditional R²
r.squaredGLMM(m)

# To extract the residuals (errors) and summarize them, 
# as well as plot them (they should be approximately normally distributed around a mean of zero)
residuals <- resid(m)
summary(residuals) 
hist(residuals)

# Compute the profile confidence intervals
confint(m, oldNames = FALSE)

# Performa Anova
anova(m)

# alternative (it does not suppor 'stargazer' package)
# # lmerTest
# mm <- lmerTest::lmer(SEVERITY_CODE ~ DHW + CF_a_runmean7 +
#                        (1 | lat) +
#                        (1 | lon), data = hdp)
# summary(mm)


# Interaction plot
theme_set(theme_sjplot2())
plot_model(m, type = "int", show.p = TRUE,
           terms = c("DHW_adj_date", 'CF_a_runmean30_adj_date'))
# Aiken and West (1991). Multiple Regression: Testing and Interpreting Interactions.
  
library(emmeans)
emmeans(m, pairwise ~ DHW|CF_a_runmean30, lmerTest.limit = 20978,
        pbkrtest.limit = 20978)
