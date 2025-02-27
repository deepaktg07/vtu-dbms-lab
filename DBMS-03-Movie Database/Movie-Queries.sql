
--List the titles of all movies directed by ‘Hitchcock’.

SELECT MOV_TITLE
FROM MOVIES
WHERE DIR_ID = (SELECT DIR_ID
FROM DIRECTOR
WHERE DIR_NAME='HITCHCOCK');

---------------------------------

--Find the movie names where one or more actors acted in two or more movies.

SELECT M.MOV_TITLE
FROM MOVIES M
JOIN MOVIE_CAST MC ON M.MOV_ID = MC.MOV_ID
WHERE MC.ACT_ID IN (
    SELECT ACT_ID
    FROM MOVIE_CAST
    GROUP BY ACT_ID
    HAVING COUNT(ACT_ID) > 1
);

--------------------------------

--List all actors who acted in a movie before 2000 and also in a movie after 2015 (use JOIN operation).

SELECT ACT_NAME
FROM ACTOR A
JOIN MOVIE_CAST C
ON A.ACT_ID=C.ACT_ID
JOIN MOVIES M
ON C.MOV_ID=M.MOV_ID
WHERE M.MOV_YEAR NOT BETWEEN 2000 AND 2015;

--------------------------------

--Find the title of movies and number of stars for each movie that has at least one rating 
--and find the highest number of stars that movie received. Sort the result by
--movie title.

SELECT M.Mov_Title, MAX(R.Rev_Stars) AS MaxStars
FROM MOVIES M
JOIN RATING R ON M.Mov_id = R.Mov_id
GROUP BY M.Mov_Title
ORDER BY M.Mov_Title;

---------------------------------

--Update rating of all movies directed by ‘Steven Spielberg’ to 5.

UPDATE RATING
SET REV_STARS=5
WHERE MOV_ID IN (SELECT MOV_ID FROM MOVIES
WHERE DIR_ID IN (SELECT DIR_ID
FROM DIRECTOR
WHERE DIR_NAME='STEVEN SPIELBERG'));
