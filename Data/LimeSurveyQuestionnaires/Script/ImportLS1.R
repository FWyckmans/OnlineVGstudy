# Initialization
source("VGS_Init.R")
Datapath = "Data/LimeSurveyQuestionnaires/RawData/"
Output_path = "Data/LimeSurveyQuestionnaires/ProcessedData/"

########## Prep dataframe
# Import LimeSurvey data
dLS1 <- read.csv(paste0(Datapath, "ResultLS1.csv"), encoding="UTF-8")
