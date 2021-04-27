# Initialization
source("VGS_Init.R")
Datapath = "Data/LimeSurveyQuestionnaires/RawData/"
Output_path = "Data/LimeSurveyQuestionnaires/ProcessedData/"

########## Prep dataframe
# Import LimeSurvey data
dLS2 <- read.csv(paste0(Datapath, "ResultLS2.csv"), encoding="UTF-8")

# Rename and select columns
colnames(dLS2)[1] <- "NS"
TestMail <- c("test", "test ", "Test", "TEST", "TEST ", "TEST 2", "TEST3", "test 3", "testbis",
              "rap@gmail.com", "jennifer.deville@ulb.be")

dLS2 <- dLS2 %>%
  filter(lastpage == 7)%>% # Remove unfinished
  filter(!ID01 %in% TestMail)
