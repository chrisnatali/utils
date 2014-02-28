lhibrary(plyr)
library(lubridate)

base_day_file <- "~/ug01_07_09_2013_full_clean"
site_day_file <- "~/ug01_07_09_2013_full_site"
base_month_file <- "~/ug01_07_2013_full_clean"
site_month_file <- "~/ug01_07_2013_full_site"

units_from_ts <- function(ts_vec, unit_spec="%H") {
  as.numeric(format(ymd_hms(ts_vec), unit_spec))
}

agg_shasol_series <- function(df, quoted_group) {
  ddply(df, quoted_group, summarize, sum_wh_delta=sum(watt_hours_delta), avg_w=mean(watts))
}

# handle daily file (aggregate by day)
df_day <- read.csv(sprintf("%s.csv", base_day_file))
df_day$hour <- units_from_ts(df_day$time_stamp)
df_day_hourly_agg <- agg_shasol_series(df_day, .(ip_addr, hour))
write.csv(df_day_agg, row.names=FALSE, sprintf("%s_agg.csv", base_day_file))

# plot customers for daily file
ggplot(df_day_hourly_agg, aes(x=hour,y=sum_wh_delta)) + 
  geom_area(aes(color=ip_addr,fill=ip_addr), position="stack") +
  xlab("Hour of Day") + ylab("Watts") + # Set axis labels
  ggtitle("Uganda Site UG01") +     # Set title
  theme_bw() + 
  theme(legend.position="none")

# handle site daily file 
df_site_day <- read.csv(sprintf("%s.csv", site_day_file))
df_site_day$hour <- units_from_ts(df_site_day$time_stamp)
df_site_day$minute <- units_from_ts(df_site_day$time_stamp, "%M")
df_site_day_hourly_agg <- agg_shasol_series(df_site_day, .(hour))
df_site_day_hourly_agg$minute <- 30
df_site_day_hourly_agg$hour_watts <- df_site_day_hourly_agg$sum_wh_delta
df_site_day_hourly_agg$minute_of_day <- with(df_site_day_hourly_agg, (hour * 60) + minute)
df_site_day_minutely_agg <- agg_shasol_series(df_site_day, .(hour, minute))

# now multiply the minutely sum_wh_delta by 60 so we can compare minutely
# to hourly units
df_site_day_minutely_agg$minute_watts <- df_site_day_minutely_agg$sum_wh_delta * 60

# prep for graphing
df_site_day_hr_min_agg <- join(df_site_day_minutely_agg, df_site_day_hourly_agg, by=c("hour", "minute"), type="full")
df_site_day_hr_min_agg$minute_of_day <- with(df_site_day_hr_min_agg, (hour * 60) + minute)

breaks <- unique(with(df_site_day_hourly_agg, minute_of_day))
labels <- unique(with(df_site_day_hourly_agg, hour))

ggplot(df_site_day_hr_min_agg) + 
  xlab("Hour of Day") + ylab("Watts") + # Set axis labels
  ggtitle("Uganda Site UG01 (1 Day)") +     # Set title
  theme_bw() +
  theme(axis.text.x=element_text(size=6)) + 
  geom_line(aes(x=minute_of_day,y=minute_watts, group=1)) + 
  geom_line(data=df_site_day_hr_min_agg[!is.na(df_site_day_hr_min_agg$hour_watts),],aes(x=minute_of_day,y=hour_watts, group=1), color="red") + 
  scale_x_discrete(breaks=breaks, labels=labels)

# circuit based handle month file
df_month <- read.csv(sprintf("%s.csv", base_month_file))
df_month$day <- units_from_ts(df_month$time_stamp, "%d")
df_month_agg <- agg_shasol_series(df_month, .(ip_addr, day))
df_month_agg$day_watts <- (df_month_agg$sum_wh_delta / 24.0)
# write.csv(df_month_agg, row.names=FALSE, sprintf("%s_agg.csv", base_month_file))
# area graph
ggplot(df_month_agg, aes(x=day,y=day_watts)) + 
  geom_area(aes(color=ip_addr,fill=ip_addr), position="stack") + 
  xlab("Day of Month") + ylab("Watts") + # Set axis labels
  ggtitle("Uganda Site UG01 (1 Month)") +     # Set title
  theme_bw() +
  theme(legend.position="none")


# site based month file 
df_site_month <- read.csv(sprintf("%s.csv", site_month_file))
df_site_month$hour <- units_from_ts(df_site_month$time_stamp)
df_site_month$day <- units_from_ts(df_site_month$time_stamp, "%d")
# daily average watts
df_site_month_daily_agg <- agg_shasol_series(df_site_month, .(day))
df_site_month_daily_agg$hour <- 11
df_site_month_daily_agg$day_watts <- (df_site_month_daily_agg$sum_wh_delta / 24.0)
df_site_month_daily_agg$hour_of_month <- with(df_site_month_daily_agg, (day * 24) + hour)
# hourly average watts
df_site_month_hourly_agg <- agg_shasol_series(df_site_month, .(day, hour))
df_site_month_hourly_agg$hour_watts <- df_site_month_hourly_agg$sum_wh_delta

# prep for graphing
df_site_month_day_hr_agg <- join(df_site_month_daily_agg, df_site_month_hourly_agg, by=c("day", "hour"), type="full")
df_site_month_day_hr_agg$hour_of_month <- with(df_site_month_day_hr_agg, (day * 24) + hour)

breaks <- unique(with(df_site_month_daily_agg, hour_of_month))
labels <- unique(with(df_site_month_daily_agg, day))

ggplot(df_site_month_day_hr_agg) + 
  xlab("Day of Month") + ylab("Watts") + # Set axis labels
  ggtitle("Uganda Site UG01 (1 Month)") +     # Set title
  theme_bw() +
  theme(axis.text.x=element_text(size=6)) + 
  geom_line(aes(x=hour_of_month,y=hour_watts, group=1)) + 
  geom_line(data=df_site_month_day_hr_agg[!is.na(df_site_month_day_hr_agg$day_watts),],aes(x=hour_of_month,y=day_watts, group=1), color="red") + 
  scale_x_discrete(breaks=breaks, labels=labels)


