/*
   _____        _  _     _    _                  _       
  / ____|   /\ | || |   | |  | |                | |      
 | |  __   /  \| || |_  | |__| | ___  _   _ _ __| |_   _ 
 | | |_ | / /\ \__   _| |  __  |/ _ \| | | | '__| | | | |
 | |__| |/ ____ \ | |   | |  | | (_) | |_| | |  | | |_| |
  \_____/_/    \_\|_|   |_|  |_|\___/ \__,_|_|  |_|\__, |
                                                    __/ |
                                                   |___/


FIRST WRITTEN ON: 2024-05-20
BY: DATAMA - GUILLAUME@DATAMA.IO
LICENCE:MIT
NOTE: This query has been written for helping to find anomalies in Google Analytics 4
      Please read more instructions on https://github.com/DataMa-Solutions/GA4-Hourly
      DataMa is a SaaS tool that helps finding insights and generate business actions based on data.
      Contact us for automatic anomaly detection in our app, as a SaaS or as an extension of visualisation Tools (Looker Studio, Tableau, PowerBI)
*/


########  Declaring variables

DECLARE Min_Date DATE DEFAULT DATE_SUB(current_date(), INTERVAL 5 DAY);
DECLARE Max_Date DATE DEFAULT DATE_SUB(current_date(), INTERVAL 1 DAY);
DECLARE Max_TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP();


########  Setting variables
SET Min_Date = DATE_SUB(CURRENT_DATE(), INTERVAL 21 DAY);  -- <--- Change time window here if need be
SET Max_Date = DATE_SUB(CURRENT_DATE(), INTERVAL 0 DAY);
SET Max_TimeStamp = (SELECT Max(timestamp_micros(event_timestamp)) FROM`carandacheanalytics.analytics_333683726.events_*` 
WHERE regexp_extract(_table_suffix, r'[0-9]+')=FORMAT_DATE('%Y%m%d',Max_Date) AND timestamp_micros(event_timestamp)<CURRENT_TIMESTAMP());



WITH base AS(
SELECT TIMESTAMP_TRUNC(timestamp_micros(event_timestamp),HOUR) Date_hour,
   device.category as Device,
   sum(case when event_name IN ('session_start') THEN 1 ELSE 0 END) as session_start, -- <--- Replace by relevant metric you want to monitor
   sum(case when event_name IN ('page_view') THEN 1 ELSE 0 END) as page_view,
   sum(case when event_name IN ('add_to_cart') THEN 1 ELSE 0 END) as add_to_cart,
   sum(case when event_name IN ('in_app_purchase', 'purchase') THEN 1 ELSE 0 END) as purchase
FROM
   `***.analytics_*****.events_*`  -- <--- Change your project and GA4 table ID here
WHERE
   (regexp_extract(_table_suffix, r'[0-9]+') between format_date('%Y%m%d',Min_Date) AND FORMAT_DATE('%Y%m%d',Max_Date))
 --  AND (privacy_info.analytics_storage IS NULL OR privacy_info.analytics_storage="Yes")
   AND timestamp_micros(event_timestamp)<TIMESTAMP_TRUNC(Max_TimeStamp,HOUR)
GROUP BY all
)

Select *
from base 
order by Date_hour DESC, 2 DESC
