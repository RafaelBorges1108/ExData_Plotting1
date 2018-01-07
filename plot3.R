## Exploratory Data Analysis
## Course Project 01

## This assignment uses data from the UC Irvine Machine Learning Repository
## In particular, we will be using the Individual household electric power consumption Data Set
## The original dataset has 2,075,259 rows and 9 columns

## Loading packages
library(dplyr)
library(lubridate)

## Downloading the data for the project and creating the directory
if (!file.exists("./household_power_consumption/household_power_consumption.txt")){
      dir.create("./household_power_consumption")
      fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      download.file(fileUrl, "./household_power_consumption.zip", method = "curl")
      unzip("./household_power_consumption.zip")
}

## Reading the dataset file
dataset <- read.table("./household_power_consumption/household_power_consumption.txt", header = TRUE, 
                      sep = ";", stringsAsFactors = FALSE, dec = ".", na.strings = "?")

## checking dataset structure
dim(dataset)
str(dataset)

## Converting date and time columns classes and creating a full datetime column
dataset <- mutate(dataset, datetime = paste(dataset$Date, dataset$Time, sep = " "))
dataset$datetime <- dmy_hms(dataset$datetime)
dataset$Date <- dmy(dataset$Date)
dataset$Time <- hms(dataset$Time)

## Selecting dates 2007-02-01 and 2007-02-02
febdataset <- subset(dataset, Date == "2007-02-01" | Date == "2007-02-02")

## Eliminating regional differences
curr_locale <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME","C")

## Plot 3
png(filename = "plot3.png", width = 480, height = 480, units = "px")
with(febdataset, plot(datetime, Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = ""))
with(febdataset, points(datetime, Sub_metering_2, type = "l", ylab = "Energy sub metering", xlab = "",
                        col = "red"))
with(febdataset, points(datetime, Sub_metering_3, type = "l", ylab = "Energy sub metering", xlab = "",
                        col = "blue"))
legend("topright", lty = "solid", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()

## Setting back current locale
Sys.setlocale("LC_TIME",curr_locale)