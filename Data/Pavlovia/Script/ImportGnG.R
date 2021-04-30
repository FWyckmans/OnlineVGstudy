##### Pavlovia Day 1
# Initialization
source("VGS_Init.R")

Datapath = "Data/Pavlovia/RawDataGnG/"
Output_path = "Data/Pavlovia/ProcessedData/"

dQ <- read.delim("Data/LimeSurveyQuestionnaires/ProcessedData/dQuestionnaireTot.txt")

# Removal of (nearly) empty CSV
PSToRemove <- c(dir(Datapath, pattern = ".log.gz"),
                dir(Datapath, pattern = ".log"),
                dir(Datapath, pattern = ".psydat"),
                dir(Datapath, pattern = ".xlsx"),
                
                # Test
                "1_VideoGameExperimentOrderB_2020_Dec_21_1057.csv"
                ) 


dt <- dir(Datapath)
ParticipantToKeep <- !(dt %in% PSToRemove)
PS <- dt[ParticipantToKeep]

dGnG <- data.frame()

Mail = c()
Compt = 1
i = "PARTICIPANT_VideoGameExperiment2_2021-04-30_11h52.47.053.csv"

for (i in PS) {
  d <- read.csv(paste0(Datapath, i), sep = ";")
  Mail[Compt] <- d$Email[1]
  ExpName <- d$expName[1]
  
  
  # TaskAttr <- d$TaskAttr[1]
  
  # Change email if needed
  if (d$Email[1] %in% names(MailToChange)){
    d$Email[1] <- MailToChange[[d$Email[1]]]
    Mail[Compt] <- d$Email[1]
  }
  
  ##### GoNoGo
  # Get GnG df
  dGnGt <- d%>%
    select(Email, expName,
           Trial = GNG_Task.thisTrialN, SOA,
           ScrColor, Primer, Resp = KResp.keys, CorrResp = Correct, RT = KResp.rt)
  
  # Change email to match LS
  dGnGt$Email <- Mail[Compt]
  
  # Remove useless rows (like training)
  dGnGt <- dGnGt[complete.cases(dGnGt$Trial),]
  
  # Start trial N with 1
  dGnGt$Trial <- dGnGt$Trial + 1
  
  # Change Primer name
  dGnGt$Primer[grep("Alcool", dGnGt$Primer)] <- "Gaming"
  dGnGt$Primer[grep("eutre", dGnGt$Primer)] <- "Neutral"
  
  # Compute nTrial, Accuracy, TrialType and TaskType
  dGnGt <- AddDummyCol(dGnGt, c("nTrial", "Accuracy", "TrialType", "TaskType"))
  
  dGnGt$nTrial <- length(dGnGt$Trial)
  dGnGt$Accuracy[dGnGt$Resp == dGnGt$CorrResp] <- 1
  dGnGt$Accuracy[dGnGt$Resp != dGnGt$CorrResp] <- 0
  
  dGnGt$TrialType[dGnGt$ScrColor == "Blue"] <- "NoGo"
  dGnGt$TrialType[dGnGt$ScrColor == "Green"] <- "Go"
  
  # if (length(dGnGt$CorrResp[dGnGt$CorrResp=="space"]) <= 120){
  #   dGnGt$TaskType <- "Gaming_NoGo"
  # } else {
  #   dGnGt$TaskType <- "Gaming_Go"
  # }
  
  dGnGt$TaskType[dGnGt$Primer == "Gaming"] <- "VG_Go"
  dGnGt$TaskType[dGnGt$Primer == "Neutral"] <- "Ne_Go"
  
  # Final GnG frame
  dGnGt <- dGnGt%>%
    group_by(Email, TaskType, nTrial, TrialType)%>%
    summarise(Acc = mean(Accuracy, na.rm = T), RT = mean(RT, na.rm = T), .groups = 'drop')%>%
    unite("Trial", TaskType, TrialType, sep = "_")%>%
    unite("Acc_RT", Acc:RT, sep = "_")%>%
    spread(key = Trial, value = Acc_RT)%>%
    separate(VG_Go_Go, c("Acc_Gaming_Go", "RT_Gaming_Go"), sep = "_")%>%
    separate(VG_Go_NoGo, c("Acc_Gaming_NoGo", "RT_Gaming_NoGo"), sep = "_")%>%
    separate(Ne_Go_Go, c("Acc_Neutral_Go", "RT_Neutral_Go"), sep = "_")%>%
    separate(Ne_Go_NoGo, c("Acc_Neutral_NoGo", "RT_Neutral_NoGo"), sep = "_")%>%
    select(Email, nTrial,
           Acc_Gaming_Go, Acc_Gaming_NoGo, Acc_Neutral_Go, Acc_Neutral_NoGo,
           RT_Gaming_Go, RT_Gaming_NoGo, RT_Neutral_Go, RT_Neutral_NoGo)
  
  dGnGt$RT_Gaming_NoGo[dGnGt$RT_Gaming_NoGo == "NaN"] <- NA
  dGnGt$RT_Neutral_NoGo[dGnGt$RT_Neutral_NoGo == "NaN"] <- NA
  
  dGnG <- rbind(dGnG, dGnGt)
  
  print(Mail[Compt])
  
  ##### Update Compt
  Compt = Compt + 1
}

# dGnG <- filter(dGnG, nTrial == 240)

dMail1 <- data.frame(Mail)

# dPav <- cbind(dGnG[,-3], dDOT[dDOT$Email%in%dGnG$Email,3:6], dVal[dVal$Email %in% dGnG$Email, 3:4])


##### Write table
# write.table(dPav, paste0(Output_path, "dPav.txt"), col.names = T, row.names = F, sep = "\t", dec = ".")
# write.table(dMail1, "AdditionalInfo/MailList/dMailPav.txt", col.names = T, row.names = F, sep = "\t", dec = ".")