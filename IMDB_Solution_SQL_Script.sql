USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Number of rows in Movie is 7997
SELECT 
	COUNT(*) AS no_of_rows_in_movie
FROM 
	movie;

-- Number of rows in genre is 14662
SELECT 
	COUNT(*) AS no_of_rows_in_genre 
FROM 
	genre;

-- Number of rows in names is 25735
SELECT 
	COUNT(*) AS no_of_rows_in_names 
FROM 
	names;

-- Number of rows in role_mapping is 15615
SELECT 
	COUNT(*) AS no_of_rows_in_role_mapping 
FROM
	role_mapping;

-- Number of rows in ratings is 7997
SELECT 
	COUNT(*) AS no_of_rows_in_ratings
FROM
	ratings;

-- Number of rows in director_mapping is 3867
SELECT
	COUNT(*) AS no_of_rows_in_director_mapping
FROM
	director_mapping; 



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
	SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_null,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null
FROM 
	movie;

/* 
Movie Table have null values in below columns
	1. country - 20 null values
    2. worlwide_gross_income - 3724 null values 
    3. languages - 194 null values
    4. production_company columns - 528 null values
*/



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Total number of movies released each year

SELECT
	Year,
    COUNT(id) AS number_of_moives
FROM 
	movie
GROUP BY
	Year;

-- Highest number of movies got released in 2017 (3052 movies) followed by 2018 (2944), 2019 (2001 movies).

-- How does the trend looks each month

SELECT 
	MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
	movie
GROUP BY
	month_num
ORDER BY 
	month_num;

-- Highest number of movies got released in the month of March (824 movies), followed by September (809 movies), January (804 movies), October (801 movies).



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

/*
SELECT
	Country,
    Year,
    COUNT(id) AS number_of_movies
FROM
	movie
WHERE 
	(Country='India' OR Country='USA') AND Year= 2019
GROUP BY
	Country;
*/

/*
SELECT
	DISTINCT Country
FROM 
	movie;
*/

/*
From the above 2 commented codes we conclude that 
There are movies which got released in multiple countries simulataneously. So by using OR or IN Operators are not giving the expected result where the same movie got released in India and USA. Hence, we used LIKE Operator.
*/

SELECT 
	Year,
    COUNT(id) AS number_of_movies 
FROM   
	movie
WHERE  
	( country LIKE '%INDIA%' OR country LIKE '%USA%' ) AND year = 2019;

-- 1059 movies got produced by India or USA in the year 2019.


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT 
	DISTINCT genre
FROM
	genre;
    
/*
Different Genres -
1. Drama
2. Fantasy
3. Thriller
4. Comedy
5. Horror
6. Family
7. Romance
8. Adventure
9. Action
10. Sci-Fi
11. Crime
12. Mystery
Others
*/



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
	g.genre,
    COUNT(m.id) AS No_of_Movies
FROM 
	genre AS g
INNER JOIN
	movie AS m 
    ON g.movie_id=m.id
GROUP BY
	genre
ORDER BY
	No_of_Movies DESC
LIMIT 1;

-- Drama Genre (4285 movies) has the highest number of movies produced among all the genres.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_count AS
(
SELECT
    COUNT(movie_id) AS No_of_Genre
FROM 
	genre
GROUP BY
	movie_id
HAVING 
	No_of_Genre=1
)
SELECT
	COUNT(*) AS One_Genre_Movie
FROM
	genre_count;

-- There are 3289 movies with only one genre



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)



/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
	g.genre,
    ROUND(AVG(m.duration),2) AS Avg_Duration
FROM 
	movie AS m
INNER JOIN
	genre AS g
    ON m.id= g.movie_id
GROUP BY
	genre
ORDER BY
	Avg_Duration DESC;

-- Action Genre has the highest duration of 112.88 followed by Romance, Crime, Drama, Fantasy, Comedy etc.,



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH rank_genre AS
(
SELECT
	g.genre,
    COUNT(m.id) AS No_of_Movies,
    RANK() OVER(ORDER BY COUNT(m.id) DESC) AS Genre_Rank
FROM 
	movie AS m
INNER JOIN
	genre AS g
    ON m.id= g.movie_id
GROUP BY
	g.genre
)
SELECT
	*
FROM
	rank_genre
WHERE genre='Thriller';

-- Among all other genres, Thriller has third (3rd rank) highest number of movies(1484) produced.



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
	ROUND(MIN(avg_rating)) AS min_avg_rating,
    ROUND(MAX(avg_rating)) AS max_avg_rating,
    ROUND(MIN(total_votes)) AS min_total_votes,
    ROUND(MAX(total_votes)) AS max_total_votes,
    ROUND(MIN(median_rating)) AS min_median_rating,
    ROUND(MAX(median_rating)) AS max_median_rating
FROM
	ratings;




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH top_rating_movie AS
(
SELECT
	m.title,
    r.avg_rating,
    RANK() OVER(ORDER BY avg_rating DESC) AS Movie_Rank
FROM
	ratings AS r
INNER JOIN
	movie AS m
    ON r.movie_id=m.id
)
SELECT 
	*
FROM
	top_rating_movie
WHERE
	Movie_Rank<=10;

-- Kirket, Love in Kilnerry got the highest avg_rating of 10 and the top 3 movies has the avg_rating>=9.8
-- Top 10 movies has the avg_rating >=9.4


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT
	median_rating,
    COUNT(movie_id) AS Movie_Count
FROM
	ratings
GROUP BY
	median_rating
ORDER BY
	Movie_Count DESC;
    

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_company_high_rank AS
(
SELECT
	m.production_company,
    COUNT(m.id) AS Movie_Count,
    RANK() OVER(ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM
	movie AS m
INNER JOIN
	ratings AS r
    ON m.id=r.movie_id
WHERE
	r.avg_rating>=8 AND production_company IS NOT NULL
GROUP BY
	production_company
)
SELECT 
	*
FROM
	prod_company_high_rank
WHERE  prod_company_rank = 1;
	
-- Dream Warrior Pictures and National Theatre Live production houses have produced highest number of Hit movies.



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
	g.genre,
    COUNT(m.id) AS Movie_Count
FROM
	genre AS g
INNER JOIN
	movie AS m
    ON g.movie_id=m.id
INNER JOIN
	ratings AS r
	ON m.id=r.movie_id
WHERE
	MONTH(m.date_published)=3 AND m.Year=2017 AND m.Country LIKE '%USA%' AND r.total_votes>1000
GROUP BY 
	g.genre
ORDER BY
	Movie_Count DESC;

-- 24 Drama Genre were released in March 2017 in USA which has more than 1000 votes followed by Comedy (9 movies), Action(8 movies), Thriller(8 movies), etc.,


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	m.title,
    r.avg_rating,
    g.genre
 FROM
	genre AS g
INNER JOIN
	movie AS m
    ON g.movie_id=m.id
INNER JOIN
	ratings AS r
	ON m.id=r.movie_id 
WHERE 
	m.title LIKE 'The%' AND r.avg_rating>8
GROUP BY
	m.title
ORDER BY
	g.genre,r.avg_rating DESC;

-- There are 8 movies where the title starts with 'The' and have an avg_rating>8
-- The Brighton Miracle has the highest avg_rating(9.5) where the genre is Drama.
-- All the movies belongs to the top 3 genres.



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below: 

SELECT
	COUNT(m.id) AS No_of_Movies
FROM 
	movie AS M
INNER JOIN
	ratings AS r
    ON m.id=r.movie_id
WHERE 
	m.date_published BETWEEN "2018-04-01" AND "2019-04-01" AND r.median_rating=8
ORDER BY
	m.date_published;

-- There are 361 movies which are released between 1 April 2018 to 1 April 2019 with median_rating of 8



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH votes_summary AS
(
SELECT 
	COUNT(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN m.id END) AS german_movie_count,
	COUNT(CASE WHEN LOWER(m.languages) LIKE '%italian%' THEN m.id END) AS italian_movie_count,
	SUM(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN r.total_votes END) AS german_movie_votes,
	SUM(CASE WHEN LOWER(m.languages) LIKE '%italian%' THEN r.total_votes END) AS italian_movie_votes
FROM
    movie AS m 
	    INNER JOIN
	ratings AS r 
		ON m.id = r.movie_id
)
SELECT 
    ROUND(german_movie_votes / german_movie_count, 2) AS german_votes_per_movie,
    ROUND(italian_movie_votes / italian_movie_count, 2) AS italian_votes_per_movie
FROM
    votes_summary;

-- Yes, German movies get more votes than Italian movies


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM 
	names;

-- We have seen highest number of nulls in height(17335) followed by known_for_movies(15226), date_of_birth(13431).
-- There is no null value for name column.


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_three_genre AS
(
SELECT
	g.genre,
    COUNT(g.movie_id),
    RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS genre_rank
FROM
	genre AS g
INNER JOIN
	ratings AS r 
    ON g.movie_id=r.movie_id
WHERE
	r.avg_rating>8
GROUP BY
	g.genre
LIMIT 3
),
top_three_directors AS
(
SELECT
	name AS director_name,
    COUNT(movie_id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS director_rank
FROM
	genre AS g
INNER JOIN
	ratings AS r USING(movie_id)
INNER JOIN
	director_mapping AS d USING(movie_id)
INNER JOIN
	names AS n 
    ON d.name_id=n.id
INNER JOIN
	top_three_genre AS tg
    ON g.genre=tg.genre
WHERE
	r.avg_rating>8
GROUP BY
	director_name
ORDER BY
	movie_count DESC
)
SELECT
	director_name,
    movie_count
FROM
	top_three_directors
WHERE
	director_rank<=3;

-- James Mangold, Soubin Shahir, Joe Russo, Anthony Russo are the top four directors based on rank<=3 with number of movies as 4,3,3,3 respectively




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
	n.name AS actor_name,
    COUNT(ro.movie_id) AS movie_count
FROM
	ratings AS r
INNER JOIN
	role_mapping AS ro
    USING(movie_id)
INNER JOIN
	names AS n
    ON ro.name_id=n.id
WHERE
	r.median_rating>=8
GROUP BY
	actor_name
ORDER BY
	movie_count DESC
LIMIT 2;

-- Mammootty(8 movies) and Mohanlal(5 movies) are the top two actors with highest movies having median_rating>=8




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
	m.production_company,
    SUM(r.total_votes) AS vote_count,
    RANK() OVER(ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM
	movie AS m
INNER JOIN
	ratings AS r
    ON m.id=r.movie_id
GROUP BY
	production_company
LIMIT 3;

-- Marvel Studios, Twentieth Century Fox and Warner Bros. are the top three production houses based on the total votes.



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
	n.name AS actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) AS actor_avg_rating,
    RANK() OVER(ORDER BY SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes) DESC) AS actor_rank
FROM 
	ratings AS r
INNER JOIN
	movie AS m
    ON r.movie_id=m.id
INNER JOIN
	role_mapping AS ro
    ON m.id=ro.movie_id
INNER JOIN
	names AS n
    ON ro.name_id=n.id
WHERE
	m.country='India' AND ro.category='actor'
GROUP BY
	actor_name
HAVING
	COUNT(m.id)>=5;

-- Top Actor is Vijay Sethupathi with actor_avg_rating (8.42) and total_votes (23114) followed by Fahadh Faasil and Yogi Babu with actor_avg_ratings as 7.99 and 7.83 respectively.




-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
	n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) AS actress_avg_rating,
    RANK() OVER(ORDER BY SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes) DESC) AS actress_rank
FROM 
	ratings AS r
INNER JOIN
	movie AS m
    ON r.movie_id=m.id
INNER JOIN
	role_mapping AS ro
    ON m.id=ro.movie_id
INNER JOIN
	names AS n
    ON ro.name_id=n.id
WHERE
	m.country='India' AND ro.category='actress' AND m.languages='Hindi'
GROUP BY
	actress_name
HAVING
	COUNT(m.id)>=3
LIMIT 5;

-- Taapsee pannu has the highest avr_rating (7.74) with total votes (18061) followed by Divya Dutta, Kriti Kharbanda and Sonakshi Sinha



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH thriller_rating AS
(
SELECT
	m.title,
    r.avg_rating
FROM
	genre AS g
INNER JOIN
	movie AS m
    ON g.movie_id=m.id
INNER JOIN
	ratings AS r
    ON m.id=r.movie_id
WHERE g.genre='Thriller'
)
SELECT
	*,
    (CASE
		WHEN avg_rating >8 THEN 'Superhit movie'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movie'
        WHEN avg_rating >=5.0 AND avg_rating < 7 THEN 'One-time-watch movie'
        WHEN avg_rating <5.0 THEN 'Flop movie'END) AS thriller_movie_class
FROM
	thriller_rating
ORDER BY
	title;




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	g.genre,
	ROUND(AVG(m.duration),2) AS avg_duration,
    SUM(ROUND(AVG(m.duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
	AVG(ROUND(AVG(m.duration),2)) OVER(ORDER BY genre ROWS 5 PRECEDING) AS moving_avg_duration
FROM 
	movie AS m 
INNER JOIN 
	genre AS g 
	ON m.id= g.movie_id
GROUP BY 
	g.genre;



-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_three_genre AS
(
SELECT 
	g.genre,
    COUNT(g.movie_id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS genre_rank
FROM 
	genre AS g
GROUP BY
	g.genre
),
top_five_movies AS
(
SELECT
	g.genre,
    m.year,
    m.title,
    CONVERT(REPLACE(TRIM(m.worlwide_gross_income),"$",""),UNSIGNED INT) AS worldwide_gross_income,
    RANK() OVER(PARTITION BY m.year ORDER BY CONVERT(REPLACE(TRIM(m.worlwide_gross_income),"$",""),UNSIGNED INT) DESC) AS movie_rank
FROM
	movie AS m
INNER JOIN
	genre AS g
    ON m.id=g.movie_id
INNER JOIN
	top_three_genre AS ttg
    USING(genre)
WHERE
	genre_rank<=3
)
SELECT
	genre,
    year,
    title,
    worldwide_gross_income,
    movie_rank
FROM
	top_five_movies
WHERE
	movie_rank<=5;
    









-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
	production_company,
    COUNT(id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM
	movie AS m
INNER JOIN
	ratings AS r
    ON m.id=r.movie_id
WHERE
	r.median_rating>=8 AND production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY
	production_company
LIMIT 2;

-- Start Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies





-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
	n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
    RANK() OVER(ORDER BY COUNT(r.movie_id) DESC) AS actress_rank
FROM 
	ratings AS r
INNER JOIN 
	genre AS g
    USING(movie_id)
INNER JOIN
	role_mapping AS rm
    USING(movie_id)
INNER JOIN
	names AS n
    ON rm.name_id=n.id
WHERE
	r.avg_rating>8 AND g.genre='drama' AND category='actress'
GROUP BY
	actress_name
LIMIT 3;

-- Parvathy Thiruvothu, Susan Brown and Amanda Lawrence are the top three actress with total votes of 4974, 656, 656 and avg_rating of 8.25, 8.94, 8.94 respectively






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH  top_director AS 
(
SELECT
	dm.name_id,
    n.name,
	dm.movie_id,
    r.avg_rating,
    r.total_votes,
    m.duration,
    m.date_published,
    LEAD(m.date_published,1) OVER(PARTITION BY dm.name_id ORDER BY m.date_published,dm.movie_id DESC) AS next_date_published
FROM
	movie AS m
INNER JOIN
	ratings AS r
    ON m.id=r.movie_id
INNER JOIN
	director_mapping AS dm
    USING(movie_id)
INNER JOIN
	names AS n
    ON dm.name_id=n.id
),
director_details AS
(
SELECT
	*,
	DATEDIFF(next_date_published, date_published) AS difference_between_dates
FROM 
	top_director
)
SELECT 
	name_id AS director_id,
    name AS director_name,
    COUNT(movie_id) AS number_of_movies,
    ROUND(AVG(difference_between_dates),2) AS avg_inter_movie_days,
    ROUND(AVG(avg_rating),2) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM 
	director_details
GROUP BY
	director_id
ORDER BY
	number_of_movies DESC
LIMIT 9;
    
/* Top 9 directors based on number of movies are -

1. Andrew Jones
2. A.L. Vijay
3. Sion Sono
4. Chris Stokes
5. Sam Liu
6. Steven Soderbergh
7. Jesse V. Johnson
8. Justin Price
9. Özgür Bakar

*/




