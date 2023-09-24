create table ipl_matches
(id int,
 city varchar(255),
 date date,
 player_of_match varchar(255),
 venue varchar(255),
 neutral_venue int,
 team1 varchar(255),
 team2 varchar(255),
 toss_winner varchar(255),
 toss_decision varchar(255),
 winner varchar(255),
 result varchar(255),
 result_margin int,
 eliminator varchar(255),
 method varchar(255),
 umpire1 varchar(255),
 umpire2 varchar(255)
);

select * from ipl_matches;