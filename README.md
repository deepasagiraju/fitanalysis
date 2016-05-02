# User retention analysis
* [Daily Active Users](#Daily-Active-Users)
* [Engagement](#Engagement)
* [Retention](#Retention)
* [Retention Cohorts](#Retention-Cohorts)
* [Monthly Seasonality](#Monthly-Seasonality)
* [Monthly Seasonality Steps](#Monthly-Seasonality-Steps)
* [Weekly Seasonality](#Weekly-Seasonality)
* [User Segmentation](#User-Segmentation)
* [Setup](#setup)


## Setup 
* Run database
```
cd $PROJECT
docker-compose up -d
```
* Create postgres table
```
drop table if exists activity;
create table activity (user_id int, activity_date date, steps int);
```
* Load data
```
copy activity from '/tmp/data/activity.csv' DELIMITER ',' CSV HEADER;
select * from activity limit 10;
```

## Daily Active Users (DAU)
![Daily Active Users](charts/dau.png)

## Engagement
![Engagement](charts/engagement.png)

## Retention
![Retention](charts/retention.png)

## Retention Cohorts
![Retention Cohorts](charts/retention_cohorts.png)

## Monthly Seasonality (Users)
![Monthly Seasonality](charts/monthly_seasonlity.png)

## Monthly Seasonality (Steps)
![Monthly Seasonality Steps](charts/monthly_seasonlity_steps.png)

## Weekly Seasonality (Users)
![Weekly Seasonality](charts/weekly_seasonlity.png)

## User Segmentation
![User Segmentation](charts/user_egmentation.png)