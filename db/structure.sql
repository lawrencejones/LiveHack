--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: hackathons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hackathons (
    id integer NOT NULL,
    eid character varying(255),
    name character varying(255),
    start character varying(255),
    "end" character varying(255),
    location character varying(255),
    description text,
    users_id integer,
    teams_id integer,
    schedule_items_id integer,
    proposals_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hackathons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hackathons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hackathons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hackathons_id_seq OWNED BY hackathons.id;


--
-- Name: hackathons_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hackathons_users (
    hackathon_id integer,
    user_id integer
);


--
-- Name: proposals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE proposals (
    id integer NOT NULL,
    "desc" character varying(255),
    name character varying(255),
    skills character varying(255),
    team_id integer,
    hackathon_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: proposals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE proposals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: proposals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE proposals_id_seq OWNED BY proposals.id;


--
-- Name: schedule_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schedule_items (
    id integer NOT NULL,
    label character varying(255),
    hackathon_id integer,
    icon_class character varying(255),
    start_time character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schedule_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schedule_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedule_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE schedule_items_id_seq OWNED BY schedule_items.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teams (
    id integer NOT NULL,
    name character varying(255),
    hackathon_id integer,
    users_id integer,
    proposals_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(255),
    name character varying(255),
    email character varying(255),
    github_email character varying(255),
    tags character varying(255),
    signed_up boolean,
    hackathons_id integer,
    teams_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hackathons ALTER COLUMN id SET DEFAULT nextval('hackathons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY proposals ALTER COLUMN id SET DEFAULT nextval('proposals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule_items ALTER COLUMN id SET DEFAULT nextval('schedule_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: hackathons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hackathons
    ADD CONSTRAINT hackathons_pkey PRIMARY KEY (id);


--
-- Name: proposals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY proposals
    ADD CONSTRAINT proposals_pkey PRIMARY KEY (id);


--
-- Name: schedule_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schedule_items
    ADD CONSTRAINT schedule_items_pkey PRIMARY KEY (id);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_hackathons_on_proposals_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hackathons_on_proposals_id ON hackathons USING btree (proposals_id);


--
-- Name: index_hackathons_on_schedule_items_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hackathons_on_schedule_items_id ON hackathons USING btree (schedule_items_id);


--
-- Name: index_hackathons_on_teams_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hackathons_on_teams_id ON hackathons USING btree (teams_id);


--
-- Name: index_hackathons_on_users_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hackathons_on_users_id ON hackathons USING btree (users_id);


--
-- Name: index_hackathons_users_on_hackathon_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hackathons_users_on_hackathon_id_and_user_id ON hackathons_users USING btree (hackathon_id, user_id);


--
-- Name: index_hackathons_users_on_user_id_and_hackathon_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hackathons_users_on_user_id_and_hackathon_id ON hackathons_users USING btree (user_id, hackathon_id);


--
-- Name: index_proposals_on_hackathon_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_proposals_on_hackathon_id ON proposals USING btree (hackathon_id);


--
-- Name: index_proposals_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_proposals_on_team_id ON proposals USING btree (team_id);


--
-- Name: index_schedule_items_on_hackathon_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_schedule_items_on_hackathon_id ON schedule_items USING btree (hackathon_id);


--
-- Name: index_teams_on_hackathon_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_on_hackathon_id ON teams USING btree (hackathon_id);


--
-- Name: index_teams_on_proposals_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_on_proposals_id ON teams USING btree (proposals_id);


--
-- Name: index_teams_on_users_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_on_users_id ON teams USING btree (users_id);


--
-- Name: index_users_on_hackathons_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_hackathons_id ON users USING btree (hackathons_id);


--
-- Name: index_users_on_teams_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_teams_id ON users USING btree (teams_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20130501092823');

INSERT INTO schema_migrations (version) VALUES ('20130501093301');

INSERT INTO schema_migrations (version) VALUES ('20130501093503');

INSERT INTO schema_migrations (version) VALUES ('20130501093637');

INSERT INTO schema_migrations (version) VALUES ('20130501093723');

INSERT INTO schema_migrations (version) VALUES ('20130501190314');