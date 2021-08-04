##### Pavlovia Day 1
# Initialization
source("VGS_Init.R")

Datapath = "Data/Pavlovia/RawDataGnG/"
Output_path = "Data/Pavlovia/ProcessedData/"

dQ <- read.delim("Data/LimeSurveyQuestionnaires/ProcessedData/dQuestionnaireTot.txt")
dPav1 <- read.delim(paste0(Output_path, "/dPav.txt"))

# Removal of (nearly) empty CSV
PSToRemove <- c(dir(Datapath, pattern = ".log.gz"),
                dir(Datapath, pattern = ".log"),
                dir(Datapath, pattern = ".psydat"),
                dir(Datapath, pattern = ".xlsx"),
                
                # Test
                "1_VideoGameExperimentOrderB_2020_Dec_21_1057.csv",
                "PARTICIPANT_VideoGameExperiment2_2021-08-02_15h23.25.110.csv"
                ) 


dt <- dir(Datapath)
ParticipantToKeep <- !(dt %in% PSToRemove)
PS <- dt[ParticipantToKeep]

dGnG <- data.frame()

Mail = c()
Compt = 1
i = "PARTICIPANT_VideoGameExperiment2_2021-06-15_09h40.01.735.csv"

for (i in PS) {
  d <- read.csv(paste0(Datapath, i), sep = ",")
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
  
  # Check task version
  TaskV <- 1
  if (!"Neutral" %in% dGnGt$Primer[1:120]){
    TaskV <- 2
    FirstTask <- "Gaming_Go"
  }
  if (!"Gaming" %in% dGnGt$Primer[1:120]){
    TaskV <- 2
    FirstTask <- "Neutral_Go"
  }
  
  # Get task type
  if (TaskV[1] == 1){
    if (length(dGnGt$CorrResp[dGnGt$CorrResp=="space"]) <= 120){
      dGnGt$TaskType <- "Gaming_NoGo"
    } else {
      dGnGt$TaskType <- "Gaming_Go"
    }
  }
  
  if (TaskV == 2){
    dGnGt$TaskType <- "Gaming_Go"
    dGnGt$TaskType[dGnGt$Primer=="Neutral"] <- "Neutral_Go"
  }
  
  # Final GnG frame
  dGnGt <- dGnGt%>%
    group_by(Email, TaskType, nTrial, TrialType, Primer)%>%
    summarise(Acc = mean(Accuracy, na.rm = T), RT = mean(RT, na.rm = T), .groups = 'drop')%>%
    unite("Trial", Primer:TrialType, sep = "_")%>%
    unite("Acc_RT", Acc:RT, sep = "_")%>%
    spread(key = Trial, value = Acc_RT)%>%
    separate(Gaming_Go, c("Acc_Gaming_Go", "RT_Gaming_Go"), sep = "_")%>%
    separate(Gaming_NoGo, c("Acc_Gaming_NoGo", "RT_Gaming_NoGo"), sep = "_")%>%
    separate(Neutral_Go, c("Acc_Neutral_Go", "RT_Neutral_Go"), sep = "_")%>%
    separate(Neutral_NoGo, c("Acc_Neutral_NoGo", "RT_Neutral_NoGo"), sep = "_")%>%
    select(Email, TaskType, nTrial,
           Acc_Gaming_Go, Acc_Gaming_NoGo, Acc_Neutral_Go, Acc_Neutral_NoGo,
           RT_Gaming_Go, RT_Gaming_NoGo, RT_Neutral_Go, RT_Neutral_NoGo)
  
  dGnGt$RT_Gaming_NoGo[dGnGt$RT_Gaming_NoGo == "NaN"] <- NA
  dGnGt$RT_Neutral_NoGo[dGnGt$RT_Neutral_NoGo == "NaN"] <- NA
  
  dGnGt <- AddDummyCol(dGnGt, c("TaskV"), TaskV)
  
  if (TaskV == 2){
    dGnGt$Acc_Gaming_Go[2] <- dGnGt$Acc_Gaming_Go[1]
    dGnGt$Acc_Gaming_NoGo[2] <- dGnGt$Acc_Gaming_NoGo[1]
    
    dGnGt$Acc_Neutral_Go[1] <- dGnGt$Acc_Neutral_Go[2]
    dGnGt$Acc_Neutral_NoGo[1] <- dGnGt$Acc_Neutral_NoGo[2]
    
    dGnGt$RT_Gaming_Go[2] <- dGnGt$RT_Gaming_Go[1]
    dGnGt$RT_Gaming_NoGo[2] <- dGnGt$RT_Gaming_NoGo[1]
    
    dGnGt$RT_Neutral_Go[1] <- dGnGt$RT_Neutral_Go[2]
    dGnGt$RT_Neutral_NoGo[1] <- dGnGt$RT_Neutral_NoGo[2]
    
    dGnGt <- dGnGt[1,]
    dGnGt$TaskType <- FirstTask
  }
  
  dGnG <- rbind(dGnG, dGnGt)
  
  print(Mail[Compt])
  
  ##### Update Compt
  Compt = Compt + 1
}

# dGnG <- filter(dGnG, nTrial == 240)
dGnG <- dGnG[ , -which(names(dGnG) == "nTrial")]

for (i in 1:length(dPav1$Email)){
  if (dPav1$Email[i] %in% dGnG$Email){
    dGnGtt <- filter(dGnG, Email == dPav1$Email[i])
    dPav1[i,2:11] <- dGnGtt[, 2:11]
    
    dGnG <- filter(dGnG, Email != dPav1$Email[i])
  }
}

# dPav <- cbind(dGnG[,-3], dDOT[dDOT$Email%in%dGnG$Email,3:6], dVal[dVal$Email %in% dGnG$Email, 3:4])


##### Write table
write.table(dPav1, paste0(Output_path, "dPav.txt"), col.names = T, row.names = F, sep = "\t", dec = ".")
# write.table(dMail1, "AdditionalInfo/MailList/dMailPav.txt", col.names = T, row.names = F, sep = "\t", dec = ".")