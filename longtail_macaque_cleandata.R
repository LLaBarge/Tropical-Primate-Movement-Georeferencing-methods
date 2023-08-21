# script for importing and exploratory analysis of long-tailed macaque
#data collected at Ketambe, Sumatra between 1976 - 1989
# contains data on House, Ketambe, Atas, Bawah, Timour, Amnatara groups

library(readr)
LT_data_combined <- read_csv("LT_data_combined.csv")
head(LT_data_combined)

# time column is missing ":" 
LT_data_combined$Time_new<- parse_time(LT_data_combined$Time, "%H%M")

# combine day month year and time into a single timestamp 