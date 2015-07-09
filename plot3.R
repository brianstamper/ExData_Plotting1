### Reading and tidying the data
# Note that this section is identical for all four plots.
# It assumes that household_power_consumption.txt is in the working directory
# and that the packages dplyr and lubridate are installed.

# We will use dplyr to work with our data frame and lubridate to parse dates
library(dplyr)
library(lubridate)
# Read in the data to a tbl_df
powdata <- tbl_df(read.table("household_power_consumption.txt", header = TRUE, 
                      sep = ";", na.strings = "?", nrows = 2075260, 
                      colClasses = c("character", "character", "numeric", 
                                     "numeric", "numeric", "numeric", 
                                     "numeric", "numeric", "numeric")))

# Only interested in February 1 & 2, 2007. Date is in %d/%m/%Y format, we want to 
# convert that and combine it with time, which is in hh:mm:ss format.
# The following takes the whole data set, filters for the data, then creates a 
# combined POSIXct date and time.
pow2days <- powdata %>%
  filter(Date == "1/2/2007" | Date == "2/2/2007") %>%
  mutate(datetime = dmy_hms(paste(Date, Time)))

# We can get rid of the bigger data set now
rm("powdata")

### Creating the plot image
png("plot3.png", 480, 480)
plot(Sub_metering_1 ~ datetime, data = pow2days, type = "l",
     xlab = "", ylab = "Energy sub metering")
lines(Sub_metering_2 ~ datetime, data = pow2days, col = "red")
lines(Sub_metering_3 ~ datetime, data = pow2days, col = "blue")
legend("topright", col=c("black", "red", "blue"), lty=c(1, 1, 1),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()