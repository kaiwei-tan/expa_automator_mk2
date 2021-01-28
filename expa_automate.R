library(tidyverse)
library(ggthemes)
library(rvest)
library(jsonlite)
library(lubridate)
library(purrr)

dev.token <- "TOKEN" # INSERT YOUR TOKEN HERE

date.from <- '2018-01-01' %>% as.Date() # yyyy-mm-dd
date.to <- '2018-12-31' %>% as.Date() # yyyy-mm-dd
per.page <- 500 # assume max of 500 new sign-ups per day

dates_between <- function(date_from, date_to) {
  list <- as.list(date_to - 0 : (as.integer(date_to) - as.integer(date_from)))
  return(list)
}

get_expa_data <- function(date_from, date_to) {
  # query URL
  query <- paste("https://gis-api.aiesec.org/v2/people?access_token=", dev.token,
                 "&per_page=", as.character(per.page),
                 "&filters[registered]%5Bfrom%5D=", date_from,
                 "&filters[registered]%5Bto%5D=", date_to,
                 "&filters[is_aiesecer]=false",
                 sep='')
  
  # get data from API using query URL
  data_raw <- fromJSON(query)$data
  
  # data cleaning: LC names
  lc_names <- data_raw$home_lc$name %>% gsub(' Singapore', '' , .)
  
  # create data with just the relevant info
  data <- data.frame(id = data_raw$id,
                     url = data_raw$url,
                     status = data_raw$status,
                     first_name = data_raw$first_name,
                     last_name = data_raw$last_name,
                     dob = data_raw$dob,
                     home_lc = lc_names,
                     email = data_raw$email,
                     phone = data_raw$phone,
                     cv_url = data_raw$cv_url,
                     created = data_raw$created_at %>% gsub('T.*', '' , .) %>% as.Date(format='%Y-%m-%d'),
                     stringsAsFactors = FALSE
  )
  
  cat(paste(date_to," "))
  return(data)
}

dates.between <- dates_between(date.from, date.to)
data <- map2(dates.between, dates.between, get_expa_data) %>% reduce(rbind)

#write.csv(data.all, "ep_data.csv")

lc_names <- data$home_lc$name %>% gsub(' Singapore', '' , .)

manager_names <- vector(length=nrow(data))
for (i in 1:nrow(data)) {
  if (!is.null(data$managers[[i]]$full_name)) {
    manager_names[i] <- data$managers[[i]]$full_name
  } else {
    manager_names[i] <- NA
  }
}

created_dates <- data.all$created %>% gsub('T.*', '' , .) %>% as.Date(format='%Y-%m-%d')
created_weeks_num <- isoweek(created_dates) # week no., week starts from Mon
created_weeks_str <-
  paste(gsub('\\-', '/', substring(as.character(
    floor_date(as.Date(created_dates, format='%Y-%m-%d'), 'week', week_start=1) + 1), 6)),
    '-',
    gsub('\\-', '/', substring(as.character(
      ceiling_date(as.Date(created_dates, format='%Y-%m-%d'), 'week', week_start=1)), 6)),
    sep='')

# Create dataframe
data.view <- data.frame(id = data$id,
                        url = data$url,
                        status = data$status,
                        first_name = data$first_name,
                        last_name = data$last_name,
                        dob = data$dob,
                        home_lc = lc_names,
                        managers = manager_names,
                        email=data$email,
                        phone=data$phone,
                        cv_url=data$cv_url,
                        created_date=created_dates,
                        created_week_num=created_weeks_num,
                        created_week_str=created_weeks_str
)
data.view

# Plot opens by month
data.all_new <- data.all %>% mutate(created_month = format(created, "%Y-%m"))
opens.count <- data.all_new %>% group_by(created_month) %>% count(name='opens')
opens.count

ggplot(opens.count, aes(x=created_month, y=opens)) +
  geom_bar(stat='identity', aes(fill=opens)) +
  theme_economist() +
  theme(axis.text.x=element_text(angle=90))