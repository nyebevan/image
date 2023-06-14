create table learner (
	id	int identity primary key
	, name varchar(10)
)
insert into learner
select name from LearnerStage

select * from learner

create table module ( 
	id int identity primary key
	, code varchar(20)
	, name varchar(50)
	, length int
)

insert into module
select code, name, F3 from ModuleStage

select * from module

drop table programme
create table programme (
	id int identity primary key
	, code	char(2)
	, name	varchar(30)
)

select * from programme
insert into programme
select code, name from ProgrammeStage

drop table event
create table event (
	id	int identity primary key
	, date datetime not null
	, module	int
	foreign key references module (id )
	, programme int
	foreign key references programme (id )
)

insert into event
select Date, m.id, p.id
from EventStage es
	inner join module m
		on es.Module = m.code
	inner join programme p
		on es.Programme = p.code

select * from event

-- now to link learner to event
-- first we need a cohort table and a learner_cohort table

drop table cohort
create table cohort ( 
	id char(4) primary key not null
	, name	varchar(30) not null
)

insert into cohort
select c.Code, p.name
from CohortStage c
inner join programme p
on p.name = c.Programme

select * from cohort

create table learner_cohort (
	cohort_id	char(4) not null
	foreign key references cohort ( id )
	, learner_id	int not null
	foreign key references learner ( id )

)

--insert into learner_cohort
--select 
--from ['DenormalisedAdvanced'] d
--inner join learner l
--	on d.Learner = l.name
--inner join cohort c
--	on c.



create table learner_event (
	learner_id int not null
	foreign key references learner ( id)
	,event_id int not null
	foreign key references event ( id )
	primary key ( learner_id, event_id )
)

insert into learner_event
select 
from 
	EventStage es inner join learner l
	on es.