# User retention analysis
* [Setup](#setup)
* [Daily Active Users](#daily-active-users)
* [Engagement](#engagement)
* [Retention](#retention)
* [Retention Cohorts](#retention-cohorts)
* [Monthly Seasonality](#monthly-seasonality)
* [Monthly Seasonality Steps](#monthly-seasonality-steps)
* [Weekly Seasonality](#seekly-seasonality)
* [User Segmentation](#user-segmentation)


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
![Monthly Seasonality](charts/monthly_seasonality.png)

## Monthly Seasonality (Steps)
![Monthly Seasonality Steps](charts/monthly_seasonality_steps.png)

## Weekly Seasonality (Users)
![Weekly Seasonality](charts/weekly_seasonlity.png)

## User Segmentation
![User Segmentation](charts/user_segmentation.png)