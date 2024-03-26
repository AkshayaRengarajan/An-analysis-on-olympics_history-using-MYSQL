create database olympic;
use olympic;
create table olympics_history(
	ID int,
    Name varchar(100),
    Sex varchar(100),
    Age varchar(100),
    Height varchar(100),
    Weight varchar(100),
    Team varchar(100),
    NOC varchar(100),
    Games varchar(100),
    Year int,
    Season varchar(100),
    City varchar(100),
    Sport varchar(100),
    Event varchar(100),
    Medal varchar(100)
    );
    
    create table noc_details(
			noc varchar(100),
			region varchar(100),
			notes varchar(100)
            );

-- QUESTIONS FOR ANALYZING SQL QUERIES--

-- 1.Finding the total number of athletes who participated in each Olympic game
     SELECT games, COUNT(DISTINCT id) AS num_athletes
     FROM OLYMPICS_HISTORY
     GROUP BY games
	 ORDER BY games;

-- 2.How many olympics games have been held?
        select count(distinct games)as total_games from olympics_history;

-- 3.List down all Olympics games held so far.
        select distinct year, season,city from olympics_history;

-- 4.Mention the total no of nations who participated in each olympics game?
        select count(distinct(noc)), year,season from olympics_history group by year,season;
        
-- 5.Identify the sport which was played in all summer olympics.
	 select distinct Sport
     from olympics_history
     where Games like '%Summer%';
     
-- 6.Which Sports were just played only once in the olympics?
    select  Sport, count(distinct (Games)) as count_in_games
	from olympics_history
    group by  Sport
    having count( distinct (Games)) = 1;
    
-- 7.Fetch the total no of sports played in each olympic games.
    select count(distinct sport) as no_sports, games from olympics_history group by games;
    
-- 8.Fetch details of the oldest athletes to win a gold medal.
      select distinct * from (
      select *,dense_rank() over(order by age desc) rnk from olympics_history  where medal='Gold' and age !='NA' order by age desc
			) t1 where rnk=1;
            
-- 9.Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
	select name,team,count(1) from olympics_history where medal<>'NA' group by name,team order by count(1) desc limit 5;
    
-- 10.Predict the  winning a medal based on age, height, weight, and sport
	   SELECT age, height, weight, sport, 
       CASE WHEN medal IS NOT NULL THEN 1 ELSE 0 END AS medal_won
       FROM olympics_history;
       
-- 11.List down total gold, silver and broze medals won by each country corresponding to each olympic games.
			  select nd.region,oh.games,sum(case when medal='Gold' then 1 else 0 end) Gold,
			  sum(case when medal='Silver' then 1 else 0 end) Silver,
			  sum(case when medal='Bronze' then 1 else 0 end) Bronze 
			  from noc_details nd join olympics_history oh on oh.noc=nd.noc 
			  group by nd.region,oh.games order by games,Gold desc;
              
-- 12.Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
      select team,count(1)from olympics_history where medal<>'NA' group by team order by count(1) desc limit 5;      