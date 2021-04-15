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

##### Functions
for (Fun in dir("Functions/")) {
  source(paste0("Functions/", Fun))
}

##### List with column names by type of variable for further references
# AllCol <- list("Index" = c("NS", "Index"),
#                "Btwn" = c("Hospit"),
#                "Cov" = c("All_Rhinitis"),
#                "Demo" = c("Sex", "Age", "DTimePCR_Testing", "DTimeT2_T1", "PCR"),
#                "Symptoms" = c("Fever", "Cough", "Dyspnea", "Rhinorhoea", "Myalgia",
#                               "Headeaches", "SoreThroat"),
#                "OtherSymptoms" = c("Nausea",	"Diarrhee",	"Vomissements",	"Fatigue",	"EruptionCutanee",	"Demangeaison",
#                                    "Frisson",	"Accouphene",	"PerteDePoids",	"DouleurThoracique",	"DouleurAbdominale",
#                                    "DouleurRetroOrbitale", "DryMouth",	"Allodynie",	"ObstructionNasale",	"Pyrosis"),
#                "Commorbidities" = c("Diabetes", "BHT", "HeartDisease", "Breathing",
#                                     "Neuro", "CRS", "All_Rhinitis", "OtherComorbidities"),
#                "OtherCommorbidities" = c("GreffeRenale",	"InsuffisanceMitrale",	"PancreatiteEthylique",
#                                          "Cataracte",	"GastriteChronique",	"ArtheriteMI",	"Sclerodermie",
#                                          "HTAP",	"TVP",	"Goitre",	"Cephalee",	"Epilepsie",	"LMMC",	"Hypothyroidie",	"Addison",
#                                          "Depression",	"CysticFibrosis",	"COPD",	"Asthma",	"HeartAttack",	"Stroke",	"Leucemia",
#                                          "Osteoporose",	"Rheuma",	"Grave"),
#                "TotComSympt" = c("nCom", "PresOfCom", "nSymptoms", "PresOfSymptoms"),
#                "Obj_SmellT1" = c("Smell_totalT1", "Smell1T1", "Smell2T1", "Smell3T1", "Smell4T1", "ObjSmellScoreT1"),
#                "Obj_TasteT1" = c("Taste_totalT1", "Taste1T1", "Taste2T1", "Taste3T1", "Taste4T1"),
#                "Subj_TasteT1" = c("SweetT1", "SaltT1", "SourT1", "BitterT1",
#                                   "SweetT1Dur", "SaltT1Dur", "SourT1Dur", "BitterT1Dur"),
#                "Subj_MeasuresT1" = c("SmellVASbeforeT1", "SmellVASduringT1",
#                                      "NasalPatencyVASbeforeT1", "NasalPatencyVASduringT1",
#                                      "TasteVASbeforeT1", "TasteVASduringT1"),
#                "Obj_ScoreT1" = c("T1SmellDisappeared", "T1SmellLessStrong", "T1Parosmia", "T1Phantosmia", "T1NoChange", "T1DK"),
#                
#                "Deltas" = c("DeltaSmell", "DeltaTaste",
#                             "DeltaSmellVAST1", "DeltaSmellVAST2",
#                             "DeltaNasalPatencyVAST1", "DeltaNasalPatencyVAST2",
#                             "DeltaTasteVAST1", "DeltaTasteVAST2"),
#                
#                "Obj_SmellT2" = c("Smell_totalT2", "Smell1T2", "Smell2T2", "Smell3T2", "Smell4T2", "ObjSmellScoreT2"),
#                "Obj_TasteT2" = c("Taste_totalT2", "Taste1T2", "Taste2T2", "Taste3T2", "Taste4T2"),
#                "Subj_TasteT2" = c("SweetT2", "SaltT2", "SourT2", "BitterT2"),
#                "Subj_MeasuresT2" = c("SmellVASbeforeT2", "SmellVASduringT2", "SmellVASafterT2",
#                                      "NasalPatencyVASbeforeT2", "NasalPatencyVASduringT2", "NasalPatencyVASafterT2",
#                                      "TasteVASbeforeT2", "TasteVASduringT2", "TasteVASafterT2"),
#                "Obj_ScoreT2" = c("T2SmellDisappeared", "T2SmellLessStrong", "T2Parosmia", "T2Phantosmia", "T2NoChange", "T2DK"))
