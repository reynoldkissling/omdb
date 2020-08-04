-- Jed
-- 7.1 Get all the movies and their trivia (so that we can show this information in a table). Return NULL if the trivia doesn’t exist for a movie. This ensures that we show movies in UI with blanks for the trivia.
SELECT movies.movie_id,
       native_name,
       movie_trivia_id,
       movie_trivia_name
FROM   movies
       LEFT OUTER JOIN movie_trivia
                    ON movies.movie_id = movie_trivia.movie_id



--  Jonathan,
-- 7.2 Get all the movies and the quotes in those movies (so that we can show this information in a table)
SELECT movies.movie_id,
       native_name,
       movie_quote_id,
       movie_quote_name
FROM   movies
       LEFT OUTER JOIN movie_quotes
                    ON movies.movie_id = movie_quotes.movie_id



--  Mel,
-- 7.3 Get all the movies and the corresponding media.
SELECT movies.movie_id,
       native_name,
       movie_media_id,
       m_link,
       m_link_type
FROM   movies
       LEFT OUTER JOIN movie_media
                    ON movies.movie_id = movie_media.movie_id
ORDER BY `movies`.`movie_id` ASC



--  Reynold,
--  7.4 Get all the movies and the corresponding people info
SELECT movies.movie_id,
       native_name,
       movie_people.people_id,
       stage_name,
       role,
       first_name,
       last_name,
       screen_name
FROM   movies
       LEFT OUTER JOIN movie_people
                    ON movies.movie_id = movie_people.movie_id
       LEFT OUTER JOIN people
       				ON people.people_id = movie_people.people_id



--  Ryan,
-- 7.5 Get the list of all people in the database
SELECT * FROM people



--  Samantha,
-- 7.6 Get the list of all people in the database. And also show their association with the movies along with the “role” and “screen_name”.
SELECT movies.movie_id,
	   native_name,
       movie_people.people_id,
       stage_name,
       role,
       first_name,
       middle_name,
       last_name,
       gender,
       image_name,
       screen_name
FROM   movies
       LEFT OUTER JOIN movie_people
                    ON movies.movie_id = movie_people.movie_id
       LEFT OUTER JOIN people
       				ON people.people_id = movie_people.people_id



-- (All)
-- 7.33
-- Connect all the tables from “movies” perspective; You should show ALL movies. Show NULLs if there is no corresponding movie_data or media or songs or people
SELECT movies.movie_id,
       native_name,
       english_name,
       year_made,
       tag_line,
       language,
       country,
       genre,
       plot,
       (SELECT COUNT(movie_trivia_id)
        FROM movie_trivia
        WHERE movies.movie_id = movie_trivia.movie_id) AS movie_trivia_count,
       (SELECT COUNT(keyword)
        FROM movie_keywords
        WHERE movies.movie_id = movie_keywords.movie_id) AS movie_keyword_count,
        (SELECT COUNT(movie_media_id)
         FROM movie_media
         WHERE movies.movie_id = movie_media.movie_id) AS movie_media_count,
        (SELECT COUNT(song_id)
         FROM movie_song
         WHERE movies.movie_id = movie_song.movie_id) AS movies_song_count,
        (SELECT COUNT(people_id)
         FROM movie_people
         WHERE movies.movie_id = movie_people.movie_id) movie_people_count

FROM   movies
       LEFT OUTER JOIN movie_data
                    ON movies.movie_id = movie_data.movie_id



--7.38 Samantha
-- Give me the list of all movies containing a substring in the Song lyrics or Song title
SELECT native_name, title, lyrics
FROM movies
LEFT OUTER JOIN movie_song ON movies.movie_id = movie_song.movie_id
LEFT OUTER JOIN songs ON movie_song.song_id = songs.song_id
WHERE title LIKE '%substring%'
   OR lyrics LIKE '%substring%'  



--7.39 by Reynold
--Give me the list of all people and the count of movies to which 
--they have some association through movie_people;
--If a person doesn’t have any association to any movie, then the COUNT shows 0.
--Original query:
--SELECT 
--	stage_name, 
--	movie_people.people_id,
--	COUNT(movie_id) AS number_of_movies 
--FROM 
--	movie_people 
--	JOIN people WHERE people.people_id = movie_people.people_id 
--GROUP BY 
--	people_id
	
--Showing rows 0 - 24 (40 total, Query took 0.0076 seconds.)

--Optimized Query

SELECT
        people.stage_name,
        movie_people.people_id,
        COUNT(movie_people.movie_id) AS number_of_movies 
    FROM
        movie_people 
    JOIN
        people 
    WHERE
        people.people_id = movie_people.people_id 
    GROUP BY
        movie_people.people_id 
    ORDER BY
        NULL
        
--Showing rows 0 - 24 (40 total, Query took 0.0019 seconds.)
--Attributes were indexed
--ORDER BY added after GROUP BY to prevent unnecessary sorting	
	

--7.40 Mel
-- Give me the list of all people and the count of songs to which they have some association through song_people If a person doesn’t have any association to any song, then do NOT include that person in the result
SELECT
    people.stage_name,
    song_people.people_id,
    COUNT(*)
FROM
    song_people
JOIN people WHERE people.people_id = song_people.people_id
GROUP BY
    people_id



-- 7.40 Alternative
SELECT   stage_name,
         Count(song_id) AS song_count
FROM     song_people
JOIN     people
WHERE    people.people_id = song_people.people_id
GROUP BY song_people.people_id



-- 7.41 Jonathan
-- Given a sub-string (prefix), return the list of all the songs whose title starts with that sub-string (prefix).
SELECT DISTINCT song_id, title
FROM songs
WHERE substring(title, 1, 2) = 'op'



--7.63 Ryan Flanagan
--Given a set of characters and length, get all the movies where these characters are appearing in any order in the native_name.
-- The length of the movie should match  the length specified in movie_numbers table.
--For example, if I specify “f, n” and length as 5, it should return the movies “final” and “funny”
select *
FROM movies
WHERE native_name LIKE '%v%' AND native_name LIKE '%o%' AND
LENGTH(native_name) = 7



-- 7.70 JED 
-- Return the COUNTS from each table in the database (see the Quiz question for example)
SELECT (SELECT Count(native_name)
        FROM   movies) AS movie_count,
        (SELECT Count(anagram)
        FROM movie_anagrams) AS anagram_count,
        (SELECT Count(movie_id)
        FROM movie_data) AS data_count,
        (SELECT Count(keyword)
        FROM movie_keywords) AS keyword_count,
        (SELECT Count(movie_media_id)
        FROM movie_media) AS movie_media_count,
        (SELECT Count(movie_id)
        FROM movie_numbers) AS movie_numbers_count,
        (SELECT Count(people_id)
        FROM movie_people) AS movie_people_count,
        (SELECT Count(movie_quote_id)
        FROM movie_quotes) AS movie_quote_count,
        (SELECT Count(song_id)
        FROM movie_song) AS movie_song_count,
        (SELECT Count(movie_trivia_id)
        FROM movie_trivia) AS movie_trivia_count,
        (SELECT Count(stage_name)
        FROM   people) AS people_count,
        (SELECT Count(people_trivia_id)
        FROM people_trivia) AS people_trivia_count,
        (SELECT Count(title)
        FROM   songs)  AS songs_count,
        (SELECT Count(keyword)
        FROM song_keywords) AS song_keywords_count,
        (SELECT Count(song_media_id)
        FROM song_media) AS song_media_count,
        (SELECT Count(song_id)
        FROM song_people) AS song_people_count,
        (SELECT Count(song_trivia_id)
        FROM song_trivia) AS song_trivia_count

FROM   movies
LIMIT  1



--7.63 Ryan Flanagan
--Given a set of characters and length, get all the movies where these characters are appearing in any order in the native_name.
-- The length of the movie should match  the length specified in movie_numbers table.
--For example, if I specify “f, n” and length as 5, it should return the movies “final” and “funny”
select *
FROM movies
WHERE native_name LIKE '%v%' AND native_name LIKE '%o%' AND
LENGTH(native_name) = 7


