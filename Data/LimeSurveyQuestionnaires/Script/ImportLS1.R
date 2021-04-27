# Initialization
source("VGS_Init.R")
Datapath = "Data/LimeSurveyQuestionnaires/RawData/"
Output_path = "Data/LimeSurveyQuestionnaires/ProcessedData/"

########## Prep dataframe
# Import LimeSurvey data
dLS1 <- read.csv(paste0(Datapath, "ResultLS1.csv"), encoding="UTF-8")

# Rename and select columns
colnames(dLS1)[1] <- "NS"
TestMail <- c("test", "test ", "Test", "TEST", "TEST ", "TEST 2", "TEST3", "test 3", "testbis",
              "rap@gmail.com", "jennifer.deville@ulb.be")

dLS1 <- dLS1 %>%
  filter(lastpage == 5)%>% # Remove unfinished
  filter(E2 == "A1")%>% # Remove not consenting
  filter(!E1 %in% TestMail)

# Create df for type of game
dType <- dLS1%>%
  select(NS, MMORPG = A3.A1., FPS = A3.A2., RPG = A3.A3., TPS = A3.A5., STR = A3.A6., Gest = A3.A7.,
         MOBA = A3.A8., Sport = A3.A10., PartyGame = A3.A9., Other = A3.A4.)
dType <- AddDummyCol(dType, "MainGame")

for (i in c(2:(length(dType)-1))) {
  dType[i][dType[i]=="A1"] <- 0
  dType[i][dType[i]=="A2"] <- 1
  dType[i][dType[i]=="A3"] <- 2
  dType[i][dType[i]=="A4"] <- 3
  dType[i][dType[i]=="A5"] <- 4
  dType[[i]] <- as.numeric(dType[[i]])
}

for (i in c(1:length(dType$MainGame))) {
  if (!is.na(dType$MMORPG[i])){
    maingamesCol = as.numeric(which.max(dType[i,c(2:(length(dType)-2))]))
    maingames = colnames(dType[maingamesCol+1])
    dType$MainGame[i] = maingames
  }
}

dLS1 <- cbind(dLS1, dType["MainGame"])

# Main df
dLS1 <- select(dLS1, NS, Mail1 = E1, Age = IP01, Gender = IP02, StudyLvl = IP03, Work = IP06, Contactable = IP04, DrugUse = IP05,
               GAS2:GAS7, OL:OLQ4, LastSession = A6, MainGame)#, Online = A5)

# Remove duplicates
dLS1 = dLS1[order(dLS1[,'Mail1'],-dLS1[,'NS']),]
dLS1 = dLS1[!duplicated(dLS1$Mail1),]
dLS1 = dLS1[order(dLS1[,'NS']),]

########## Columns handling
##### Demo
# Change badly encoded age

# Order
dLS1 <- AddDummyCol(dLS1, "Order", "A")
dLS1$Order[dLS1$Age%%2 == 1] <- "B"

# Gender
dLS1$Gender[dLS1$Gender == "A1"] <- "Male"
dLS1$Gender[dLS1$Gender == "A2"] <- "Female"
dLS1$Gender[dLS1$Gender == "A3"] <- "Other"

dLS1$Gender <- factor(dLS1$Gender, ordered = F)

# StudyLevel
dLS1$StudyLvl[dLS1$StudyLvl == "A1"] <- 0
dLS1$StudyLvl[dLS1$StudyLvl == "A2"] <- 6
dLS1$StudyLvl[dLS1$StudyLvl == "A3"] <- 9
dLS1$StudyLvl[dLS1$StudyLvl == "A4"] <- 12
dLS1$StudyLvl[dLS1$StudyLvl == "A5"] <- 15
dLS1$StudyLvl[dLS1$StudyLvl == "A6"] <- 17
dLS1$StudyLvl[dLS1$StudyLvl == "A7"] <- 21

dLS1$StudyLvl <- as.numeric(dLS1$StudyLvl)

# Work
dLS1$Work[dLS1$Work == 1] <- "Student"
dLS1$Work[dLS1$Work == 2] <- "Workman"
dLS1$Work[dLS1$Work == 3] <- "Employee"
dLS1$Work[dLS1$Work == 4] <- "Executive"
dLS1$Work[dLS1$Work == 5] <- "Independent"
dLS1$Work[dLS1$Work == 6] <- "Unemployed"
dLS1$Work[dLS1$Work == 7] <- "Retirement"
dLS1$Work[dLS1$Work == 8] <- "Other"

dLS1$Work <- factor(dLS1$Work, ordered = F)

# Contactable
dLS1$Contactable[dLS1$Contactable == "A1"] <- "Yes"
dLS1$Contactable[dLS1$Contactable == "A2"] <- "No"

dLS1$Contactable <- factor(dLS1$Contactable, ordered = F)

# DrugUse
dLS1$DrugUse[dLS1$DrugUse == "A1"] <- "Yes"
dLS1$DrugUse[dLS1$DrugUse == "A2"] <- "No"

dLS1$DrugUse <- factor(dLS1$DrugUse, ordered = F)

##### Video-Game
# Online
dLS1$OL[dLS1$OL == "OL1"] <- "Online"
dLS1$OL[dLS1$OL == "OL2"] <- "Offline"
dLS1$OL[dLS1$OL == "OL3"] <- "Both"
dLS1$OL[dLS1$OL == ""] <- NA

dLS1$OL <- factor(dLS1$OL, ordered = F)

# GAS
for (i in grep("GAS", colnames(dLS1))){
  dLS1[,i] <- str_remove(dLS1[,i], "A")
  dLS1[,i] <- as.numeric(dLS1[,i])
  # dLS1[,i] <- dLS1[,i] -1
  dLS1[,i] <- ifelse(dLS1[,i] >= 3, 1, 0)
}

dLS1 <- mutate(dLS1, GAS = GAS1 + GAS2 + GAS3 + GAS4 + GAS5 + GAS6 + GAS7)
dLS1 <- AddDummyCol(dLS1, "Grp", Val = "HC")
dLS1$Grp[dLS1$GAS >= 4] <- "PG"

# MPOG
dMPOG <- select(dLS1, NS, OLQ1.OLQ1.:OLQ4)

for (i in grep("OLQ", colnames(dMPOG))){
  dMPOG[,i] <- str_remove(dMPOG[,i], "OLQ1")
  dMPOG[,i] <- str_remove(dMPOG[,i], "OLQ2")
  dMPOG[,i] <- str_remove(dMPOG[,i], "OLQ3")
  dMPOG[,i] <- str_remove(dMPOG[,i], "OLQ4")
  dMPOG[,i] <- as.numeric(dMPOG[,i])
}

dMPOG <- dMPOG%>%
  mutate(Advancement = OLQ1.OLQ1. + OLQ1.OLQ2. + OLQ1.OLQ3. + OLQ1.OLQ4. + OLQ1.OLQ5. + OLQ1.OLQ6.,
         Mechanics = OLQ2.OLQ7. + OLQ1.OLQ8. + OLQ3.OLQ9. + OLQ1.OLQ10.,
         Competition = OLQ2.OLQ11. + OLQ3.OLQ12. + OLQ2.OLQ13. + OLQ2.OLQ14.,
         Socializing = OLQ2.OLQ15. + OLQ2.OLQ16. + OLQ2.OLQ17. + OLQ2.OLQ18.,
         Relationship = OLQ3.OLQ19. + OLQ3.OLQ20. + OLQ3.OLQ21.,
         Teamwork = 6 - OLQ4 + 6 - OLQ1.OLQ23. + OLQ2.OLQ24. + 6 - OLQ1.OLQ25.,
         Discovery = OLQ2.OLQ26. + OLQ2.OLQ27. + OLQ2.OLQ28. + OLQ2.OLQ29.,
         Roleplaying = OLQ2.OLQ30. + OLQ2.OLQ31. + OLQ3.OLQ32. + OLQ3.OLQ33.,
         Customization = OLQ2.OLQ34. + OLQ1.OLQ35. + OLQ1.OLQ36.,
         Escapism = OLQ3.OLQ37. + OLQ3.OLQ38. + OLQ1.OLQ39.)

##### Final dataframe
dF <- select(dLS1, NS, Mail1, Grp, Order, Age, Gender, StudyLvl, Work, Contactable, DrugUse, GAS, OL, MainGame, LastSession)
dF <- cbind(dF, dMPOG[41:length(dMPOG)])
dMailLS1 <- select(dLS1, Mail1)
dAge <- dLS1[, c(1, 2, 3)]

# Export
write.table(dF, paste0(Output_path, "dLS1.txt"), col.names = T, row.names = F, sep = "\t", dec = ".")
write.table(dMailLS1, "AdditionalInfo/MailList/MailLS1.txt", col.names = T, row.names = F, sep = "\t", dec = ".")
write.table(dAge, "AdditionalInfo/MailList/AgeLS1.txt", col.names = T, row.names = F, sep = "\t", dec = ".")
