library(Matrix)
library(lme4)
library(car)

# Clear the workspace
rm(list=ls())

# Read in the data
data <- read.table(header=T,"LMM_separateMeasures_4regions.xls")

# Fit the mixed-effects models with tms_site being a fixed effect and subject a random effect
att.lmer = lmer(Attention ~ 1 + tms_site + (1|Subject), data=data, weights = attFMRI);
sat.lmer = lmer(SAT ~ 1 + tms_site + (1|Subject), data=data, weights = satFMRI);
type2AUC.lmer = lmer(Conf ~ 1 + tms_site + (1|Subject), data=data, weights = confFMRI);

# Summarise models
summary(att.lmer);
summary(sat.lmer);
summary(type2AUC.lmer);

# Get p-values with CAR package
Anova(att.lmer,type=3)
Anova(sat.lmer,type=3)
Anova(type2AUC.lmer,type=3)