#################################### Initialization ###############################################
remove(list = ls())

##### Data path
Datapath = "RawData/"
Output_path = "Output/"

##### Cran packages
## Install
packages <- c("dplyr", "tidyr",
              "ggplot2", "gridExtra", "cowplot", "corrplot",
              "nlme", "lmerTest", "BayesFactor", "stats",
              "car", "readxl", "readr", "Hmisc", "rms", "ISLR", "e1071", "stringr", "writexl",
              "hBayesDM", "FactoMineR", "factoextra",
              "devtools")

new.packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

## Data
library(dplyr)
library(tidyr)

## Graphics
library(ggplot2)
library(gridExtra)
library(cowplot)
library(corrplot)

## Stat and ML
library(nlme)
library(lmerTest)
library(BayesFactor)
library(stats)
library(FactoMineR)
library(factoextra)

## Misc (or don't remember and imported anyway)
library(car)
library(readxl)
library(readr)
library(Hmisc)
library(rms)
library(ISLR)
library(e1071)
library(stringr)
library(writexl)

## Specific
library(devtools)
# install_github("andrewheiss/limer")
# library(limer)

##### Functions
for (Fun in dir("Functions/")) {
  source(paste0("Functions/", Fun))
}

##### List of badly spelled email by participant
MailToChange <- list("Alexdrg18@gmail.com" = "alexdrg18@gmail.com")


##### List of participant who gave two different ages for LS1 and LS2
FU = c()
