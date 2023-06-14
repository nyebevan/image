--====================================================================
-- customer has supplied a new list of books with more than one author
-- so we need a bookauthor table with a key of book_id and au_id
-- we use the data import to get another staging table book_data_list2
--====================================================================
if OBJECT_ID('bookauthor') is not null        
	drop table bookauthor;
go
create table bookauthor (
	book_id		int	not null,
	au_id		int	not null,
	constraint pk_book_author
	primary key ( book_id, au_id)
) ;
go
--=======================================================
-- populate new table with existing book and author data
--=======================================================
insert into bookauthor
select b.book_id, a.au_id
from author a
join book b
	on a.au_id = b.au_id;
go
--=======================================================
-- confirm the data is correct by joining the 3 tables
-- 10 rowsno duplicates etc.
--=======================================================
select b.title, a.name, b.price
from book b
join	bookauthor ba
	on b.book_id = ba.book_id
join	author a
	on a.au_id = ba.au_id;
go
--=======================================================
-- technically we no longer need the au_id column in the book table
-- so let's try and delete it...
--=======================================================
alter table book
drop column au_id;
go
select * from book;

--=================================================================
-- now we get the new data set with the books with multiple authors
--=================================================================
select * from book_data_list2;

--=================================================================
-- populate the book and author tables first, then we can add the
-- new book and author primary keys to the book author table
--=================================================================
insert into author
select distinct author, null
from book_data_list2
where author not in ( 
	select name from author
);
go

select name from author;

insert into publisher
select distinct publisher, null as [city]
from book_data_list2
where publisher not in ( 
	select name from publisher
);
go
select * from publisher;

insert into book
select title
	,	p.pub_id
	, case
		when price = 'NULL' then null
		else price
	end as [price]
from book_data_list2 l
join	publisher p
	on l.publisher = p.name
group by title
	,	p.pub_id
	, case
		when price = 'NULL' then null
		else price
	end;
go


--=================================================================
-- now we can populate the bookauthor with the new books and authors
--=================================================================

insert into bookauthor
select b.book_id, a.au_id
from book_data_list2 l
join author a
	on l.author = a.name
join book b
	on l.title = b.title;
go
--=================================================================
-- now join book, bookauthor and author to check it all looks correct!
--=================================================================
select
*
from book b
join bookauthor ba
	on b.book_id = ba.book_id
join author a
	on a.au_id = ba.au_id;
--=================================================================
-- add in the publisher table too...
--=================================================================
select
*
from book b
join bookauthor ba
	on b.book_id = ba.book_id
join author a
	on a.au_id = ba.au_id
join publisher p
	on b.pub_id = p.pub_id;

--=================================================================
-- just display the useful columns
--=================================================================
select
	b.title
	, a.name
	, p.name
	, b.price
from book b
join bookauthor ba
	on b.book_id = ba.book_id
join author a
	on a.au_id = ba.au_id
join publisher p
	on b.pub_id = p.pub_id;

--=================================================================
-- tidy up by removing the duplicate rows and showing author as one column
--=================================================================
select
	b.title
	, string_agg(a.name, ', ') as [authors]
	, p.name
	, b.price
from book b
join bookauthor ba
	on b.book_id = ba.book_id
join author a
	on a.au_id = ba.au_id
join publisher p
	on b.pub_id = p.pub_id
group by b.title, p.name, b.price;
