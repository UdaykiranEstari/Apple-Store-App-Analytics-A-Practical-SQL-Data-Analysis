-- Apple Store App Analytics: A Practical SQL Data Analysis


-- Creating a Combined table for app_description table

CREATE TABLE appleStore_description_combined AS

SELECT *
FROM appleStore_description1

UNION ALL

SELECT *
FROM appleStore_description2

UNION ALL

SELECT *
FROM appleStore_description3

UNION ALL

SELECT *
FROM appleStore_description4


** EXPLORATORY DATA ANALYSIS **

-- Checking number of unique apps in both tables 

SELECT COUNT(DISTINCT id) as Unique_app_ids
FROM AppleStore

SELECT COUNT(DISTINCT id) as Unique_app_ids
FROM appleStore_description_combined

-- Checking for any missing values

SELECT COUNT(*) as missing_values
FROM AppleStore
WHERE track_name is NULL
	OR rating_count_tot is NULL
    OR user_rating is NULL
    OR prime_genre is NULL
    OR size_bytes is NULL



SELECT COUNT(*) as missing_values
FROM appleStore_description_combined
WHERE track_name is NULL
	OR size_bytes is NULL
    OR app_desc is NULL

-- both tables have no missing values this is pretty clean dataset


-- Finding the number of apps for genre

SELECT prime_genre,
		COUNT(track_name) as Num_apps
FROM AppleStore
GROUP BY prime_genre
ORDER BY 2 DESC


-- Get Overview of apps ratings

-- range of ratings

SELECT  MIN(user_rating) as MinRating,
        AVG(user_rating) as AvgRating,
		MAX(user_rating) AS MaxRating
FROM AppleStore

-- rating count total range

SELECT  MIN(rating_count_tot) as MinRatingCount,
        AVG(rating_count_tot) as AvgRatingCount,
		MAX(rating_count_tot) AS MaxRatingCount
FROM AppleStore

-- range of price of apps

SELECT  MIN(price) as MinPrice_$US,
        AVG(price) as AvgPrice_$US,
		MAX(price) AS MaxPrice$US
FROM AppleStore
	
-- Size of apps in bytes

SELECT  MIN(size_bytes)/1048576 as "MinSize(MB)",
        AVG(size_bytes)/1048576 as "AvgSize(MB)",
		MAX(size_bytes)/1048576 AS "MaxSize(MB)"
FROM AppleStore

-- no of languages the app supports

SELECT  MIN(lang_num)as "MinNoofLanguages",
        AVG(lang_num)as "AvgNoofLanguages",
		MAX(lang_num)as "MaxNoofLanguages"
FROM AppleStore

-- length of app descrption varation

SELECT  MIN(Length(app_desc)) as "MinLenAppDescription",
		AVG(Length(app_desc)) as "AvgLenAppDescription",
        MAX(Length(app_desc)) as "MaxLenAppDescription"
FROM appleStore_description_combined

-- Content rating groups and no_of_apps in each group

SELECT cont_rating as content_rating,
		COUNT(cont_rating) as "Number of Apps"
FROM AppleStore
GROUP BY 1
ORDER BY 2 DESC


** Finding Insights **

-- Finding Whether avg rating of paid or free app is higher 

SELECT CASE 
		WHEN price > 0 THEn "Paid"
        ELSE "Free" 
       END AS App_Type,
       AVG(user_rating) as AvgRating
FROM AppleStore
GROUP BY App_Type

-- number of paid and free apps with the top user rating in each genre

WITH cte_topranked_apps AS
(
    SELECT
        prime_genre,
        track_name,
        price,
        user_rating,
        RANK() OVER (ORDER BY user_rating DESC) AS rank,
        CASE
            WHEN price > 0 THEN "Paid"
            ELSE "Free" 
        END AS App_Type
    FROM AppleStore
)

SELECT
    prime_genre,
    App_Type,
    COUNT(*) AS no_of_apps
FROM cte_topranked_apps
WHERE rank = 1
GROUP BY prime_genre, App_Type
ORDER BY prime_genre;

-- check whether apps have more languages have higher rating
-- dividing languages into groups <10 10-30 31-50 51-100

SELECT  CASE
			WHEN lang_num < 10 THEN "< 10 Languages"
            WHEN lang_num BETWEEN 10 AND 30 THEN "10-30 Languages" 
            WHEN lang_num BETWEEN 31 AND 50 THEN "31-50 Languages"
            WHEN lang_num BETWEEN 50 AND 100 THEN "50-100 Languages"
            END as LangGroup,
        AVG(user_rating) as AvgRating
FROM AppleStore
GROUP BY LangGroup
ORDER BY AvgRating DESC

-- here 10-30 Language group has more ratings .. if we want more info let's go into little depth

SELECT CASE
			WHEN lang_num BETWEEN 10 AND 15 THEN "10-15 Languages"
            WHEN lang_num BETWEEN 16 AND 20 THEN "16-20 Languages"
            WHEN lang_num BETWEEN 21 AND 25 THEN "21-25 Languages"
            WHEN lang_num BETWEEN 26 AND 30 THEN "26-30 Languages"
       END AS LangGroup,
       AVG(user_rating) as AvgRating
FROM AppleStore
GROUP BY LangGroup
ORDER BY AvgRating DESC

-- 10-15 Language support is enough is good and allot time for other improvement instead of adding more language support

-- Check Genre with low rating

SELECT prime_genre,
		Avg(user_rating) as AvgRating
FROM AppleStore
GROUP BY prime_genre
ORDER BY AvgRating
LIMIT 5

-- Catalogs, Finance and Book genre has very less reviews. Creating a better product in this genre gives high chance of success

-- Check if there is realation between app_description and user_rating

SELECT  CASE
			WHEN Length(b.app_desc) < 500 THEN "Short"
            WHEN Length(b.app_desc) BETWEEN 500 AND 1000 THEN "Medium"
            ELSE "Long"
        END AS LangLenGroup,
        Avg(user_rating) as Avg_Rating
FROM AppleStore a
JOIN appleStore_description_combined b
ON a.id = b.id
GROUP BY LangLenGroup
ORDER BY Avg_Rating DESC

-- According to the results we can say that longer the description better the rating user understand the app more detailly.


SELECT app_desc
FROM appleStore_description_combined
WHERE app_desc ILIKE '%Feature%' OR app_desc ILIKE '%Guide%'


-- Having keywords and their explain like Features, Usage, Hints, Tips will increase your rating 

PRAGMA case_sensitive_like = true;

SELECT avg(a.user_rating) as Avg_Rating
FROM AppleStore a
JOIN appleStore_description_combined b
ON a.id = b.id
WHERE  	b.app_desc LIKE '%Feature%' 
		OR b.app_desc LIKE '%Usage%'
        OR b.app_desc LIKE '%Hint%'
        OR b.app_desc LIKE '%Tips%'
        

PRAGMA case_sensitive_like = true;
        
SELECT avg(a.user_rating) as Avg_Rating
FROM AppleStore a
JOIN appleStore_description_combined b
ON a.id = b.id
WHERE  	b.app_desc NOT LIKE '%Feature%' 
		OR b.app_desc NOT LIKE '%Usage%'
        OR b.app_desc NOT LIKE '%Hint%'
        OR b.app_desc NOT LIKE '%Tips%'
        



-- top apps in each genre where minimum rating count is 10000

/* 
considering the rating count filter, we can focus on apps that have been rated by a substantial number of users, 
ensuring that the top-ranked apps are genuinely popular and influential within their respective genres. 
This analysis provides valuable insights for app developers seeking to understand the most highly-rated 
apps in different genres and make informed decisions for app development strategies.

*/

WITH cte_topranked_apps AS
(
    SELECT
        prime_genre,
        track_name,
        user_rating,
  		rating_count_tot,
        RANK() OVER (ORDER BY user_rating DESC) AS rank
    FROM AppleStore
  	WHERE rating_count_tot > 10000
)

SELECT *
FROM cte_topranked_apps
WHERE rank = 1
ORDER BY prime_genre, rating_count_tot DESC


-- if we want only top app in each genre with highest no_of_rating then
-- the tie between app is broken with the help of total number of ratings

WITH cte_topranked_apps AS
(
    SELECT
        prime_genre,
        track_name,
        user_rating,
  		rating_count_tot,
        RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
    FROM AppleStore
)

SELECT  prime_genre,
        track_name,
        user_rating,
  		rating_count_tot
FROM cte_topranked_apps
WHERE rank = 1
ORDER BY prime_genre, rating_count_tot DESC



-- Price correaltion with user_rating
-- gives the idea what price range is best to set

SELECT CASE 
	WHEN price < 5 THEN '< 5 $' 
        WHEN price BETWEEN 05 AND 10 THEN '05-10 $'
        WHEN price BETWEEN 11 AND 20 THEN '11-20 $'
        WHEN price BETWEEN 21 AND 30 THEN '21-30 $'
        WHEN price BETWEEN 31 AND 40 THEN '31-40 $'
        WHEN price BETWEEN 41 AND 50 THEN '41-50 $'
        WHEN price BETWEEN 51 AND 60 THEN '51-60 $'
       ELSE '> 60 $' END AS PriceBucket,
       Avg(user_rating) AS AvgRating       
FROM AppleStore
GROUP BY PriceBucket
ORDER BY AvgRating DESC

-- (31-40) or(50-60) $ is the best price range to set to get better reviews where your app is capable of that price




-- End
