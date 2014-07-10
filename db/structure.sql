--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: first_agg(anyelement, anyelement); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION first_agg(anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
            SELECT $1;
          $_$;


--
-- Name: first(anyelement); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE first(anyelement) (
    SFUNC = first_agg,
    STYPE = anyelement
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: authors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE authors (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying(255)
);


--
-- Name: authors_books; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE authors_books (
    id integer NOT NULL,
    author_id integer,
    book_id integer
);


--
-- Name: authors_books_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authors_books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authors_books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authors_books_id_seq OWNED BY authors_books.id;


--
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authors_id_seq OWNED BY authors.id;


--
-- Name: books; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE books (
    id integer NOT NULL,
    filename text,
    name text,
    thumbnail character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    file character varying(255)
);


--
-- Name: books_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE books_categories (
    id integer NOT NULL,
    book_id integer,
    category_id integer
);


--
-- Name: books_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE books_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: books_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE books_categories_id_seq OWNED BY books_categories.id;


--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE books_id_seq OWNED BY books.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: tsvector_search_documents; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW tsvector_search_documents AS
 SELECT bk.id,
    (((setweight(to_tsvector('english'::regconfig, COALESCE(first(bk.name), ''::text)), 'A'::"char") || setweight(to_tsvector('english'::regconfig, COALESCE(first(bk.filename), ''::text)), 'B'::"char")) || setweight(to_tsvector('english'::regconfig, COALESCE(string_agg((c.name)::text, ' '::text), ''::text)), 'C'::"char")) || setweight(to_tsvector('english'::regconfig, COALESCE(string_agg((a.name)::text, ' '::text), ''::text)), 'D'::"char")) AS document
   FROM ((((books bk
   LEFT JOIN books_categories bc ON ((bc.book_id = bk.id)))
   LEFT JOIN categories c ON ((bc.category_id = bc.id)))
   LEFT JOIN authors_books ab ON ((ab.book_id = bk.id)))
   LEFT JOIN authors a ON ((ab.author_id = ab.id)))
  GROUP BY bk.id
  WITH NO DATA;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY authors ALTER COLUMN id SET DEFAULT nextval('authors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY authors_books ALTER COLUMN id SET DEFAULT nextval('authors_books_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY books ALTER COLUMN id SET DEFAULT nextval('books_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY books_categories ALTER COLUMN id SET DEFAULT nextval('books_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: authors_books_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY authors_books
    ADD CONSTRAINT authors_books_pkey PRIMARY KEY (id);


--
-- Name: authors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: books_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY books_categories
    ADD CONSTRAINT books_categories_pkey PRIMARY KEY (id);


--
-- Name: books_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: index_authors_books_on_author_id_and_book_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authors_books_on_author_id_and_book_id ON authors_books USING btree (author_id, book_id);


--
-- Name: index_authors_books_on_book_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authors_books_on_book_id ON authors_books USING btree (book_id);


--
-- Name: index_books_categories_on_book_id_and_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_books_categories_on_book_id_and_category_id ON books_categories USING btree (book_id, category_id);


--
-- Name: index_books_categories_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_books_categories_on_category_id ON books_categories USING btree (category_id);


--
-- Name: index_tsvector_search_documents_on_document; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tsvector_search_documents_on_document ON tsvector_search_documents USING gin (document);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140709162209');

INSERT INTO schema_migrations (version) VALUES ('20140709173504');

INSERT INTO schema_migrations (version) VALUES ('20140709181019');

INSERT INTO schema_migrations (version) VALUES ('20140709181151');

INSERT INTO schema_migrations (version) VALUES ('20140709181456');

INSERT INTO schema_migrations (version) VALUES ('20140709181636');

INSERT INTO schema_migrations (version) VALUES ('20140709182801');

INSERT INTO schema_migrations (version) VALUES ('20140710062223');

