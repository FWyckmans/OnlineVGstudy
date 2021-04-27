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
                "PARTICIPANT_VideoGameExperiment_2021-02-22_22h45.44.782.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-23_19h27.58.213.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-23_20h32.32.797.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-23_20h47.33.302.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-23_21h00.52.858.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-23_21h06.37.193.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-24_11h01.47.124.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-25_16h15.24.885.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-27_17h58.24.696.csv",
                "PARTICIPANT_VideoGameExperiment_2021-02-27_18h01.34.950.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-01_22h27.56.945.csv",
                "PARTICIPANT_VideoGameExperiment_2021-03-09_10h54.26.322.csv",
                
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
                "PARTICIPANT_VideoGameExperiment_2021-03-31_12h38.02.119.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-01_20h35.00.286.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-05_20h01.16.707.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-13_19h10.10.228.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-13_19h10.11.623.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-15_14h30.38.643.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-15_14h30.40.880.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-15_17h19.29.428.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-15_17h19.40.016.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-15_17h20.08.832.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-15_17h20.35.278.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-15_17h21.10.287.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-15_17h21.37.356.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-15_17h35.22.782.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-15_17h35.28.016.csv",
                "PARTICIPANT_VideoGameExperiment_2021-04-15_18h36.51.760.csv",
                
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
                "PARTICIPANT_VideoGameExperimentOrderB_2021-03-29_12h46.01.784.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-04-07_18h37.06.773.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-04-07_18h38.22.856.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-04-07_18h40.38.761.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-04-15_19h34.24.755.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-04-15_19h36.21.972.csv",
                "PARTICIPANT_VideoGameExperimentOrderB_2021-04-15_19h37.46.565.csv")

dt <- dir(Datapath)
ParticipantToKeep <- !(dt %in% PSToRemove)
PS <- dt[ParticipantToKeep]

dTot <- data.frame()
Mail = c()
Compt = 1

for (i in PS) {
  d <- read.csv(paste0(Datapath, i))
  Mail[Compt] <- d$Email[1]
  order <- d$expName[1]
  
  # Change email if needed
  if (d$Email[1] %in% names(MailToChange)){
    d$Email[1] <- MailToChange[[d$Email[1]]]
    Mail[Compt] <- d$Email[1]
  }
  
  dTot <- rbind(dTot, d)
  Compt = Compt + 1
}


dMail1 = data.frame(Mail)
i