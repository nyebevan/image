-- check data imported
select * from DataBasic

-- remove any constraints to avoid issues when deleting tables
if object_id('fk_module') is not null
	alter table event
	drop constraint fk_module
if object_id('fk_programme') is not null
	alter table event
	drop constraint fk_programme

-- create module table should contain list of courses Module column from Import
if object_id('module') is not null
	drop table module
create table module ( 
	id int identity primary key
	, name varchar(50)
)

insert into module
select Distinct Module from DataBasic

select * from module

-- create programme table should contain Data Technican & Data Analyst
if object_id('programme') is not null
	drop table programme
create table programme (
	id int identity primary key
	, name	varchar(30)
)

insert into programme
select distinct Programme from DataBasic

-- create learner table should contain list of learners Learner column from Import
if object_id('learner') is not null
	drop table learner
create table learner (
	id	int identity primary key
	, name varchar(10)
	, prog_id int
)

insert into learner
select distinct Learner, p.id from DataBasic s
join programme p
on s.Programme = p.name

select * from learner

-- create event table should contain date, module & programme
if object_id('event') is not null
	drop table event
create table event (
	id	int identity primary key
	, date datetime not null
	, module	int
	constraint fk_module foreign key  references module (id )
	, programme int
	constraint fk_programme foreign key  references programme (id )
)

insert into event
select distinct [Start Date], m.id, p.id
from DataBasic s
	inner join module m
		on s.Module = m.name
	inner join programme p
		on s.Programme = p.name

select * from event

-- now to link learner to event
-- first we need a learner event table to link event (course) with a learner
if object_id('learner_event') is not null
	drop table learner_event
create table learner_event ( 
	learner_id int not null,
	event_id	int not null,
	primary key ( learner_id, event_id)
)

insert into learner_event
select l.id, e.id
from DataBasic s
inner join event e
on s.[Start Date] = e.date
inner join learner l
on s.Learner = l.name


-- now build sql to create the normalised list as per the workbook
-- show date, learner name, module (course) and programme
-- requires a 5 table join to link all tables together and show relevant info
select e.date, l.name, m.name, p.name 
from event e
join learner_event le
	on e.id = le.event_id
join learner l
	on l.id = le.learner_id
join programme p
	on e.programme = p.id
join module m
	on e.module = m.id
order by date


