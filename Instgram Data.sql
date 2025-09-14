CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE
);

CREATE TABLE Posts (
    post_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    caption TEXT,
    image_url VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Comments (
    comment_id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Likes (
    like_id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Followers (
    follower_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    follower_user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (follower_user_id) REFERENCES Users(user_id)
);

INSERT INTO Users (name, email, phone_number)
VALUES
    ('John Smith', 'johnsmith@gmail.com', '1234567890'),
    ('Jane Doe', 'janedoe@yahoo.com', '0987654321'),
    ('Bob Johnson', 'bjohnson@gmail.com', '1112223333'),
    ('Alice Brown', 'abrown@yahoo.com', NULL),
    ('Mike Davis', 'mdavis@gmail.com', '5556667777');


INSERT INTO Posts (user_id, caption, image_url)
VALUES
    (1, 'Beautiful sunset', '<https://www.example.com/sunset.jpg>'),
    (2, 'My new puppy', '<https://www.example.com/puppy.jpg>'),
    (3, 'Delicious pizza', '<https://www.example.com/pizza.jpg>'),
    (4, 'Throwback to my vacation', '<https://www.example.com/vacation.jpg>'),
    (5, 'Amazing concert', '<https://www.example.com/concert.jpg>');


INSERT INTO Comments (post_id, user_id, comment_text)
VALUES
    (1, 2, 'Wow! Stunning.'),
    (1, 3, 'Beautiful colors.'),
    (2, 1, 'What a cutie!'),
    (2, 4, 'Aww, I want one.'),
    (3, 5, 'Yum!'),
    (4, 1, 'Looks like an awesome trip.'),
    (5, 3, 'Wish I was there!');

INSERT INTO Likes (post_id, user_id)
VALUES
    (1, 2),
    (1, 4),
    (2, 1),
    (2, 3),
    (3, 5),
    (4, 1),
    (4, 2),
    (4, 3),
    (5, 4),
    (5, 5);

INSERT INTO Followers (user_id, follower_user_id)
VALUES
    (1, 2),
    (2, 1),
    (1, 3),
    (3, 1),
    (1, 4),
    (4, 1),
    (1, 5),
    (5, 1);



SELECT * FROM Users;
SELECT * FROM Posts;
SELECT * FROM Comments;
SELECT * FROM Likes;
SELECT * FROM Followers;

-- Updating the caption of post_id 3
update Posts
set Caption='Best Pizza Ever'
where post_id=3;

-- Selecting all the posts where user_id is 1
SELECT * from posts where User_id=1;

-- Selecting all the posts and ordering them by created_at in descending order
SELECT * FROM posts
ORDER BY created_at DESC;

-- Counting the number of likes for each post and showing only the posts with more than 2 likes

Select p.post_id,count(l.like_id) from Likes l
LEFT JOIN Posts p on l.Post_id= p.Post_id
GROUP BY p.post_id
having count(l.like_id) > 2;


--Finding the total number of likes for all posts
SELECT p.post_id,COUNT (l.like_id) 
FROM Posts p
LEFT JOIN likes l ON p.User_id=l.User_id
Group By p.post_id;

-- Finding all the users who have commented on post_id 1
SELECT name FROM Users
where user_id IN (SELECT User_id from comments where post_id=1)

SELECT U.user_id,U.Name
from Users U
left Join comments C on U.user_id = C.User_Id
where c.post_id=1;

-- Ranking the posts based on the number of likes
with CTE AS (
select count(L.like_id) As Number_Likes,P.Post_id
from likes L
left Join posts P ON L.post_id = P.post_id
Group by P.Post_Id)

select Post_id,Number_Likes,
RANK() OVER(ORDER BY Number_Likes DESC) as Rank_of_Likes
fROM CTE;

-- Finding all the posts and their comments using a Common Table Expression (CTE)

with Comment_Post AS(
Select P.Post_id,P.Caption,C.Comment_Text
From posts P
Left join Comments C on P.Post_id = C.Post_Id)

Select * from Comment_Post;

-- Categorizing the posts based on the number of likes
with CTE AS (
select count(L.like_id) As Number_Likes,P.Post_id
from likes L
left Join posts P ON L.post_id = P.post_id
Group by P.Post_Id)

select Post_id,Number_Likes,

CASE 
WHEN Number_Likes > 2 THEN 'High Engaement'
When Number_Likes <= 2 THEN 'Low Engagement'
ELSE 'Low Like'
END AS Number_of_Likes
fROM CTE;


SELECT Post_id ,N0_of_Likes,
CASE
	WHEN N0_of_Likes = 0 THEN 'NO LIKES'
	WHEN N0_of_Likes <= 2 THEN 'FEW LIKES'
	WHEN N0_of_Likes > 2 THEN 'SOME LIKES'
	ELSE 'NO DATA'
END AS Number_of_Likes 
FROM (
SELECT P.post_id,COUNT(L.Like_Id) as N0_of_Likes 
FROM Likes L
LEFT JOIN Posts P ON L.Post_id = P.Post_id
GROUP BY P.Post_id) AS likes_by_post;


-- Finding all the posts created in the last month

SELECT *
FROM Posts
WHERE created_at >= CAST(DATE_TRUNC('month', CURRENT_TIMESTAMP - INTERVAL '1 month') AS DATE);

--Which users have liked post_id 2?

SELECT U.User_id,U.name,L.Post_id
FROM Users U 
 JOIN Likes L ON L.User_id = U.User_id
Where L.Post_id = 2;

--Which posts have no comments?
SELECT Posts.caption
FROM Posts
LEFT JOIN Comments ON Posts.post_id = Comments.post_id
WHERE Comments.comment_id IS NULL;

--How many likes does each post have?
SELECT P.Post_id,COUNT(S.Like_id)
From Posts p
Join Likes S On P.Post_id = S.Post_id
GROUP BY P.Post_id;

--What is the average number of likes per post
SELECT AVG(Likes_Post)
FROM(
SELECT P.Post_id,COUNT(S.Like_id)As Likes_Post
From Posts p
Join Likes S On P.Post_id = S.Post_id
GROUP BY P.Post_id) As AVERAGE_LIKE








