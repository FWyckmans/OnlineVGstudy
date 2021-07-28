##### Pavlovia Day 1
# Initialization
source("VGS_Init.R")

Datapath = "Data/Pavlovia/ProcessedData/"
Output_path = "Data/ProcessedData/"

dQ <- read.delim("Data/LimeSurveyQuestionnaires/ProcessedData/dQuestionnaireTot.txt")
dPav <- read.delim(paste0(Datapath, "dPav.txt"))

dQ <- AddDummyCol(dQ, colnames(dPav[2:length(dPav)]))

for (i in dQ$Mail1) {
  if (i %in% dPav$Email){
    for (n in colnames(dPav[2:length(dPav)])) {
      dQ[which(dQ$Mail1 == i), n] <- dPav[which(dPav$Email == i), n]
    }
  }
}

dMailTot <- dQ[2]
dTot <- dQ[, -which(names(dQ) %in% c("Mail1"))]

dTot <- dTot%>%
  mutate(deltaACCnogoNmG = Acc_Neutral_NoGo - Acc_Gaming_NoGo,
         deltaRTgoNmG = RT_Neutral_Go - RT_Gaming_Go,
         deltaEVANmG = EVA_Neutre - EVA_Gaming)

write.table(dTot, paste0(Output_path, "dTot.txt"), col.names = T, row.names = F, sep = "\t", dec = ".")
write_xlsx(dTot, paste0(Output_path, "dTot.xlsx"))
write.table(dMailTot, "AdditionalInfo/MailList/dMailTot.txt", col.names = T, row.names = F, sep = "\t", dec = ".")