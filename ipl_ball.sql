create table ipl_ball
(id int,
 inning	int,
 over int,
 ball int,
 batsman varchar(255),
 non_striker varchar(255),
 bowler	varchar(255),
 batsman_runs int,
 extra_runs	int,
 total_runs	int,
 is_wicket int,
 dismissal_kind varchar(255),	
 player_dismissed varchar(255),
 fielder varchar(255),
 extras_type varchar(255),
 batting_team varchar(255),
 bowling_team varchar(255)
);

select * from ipl_ball;