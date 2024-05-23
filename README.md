# GA4 Hourly alerting
A Big Query SQL request to monitor and explain GA4 metrics on hourly basis. 

It helps generating a file that containing previous data from both day and intra day Google Analytics 4 Big Query exports and make sure it includes all data on last few days up to previous hour from current time

A good example of usage can be found on this article explaining [how to use Datama Detect for hourly GA4 anomaly alerting](https://datama.io/hourly-anomaly-detection-and-explanation-on-ga4-google-analytics-4/)

Here is a step by step guide on how to use it

0. Make sure you have connected  GA4 to Big Query, including the "Streaming" option for continious export of data
   You can find tutorials here: [connect GA4 to BigQuery](https://support.google.com/analytics/answer/9823238?hl=en#zippy=%2Cin-this-article) (for all clients)
1. Copy Paste the file [GA4_Hourly_schedule.sql](https://github.com/DataMa-Solutions/GA4-Hourly/blob/main/GA4_Hourly_schedule.sql) in a Big Query SQL environment (or if you are familiar with git, clone it on desired place)
3. Find and replace the name of the GA4 (```***.analytics_*****.events_*```) event tables with the proper names of your table in the whole query
2. [Optional] Specify the proper number of days you want to include in the analysis by changing the time window on ```Min_Date``` definition
4. [Optional] Find and replace the events you want to track for anomalies (e.g. session_start or purchases) and the dimensions that you want to collect to explain those anomalies (e.g. Devices)
5. Run the query and visualize results - data should look like [this](https://docs.google.com/spreadsheets/d/1Z2JovUx_q7uLR2iy_fukiJWpIrA1o5wfvfnaHQUgBE4/edit#gid=0)
6. Detect anomalies and trigger emails

   . You can build your own system for both detecting anomalies and sending those anomalies to final recipients. To do so, BigQuery [DETECT_ANOMALIES](https://cloud.google.com/bigquery/docs/reference/standard-sql/bigqueryml-syntax-detect-anomalies) might be a good start

   . Or you can use DataMa Detect SaaS for free: create account on [DataMa platform](app.datama.io) and connect your BigQuery data in DataMa Detect.
   DataMa Detect will provide not only anomaly detection in your favorite messaging app but also explanation for those anomalies withing requested dimensions. 
   Please read this [article](https://datama.io/hourly-anomaly-detection-and-explanation-on-ga4-google-analytics-4/) to get started 

![Anomaly detection Message](https://github.com/DataMa-Solutions/GA4-Hourly/assets/61363175/ceb70b2a-8042-49e6-bef7-363e9d04e30f)
