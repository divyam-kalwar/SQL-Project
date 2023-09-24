--Question 1 - Players with high S.R who have faced at least 500 balls.

select batsman,
sum(batsman_runs) as runs,
count(case when extras_type != 'wides' then ball end) as balls_faced,
round((sum(batsman_runs)*100.0/count(case when extras_type != 'wides' then ball end)),2) as strike_rate
from ipl_ball
group by batsman
having count(case when extras_type != 'wides' then ball end)>=500 
order by strike_rate desc limit 10;

--Question 2 - Players with good Average who have played more than 2 ipl seasons.

select a.player_of_match,
count(distinct extract('year' from a.date)) as season_played,
b.total_runs,
b.batsman_dismissed,
round(b.total_runs*1.0/nullif(b.batsman_dismissed,0),2) as average_strike_rate
from ipl_matches as a
join (select batsman, 
	  sum(batsman_runs) as total_runs,
	  count(case when is_wicket != '0' then is_wicket end) as batsman_dismissed
	  from ipl_ball group by batsman)as b 
on a.player_of_match=b.batsman
group by a.player_of_match,b.total_runs,b.batsman_dismissed
having count(distinct extract('year' from date))>2
order by average_strike_rate desc limit 10;

--Question 3 - Hard-hitting players who have scored most runs in boundaries and have played more then 2 ipl season.

select a.player_of_match,
count(distinct extract('year' from date)) as season_played,
b.no_of_boundaries,
b.total_runs,
round(b.no_of_boundaries*100.0/nullif(b.total_runs,0),2)as boundary_percentage
from ipl_matches as a
join (select batsman,
	  count(case when batsman_runs='4' or batsman_runs='6' then batsman_runs end)as no_of_boundaries,
	  sum(batsman_runs) as total_runs	  
	  from ipl_ball group by batsman)as b
on a.player_of_match=b.batsman
group by a.player_of_match,b.no_of_boundaries,b.total_runs
having count(distinct extract('year' from date))>2
order by boundary_percentage desc limit 10;

--Question 4 - Bowlers with good economy who have bowled at least 500 balls in IPL so far.

select bowler as bowler_name,
round(sum(total_runs)/(count(bowler)/6.0), 2) as economy
from ipl_ball
group by bowler
having count(bowler)>=500
order by economy desc limit 10;

--Question 5 - Bowlers with the best strike rate and who have bowled at least 500 balls in IPL so far.

select bowler as bowler_name,
count(bowler)as no_of_balls_bowled,
sum(case when is_wicket != '0' then is_wicket end) as total_wickets,
round(count(bowler)*1.0/sum(case when is_wicket != '0' then is_wicket end),2) as bowler_sr
from ipl_ball
group by bowler
having count(bowler)>=500
order by bowler_sr limit 10;

--Question 6 - All rounders who have faced at least 500 balls in IPL so far and have bowled minimum 300 balls.
select batsman as all_rounder,
round((sum(batsman_runs)*100.0/count(case when extras_type != 'wides' then ball end)),2) as batsman_sr,
b.bowler_sr
from ipl_ball as a
inner join (select bowler,
	round(count(bowler)*1.0/sum(case when is_wicket != '0' then is_wicket end),2) as bowler_sr
	from ipl_ball
	group by bowler
	having count(bowler)>=300
	order by bowler_sr asc) as b
on a.batsman=b.bowler
group by batsman,b.bowler_sr
having count(case when extras_type != 'wides' then ball end)>=500
order by batsman_sr desc,bowler_sr asc limit 10;

--Additional Questions for Final Assessment
create table deliveries as 
(select * from ipl_ball)

create table matches as 
(select * from ipl_matches)

--Question 1
select city,
count(case when city != 'NA' then city end) as host_city
from matches
group by city
order by city;

--Question 2
create table deliveries_v02 as
(
select *,
(case when total_runs>='4' then total_runs else '0' end) as boundaries,
(case when total_runs='0' then 'dot' else '0' end) as dot,
(case when total_runs<'4' then total_runs else '0' end) as total_run
from deliveries
)

select *,(case when total_runs>='4' then 'boundary'
		 	when total_runs='0' then 'dot'
		 	else 'other' end) as ball_result
from deliveries;
select * from deliveries_v02;

--Question 3
select batting_team,
count(case when boundaries>='4' then boundaries end) as total_no_of_boundaries,
count(case when dot='dot' then dot end) as dot_balls
from deliveries_v02
group by batting_team;

--Question 4
select batting_team,
count(case when boundaries>='4' then boundaries end) as total_no_of_boundaries
from deliveries_v02
group by batting_team
order by total_no_of_boundaries desc;

--Question 5
select bowling_team,
count(case when dot='dot' then dot end) as total_no_of_dot_balls
from deliveries_v02
group by bowling_team
order by total_no_of_dot_balls desc;

--Question 6
select 
count(case when dismissal_kind != 'NA' then dismissal_kind end) as total_no_of_dismissal
from deliveries_v02;

--Question 7
select bowler,
sum(extra_runs) as max_extra_runs
from deliveries
group by bowler
order by max_extra_runs desc limit 5;

--Question 8
create table deliveries_v03 as
(
select a.*,
	   b.venue,
       b.date AS match_date
from deliveries_v02 as a
left join (select id,venue,date
		  from matches) as b
on a.id=b.id
)

select * from deliveries_v03;

--Question 9
select venue,
sum(total_runs) as total_runs_venue
from deliveries_v03
group by venue
order by total_runs_venue desc;

--Question 10
select venue,
extract('year' from match_date) as match_dates,
sum(total_runs) as total_runs_scored
from deliveries_v03
where venue='Eden Gardens'
group by extract('year' from match_date),venue
order by total_runs_scored desc;


select count(*) from ipl_ball;