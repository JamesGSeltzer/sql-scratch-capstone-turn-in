     -- Queries from Section 1 Get Familiar With CoolTShirts -- 

 -- How many campaigns and sources does CTS use? How are they related? What pages are on their website? -- 


 SELECT COUNT(DISTINCT utm_campaign) AS 'CTS Campaigns' 
 FROM page_visits;


 SELECT COUNT(DISTINCT utm_source) AS 'CTS Sources'
 FROM page_visits;


 SELECT DISTINCT utm_source AS 'Source', 
                 utm_campaign AS 'Campaign'
 FROM page_visits;

 
 SELECT DISTINCT page_name AS 'CTS Pages'
 FROM page_visits;



     -- Queries from Section 2 What Is The User Journey -- 


 -- First touches per campaign -- 


 WITH first_touch AS (
  SELECT user_id,
           MIN(timestamp) AS first_touch_at 
         FROM page_visits
         GROUP BY user_id),
 ft_attr AS (    
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
         ON ft.user_id = pv.user_id
         AND ft.first_touch_at = pv.timestamp)
  SELECT ft_attr.utm_source AS 'Source',
         ft_attr.utm_campaign AS 'Campaign',
         COUNT(*)
  FROM ft_attr
  GROUP BY 1, 2
  ORDER BY 3 DESC; 



 -- Last touches per campaign -- 


 WITH last_touch AS (
    SELECT user_id,
            MAX(timestamp) AS last_touch_at
         FROM page_visits
         GROUP BY user_id),
 lt_attr AS (
    SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
    FROM last_touch lt
    JOIN page_visits pv
         ON lt.user_id = pv.user_id
         AND lt.last_touch_at = pv.timestamp)
    SELECT lt_attr.utm_source AS 'Source',
         lt_attr.utm_campaign AS 'Campaign',
         COUNT(*)
    FROM lt_attr
    GROUP BY 1, 2
    ORDER BY 3 DESC;




 -- Query from Slide 9 to determine how many visitors make a purchase -- 


SELECT COUNT (DISTINCT user_id) AS ‘Customers’
FROM page_visits
WHERE page_name = '4 - purchase';




 -- How many last touches on the purchase page is each campagin responsible for -- 


 WITH last_touch AS (
    SELECT user_id,
             MAX(timestamp) AS last_touch_at
         FROM page_visits
         WHERE page_name = '4 - purchase'
         GROUP BY user_id),
 lt_attr AS (
    SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
    FROM last_touch lt
    JOIN page_visits pv
         ON lt.user_id = pv.user_id
         AND lt.last_touch_at = pv.timestamp)
    SELECT lt_attr.utm_source AS 'Source',
         lt_attr.utm_campaign AS 'Campaign',
         COUNT(*) 
    FROM lt_attr
    GROUP BY 1, 2
    ORDER BY 3 DESC;





 -- Queries from Slide 10 & 11 used to illustrate the typical user journey --  


SELECT DISTINCT user_id AS 'CTS Customers'
FROM page_visits 
WHERE page_name = '4 - purchase' 
LIMIT 5;


SELECT *
FROM page_visits
WHERE user_id = 10030;






