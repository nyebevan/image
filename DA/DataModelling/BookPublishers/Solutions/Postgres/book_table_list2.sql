-- Table: public.book_data_list1

-- DROP TABLE IF EXISTS public.book_data_list1;

CREATE TABLE IF NOT EXISTS public.book_data_list2
(
    title character varying(100) COLLATE pg_catalog."default",
    author character varying(50) COLLATE pg_catalog."default",
    publisher character varying(50) COLLATE pg_catalog."default",
    price character varying(50) COLLATE pg_catalog."default"
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.book_data_list1
    OWNER to postgres;