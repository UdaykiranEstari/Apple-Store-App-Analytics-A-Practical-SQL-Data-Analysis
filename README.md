
# PRACTICAL Data Analytics with SQL

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

Through our data analysis, we observed a positive correlation between the number of languages supported by an app and its user ratings. Apps that supported a moderate number of languages tended to have better average user ratings. This insight indicates that focusing on supporting the most relevant languages for the target audience can significantly improve user satisfaction and overall ratings.

**3. Low-Rated Genres**

Our analysis also identified genres with low ratings in the dataset. This finding presents an opportunity for our stakeholder to explore these genres further and potentially address user needs in those categories. By understanding the pain points and shortcomings of low-rated apps in these genres, our stakeholder can make strategic decisions to create high-quality apps that cater to user preferences, leading to the possibility of achieving higher ratings.

**4. App Description Length**

A notable insight from the analysis was the positive correlation between app description length and user ratings. Apps with longer and more comprehensive descriptions tended to receive better user ratings. This suggests that clear and detailed app descriptions can positively influence user perceptions and satisfaction. As a recommendation, we advised our stakeholder to focus on crafting clear and engaging app descriptions to enhance user ratings.

## Conclusion

In conclusion, this project has demonstrated the power of data analytics with SQL in providing actionable insights for app development strategies. By analyzing the comprehensive dataset of apps available on the Apple Store, we have been able to offer valuable recommendations to our stakeholder. As an aspiring app developer, these insights can guide them in making informed decisions about app categories, pricing, language support, and app descriptions, ultimately leading to successful app development and enhanced user satisfaction.

I hope this project serves as a practical reference for both myself and others in the data community who are learning SQL and seeking real-world examples. If you have any questions or wish to collaborate on SQL-related projects, please feel free to reach out.

Thank you for joining me on this data analytics journey!
