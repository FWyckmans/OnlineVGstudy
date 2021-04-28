##### Pavlovia Day 1
# Initialization
source("VGS_Init.R")

Datapath = "Data/Pavlovia/RawData/"
Output_path = "Data/Pavlovia/ProcessedData/"

dQ <- read.delim("Data/LimeSurveyQuestionnaires/ProcessedData/dQuestionnaireTot.txt")

# Removal of (nearly) empty CSV
PSToRemove <- c(dir(Datapath, pattern = ".log.gz"),
                dir(Datapath, pattern = ".log"),
                dir(Datapath, pattern = ".psydat"),
                dir(Datapath, pattern = ".xlsx"),
                
                # Test
                "1_VideoGameExperimentOrderB_2020_Dec_21_1057.csv",
                "_VideoGameExperiment_2021_Jan_04_1434.csv",
                "PARTICIPANT_VideoGameExperiment_2020-12-23_09h12.39.530.csv",
                "PARTICIPANT_VideoGameExperiment_2020-12-30_11h52.14.257.csv",
                "PARTICIPANT_VideoGameExperiment_2021-01-04_17h36.00.501.csv",
                "PARTICIPANT_VideoGameExperiment_2021-01-28_18h01.13.418.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-08_12h51.02.431.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-15_15h46.44.696.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-16_16h33.20.329.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-16_18h34.01.832.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-17_00h06.47.703.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-17_14h51.53.609.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-17_15h59.24.075.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-17_20h23.01.088.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-17_21h12.21.997.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-18_19h22.10.073.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-08_16h00.43.231.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-26_13h08.19.643.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-26_13h08.29.398.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-26_13h08.33.207.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-26_16h52.37.748.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-26_18h25.23.278.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-26_22h08.32.472.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-27_14h32.05.765.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-27_14h34.29.280.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-27_14h34.40.829.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-27_14h34.54.467.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-27_14h35.09.123.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-27_15h10.54.196.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-28_15h18.07.554.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-28_17h43.53.362.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-29_15h51.55.419.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-30_21h07.38.269.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-05_20h01.16.707.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-13_19h10.10.228.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-13_19h10.11.623.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-15_14h30.38.643.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-15_14h30.40.880.csv",

                
                # Empty df
                "PARTICIPANT_VideoGameExperiment_2020-12-21_12h24.29.717.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-09_22h32.37.987.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-22_21h37.41.535.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-23_00h07.09.838.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-25_16h41.34.326.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-01_23h17.47.548.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-01_23h20.19.426.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-01_23h20.26.498.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-01_23h25.00.418.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-02_18h18.34.068.csv",

                
                # Order B
                "PARTICIPANT_VideoGameExperiment_OrderB_2021-02-16_13h28.15.296.csv",
                "PARTICIPANT_VideoGameExperiment_OrderB_2021-03-26_13h43.12.091.csv",
                "PARTICIPANT_VideoGameExperiment_OrderB_2021-03-26_16h22.36.979.csv",
                "PARTICIPANT_VideoGameExperiment_OrderB_2021-03-26_16h37.35.385.csv",
                "PARTICIPANT_VideoGameExperiment_OrderB_2021-03-27_22h19.02.573.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2020-12-21_12h27.33.178.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-02-16_14h48.27.438.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-03-09_19h53.32.246.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-03-09_19h57.23.913.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-03-09_19h59.37.636.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-03-09_20h00.57.604.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-03-25_17h26.41.670.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-03-25_17h30.05.009.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-03-25_17h31.17.711.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-03-26_14h29.01.956.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-03-27_10h10.22.703.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-03-28_19h09.34.770.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-03-28_21h10.02.166.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-03-29_12h46.01.784.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-04-04_17h33.57.131.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-04-07_18h37.06.773.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-04-07_18h38.22.856.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-04-07_18h40.38.761.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-04-15_19h34.24.755.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-04-15_19h36.21.972.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-04-15_19h37.46.565.csv",
                
                # Not finished
                "PARTICIPANT_VideoGameExperiment_2021-03-26_12h56.53.257.csv", #Vulcana
                "PARTICIPANT_VideoGameExperiment_2021-03-26_15h12.03.438.csv", # Saboye
                "PARTICIPANT_VideoGameExperiment_2021-03-26_14h41.07.597.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-30_10h32.19.713.csv", # Courbet
                "PARTICIPANT_VideoGameExperiment_2021-03-31_12h20.36.207.csv" # Begnis
                ) 


dt <- dir(Datapath)
ParticipantToKeep <- !(dt %in% PSToRemove)
PS <- dt[ParticipantToKeep]

dGnG <- data.frame()
dDOT <- data.frame()
dVal <- data.frame()
Mail = c()
Compt = 1
# i = PS[1]
i = "PARTICIPANT_VideoGameExperiment_2021-04-15_15h42.00.134.csv"

for (i in PS) {
  d <- read.csv(paste0(Datapath, i))
  Mail[Compt] <- d$Email[1]
  order <- d$expName[1]
  TaskAttr <- d$TaskAttr[1]
  
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

  if (length(dGnGt$CorrResp[dGnGt$CorrResp=="space"]) <= 120){
    dGnGt$TaskType <- "Gaming_NoGo"
  } else {
    dGnGt$TaskType <- "Gaming_Go"
  }

  # Final GnG frame
  dGnGt <- dGnGt%>%
    group_by(Email, TaskType, nTrial, TrialType)%>%
    summarise(Acc = mean(Accuracy, na.rm = T), RT = mean(RT, na.rm = T), .groups = 'drop')%>%
    unite("Acc_RT", Acc:RT, sep = "_")%>%
    spread(key = TrialType, value = Acc_RT)%>%
    separate(Go, c("Acc_Go", "RT_Go"), sep = "_")%>%
    separate(NoGo, c("Acc_NoGo", "RT_NoGo"), sep = "_")%>%
    select(Email, TaskType, nTrial, Acc_Go, Acc_NoGo, RT_Go, RT_NoGo)

  dGnGt$RT_NoGo[dGnGt$RT_NoGo == "NaN"] <- NA

  dGnG <- rbind(dGnG, dGnGt)
  
  ##### DOT probe
  dDOTt <- d%>%
    select(Email, expName,
           Trial = DOT_Task.thisN,
           TypeL, TypeR, DotPosition, Type, Resp = DOT_KResp.keys, CorrResp = RespCorr, RT = DOT_KResp.rt)


  # Change email to match LS
  dDOTt$Email <- Mail[Compt]

  # Remove useless rows (like training)
  dDOTt <- dDOTt[complete.cases(dDOTt$Trial),]

  # Start trial N with 1
  dDOTt$Trial <- dDOTt$Trial + 1

  # Change dot position to reflect the stimulus it is on
  dDOTt$DotPosition[dDOTt$DotPosition == "Left"] <- dDOTt$TypeL[dDOTt$DotPosition == "Left"]
  dDOTt$DotPosition[dDOTt$DotPosition == "Right"] <- dDOTt$TypeR[dDOTt$DotPosition == "Right"]
  dDOTt$DotPosition[dDOTt$DotPosition == "JV"] <- "Gaming"
  dDOTt$DotPosition[dDOTt$DotPosition == "Neutre"] <- "Neutral"

  # Compute nTrial, Accuracy
  dDOTt <- AddDummyCol(dDOTt, c("nTrial", "Accuracy"))

  dDOTt$nTrial <- length(dDOTt$Trial)

  dDOTt$Accuracy[dDOTt$Resp == dDOTt$CorrResp] <- 1
  dDOTt$Accuracy[dDOTt$Resp != dDOTt$CorrResp] <- 0

  # Final DOT frame
  dDOTt <- dDOTt%>%
    group_by(Email, DotPosition, nTrial)%>%
    summarise(Acc = mean(Accuracy, na.rm = T), RT = mean(RT, na.rm = T), .groups = 'drop')%>%
    unite("Acc_RT", Acc:RT, sep = "_")%>%
    spread(key = DotPosition, value = Acc_RT)%>%
    separate(Gaming, c("Acc_Congr", "RT_Congr"), sep = "_")%>%
    separate(Neutral, c("Acc_Incongr", "RT_Incongr"), sep = "_")%>%
    select(Email, nTrial, Acc_Congr, Acc_Incongr, RT_Congr, RT_Incongr)

  dDOT <- rbind(dDOT, dDOTt)
  
  ##### Valence Task
  dVALt <- d%>%
    select(Email, expName,
           Trial = Val_Task.thisN,
           Type, Eva = Val_Slider.response)
  
  dVALt <- dVALt[complete.cases(dVALt$Trial),]
  dVALt$Trial <- dVALt$Trial + 1
  
  # Compute nTrial
  dVALt <- AddDummyCol(dVALt, "nTrial")
  dVALt$nTrial <- max(dVALt$Trial)
  
  # Final Valence Frame
  dVALt <- dVALt%>%
    group_by(Email, Type, nTrial)%>%
    summarise(EVA = mean(Eva), .groups = 'drop')%>%
    spread(key = Type, value = EVA)%>%
    select(Email, nTrial, EVA_Gaming = JV, EVA_Neutre = Neutre)
  
  dVal <- rbind(dVal, dVALt)

  print(Mail[Compt])
  ##### Update Compt
  Compt = Compt + 1
}

dGnG <- filter(dGnG, nTrial == 240)
dDOT <- filter(dDOT, nTrial == 96)
dVal <- filter(dVal, nTrial == 24)
dMail1 = data.frame(Mail)

dPav <- cbind(dGnG, dDOT[dDOT$Email%in%dGnG$Email,3:6], dVal[dVal$Email %in% dGnG$Email, 3:4])


##### Write table
write.table(dPav, paste0(Output_path, "dPav.txt"), col.names = T, row.names = F, sep = "\t", dec = ".")