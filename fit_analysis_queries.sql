-- Daily Active Users (DAU)
SELECT 
  date_trunc('Day', activity_date::timestamp) AS Day
  , count(distinct user_id) AS Number_of_Users
FROM 
  activity
GROUP BY
  1;


-- Weekly Active Users (WAU)
SELECT 
  date_trunc('week', activity_date::timestamp) AS week
  , count(distinct user_id)
FROM 
  activity
GROUP BY
  1;


-- Monthly Active Users (MAU)
SELECT 
  to_char(activity_date, 'YYYY-MM') AS month,
  count(distinct user_id)
FROM 
  activity
GROUP BY
  1;
 

-- Engagement & Month over Month change
WITH 
monthly AS (
        SELECT
                date_trunc('month', activity_date::timestamp)::date AS month
                , count(distinct user_id) mau
        FROM activity
        GROUP BY 1
        ),
total_users AS (
        SELECT count(distinct user_id) AS total_users FROM activity
        )
SELECT 
        month
        , (mau*100 / total_users) AS engagement_percent
        , (mau - lag(mau, 1) over (ORDER BY month))*100/lag(mau, 1) over (ORDER BY month) AS percent_change
FROM monthly, total_users
ORDER BY 1;


-- Retention
with 
joined_dates AS (
        SELECT user_id, min(activity_date) AS joined_date
        FROM activity
        GROUP BY 1
        ),
totals AS (
        SELECT count(distinct user_id) AS total_users FROM activity
        ),
tenure_counts AS (
        SELECT 
                (activity_date - joined_date) AS tenure
                , count(distinct a.user_id) AS cnt
        FROM 
                activity A join joined_dates J ON A.user_id = J.user_id
        GROUP BY 1
        )
SELECT 
        t.tenure AS days_since_join
        , t.cnt AS num_users
        , (t.cnt*100 / ts.total_users) AS active_user_percentage
FROM
        tenure_counts t, totals ts
ORDER BY 
        1;




-- Retention By Cohorts 
with 
joined_dates AS (
     SELECT user_id, min(activity_date) AS joined_date
     FROM activity
     GROUP BY 1
     ),
joined_2012 AS (
        SELECT 
             (activity_date - joined_date) AS tenure
             , count(distinct a.user_id) AS cnt
        FROM 
             activity A join joined_dates J ON A.user_id = J.user_id
        WHERE to_char(joined_date, 'YYYY') = '2012'
        GROUP BY 1
),
joined_2013 AS (
        SELECT 
             (activity_date - joined_date) AS tenure
             , count(distinct a.user_id) AS cnt
        FROM 
             activity A join joined_dates J ON A.user_id = J.user_id
        WHERE to_char(joined_date, 'YYYY') = '2013'
        GROUP BY 1
)
SELECT a.tenure AS days_since_join, a.cnt AS cohort_2012, b.cnt AS cohort_2013
FROM joined_2012 a full outer join joined_2013 b ON a.tenure = b.tenure
ORDER BY 1;



-- Monthly Seasonality Users 
with a AS (
SELECT 
  to_char(activity_date, 'MON') AS month,
  to_char(activity_date, 'MM') AS month_num,
  count(distinct user_id)
FROM 
  activity
GROUP BY
  1, 2
ORDER BY 2
)
SELECT month, count FROM a;


-- Monthly Seasonality Steps
with a AS ( 
	SELECT 
		to_char(activity_date, 'MON') AS month,
		to_char(activity_date, 'MM') AS month_num, 
		count(distinct user_id) 
	FROM 
		activity 
	GROUP BY
		 1, 2 
	ORDER BY 
		2 
	) 
	SELECT month, count FROM a ;



-- Seasonality Week
	-- Chart 1
	SELECT 
	  to_char(activity_date, 'DAY') AS day,
	  count(steps)
	FROM 
	  activity
	GROUP BY
	  1;

	--Chart 2
	SELECT 
	  to_char(activity_date, 'DAY') AS day,
	  count(distinct user_id)
	FROM 
	  activity
	GROUP BY
	  1;



-- Users Segmented By Usage
with 
monthly AS (SELECT to_char(activity_date, 'YYYY-MM') AS activity_month, user_id, sum(steps) AS steps FROM activity GROUP BY 1, 2),
user_types AS (SELECT
       case when steps < 10000 then 'VERY_LOW'
               when steps >= 10000 and steps < 50000 then 'LOW'
               when steps >= 50000 and steps < 100000 then 'MEDIUM'
               when steps >= 100000 and steps < 200000 then 'HIGH'
               else 'VERY_HIGH'
       end AS user_type
       , activity_month
       , user_id
FROM 
       monthly
)
SELECT 
       activity_month
       , sum(case when user_type = 'VERY_LOW' then 1 else 0 end) AS very_low
       , sum(case when user_type = 'LOW' then 1 else 0 end) AS low
       , sum(case when user_type = 'MEDIUM' then 1 else 0 end) AS medium
       , sum(case when user_type = 'HIGH' then 1 else 0 end) AS high
       , sum(case when user_type = 'VERY_HIGH' then 1 else 0 end) AS very_high
FROM user_types
GROUP BY 1
ORDER BY 1
;
