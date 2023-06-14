--===========================================
-- create book table
--===========================================
if OBJECT_ID('book') is not null
	drop table book;
go
create table book (
	book_id		int primary key identity,
	title		varchar(100)	not null,
	au_id		int			not null,
	pub_id		int			not null,
	price		money		null
);
go
--===========================================
-- create author table
--===========================================
if OBJECT_ID('author') is not null
	drop table author
create table author (
	au_id		int	primary key identity,
	name		varchar(50)	not null,
	contact		varchar(50) null
);
go
--===========================================
-- create publisher table
--===========================================
if OBJECT_ID('publisher') is not null
	drop table publisher
create table publisher (
	pub_id		int primary key identity,
	name		varchar(50)	not null,
	contact		varchar(50) null		
);
go
--===========================================
-- populate tables from staging table
-- we use the 'import data' utility to do this
-- make sure the '"' is used as the string delimiter
-- also the title is changed to 100 characters
-- otherwise the import fails
-- once we have the staging table book_data_list1
-- we use it to populate our new tables with the relevant data
--===========================================

--===========================================
-- author
--===========================================
insert into author
select distinct author, null
from book_data_list1;

select * from author;
go
--===========================================
-- publisher
--===========================================
insert into publisher
select distinct publisher, null
from book_data_list1;

select * from publisher;
go
--===========================================
-- book
--===========================================
insert into book
select title
	,	a.au_id
	,	p.pub_id
	, case
		when price = 'NULL' then null	-- the csv file had the word 'NULL' not the db null!
		else price
	end
	
from book_data_list1 l
join	author a
	on l.author = a.name
join	publisher p
	on l.publisher = p.name;

select * from book;
go