-- script to create and insert data for my data model for Kaplan 

--drop all foreign key constraints
if OBJECT_ID ( 'event') is not null 
	alter table event
		drop
			constraint fk_event_module,
			constraint fk_event_programme,
			constraint fk_event_cohort

if OBJECT_ID ( 'cohort') is not null 
	alter table event
		drop
			constraint fk_cohort_programme
			
if OBJECT_ID ( 'learner') is not null 
	alter table learner
		drop
			constraint fk_learner_cohort

--alter table event
--drop constraint 

-- programme table
if OBJECT_ID ( 'programme') is not null 
	drop table programme

create table programme (
	id char(3) primary key
	, name	varchar(30)
)

insert into programme
select Code, Name
from ProgrammeStage

select * from programme

-- cohort table
if OBJECT_ID ( 'cohort') is not null 
	drop table cohort

create table cohort (
	id char(4) primary key
	, programme_id	char(3)
)

alter table cohort
add
	constraint fk_cohort_programme
	foreign key ( programme_id)
	references programme (id)

insert into cohort
select c.Code, p.id
from CohortStage c inner join programme p
	on c.Programme = p.name

select * from cohort

-- learner table
if OBJECT_ID ( 'learner') is not null 
	drop table learner

create table learner (
	id	int	identity primary key
	, name	varchar(20)
	, cohort_id	char(4)
)

alter table learner
add
	constraint fk_learner_cohort
	foreign key ( cohort_id)
	references cohort (id)

insert into learner
select ls.Name, ls.Cohort
from LearnerStage ls

select * from learner

select l.name,p.name  from learner l
inner join cohort c
	on l.cohort_id = c.id
inner join programme p
	on c.programme_id = p.id

-- create module table
if OBJECT_ID ( 'module') is not null 
	drop table module

create table module (
	id	int	identity primary key
	, code varchar(20)
	, name varchar(50)
	, length int
)

insert into module
select * from ModuleStage

select * from module

-- how to get data from another databse...
--select * from Metis_SQL.dbo.activities

-- create event table
if OBJECT_ID ( 'event') is not null 
	drop table event

create table event ( 
	id	int	identity	primary key
	, date	datetime	not null
	, module_id	int		not null
	, programme_id	char(3)	not null
	, cohort_id char(4)		not null
)

alter table event
add
	constraint fk_event_module
	foreign key ( module_id)
	references module (id),

	constraint fk_event_programme
	foreign key ( programme_id )
	references programme ( id),

	constraint fk_event_cohort
	foreign key ( cohort_id )
	references cohort ( id)

insert into event
select e.Date, m.id, p.id, c.id	-- this returns too many rows duplicates 
from EventStage e 
	inner join module m
		on e.Module = m.code
	inner join programme p
		on e.Programme = p.id
	inner join cohort c
		on p.id = c.programme_id
--=================================
select convert ( varchar(13), e.Date , 103 )
	,m.id
	--,p.id
	--,c.id
from EventStage e 
	left join module m
		on e.Module = m.code
	--inner join programme p
	--	on e.Programme = p.id
	--inner join cohort c
	--	on p.id = c.programme_id
--=================================

select * from EventStage
select * from event


-- write query to denormalise the data to the basic view 
select e.date, m.name, l.name, p.name
from event e 
	inner join module m
		on e.module_id = m.id
	inner join programme p
		on e.programme_id = p.id
	inner join cohort c
		on e.cohort_id = c.id
	inner join learner l
		on c.id = l.cohort_id

-- write query to denormalise the data to the advanced view 
select e.date as [Start Date]
	, DATENAME(dw,e.date)	as	[Start Day]
	, DATEADD(dd,m.length - 1, e.date)	 as	[End Date]
	, DATENAME(dw,DATEADD(dd,m.length - 1, e.date))	as	[End Day]
	, m.name	as	Module
	, l.name	as	Learner
	, c.id		as	Cohort 
	, p.name	as	Programme
--	, t.name	as	Tutor
from event e 
	inner join module m
		on e.module_id = m.id
	inner join programme p
		on e.programme_id = p.id
	inner join cohort c
		on e.cohort_id = c.id
	inner join learner l
		on c.id = l.cohort_id

-- missing tutor so lets re-engineer the model...

-- create tutor table
if OBJECT_ID ( 'tutor') is not null 
	drop table tutor

create table tutor (
	id			int		identity	primary key
	, fname		varchar(30)	not null
	, lname		varchar(30)	not null
)

insert tutor
select * from TutorStage

select * from tutor

-- need to update event table with a reference to the tutor id
alter table event 
add tutor_id int
foreign key references tutor ( id)

select * from event

update event 
set tutor_id = t.id
from 
	event e
	inner join DenormalisedAdvanced d
		on e.date = d.[Start Date]
	inner join tutor t
		on d.Tutor = t.fname + ' ' + t.lname

-- now add tutor table to join
select e.date as [Start Date]
	, DATENAME(dw,e.date)	as	[Start Day]
	, DATEADD(dd,m.length - 1, e.date)	 as	[End Date]
	, DATENAME(dw,DATEADD(dd,m.length - 1, e.date))	as	[End Day]
	, m.name	as	Module
	, l.name	as	Learner
	, c.id		as	Cohort 
	, p.name	as	Programme
	, t.fname + ' ' + t.lname	as	Tutor
from event e 
	inner join module m
		on e.module_id = m.id
	inner join programme p
		on e.programme_id = p.id
	inner join cohort c
		on e.cohort_id = c.id
	inner join learner l
		on c.id = l.cohort_id
	inner join tutor t
		on e.tutor_id = t.id