library(Matrix)
library(lme4)
library(car)

# Clear the workspace
rm(list=ls())

# Read in the data
data <- read.table(header=T,"LMM_allMeasures.xls")

# Fit the Linear Mixed-Effects Model
interaction.lmer = lmer(y ~ tms_site*measure + (1 + tms_site + measure | Subject), data=data, REML=FALSE);

# Summarise model output
summary(interaction.lmer);

# Get p-values with CAR package
Anova(interaction.lmer,type=3)