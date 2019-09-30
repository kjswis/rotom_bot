--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5
-- Dumped by pg_dump version 11.5

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
-- Name: characters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.characters (
    id integer NOT NULL,
    user_id character varying(50),
    name character varying NOT NULL,
    species character varying NOT NULL,
    types character varying NOT NULL,
    age character varying,
    weight character varying,
    height character varying,
    gender character varying,
    orientation character varying,
    relationship character varying,
    attacks character varying,
    likes character varying,
    dislikes character varying,
    personality character varying,
    backstory character varying,
    other character varying,
    edit_url character varying,
    active character varying,
    dm_notes character varying,
    location character varying,
    rumors character varying
);


--
-- Name: characters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.characters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.characters_id_seq OWNED BY public.characters.id;


--
-- Name: urls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.urls (
    id integer NOT NULL,
    char_id integer NOT NULL,
    category character varying,
    keyword character varying,
    url character varying NOT NULL
);


--
-- Name: urls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urls_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.urls_id_seq OWNED BY public.urls.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id character varying(25) NOT NULL,
    level integer DEFAULT 1,
    next_level integer DEFAULT 22,
    boosted_xp integer DEFAULT 0,
    unboosted_xp integer DEFAULT 0,
    evs character varying(50) NOT NULL,
    hp integer NOT NULL,
    attack integer NOT NULL,
    defense integer NOT NULL,
    sp_attack integer NOT NULL,
    sp_defense integer NOT NULL,
    speed integer NOT NULL
);


--
-- Name: characters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters ALTER COLUMN id SET DEFAULT nextval('public.characters_id_seq'::regclass);


--
-- Name: urls id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urls ALTER COLUMN id SET DEFAULT nextval('public.urls_id_seq'::regclass);


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.characters (id, user_id, name, species, types, age, weight, height, gender, orientation, relationship, attacks, likes, dislikes, personality, backstory, other, edit_url, active, dm_notes, location, rumors) FROM stdin;
1	215240568245190656	Mizukyu	Mimikyu	Ghost Fairy	old	1.5 lbs	0'8"	Female	Pansexual	Married	Shadow Claw | Play Rough | Psychic | Shadow Sneak	cuddles, soft things, and Neiro waterbed	bullies, rejection, being exposed	I am shy and a bit recluse, but warm when you take the time to get to know me. I don't like when people try to see under my disguise, I've lost many friends that way (to death) including my spouse. Really, really really likes to dress up as other pokemon	Has existed more years than she cares to count. She is immortal, due to being a ghost. She has learned to carefully hide her appearance as to make sure not to accidentally kill more friends. Took up tailoring to make multiple disguises, because pretending to be a Pikachu forever is boring.	Switches disguising with moods. Has made them for all pokemon. Also a master shadow bender	?edit2=2_ABaOnuc3HZEyhI9EeApXcJtsBmDzqtzDGH5De46CfuRBxwVavQKAfTT_LZy_kMH0sz5H7gk	Active	\N	\N	loves children | hates washing and tailoring disguises | surprisingly soft| steals children | wishes to be admired
\.


--
-- Data for Name: urls; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.urls (id, char_id, category, keyword, url) FROM stdin;
1	1	sfw	primary	https://i.kym-cdn.com/photos/images/original/001/194/272/043.png
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, level, next_level, boosted_xp, unboosted_xp, evs, hp, attack, defense, sp_attack, sp_defense, speed) FROM stdin;
271741998321369088	70	25550	25285	18368	24, 4, 5, 5, 6, 5	432	127	128	143	145	136
215240568245190656	30	4950	4686	984	23, 4, 6, 6, 4, 5	201	67	67	69	62	64
263878163975634947	17	1702	1675	1227	19, 5, 4, 5, 6, 4	113	39	41	39	42	38
\.


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.characters_id_seq', 1, true);


--
-- Name: urls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.urls_id_seq', 1, true);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: urls urls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urls
    ADD CONSTRAINT urls_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: characters character_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT character_user_id FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: urls url_character_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urls
    ADD CONSTRAINT url_character_id FOREIGN KEY (char_id) REFERENCES public.characters(id);


--
-- PostgreSQL database dump complete
--

