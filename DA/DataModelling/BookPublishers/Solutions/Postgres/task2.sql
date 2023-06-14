
/****** Object:  Table [dbo].[book_data_list1]    Script Date: 19/01/2023 11:29:19 ******/


CREATE TABLE book_data_list1(
	title varchar(100) NULL,
	author varchar(50) NULL,
	publisher varchar(50) NULL,
	price varchar(50) NULL
);

-- import using util make sure header option is selected

-- confirm data loaded ok
select * from book_data_list1;

-- create book, author and publisher table
drop table if exists book;
create table book(
	book_id int serial primary key,
	title	varchar(100),
	au_id	int,
	pub_id	int,
	price   money
);

drop table if exists author;
create table author(
	au_id int serial primary key,
	name	varchar(50)
);

drop table if exists publisher;
create table publisher(
	pub_id int serial primary key,
	name	varchar(50)
);

insert into author (name)
select distinct author from book_data_list1;
select * from author;

insert into publisher(name)
select distinct publisher from book_data_list1;
select * from publisher;

insert into book ( title, au_id, pub_id, price )
select b.title, a.au_id, p.pub_id, cast(b.price as money)
from book_data_list1 b
inner join
author a
on b.author = a."name"
inner join 
publisher p
on b.publisher = p.name

select * from book;