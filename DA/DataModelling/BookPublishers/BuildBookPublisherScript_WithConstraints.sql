--======================================================================
-- try and insert exisitng row into titleauthor table
--======================================================================
select top 1 * from bookauthor

select ba.book_id, ba.au_id, b.title, a.name
from bookauthor ba
left join	author a
	on ba.au_id = a.au_id
left join	book b
	on b.book_id = ba.book_id

insert into bookauthor
values ( 1, 7)

--======================================================================
-- try and insert non existent book or author row into titleauthor table
--======================================================================
insert into bookauthor
values ( 111, 77)

insert into bookauthor
values ( 1, 77)

insert into bookauthor
values ( 111, 7)

select * from bookauthor

delete from bookauthor
where book_id = 111
or au_id = 77

alter table bookauthor
add constraint fk_book
foreign key ( book_id)
references book ( book_id)

--alter table bookauthor
--drop constraint fk_book

alter table bookauthor
add constraint fk_author
foreign key ( au_id)
references author ( au_id)

--delete from author
--where au_id = 7

--===============================================================================
-- pub_id is a foreign key in the book table so we should add that constraint too
--===============================================================================

alter table book
add constraint fk_pub
foreign key ( pub_id )
references publisher ( pub_id )


