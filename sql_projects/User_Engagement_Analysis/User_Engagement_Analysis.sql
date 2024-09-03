--Create table posts and user_reactions----

Create table posts(
post_id int primary key,
post_content varchar(max),
post_date datetime)


Insert into posts(post_id,post_content,post_date)
values (1,'Lorem ipsum dolor sit amet...','2023-08-25 11:00:00'),
    (2, 'Exploring the beauty of nature...', '2023-08-26 15:30:00'),
   (3, 'Unveiling the latest tech trends...', '2023-08-27 12:00:00'),
   (4, 'Journey into the world of literature...', '2023-08-28 09:45:00'),
    (5, 'Capturing the essence of city life...', '2023-08-29 16:20:00')

Create table user_reactions(
reaction_id int primary key,
userid int,
post_id int,
constraint fk_postid foreign key(post_id) references posts(post_id),
reaction_type varchar(10),
constraint chk_recationtype check (reaction_type in ('like','comment','share')),
reaction_date datetime)

Insert into user_reactions 
values
    (1, 101, 1, 'like', '2023-08-25 10:15:00'),
    (2, 102, 1, 'comment', '2023-08-25 11:30:00'),
    (3, 103, 1, 'share', '2023-08-26 12:45:00'),
    (4, 101, 2, 'like', '2023-08-26 15:45:00'),
    (5, 102, 2, 'comment', '2023-08-27 09:20:00'),
    (6, 104, 2, 'like', '2023-08-27 10:00:00'),
    (7, 105, 3, 'comment', '2023-08-27 14:30:00'),
    (8, 101, 3, 'like', '2023-08-28 08:15:00'),
    (9, 103, 4, 'like', '2023-08-28 10:30:00'),
    (10, 105, 4, 'share', '2023-08-29 11:15:00'),
    (11, 104, 5, 'like', '2023-08-29 16:30:00'),
    (12, 101, 5, 'comment', '2023-08-30 09:45:00')

--Retrieve the comprehensive count of likes, comments, and shares garnered by posts identified by its unique post ID--

Select p.post_id,
p.post_content,
Count(Case when r.reaction_type='like' then 1 end) as num_likes,
Count(Case when r.reaction_type='comment' then 1 end) as num_comments,
Count(Case when r.reaction_type='share' then 1 end) as num_shares
from posts p
left join user_reactions r
on p.post_id=r.post_id
group by p.post_id,p.post_content

--Calculating the mean number of reactions, encompassing likes, comments, and shares, per distinct user.---

Select cast(reaction_date as date) as reaction_day,
Count(distinct(userid)) as usercount,
Count(*) as total_reactions,
Avg(count(*)) over (partition by cast(reaction_date as date)) as avg_reactions_per_user
from user_reactions
group by cast(reaction_date as date)

--Identify the three most engaging posts, measured by the aggregate sum of reactions, within the preceding week.--

Select top(3) p.post_id,
p.post_content,
Count(Case when r.reaction_type='like' then 1 end)+
Count(Case when r.reaction_type='comment' then 1 end)+
Count(Case when r.reaction_type='share' then 1 end) as total_reactions
from posts p
left join user_reactions r
on p.post_id=r.post_id
--where cast(reaction_date as date) between DATEADD(WEEK, -1, GETDATE()) and GETDATE()
group by p.post_id,p.post_content
order by total_reactions desc





