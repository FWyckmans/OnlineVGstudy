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

# Main df
dLS2 <- dLS2%>%
  select(NS, Mail2 = ID01, "CoH.CoH01.":colnames(dLS2[length(dLS2)]))

# Remove duplicates
dLS2 = dLS2[order(dLS2[,'Mail2'],-dLS2[,'NS']),]
dLS2 = dLS2[!duplicated(dLS2$Mail2),]
dLS2 = dLS2[order(dLS2[,'NS']),]  

# Change badly spelled email if needed
for (i in c(1:length(dLS2$Mail2))) {
  if (dLS2$Mail2[i] %in% names(MailToChange)){
    dLS2$Mail2[i] <- MailToChange[[dLS2$Mail2[i]]]
  }
}

########## Columns handling
##### Test
dLS2 <- rename(dLS2, Test01 = UPPS.Test01., Test02 = PANAS.Test02.)

##### CoH
dCoH <- select(dLS2, NS, CoH.CoH01.:CoH.CoH27.)

for (i in colnames(dCoH[2:length(dCoH)])) {
  dCoH[,i] <- str_remove(dCoH[,i], "A")
  dCoH[,i] <- as.numeric(dCoH[,i])
  dCoH[,i] <- dCoH[,i]
}

dCoH <- dCoH%>%
  mutate(Auto = CoH.CoH03. + CoH.CoH05. + CoH.CoH09. + CoH.CoH11. + CoH.CoH16. +
           CoH.CoH19. + CoH.CoH23. + CoH.CoH25. + CoH.CoH26.,
         Routine = CoH.CoH01. + CoH.CoH02. + CoH.CoH04. + CoH.CoH06. + CoH.CoH07. +
           CoH.CoH10. + CoH.CoH12. + CoH.CoH14. + CoH.CoH15. + CoH.CoH18. + CoH.CoH20. + CoH.CoH22. + CoH.CoH27.)

##### UPPS
dUPPS <- select(dLS2, NS, UPPS.UPPS01.:UPPS.UPPS20.)

for (i in colnames(dUPPS[2:length(dUPPS)])) {
  dUPPS[,i] <- str_remove(dUPPS[,i], "U01")
  dUPPS[,i] <- as.numeric(dUPPS[,i])
}

dUPPS <- dUPPS%>%
  mutate(NegUr = 5-UPPS.UPPS04. + 5-UPPS.UPPS07. + 5-UPPS.UPPS12. + 5-UPPS.UPPS17.,
         PosUr = 5-UPPS.UPPS02. + 5-UPPS.UPPS10. + 5-UPPS.UPPS15. + 5-UPPS.UPPS20.,
         LoPr = UPPS.UPPS01. + UPPS.UPPS06. + UPPS.UPPS13. + UPPS.UPPS19.,
         LoPe = UPPS.UPPS05. + UPPS.UPPS08. + UPPS.UPPS11. + UPPS.UPPS16.,
         SS = 5-UPPS.UPPS03. + 5-UPPS.UPPS09. + 5-UPPS.UPPS14. + 5-UPPS.UPPS18.,
         UPPS = NegUr + PosUr + LoPr + LoPe + SS)

##### Beck
dBeck <- select(dLS2, NS, B1:B13)

for (i in colnames(dBeck[2:length(dBeck)])) {
  dBeck[,i] <- str_remove(dBeck[,i], "A")
  dBeck[,i] <- as.numeric(dBeck[,i])
  dBeck[,i] <- dBeck[,i] - 1
}

dBeck <- dBeck%>%
  mutate(BDI = B1 + B2 + B3 + B4 + B5 + B6 + B7 + B8 + B9 + B10 + B11 + B12 + B13)

##### PANAS
dPANAS <- select(dLS2, NS, PANAS.PANAS01.:PANAS.PANAS20.)

for (i in colnames(dPANAS[2:length(dPANAS)])) {
  dPANAS[,i] <- str_remove(dPANAS[,i], "A")
  dPANAS[,i] <- as.numeric(dPANAS[,i])
}

dPANAS <- dPANAS%>%
  mutate(PosAff = PANAS.PANAS01. + PANAS.PANAS03. + PANAS.PANAS05. + PANAS.PANAS09. + PANAS.PANAS10. +
           PANAS.PANAS12. + PANAS.PANAS14. + PANAS.PANAS16. + PANAS.PANAS17. + PANAS.PANAS19.,
         NegAff = PANAS.PANAS02. + PANAS.PANAS04. + PANAS.PANAS06. + PANAS.PANAS07. + PANAS.PANAS08. +
           PANAS.PANAS11. + PANAS.PANAS13. + PANAS.PANAS15. + PANAS.PANAS18. + PANAS.PANAS20.)

##### Internet Addiction Test
dIAT <- select(dLS2, NS, I1:I20)

for (i in colnames(dIAT[2:length(dIAT)])) {
  dIAT[,i] <- str_remove(dIAT[,i], "A")
  dIAT[,i] <- as.numeric(dIAT[,i])
  dIAT[,i] <- dIAT[,i]
}

dIAT <- mutate(dIAT, IAT = I1 + I2 + I3 + I4 + I5 + I6 + I7 + I8 + I9 + I10 +
                 I11 + I12 + I13 + I14 + I15 + I16 + I17 + I18 + I19 + I20)

##### Check if tests OK
dTest <- select(dLS2, NS, Test01, Test02)
dTest <- AddDummyCol(dTest, "TestQOK", 0)

dTest$Test01[dTest$Test01 != "U013"] <- 0
dTest$Test01[dTest$Test01 == "U013"] <- 1
dTest$Test01 <- as.numeric(dTest$Test01)

dTest$Test02[dTest$Test02 != "A2"] <- 0
dTest$Test02[dTest$Test02 == "A2"] <- 1
dTest$Test02 <- as.numeric(dTest$Test02)

dTest <- mutate(dTest, Testok = Test01 + Test02)
dTest$TestQOK[dTest$Testok == 2] <- 1

########## Final Frame
dF <- cbind(dLS2[c(1, 2)], dTest[c("TestQOK", "Test01", "Test02")],
            dIAT["IAT"], dCoH[c("Auto", "Routine")],
            dUPPS[c("UPPS", "NegUr", "PosUr", "LoPr", "LoPe", "SS")], dPANAS[c("PosAff", "NegAff")],
            dBeck["BDI"])

dMailLS2 <- select(dLS2, Mail2)

########## Export
write.table(dF, paste0(Output_path, "dLS2.txt"), col.names = T, row.names = F, sep = "\t", dec = ".")
write.table(dMailLS2, "AdditionalInfo/MailList/MailLS2.txt", col.names = T, row.names = F, sep = "\t", dec = ".")
