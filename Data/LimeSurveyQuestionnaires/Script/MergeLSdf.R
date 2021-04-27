##### Merge dLS
# Initialization
source("VGS_Init.R")
Datapath = "Data/LimeSurveyQuestionnaires/ProcessedData/"
Output_path = "Data/LimeSurveyQuestionnaires/ProcessedData/"

##### Import processed LS data
dLS1 <- read.delim(paste0(Datapath, "dLS1.txt"))
dLS2 <- read.delim(paste0(Datapath, "dLS2.txt"))

dLS1 <- AddDummyCol(dLS1, "Finished", 0)

for (i in dLS1$Mail1){
  if (i %in% dLS2$Mail2){
    dLS1$Finished[dLS1$Mail1 == i] = 1
  }
}

dLS1 <- filter(dLS1, Finished == 1)
dLS1 = dLS1[order(dLS1[,'Mail1']),]
dLS2 <- filter(dLS2, Mail2 %in% dLS1$Mail1)
dLS2 = dLS2[order(dLS2[,'Mail2']),]

dQ <- cbind(dLS1, dLS2[3:length(dLS2)])
dRecr <- dQ[c("Mail1", "Contactable", "Age", "Gender", "GAS")]

write.table(dQ, paste0(Output_path, "dQuestionnaireTot.txt"), sep = "\t", dec = ".", col.names = T, row.names = F)
write_xlsx(dQ, paste0(Output_path, "dQuestionnaireTot.xlsx"))
write_xlsx(dQ, "dRecrutement.xlsx")

