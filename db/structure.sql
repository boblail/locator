SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: counties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.counties (
    fips bigint NOT NULL,
    state_fips integer,
    name character varying
);


--
-- Name: counties_fips_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.counties_fips_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: counties_fips_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.counties_fips_seq OWNED BY public.counties.fips;


--
-- Name: county_monthly_weather_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.county_monthly_weather_values (
    id bigint NOT NULL,
    fips integer,
    month date,
    min_temperature numeric,
    max_temperature numeric
);


--
-- Name: county_monthly_weather_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.county_monthly_weather_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: county_monthly_weather_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.county_monthly_weather_values_id_seq OWNED BY public.county_monthly_weather_values.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.states (
    fips bigint NOT NULL,
    abbreviation character varying,
    name character varying
);


--
-- Name: states_fips_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.states_fips_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_fips_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.states_fips_seq OWNED BY public.states.fips;


--
-- Name: counties fips; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.counties ALTER COLUMN fips SET DEFAULT nextval('public.counties_fips_seq'::regclass);


--
-- Name: county_monthly_weather_values id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.county_monthly_weather_values ALTER COLUMN id SET DEFAULT nextval('public.county_monthly_weather_values_id_seq'::regclass);


--
-- Name: states fips; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states ALTER COLUMN fips SET DEFAULT nextval('public.states_fips_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: counties counties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.counties
    ADD CONSTRAINT counties_pkey PRIMARY KEY (fips);


--
-- Name: county_monthly_weather_values county_monthly_weather_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.county_monthly_weather_values
    ADD CONSTRAINT county_monthly_weather_values_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: states states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT states_pkey PRIMARY KEY (fips);


--
-- Name: index_county_monthly_weather_values_on_fips_and_month; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_county_monthly_weather_values_on_fips_and_month ON public.county_monthly_weather_values USING btree (fips, month);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210820133803'),
('20210820141135'),
('20210820142134');


