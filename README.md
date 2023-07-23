
# Practical Data Analytics with SQL

## **Introduction**

Welcome to the "PRACTICAL Data Analytics with SQL" project! This repository is a culmination of my extensive practice and learning in SQL, and I'm excited to showcase my skills in the real world. The main purpose of this project is to serve as a future reference for myself, where I can review and reinforce what I have learned. Additionally, I hope this repository will be a valuable resource for anyone who is learning SQL and looking for real-world examples.

## SQL Expertise

Throughout my learning, I've honed my skills in SQL and its applications in data analysis. Some key areas where I excel include:

- Crafting complex SQL queries to efficiently extract and manipulate data for analysis.
- Performing exploratory data analysis (EDA) using SQL to gain insights into data characteristics.
- Utilizing SQL for data cleaning, integration, and preparation tasks to ensure data quality.
- Optimizing SQL queries for performance and efficiency, even with large datasets and databases.

## Showcase Project: Practical Data Analysis of Apple Store Apps

In this project, we worked with two datasets: `applestore.csv` and `AppleStore_description`. These datasets contain information about various apps available on the Apple Store, such as app names, ratings, app types, and descriptions. The goal was to provide data-driven insights to an aspiring app developer who needed to make decisions about app categories, pricing, and strategies to maximize user ratings.

## Project Overview

### Dataset and Tools

For this project, I utilized the powerful online resource `sqliteonline.com`, which enables SQL analysis without any installations. Due to the platform's 4 MB size limit, I divided the large CSV file into four smaller files and combined them using the `UNION ALL` feature to create a unified dataset for analysis.

However, it's essential to note that this project is highly adaptable to different flavors of SQL, such as PostgreSQL or MSSQL. While there might be minor differences in syntax, the overall idea and methodology of the project remain consistent across various SQL environments.

Feel free to use your preferred SQL flavor and tools to replicate and extend the analysis presented in this project. Whether you choose PostgreSQL, MSSQL, MySQL, or any other SQL variant, the fundamental principles of data analytics and querying remain applicable.

Happy exploring and analyzing with your flavor of SQL!

## Project Steps

### Step 1: Stakeholder Identification

The first step of the project involved identifying the stakeholder, who was an aspiring app developer looking for data-driven insights to build successful apps. Our goal was to answer essential questions such as:

- Identifying popular app categories: We aimed to determine which app categories were the most popular among users.
- Determining pricing strategies: We sought to understand how app pricing affected user engagement and ratings.
- Understanding factors influencing user ratings: We aimed to analyze various factors that influenced user ratings for apps on the Apple Store.

### Step 2: Exploratory Data Analysis (EDA)

EDA played a crucial role in understanding the dataset's structure and quality. We conducted several exploratory data analysis tasks, including:

- Checking for missing values: We ensured that the data was clean and reliable by checking for any missing values in the dataset.
- Exploring app categories' distribution: Through data visualisation and summary statistics, we identified the dominant genres among the apps in the dataset.

In this phase, we gained valuable insights into the dataset, which provided a foundation for further analysis and decision-making.

for more info check the sql file `AppStore_Analysis.sql`

### Step 3 : Data Analysis and Insights

After completing the exploratory data analysis (EDA), we proceeded with the data analysis phase, where we derived valuable insights to guide our stakeholder's app development decisions. The following are the key insights we obtained:

**1. Paid vs. Free Apps**


```sql


-- Finding Whether avg rating of paid or free app is higher 

SELECT CASE
        WHEN price > 0 THEn "Paid"
        ELSE "Free" 
       END AS App_Type,
       AVG(user_rating) as AvgRating
  FROM AppleStore
 GROUP BY App_Type

-- Number of paid and free apps with the top user rating in each genre

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

```


On conducting the analysis, we found that, on average, paid apps received slightly higher ratings compared to free apps. This suggests that users might perceive paid apps as having higher value and engagement, leading to better ratings. As a recommendation, our stakeholder could consider offering a paid app to potentially enhance user engagement and increase the perceived value of their app.

**2. Languages and Ratings**


```sql

-- Dividing languages into groups <10 , 10-30 , 31-50 , 51-100

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

-- Here 10-30 Language group has more ratings .. if we want more info let's go into little depth

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

-- 10-15 Language support is enough is good.

```


Through our data analysis, we observed a positive correlation between the number of languages supported by an app and its user ratings. Apps that supported a moderate number of languages tended to have better average user ratings. This insight indicates that focusing on supporting the most relevant languages for the target audience can significantly improve user satisfaction and overall ratings.

**3. Low-Rated Genres**

```sql

-- Check Genre with low rating

SELECT prime_genre,
		Avg(user_rating) as AvgRating
FROM AppleStore
GROUP BY prime_genre
ORDER BY AvgRating
LIMIT 5

-- Catalogs, Finance and Book genre has very less reviews. Creating a better product in this genre gives high chance of success
```

Our analysis also identified genres with low ratings in the dataset. This finding presents an opportunity for our stakeholder to explore these genres further and potentially address user needs in those categories. By understanding the pain points and shortcomings of low-rated apps in these genres, our stakeholder can make strategic decisions to create high-quality apps that cater to user preferences, leading to the possibility of achieving higher ratings.

**4. App Description Length**

```sql

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

```
A notable insight from the analysis was the positive correlation between app description length and user ratings. Apps with longer and more comprehensive descriptions tended to receive better user ratings. This suggests that clear and detailed app descriptions can positively influence user perceptions and satisfaction. As a recommendation, we advised our stakeholder to focus on crafting clear and engaging app descriptions to enhance user ratings.

**5. App Description Keywords**

```sql

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

```
keywords could enhance app features and usage, leading to better user satisfaction and higher ratings.

**6.Top Apps in Each Category **

```sql

-- Top Apps in each Category by user ratings if there is tie between 2 apps it's broken by total number of ratings 

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

```
If you are interested in all the top apps with substantial number of users. here I have taken this substantial number of users as 10000

```sql

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

```
Considering the rating count filter, we can focus on apps that have been rated by a substantial number of users, ensuring that the top-ranked apps are genuinely popular and influential within their respective genres. This analysis provides valuable insights for app developers seeking to understand the most highly-rated apps in different genres and make informed decisions for app development strategies.

## Conclusion

In conclusion, this project has demonstrated the power of data analytics with SQL in providing actionable insights for app development strategies. By analyzing the comprehensive dataset of apps available on the Apple Store, we have been able to offer valuable recommendations to our stakeholder. As an aspiring app developer, these insights can guide them in making informed decisions about app categories, pricing, language support, and app descriptions, ultimately leading to successful app development and enhanced user satisfaction.

I hope this project serves as a practical reference for both myself and others in the data community who are learning SQL and seeking real-world examples. If you have any questions or wish to collaborate on SQL-related projects, please feel free to reach out.

Thank you for joining me on this data analytics journey!
