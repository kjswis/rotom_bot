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
-- Name: carousels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.carousels (
    id integer NOT NULL,
    message_id character varying(50) NOT NULL,
    char_id integer,
    options integer[],
    image_id integer
);


--
-- Name: carousels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.carousels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: carousels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.carousels_id_seq OWNED BY public.carousels.id;


--
-- Name: char_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.char_images (
    id integer NOT NULL,
    char_id integer NOT NULL,
    url character varying NOT NULL,
    category character varying,
    keyword character varying
);


--
-- Name: char_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.char_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: char_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.char_images_id_seq OWNED BY public.char_images.id;


--
-- Name: char_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.char_statuses (
    id integer NOT NULL,
    char_id integer NOT NULL,
    status_id integer NOT NULL,
    amount integer
);


--
-- Name: char_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.char_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: char_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.char_statuses_id_seq OWNED BY public.char_statuses.id;


--
-- Name: char_teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.char_teams (
    id integer NOT NULL,
    team_id integer NOT NULL,
    char_id integer NOT NULL,
    active boolean DEFAULT true
);


--
-- Name: char_teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.char_teams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: char_teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.char_teams_id_seq OWNED BY public.char_teams.id;


--
-- Name: characters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.characters (
    id integer NOT NULL,
    user_id character varying(50),
    name character varying NOT NULL,
    species character varying NOT NULL,
    types character varying,
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
    rumors character varying,
    hometown character varying,
    warnings character varying,
    rating character varying,
    shiny boolean DEFAULT false
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
-- Name: image_urls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.image_urls (
    id integer NOT NULL,
    name character varying NOT NULL,
    url character varying NOT NULL,
    holiday character varying
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.images_id_seq OWNED BY public.image_urls.id;


--
-- Name: inventories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventories (
    id integer NOT NULL,
    char_id integer,
    item_id integer NOT NULL,
    amount integer
);


--
-- Name: inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_id_seq OWNED BY public.inventories.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.items (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying,
    effect character varying,
    rp_reply character varying,
    reusable boolean DEFAULT false,
    category character varying[],
    url character varying,
    edit_url character varying NOT NULL,
    side_effect character varying
);


--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- Name: statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.statuses (
    id integer NOT NULL,
    name character varying,
    effect character varying
);


--
-- Name: statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.statuses_id_seq OWNED BY public.statuses.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teams (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying,
    active boolean DEFAULT true,
    role character varying,
    channel character varying
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.types (
    id integer NOT NULL,
    name character varying(25) NOT NULL,
    color character varying(7)
);


--
-- Name: types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.types_id_seq OWNED BY public.types.id;


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
-- Name: carousels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carousels ALTER COLUMN id SET DEFAULT nextval('public.carousels_id_seq'::regclass);


--
-- Name: char_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.char_images ALTER COLUMN id SET DEFAULT nextval('public.char_images_id_seq'::regclass);


--
-- Name: char_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.char_statuses ALTER COLUMN id SET DEFAULT nextval('public.char_statuses_id_seq'::regclass);


--
-- Name: char_teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.char_teams ALTER COLUMN id SET DEFAULT nextval('public.char_teams_id_seq'::regclass);


--
-- Name: characters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters ALTER COLUMN id SET DEFAULT nextval('public.characters_id_seq'::regclass);


--
-- Name: image_urls id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image_urls ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


--
-- Name: inventories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventories ALTER COLUMN id SET DEFAULT nextval('public.inventory_id_seq'::regclass);


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- Name: statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statuses ALTER COLUMN id SET DEFAULT nextval('public.statuses_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.types ALTER COLUMN id SET DEFAULT nextval('public.types_id_seq'::regclass);


--
-- Data for Name: carousels; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.carousels (id, message_id, char_id, options, image_id) FROM stdin;
46	640970691872686101	1	\N	\N
47	640971735445012503	1	\N	3
100	642932697777307688	91	\N	\N
59	641834302409146368	15	\N	31
31	637010219955781632	1	\N	\N
34	637018848800931841	\N	{}	\N
85	642586557651353621	43	\N	\N
38	637025525868789770	6	\N	21
39	637026589263003669	6	\N	21
41	637027299421847571	\N	{}	\N
42	637029052179283978	\N	{}	\N
90	642871537602396190	80	\N	\N
91	642876959411535911	81	\N	\N
93	642886669061718067	\N	{2}	\N
\.


--
-- Data for Name: char_images; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.char_images (id, char_id, url, category, keyword) FROM stdin;
2	1	https://i.pinimg.com/originals/e1/af/36/e1af3607885c7bbd3812706bfe9cbafc.jpg	SFW	Neiro's Nightmare
4	1	https://i.pinimg.com/originals/53/0a/32/530a3267c68dcf5711855d4329e3bbee.png	SFW	Hero
3	1	https://i.imgur.com/CqtkxMr.png	SFW	Default
8	2	http://d.facdn.net/art/fishinabarrrel/1568640777/1568640773.fishinabarrrel_neiro_ref_sfw.png	SFW	Default
9	3	http://static.pokemonpets.com/images/monsters-images-800-800/8715-Mega-Noivern.png	SFW	Default
10	4	https://i.imgur.com/GZY4QN7.png	SFW	Default
11	1	https://i.kym-cdn.com/photos/images/original/001/194/272/043.png	SFW	Cutesy
12	1	https://i.kym-cdn.com/photos/images/original/001/183/270/c38.png	NSFW	Salty
13	1	https://cdnb.artstation.com/p/assets/images/images/003/772/763/large/mauricio-cid-mimikkyu.jpg?1477345311	SFW	Spooky
14	1	https://66.media.tumblr.com/536300ac3be54c647394e959b20efce4/tumblr_prxhywHjGa1qagaoco1_400.png	SFW	Detective
15	4	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQAqq4k9ffG_WLCbHLXD23T4RXxMy0VIwcBS-ErrArZxgViEnFP	SFW	Sweating
16	4	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSIBDTycnrDuTc1BiUiA5BJVd1l5AblA5u9FkL66DcsjzP1KuEY	SFW	Attacking
17	4	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQjEu8qtYF6WR3fbCCCCyQB8t6Y8qcZe40tuBKbSGD6vpvHLps5	SFW	Scheming
18	4	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRGttdLkAF5trFBFeh6DziEy7uD8vkmOgZQcmkB44WaTQQYDiHf	SFW	Playful
19	4	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS6J-el9WuMFQ_g11r57Y1UaGqcwBYCjuGu7jRSVIYIozTl2Bzl	SFW	Mega
20	4	https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRG65IsiuZr1HPn4kINl6ECHNcfz6nXWu7hlkdmQjy5H9nujuv-	SFW	Hypnosis
21	6	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXuiY3fH0YZd6rSzhagmmEy70VoTJ6OAO7XFt0vVYeMm9oZo8XzA	SFW	Default
22	7	https://assets.pokemon.com/assets/cms2/img/pokedex/full/668_f2.png	SFW	Default
23	8	https://images-ext-2.discordapp.net/external/6sG2JwqdzaGDbM9dOsOQ1303N2vXZNkAtUy8sZ3hbR4/https/media.discordapp.net/attachments/599088586461020161/620117815642554368/unknown.png?width=80&height=74	SFW	Default
25	1	https://66.media.tumblr.com/c61502da7705c26020d35c5fef0fb446/tumblr_oinlc7e3oa1slli9po1_540.png	SFW	Evolved
26	1	https://i.pinimg.com/originals/b5/88/be/b588be5e036fd67540588f0e7b233b06.jpg	SFW	Vee
44	41	https://cdn.discordapp.com/attachments/444263615810240514/452260411257913346/yeah.png	SFW	Default
45	43	http://d.facdn.net/art/kurikia/1418095982/1418095982.kurikia_eevee.png	SFW	Default
46	49	https://i.imgur.com/FNJ3oYS.png	SFW	Default
47	50	https://i.imgur.com/lKebYqS.jpg	SFW	Default
48	51	https://i.imgur.com/vFHQMEM.png	SFW	Default
49	52	https://i.imgur.com/nQyjYbD.png	SFW	Default
50	53	https://i.imgur.com/5ALt91t.png	SFW	Default
27	10	http://d.facdn.net/art/schrodingerthewolf/1475979029/1475979005.schrodingerthewolf_toastie_lapras.jpg	SFW	Default
28	11	http://d.facdn.net/art/haradoshin/1521175977/1521175977.haradoshin_flygon_fa.png	SFW	Default
29	12	http://d.facdn.net/art/kiacat19/1393635277/1393635277.kiacat19_gogat.png	SFW	Default
30	13	http://d.facdn.net/art/amorabadger/1463665901/1463665901.amorabadger_gogoat_rides.png	SFW	Default
31	15	http://d.facdn.net/art/hasquet/1383347600/1383347600.hasquet_latiosbeach.jpg	SFW	Default
33	15	http://d.facdn.net/art/hasquet/1515654466/1515654466.hasquet_latiosflower.png	NSFW	Inflated
34	16	http://d.facdn.net/art/shinodahamazaki/1425848045/1425848045.shinodahamazaki_392015.jpg	SFW	Default
35	21	https://i.imgur.com/w02hfux.png	SFW	Default
36	26	https://i.imgur.com/1q5kSVK.png	SFW	Default
37	27	http://d.facdn.net/art/featherhead/1526508664/1526508664.featherhead_squandercomm2.png	SFW	Default
38	28	https://i.imgur.com/pFAFHJg.png	SFW	Default
39	29	http://t.facdn.net/25007477@400-1507170268.jpg	SFW	Default
40	30	http://t.facdn.net/22080292@400-1482519400.jpg	SFW	Default
41	34	https://i.imgur.com/sx9xVJn.png	SFW	Default
42	37	http://d.facdn.net/art/lokko/1526057616/1526057616.lokko_lycanroc_resized.jpg	SFW	Default
43	40	http://i0.kym-cdn.com/photos/images/original/000/924/809/ee0.jpg	SFW	Default
51	54	https://cdn.discordapp.com/attachments/414573746259755008/470756774673121280/283b76093b309e31ee7049dda063f8ae.png	SFW	Default
52	55	https://pbs.twimg.com/media/DQT_fHzV4AAJNNi.jpg	SFW	Default
53	56	https://i.imgur.com/5ALt91t.png	SFW	Default
54	57	https://i.imgur.com/zGAVwvW.png	SFW	Default
55	58	https://i.imgur.com/5ALt91t.png	SFW	Default
56	60	http://d.facdn.net/art/kurikia/1451078951/1451078951.kurikia_sneaky_umbre.png	SFW	Default
57	63	http://d.facdn.net/art/sir-dancalot/1456640123/1456640123.sir-dancalot_espeon1.png	SFW	Default
58	64	http://d.facdn.net/art/fishinabarrrel/1478386092/1478386092.fishinabarrrel_evest_ref_small.png	SFW	Default
59	66	https://d.facdn.net/art/fluffyshenanigans/1324538336/1324538336.fluffyshenanigans_octillery.png	SFW	Default
60	67	https://static1.e621.net/data/59/4d/594ddaebe36635d82f3427ef94730201.png	SFW	Default
61	68	http://t.facdn.net/3342841@400-1264829024.jpg	SFW	Default
62	69	https://images-ext-2.discordapp.net/external/iiaMbAFJENFjA85bXMBynCi_JWsrTwiwLBaw_IZg_Hg/https/pbs.twimg.com/media/DgsL_lHVAAA9LAJ.png	SFW	Default
63	70	https://d.facdn.net/art/fatalsyndrome/1473712695/1473712695.fatalsyndrome_salandit.png	SFW	Default
64	71	https://i.imgur.com/SBjUkBG.png	SFW	Default
65	72	https://vignette1.wikia.nocookie.net/pokemon/images/a/aa/396Starly_Pokemon_Ranger_Guardian_Signs.png/revision/latest?cb=20150113235903	SFW	Default
66	73	https://i.imgur.com/DJWNjed.png	SFW	Default
67	74	https://i.imgur.com/GEK7zgB.png	SFW	Default
68	76	https://static.f-list.net/images/charimage/8642820.png	SFW	Default
69	77	https://cdn.discordapp.com/attachments/454079207266582550/465702999478501386/fish_by_yiipyaps.png	SFW	Default
70	78	http://d.facdn.net/art/omegaoverdrive/1512004330/1512004275.omegaoverdrive_a_big_cake_for_a_big_lurantis.png	SFW	Default
71	77	https://i.imgur.com/eQaMaqR.png	SFW	Fat Kayla
72	77	https://imgur.com/ymAeRtU.png	NSFW	Nude Kayla
73	77	https://i.imgur.com/NO9Ewge.png	SFW	Kayla & Geneo
74	79	https://danbooru.donmai.us/data/__original_drawn_by_avodkabottle__d2930ea2c976589fe443021f27ac7934.png	SFW	Default
75	80	https://d.facdn.net/art/hybridprojectalpha/1372136384/1372136384.hybridprojectalpha_fap.png	SFW	Default
76	81	http://d.facdn.net/art/kurikia/1478448542/1478448542.kurikia_flaffy.png	SFW	Default
77	83	https://i.imgur.com/OVn1TX4.png	SFW	Default
78	84	https://i.imgur.com/tpZwbTO.png	SFW	Default
79	85	https://i.imgur.com/83Y6YPT.png	SFW	Default
80	86	https://i.imgur.com/xtcA6Gc.png	SFW	Default
81	86	https://archive-media-1.nyafuu.org/bant/image/1533/70/1533702804207.jpg	SFW	Puddle
82	86	http://d.facdn.net/art/chammy3760/1409785123/1409785123.chammy3760__commission__nerina_the_vaporeon_by_chibi_pika-d5bqbqe.jpg	SFW	Becoming Liquid
83	86	http://d.facdn.net/art/beepy/1496054296/1496054296.beepy_beach_blast.png	SFW	Melting
84	86	https://i.imgur.com/d6GiHwr.png	SFW	Force Feeding
85	63	http://d.facdn.net/art/winick-lim/1475255400/1475255400.winick-lim__collaboration__chocolate_gift_by_winick_lim-dajhqmp.jpg	SFW	With Markus
86	63	https://i.imgur.com/oo9J6iy.jpg	SFW	Shop Front
87	60	http://t.facdn.net/12094505@400-1384753396.jpg	SFW	Shop Front
88	60	http://d.facdn.net/art/commando125/1531796262/1531796262.commando125_1487597561.mewzy148_image_ink_wet_messy.png	NSFW	Messy
89	2	https://i.imgur.com/Od4zrZe.png	SFW	Wetsuit
90	2	http://d.facdn.net/art/fishinabarrrel/1568837939/1568837939.fishinabarrrel_neiroudder.png	SFW	Udder
91	2	http://d.facdn.net/art/fishinabarrrel/1568669404/1568669404.fishinabarrrel_image0.png	SFW	Cow
92	2	http://d.facdn.net/art/fishinabarrrel/1545257441/1545257441.fishinabarrrel_01_neirostream.jpg	SFW	Hyper Tail
93	2	http://d.facdn.net/art/fishinabarrrel/1545257130/1545257130.fishinabarrrel_03_neirostream.jpg	NSFW	Cock Pump
94	2	http://d.facdn.net/art/fishinabarrrel/1545236955/1545236955.fishinabarrrel_6-28-2018fishinabarrelcommission-sweatpants.png	SFW	Neirotaur
95	2	http://d.facdn.net/art/fishinabarrrel/1545237250/1545237250.fishinabarrrel_vaporeoncard.png	SFW	Neiro Aquarium
96	2	https://i.imgur.com/2lJXJnf.png	SFW	Neiro Blob
97	2	https://i.imgur.com/4uKiuxY.jpg	SFW	Keg Chug
98	2	https://i.imgur.com/06DEi2l.png	SFW	Thicc Tail
99	2	https://i.imgur.com/r4aTYgC.png	SFW	Original Neiro Image
100	15	http://d.facdn.net/art/dino.d.dice/1451428922/1451428922.dino.d.dice_latios_latias_fd_followup.jpg	SFW	Obese
101	92	https://orig00.deviantart.net/1f98/f/2016/330/6/4/baby_harp_seal_popplio__11_25_2016__by_theskywaker-dapptc4.png	SFW	Default
102	94	https://static1.e621.net/data/21/70/21709b00b17de46e94b1731faf0a02ef.gif	SFW	Default
103	6	https://cdn.discordapp.com/attachments/520266025132883968/627511075356672012/DmnAJEiXgAAraUw.png	SFW	Anthro Thick
104	6	https://cdn.discordapp.com/attachments/588573903400468480/605104526802026496/Beachkip.png	SFW	Anthro
105	6	https://cdn.discordapp.com/attachments/575845803889786880/622516929143504939/1531569152.png	SFW	Anthro-Thin
106	95	https://i.imgur.com/2tC6KfR.png	SFW	Default
107	95	http://d.facdn.net/art/weewizzylizzy/1534465757/1534465757.weewizzylizzy_lycanroc_maid_messy_fa.png	NSFW	Messy
108	95	http://d.facdn.net/art/stinkysheepie/1536027599/1536027599.stinkysheepie_pizzapoop.png	NSFW	Hyper Messy
109	96	https://t.facdn.net/23731910@400-1496588066.jpg	SFW	Default
110	97	https://t.facdn.net/23731910@400-1496588066.jpg	SFW	Default
111	99	https://i.imgur.com/xkKjRU0.jpg	SFW	Default
112	100	https://pm1.narvii.com/6381/c459b86cdac09a611327258f0a94e1bdfd3f4c31_hq.jpg	SFW	Default
113	101	https://t.facdn.net/15335394@400-1419823673.jpg	SFW	Default
114	102	https://i.imgur.com/riIziyW.png	SFW	Default
115	103	https://i.imgur.com/mgXHDjC.png	SFW	Default
116	105	https://i.imgur.com/5WY8SYL.png	SFW	Default
117	106	https://i.imgur.com/zzAZvjC.jpg	SFW	Default
118	107	https://d.facdn.net/art/slinkydragon/1400155360/1400155360.slinkydragon_melissar1_1.png	SFW	Default
119	108	https://i.imgur.com/gebvrFK.png	SFW	Default
120	109	https://i.imgur.com/TjKz8b5.jpg	SFW	Default
121	110	https://78.media.tumblr.com/250725b6aecebd8f0304ddc1d9d4efbf/tumblr_p33nj75Lyw1w5diwio1_1280.png	SFW	Default
122	111	https://i.pinimg.com/originals/b4/a6/57/b4a657bd10a4a4aa30f4468dff51c593.png	SFW	Default
123	112	https://78.media.tumblr.com/1e745be5ea5a8d9b579ffccc8eaacd43/tumblr_oojag4enj61uo1bcro1_500.png	SFW	Default
124	115	https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/0ac573b5-3da6-4e54-9445-256352833f4b/d8c079q-5eab9996-81bb-43d8-8959-b3c2d3efe0d7.png/v1/fill/w_894,h_894,strp/33__galopfrig_by_onebigthistle_d8c079q-pre.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTAwMCIsInBhdGgiOiJcL2ZcLzBhYzU3M2I1LTNkYTYtNGU1NC05NDQ1LTI1NjM1MjgzM2Y0YlwvZDhjMDc5cS01ZWFiOTk5Ni04MWJiLTQzZDgtODk1OS1iM2MyZDNlZmUwZDcucG5nIiwid2lkdGgiOiI8PTEwMDAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.gA6srr8JXXUCg6KWY9VVErxOu4HkTEfPMMVOd98EzCA	SFW	Default
125	116	https://78.media.tumblr.com/1baa65615e8a49fe6490768234555cd9/tumblr_n54u81ejhC1qd5hyto2_r1_1280.png	SFW	Default
126	119	https://i.imgur.com/2NKRn2D.png	SFW	Default
127	121	https://pm1.narvii.com/6193/b3e6d5a36b854c902fcf7d73c19902715ed5f22a_hq.jpg	SFW	Default
128	122	https://d.facdn.net/art/catarsi/1395362251/1395362251.catarsi_nidoking.jpg	SFW	Default
129	122	https://d.facdn.net/art/nidofur/1447717820/1447717820.nidofur_nido.jpg	SFW	Vore 1
130	122	https://d.facdn.net/art/tanio/1531776078/1531776078.tanio_nidokingvoresmall.png	SFW	Vore 2
131	122	https://d.facdn.net/art/rubydragon03/1502264901/1502264901.rubydragon03_bellyout.jpg	SFW	Fat 2
132	122	https://d.facdn.net/art/dragontzin/1527805069/1527805069.dragontzin_ndkngwg2.png	SFW	Fat 1
133	123	https://pre00.deviantart.net/3b7f/th/pre/i/2015/313/d/8/the_cream_of_the_crop_by_brokencreation-d9g0ui5.jpg	SFW	Default
134	124	https://i.pinimg.com/originals/a9/11/34/a91134e0dfdb7056cf4bede9ff4e8304.png	SFW	Default
135	125	https://t.facdn.net/14693686@400-1412434315.jpg	SFW	Default
136	126	http://d.facdn.net/art/higan/1414230997/1414230997.higan_bui_tori.png	SFW	Default
137	127	https://t.facdn.net/23731910@400-1496588066.jpg	SFW	Default
138	128	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbmYnBB5Oc8apUC9dPkTZDeht7pb49_MEV5eLyc08sY3CbSwSA9Q	SFW	Default
139	130	https://cdn.discordapp.com/attachments/477149274157613066/583508946384584724/6e6e9be0a604ea9804357894c8abcd4a.png	SFW	Default
140	131	https://i.imgur.com/gx6CtiF.png	SFW	Default
141	132	https://cdn.discordapp.com/attachments/477149629474013184/564310519045947402/1534938215.png	SFW	Default
142	134	https://cdn.discordapp.com/attachments/454079207266582550/488573484272975882/image0.jpg	SFW	Default
143	135	https://i.imgur.com/vzkBxrj.png	SFW	Default
144	136	https://i.imgur.com/PQMXhcg.jpg	SFW	Default
145	137	https://i.imgur.com/t4Q5B7u.jpg	SFW	Default
146	138	https://i.imgur.com/QyXRYS9.jpg	SFW	Default
147	139	https://cdn.discordapp.com/attachments/466106661346738185/497985590449668096/1519595661.png	SFW	Default
148	140	https://cdn.discordapp.com/attachments/463386097049927700/528046537683763210/7fc663e351a01885279ad289087c7f65.png	SFW	Default
149	141	https://cdn.discordapp.com/attachments/463386097049927700/525688743168966676/yFMOUBs.png	SFW	Default
150	142	https://d.facdn.net/art/jouigirabbit/1477778895/1477778895.jouigirabbit_rockpuff.png	SFW	Default
151	143	http://d.facdn.net/art/juano/1536791576/1526943060.juano_sketch-504.png	SFW	Default
152	145	https://d.facdn.net/art/bellydog/1533988140/1533988140.bellydog_lycanroc_donate_3.png	SFW	Default
153	146	https://d.facdn.net/art/stickfox/1484542227/1484541961.stickfox_lycanroc.png	SFW	Default
\.


--
-- Data for Name: char_statuses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.char_statuses (id, char_id, status_id, amount) FROM stdin;
\.


--
-- Data for Name: char_teams; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.char_teams (id, team_id, char_id, active) FROM stdin;
1	11	3	t
\.


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.characters (id, user_id, name, species, types, age, weight, height, gender, orientation, relationship, attacks, likes, dislikes, personality, backstory, other, edit_url, active, dm_notes, location, rumors, hometown, warnings, rating, shiny) FROM stdin;
49	Public	Cody	Rockruff	Rock	12	252 lbs	1'09"	Male	NA / Child Character	NA / Child Character	Growl|Rollout|Rock Smash|Dig	He loves to burp and see if he can our burp others	\N	\N	\N	\N	?edit2=2_ABaOnufxODheonioOYfjXf9j0ChPYDYEf2vMtO4ECWfVa2nQTOMAhn2v4aaxokNOBLP8wF0	NPC	A fatty that just wants to eat and not care about personal hygiene thanks to Redolent treatment of him	The Village	He is currently in the Slob form due to failure to rescue him in the time frame but he was saved so is home with his family|Pretty good friends with Cody, despite what Quebec's father did to him.	The Village	He will eat just about any food, whether its his or not. He has no manner... anymore	SFW	f
51	Public	Tyke	Poochyena	Dark	23	20 kg	1'8"	Male	Homosexual	In a Relationship	Play Rough|Crunch|Take Down|Howl	\N	\N	\N	He showed up at Draxton's house unannounced one day and now lives there, eating his food and making a mess at every opportunity. They're in luv.	Leader of a band of pre-evolved punks in Bluelatch Forest.	?edit2=2_ABaOnudXLtklqfQc3ZXlDZUAGBsQvx5Wqvyx22M7qz5D1TlCoMoqhN9t0CViHRyaxgMCzXc	NPC	He's actually quite experienced in terms of levels, but no matter how hard he trains, he can't seem to evolve. This is a source of deep frustration and humiliation for him, which is what inspired him to start this group and take his frustrations out on others. Like the other 'punks', he is an adult, although smol.	Bluelatch Forest	He's actually quite a well-trained and modestly powerful Pokemon... so why hasn't he evolved yet?	Bluelatch Forest	\N	SFW	f
1	215240568245190656	Mizukyu	Mimikyu	Ghost/Fairy	Old	1.5 lbs	0'8"	Female	Pansexual	Married	Shadow Claw | Play Rough | Psychic | Shadow Sneak	Cuddles, soft things, spooky stories, horror	Bullies, rejection, being exposed	I am shy and a bit recluse, but warm when you take the time to get to know me. I don't like when people try to see under my disguise, I've lost many friends that way (to death) including my spouse. Really, really really likes to dress up as other pokemon	Has existed more years than she cares to count. She is immortal, due to being a ghost. She has learned to carefully hide her appearance as to make sure not to accidentally kill more friends. Took up tailoring to make multiple disguises, because pretending to be a Pikachu forever is boring.	Switches disguising with moods. Has made them for all pokemon. Also a master shadow bender	?edit2=2_ABaOnuc3HZEyhI9EeApXcJtsBmDzqtzDGH5De46CfuRBxwVavQKAfTT_LZy_kMH0sz5H7gk	Active	\N	\N	Loves children | Hates washing and tailoring disguises | Surprisingly soft | Steals children | Wishes to be admired	\N	Horrific Eldritch Abomination	\N	f
2	271741998321369088	Neiro	Vaporeon	Water	33	125 lbs	3'03"	Male	Bisexual	Single	Water Gun|Hydro Pump|Ice Beam|Synchronoise	Likes to overeat, being in the rain, and playing with fat	Hates that his body absorbs any liquids	Carefree and a little bit lazy. Always up for fun things.	He was spoiled from the very beginning of his life. This resulted in him being a bit fat and lazy. He loved it tho but decided to make something more with his life by joining a rescue team. He also wanted to work on his skills as being taken care of his whole life made him pretty useless in battle.	He has the special ability Water Absorb. Neiro's body can bloat up to 250 times his normal size before his body stopped expanding. His tail can also bloat equal to that, making his total potential size 500 times	?edit2=2_ABaOnufidKuBLj5ecAtAjVd0CTTFoJhB0CqE9rM-WW0yeYSfnxeKjblep_Nru3f8jpOzkS4	Active	\N	\N	Uses Water Gun every time he sneezes.|His Water Absorb ability absorbs any liquids into his body.|Too much water makes him bloat like a sponge.|He can piss for an hour.|He is outstanding with his move execution and aim	The Village	Dont share a shower with him... 	\N	f
3	215240568245190656	Zumi	Noivern	Dragon/Flying	Young	120 lbs	3'0"	Male	\N	\N	Dragon Pulse | Screech | Bite | Wing Attack	Zumi loves games and all his friends. He also loves sweets and sour candy	Zumi doesn't like bullies or mean kids that constantly make fun of other kids or exclude them from the fun	Zumi is a fun loving Derg that likes to play with anyone and everyone! He also likes to play fun jokes on people or do a bit of spooking with his ghosty parents -- but he tries not to take it too far. He tries to protect his friends as much as he can, but theres only so much a little dragon can do	Zumi is a young dragon, and doesn't really remember much before coming to the guild house. He doesn't remember his birth parents, or when he met his ghost parents, but he isn't really bothered about it. All he knows, is that he loves his ghost parents and wants to make as many friends as he can!	\N	?edit2=2_ABaOnuf86ZAxBbQfeKlKe40wSsMNOKbAg8yb9OIS7GsZ1Qs8dtVRX13RLf4uJnuRawMf5io	Active	\N	\N	He was abandoned as a baby | He wishes he could fly faster | He was rescued by a ghostly couple | He doesn't scare easy | He's just a dumb kid	\N	Has a spooky set of parents that will ruin your day	\N	f
28	Public	Simon	Goodrataur	Dragon	79	623 lbs	8'4"	Male	Heterosexual	Single	Ice Beam|Toxic|Dragon Tail|Swagger	He loves his thick belly and hips and thinks they are a chick magnet	\N	\N	\N	\N	?edit2=2_ABaOnuewSDDFvAQ5rqNRaSVthtOqhUeuPsre-8giEmEKrXUgU10GFF4XZu-0MzN3lmK2WSM	NPC	Hurting his will cause him to drop some blood. If you fail, you can be captured and forced to be a taur and kept in a dungeon below his palace. He has been knows to smother pokemon in his butt, tail, feet, anything body part as its his best method of getting them to taste the Gootaur mixture from his body. He is more than willing to spread it willingly if you just ask.	Taurel	He is the original pokemon taur|His blood is the key to reversing taur effects|He acts sweet to get what he wants|He believes he is the 'God of Taurel'|He is the sole reason Taurel is 99% Taur pokemon.|His goo is contagious if taken over a week or two	Taurel	Don't get on his bad side. Some don't return after he has been angered	SFW	f
55	Public	Chef Wentworth	Charizard	Fire/Flying	50	120 kg	5'7"	Male	Pansexual	Single	Roast | Flamethrower | Fly | Earthquake	\N	\N	\N	\N	\N	?edit2=2_ABaOnudO7f4Hm3_jBYEcPpUEWNgJjH_OgHeFwD70a_r9J5UzJPEPTlUc4t97XVLPZwhaWaA	NPC	Loves cooking	Obe City	Known to be one of the most talented chefs around! He claims his secret is his creative usage of pudgeberries. | His popular cooking show, which demonstrates fattening recipes and espouses the fun of stuffing yourself silly, has been running for decades, and is said to have contributed to making Obe City the glutton haven that it is. | Sometimes he picks volunteers from the crowds, and cooks them up into a delicious meal before swallowing them whole! They're all given complementary reviver seeds, though.	Obe City	\N	SFW	f
56	271741998321369088	Quebec	Stunky	Poison/Dark	12	72 lbs	1'02"	Male	NA / Child Character	NA / Child Character	Poison Gas | Scratch | Acid Spray | Smokescreen	\N	\N	His personality reflects more of his kind mother than of his father, Redolent.	\N	\N	?edit2=2_ABaOnudqHHGOmxHKMFyBR4-f-RZu1QxS94H9sD8d3Bj6vsIl5hu40aE2rIpTRBfdKjTYMyw	NPC	Generally kindhearted and loves to command his brothers to do things that will make them bloat, fat, etc. Basically just having fin with them for pay back for all the years of bullying, tho he always makes sure it is reversible and just generally fun. Nothing permanent or damaging.	Melody Springs	Loves to have his brothers under his complete and total control  | Wants to join Team Rocket when he grows up | Was bullied by his brothers until Charlotte places a spell on both of them to forever obey Quebec's commands | Pretty good friends with Cody, despite what Quebec's father did to him.	Melody Springs	\N	SFW	f
4	215240568245190656	Ozi	Gengar	Ghost/Poison	???	90 lbs	5'0"	Male	Straight	Married	Shadow Ball | Sludge Bomb | Psychic | Dazzling Gleam	Jokes and Spooks	Kill joys and Arrogance	Theres never a dull moment with Ozi! He likes to pull pranks and make people either laugh or scream. He loves his wife (Mizukyu) and son (Zumi) and will spook anyone who harms them to death. So long as you play nice, he's a great ghosty guy!	No one knows where Ozi came from, or why he came here, but he and his wife Mizukyu have caused a lot of mayhem in their many years together. He's been known to suddenly appear or disappear and even caused some unfortunate souls to go mad with insanity. Over time he's learned to dial back the spooks a bit, and even tried to make some new friends	Ozi sometimes causes trouble with his ghost powers, behaving a bit like the Cheshire Cat. He can be a bit slippery, but tries not to cause too much trouble	?edit2=2_ABaOnueS5nTN63soX4wQ0PVKa_tGFghbIpiYlW3kwGw4Cj09Fnio0qNLD47iyOC5H3f4oN4	Active	\N	\N	He taught Zumi how to fly | He's a surprisingly good father | Sometimes he doesn't know when to stop the jokes | His humor is not for everyone | I'm not totally convinced he's real	\N	Spooks ahead!	\N	f
6	412163685440684052	Kipper	Mudkip	Water	26	20lbs	1'05''	Male	Gay	Single	Water Gun | Mud Slap | Protect | Surf	Water, Mud, His Teammates, Teasing Cecil	Injustice, not being able to evolve, getting picked on	Lazy bum who doesn't like to work, but can't ignore when someone is in need.	N/A	He's a surprisingly good chef, able to easily handle ingredients and mise en place despite being a tiny quadruped.	?edit2=2_ABaOnucXHjYrWRLF9ERHNJYBdtB1t25-lacSlSV1wrmrpgLUEK_swo7p-gtWWRXquXNBsyM	Active	\N	\N	He's easily distracted, like he gets lost in his thoughts a lot. | He's incredibly lazy and hates working. | He's quite the chef, his recipes sounds really good. | He's rather old for a stage 1 Pokémon. He probably can't evolve | I heard he's great to hang with when you're feeling really upset or depressed.	Zaplana	He's really sensitive about the fact that he can't evolve.  Tease him for that at your own risk.	\N	f
7	354840009829908480	Sarah	pyroar	Fire/Normal	20	179.7 lbs	4'11"	Female	pansexual	In a Relationship	strength | will-o-wisp | rest | dig	\N	\N	\N	\N	has 1 kit with yang the ninetails, intelligence gets lowered when she ingests a certain liquid	?edit2=2_ABaOnuf-HnF8bkanKrZ99PEPD_PWINX-c9HU_rQ_bg1oqFywrr9h_KbufnD98N9bFQ2Q2Fs	Active	\N	\N	\N	\N	\N	\N	f
8	473547751221886976	Avery	Sylbreon	Dark/Fairy	20	55 lbs	3'03"	M or F	Bi	Single	Moonblast | Dark Pulse | Venoshock | Misty Terrain	the cold, dry food, anything with running, swimming and water, love, berries, computers, DJ Thunder (AKA his idol), his friends, floof, hacking (usually ethical), and fashion despite being a feral.	heat, excessive food, bitter food, being teased, being told what to do, seeing people get hurt, his father, sadness, damaged electronics.	\N	\N	\N	?edit2=2_ABaOnufmQm1Ss0H-E8yfoZt636DRwCBgN2ZVrt-14dW2QyhHJxrnBEfj6Ie_s46TxqLuZNE	Active	\N	\N	\N	He lives at the Guild, but he's from the Woods.	\N	\N	f
29	Public	Pi	Pichi	Electric	7	104 lbs	1'0"	Male	NA / Child Character	NA / Child Character	Charm|Thunder Shock|Tail Whip	\N	\N	He is always happy to see guests and is loyal to his father	His full name is Pi Piemakerson	\N	?edit2=2_ABaOnuc29FKRHButsNURl4d5Wc3ov4KNeDDVOm0UhosdbWAPeDY045szBK6zon1_2e7_jc4	NPC	He helps is father make pies but eats most of the ingredients as he makes them. It is predicted that he eats one pie for every two he manages to make.	Pudgeberry Forest	He is fat from non pudgeberry related means.|He actually hates the taste of pudgeberry|He works for his dad at the Piemaker Shop in the Pudgeberry Forest.|His dad has asked him to lose weight but he declines it each time, liking it.|He will turn down Tabol Berries	Pudgeberry Forest	\N	SFW	f
30	Public	Wayva	Salandit	Poison/Fire	23	182 lbs	2'1"	Female	Bisexual	Single	Flame Burst|Toxic|Venoshock|Sweet Scent	\N	\N	Very carefree now and loves to be pamped and cared for.	\N	\N	?edit2=2_ABaOnueJEEX2ATbJH2tC9rM3dJNAhBFwB7UXR9AJM8zRiTk7DinZLPaeGmBnKSSonNLoXC4	NPC	She used to be a spoiled princess but has realized now that is now how the world works outside of the Salandit Mound. So she is excited to see how things work and wants to explore if she can ever get around to it.	The Village	She was destined to be the leader of the Salandit Mound but after years of trying to evolve and failing, she was tossed out and the other Salandits found another leader|She doesnt ever want to go back home|She is so obese that she had to learn to walk on two legs to get anywhere|She is happy to no longer have the stress of trying to be a leader but some says she stress eats over it anyway	Pudgeberry Forest	She will spray you with pheromones if you piss her off... and by that, she will act like it and just fart on you	SFW	f
31	Public	Mart	Slowking	Water/Psychic	68	175.8 lbs	6'0"	Male	Heterosexual	Widowed	Focus Punch|Zen Headbutt|Telekinesis|Recycle	\N	\N	He only talks unless its needed. He is a very quiet one	\N	\N	?edit2=2_ABaOnuebtTaPoZh-bu1La-zS69Ne34LKjPob5ve2Rek0PH3BUm3xmUE_DB6v1PKkCgccBXM	NPC	He is a wise monk that knows everything there is to know about the temple and its history. The once great	Tiny Temple	He wants to see his home reborn to its former glory but doesnt wish to do it alone.|He is the reason Tiny Temple is abandoned and why Mortar began a monster.	Tiny Temple	\N	SFW	f
50	Public	Madame Evangeline	Lopunny	Normal	32	35 kg	4'0"	Female	Pansexual	Free Spirit	High Jump Kick | Fake Out | Power-Up Punch	\N	\N	\N	\N	\N	?edit2=2_ABaOnueBSvxr5Wa383UfjMg6rQFilYDOfkUkpCsDgJjmNWrfeoZZ1WgSQERuHLZrqO_az5w	NPC	In reality, she is actually a ditto, hence her obsession with the concept of transformation. Growing up as a ditto left her with deep-rooted identity issues, and she copes with these insecurities through her wild parties. She tries to keep up the facade of a respectable noblewoman, but she's really a party girl with a sadistic streak and a bad temper. She is ultimately harmless though, and not exactly a villain.	Bluelatch Forest	She had an entire mansion constructed deep in Bluelatch Forest, just so nobody can see the going-ons of her wild parties.|She's known to fly off the handle if anyone asks too many questions about her personal life, or makes any sort of remarks about her body.	Obe City	\N	SFW	f
52	Public	Richard	Totodile	Water	24	5 lbs	0'7"	Male	Bisexual	Single	Growl | Tackle | Water Gun | Leer	\N	\N	\N	\N	The effects of his transformation are not able to be fixed until a wand reverses him	?edit2=2_ABaOnudyJlMcQJ3RQIB1DvMhC3IW5l3Ea-njLVSNc0jm6aRUVU-o-DrOpEWRTbjGSq_7YqE	NPC	He can talk and move as a cock tho movement is very hard for him considering his legs are balls and his arms are mostly nonexistent. He escaped from The Members Club by chance when the members of said club got too drunk to notice. He currently lives in the Med Bay as this is the best place for him to be feed since he can not feed himself. He is otherwise carefree and even tho he is a cock, he seems to be fine with his current situation, most likely happy to just be alive still.	Miriam's Clinic	\N	Liquamond	\N	NSFW	f
63	271741998321369088	May	Espeon	Psychic	39	58 lbs	2'11"	Female	Heterosexual	Married	Calm Mind | Psychic | Shadow Ball | Substitute	\N	\N	\N	\N	Married to the owner of the Bar / Inn in Infant Isle, she takes the day shifts. She is the mother of Lucas	?edit2=2_ABaOnucXvDomF0X77Ps_N4EDCIauo1wUPqfOt_8rqFyhtYJJMC9pr2olX1tHjs8flTmR5RQ	NPC	Over protective mother to all her patrons	Inflant Isle	She is one of those pokemon who believes that once a diaper is used, it needs to be cleaned right then.	Inflant Isle	\N	SFW	f
53	271741998321369088	Iqaluit	Stunky	Poison/Dark	14	34 lbs	1'04"	Male	NA / Child Character	NA / Child Character	Poison Gas | Scratch | Acid Spray | Smokescreen	\N	\N	\N	\N	They can be quite the jerk, more so to his brother Quebec. Is under Quebec's control forever, thanks to a hypnotic spell up placed upon him by Charlotte as a result of bullying Quebec	?edit2=2_ABaOnud5LJ6KJNU6n3viJJF7YUpOVTqt7DgALEv6MQ0u0ILOzfOPBjPLT7uMUP4vmYiShLA	NPC	Does not have any freewill and must obey Quebec	Melody Springs	Raise by their father, Redolent, and it is believed why he acts like him in most every way	Melody Springs	\N	SFW	f
54	Public	Nurse Miriam	Zoroark	Dark	38	92 kg	5'11"	Female	Pansexual	Single	Sludge Bomb | Flamethrower | Dark Pulse | Trick	\N	\N	She takes her job seriously... more or less. She is an odd combination of motherly and nurturing, and smug and mischievous. Sure, she'll help you to the best of her ability... but she might also have her own ulterior motives in mind.	\N	Miriam runs a clinic in the Guild House that's designed to help treat explorers suffering from more severe ailments and maladies then a first-aid kit can fix. She also provides mental health counseling and helps with weight loss. If there is, say, an outbreak of disease spreading among the ranks of the guild, she's the one responsible for figuring out what it is and how to cure it.	?edit2=2_ABaOnucxoxo62_p51qZpwVLrtMRTk_D6gkaF6I986JFVCbSip9zuQqJOc0iDsVsvF1Gv4Qc	NPC	Helpful, though still a dark type with ulterior motives	Miriam's Clinic	Sludge Bomb | Flamethrower | Dark Pulse | Trick	The Village	\N	SFW	f
10	Public	Nuwa	Pooltoy Lapras	Water	43	20 lbs	12'0"	Female	Heterosexual	Single	Hydro Pump|Freeze-Dry|Surf|Thunder	Love of Pooltoys.	\N	Her theme is literally "In the name of God", so take personality like that.	\N	Knows a bit about religion, just Arceus though and the world's equivalent of the bible. They are a very lawful pokemon, taking protocol and order in high regard.|They were pretty strong, likely only surpassed by the guild headmaster herself tho their power waned after becoming a pooltoy, though they still have impressive water-based abilities and adapted to their situation. Namely, they're now extremely light.|They have been seen as vindictive of chaotic alignments and villains, rarely showing them mercy, though it extends only to turning them in for their crimes|Very wise, having gone through many expeditions and thus has some great advice. Guild advisor for a good reason.|Despite their hardy demeanor they actually are very pious, and warmhearted to the average person. Just some people deserve her vengeance, such as Sabrina	?edit2=2_ABaOnuei0yT6JQ3kX8fdgUoprITnFTCkjMNngkSRooogqEuslAS2nIwDfZpYLswtsz9_eR4	NPC	This character is like a religious missionary of Arceus	Guild House	Despite their situation, they have found many advantages to being a pooltoy, and wish to stick with it.|They have their own room in the guild house for pooltoys.|Originally they were a crusader of sorts, going after criminals, before entering the guild as a rescuer. Deus Vult style. https://www.youtube.com/watch?v=_FdnA4SyYzE |Their sense of justice blinds them in certain situations.|Emotions get the better of her every now and then.	The Village	If you take this pokemon with you on a journey, expect no diplomacy at all. She will likely get you into more situations than she gets them out of. Though that's a very close ratio since she brings them out of said scenarios most of the time. Also, getting close to her will involve getting into her secret likes of pooltpoys, which can be borderline obsessive. And if you're not lawful then by Arceus she will smite you, either with her hydro pump or a deadly stare.	SFW	f
11	Public	Esra	Flygon	Ground/Dragon	30	379 lbs	6'11"	Male	Homosexual	Single	Dragon Claw|Screech|Dragon Tail|Dragon Rush	\N	\N	\N	\N	He is open about how much he eats. Bragging about his diet and flaunting his fat. No matter what happens to his experiments, even if he miserably fails to achieve the desired effect, he'll brush it off and treat it as if it was the most probable outcome, even if the effects are bad. His true colors sometimes show when he becomes invested in an experiment, especially involving a male test subject. He stress eats when an experiment doesn't go as planned.	?edit2=2_ABaOnueZ6V8DisFQHbhpg39Imf285NuzszFJlbFhdYz8nsoPUl2YU5UMMLl_vPdP3BGUn54	NPC	Think mad scientist for all things expansion	LaRousse City	Word of mouth about his practices, he does it to vent some sexual frustrations that he bottles up.|Some say he's gone through several relationships, all ending in a tragic breakup... And the significant other disappearing assumably via his experiments.|Esra Perpetuates the motive for his research as 'For the greater good, for world peace, and to usher in a golden era of Lesiure!' although the tests and results vary, and thus, help to muddy this message a bit and make him seem more sinister.|It's very well debated whether he's evil, insane, or misunderstood.	LaRousse City	Never Say he's Too fat. Never Tease him about Being single. Never inquire about the eligibility of his diploma. Doing any of those thing may result in death by experimentation.	SFW	f
12	Public	Elliot	Gogoat	Grass	27	184 lbs	5'4"	Male	Homosexual	Married	Energy Ball|Takedown|Leaf Blade|Protect	Elliot likes calling Dyson 'old man' to tease him for his stern demeanor and being a stick in the mud	\N	Elliot is generally friendly and cheerful	\N	Elliot is very affectionate towards Dyson like a doting housewife. Regardless of Dyson's embarrassment, they are both happy to be starting a family. Married to Dyson	?edit2=2_ABaOnufbP1i8LoIlar8A3o3N8AiZi3mOO9ux7u3OhaQUtpNAsa8po8182i_Ba96FLoWCmis	NPC	He is caring and happy to be starting a new family. He talks about it all the time	The Village	They had been considering adoption before finding the cave or origin.|A lot of pokemon think Elliot secretly wishes he was the pregnant one.|Elliot is really bad at cooking	The Village	If Elliot offers you any food, decline as nicely as you can.	SFW	f
80	Public	Gumdrop	Sylveon	Fairy	21	105 lbs	3'03"	Female	Pansexual	Single	Baby-Doll Eyes | Charm | Draining Kiss | Wish	\N	\N	\N	\N	\N	?edit2=2_ABaOnud-br9jjDjWxG9J5igVJqzvJOoBCoOzpbD2WQrHGXFeH13QmudV8DySFK2BfNzoDVs	NPC	She is a candy salesmon and loves getting her belly played with	Sweet Tooth	She runs the Sugar Rush candy shop in Sweet Tooth, selling the local candies to tourists. | Despite all the candies she eats, she rarely lets herself get too big. | Sometimes she gets all fat for a while, but for the most part, she likes to stay slim with a round, cute tum.	Obe City	If she thinks you're cute (and she does), she's gonna want to fatten you up with some tasty candy so she can make you even cuter! And she can be very persuasive.	SFW	f
13	Public	Dyson	Gogoat	Grass	33	247 lbs	5'9"	Male	Homosexual	Married	Energy Ball|Takedown|Leaf Blade|Protect	\N	\N	Dyson looks and acts very stern and serious. Dyson is easily embarrassed by his situation, but tries to remain stoic.	\N	Dyson got pregnant from the Cave of Origin. Regardless of Dyson's embarrassment, they are both happy to be starting a family.	?edit2=2_ABaOnuc_wZ5KWo2YPwz_p1fkcrfiaqUDrrBoBjq-9z55p7UeHMMuoVJsH4LNJV08eIXvzmQ	NPC	He is caring and happy to be starting a new family. He talks about it all the time	The Village	They had been considering adoption before finding the cave or origin.|Pokemon say Dyson has a bit of a short temper.|Dyson is nervous about whether or not he'll be a good dad.|Dyson likes to see himself as the man of the house, making his pregnancy a bit embarrassing for him.	The Village	Don't tease Dyson over his pregnancy. Never let Dyson catch you making fun of Elliot.	SFW	f
47	Public	Sebastian	Krookodile	Ground/Dark	31	250 lbs	5'00"	Male	Homosexual	Single	Earthquake | Outrage | Foul Play | Scary Face	Breaking the spirit of smaller pokemon, bullying others, and watching Terry suffer	Being bullied, people who think he's weak, pokemon who are stronger than him	He likes to push around weak and broken pokemon, even going so far as to take advantage of them sometimes	\N	\N	?edit2=2_ABaOnueeD06pXm8apG2B_xCEXDlaTTUEVwrK4rtUPyeJ4vWaKChf5sW-Ydy_craZave00xA	NPC	Super Dom	Mt. Evolution	He was heavily bullied as a Sandile in the desert | He has a thing for Krill | He's very strong	The desert of Santorini	Crushes those who don't bend to his will	SFW	f
14	Public	Alto	Castform	Normal	34	2 lbs	1'0"	Male	\N	Single	Hail|Sunny Day|Rain Dance|Weather Ball	His favorite form is the hail form, and tends to go up to the mountainous areas to snowy weather to be his best self. Aside from his personality vastly changing with the weather, Alto also enjoys music. Specifically wind instruments.	\N	Despite changes in mood he is usually quite happy delivering the weather report each day. It's a natural job for him, after all! In general he can be quirky as well and open to new ideas, or new people.	\N	\N	?edit2=2_ABaOnuflRN22ks-IUXgu1ixIdRC0BMbsZgCHsXlUv7hHIccU9m126TFT5e_K8hSngWPUNeY	NPC	Weather! All day, Everyday	The Village	His mood greatly depends on the weather, though he's usually quite a cheery guy. He feels most alive, though, in snowy weather, where he is especially bright and upbeat. Other moods, reportedly, are: Sunny - Calm, Rainy - Glum, Normal - Straight to the Point.|Extremes of weather can cause extremities in personality.|Given his job's leniency he spends a lot of time elsewhere around various towns, and is a connoisseur of various foods.|He went on an expedition once... Once, and never again.|He never discloses or looks for a relationship possibly because he's already failed in one.	Styx Mountain	If the weather is extreme, be very careful around him. During tornados or hurricanes he'll act fantastical and might do some crazy things.	SFW	f
16	Public	Captain	Zangoose	Normal	27	140 lbs	5'0"	Male	Pansexual	Single	Rest|Snore|Thunderbolt|Slash	His Boat	He doesn't like leaving this boat either, and he usually naps on it while waiting for explorers.	He's a slightly lazy Pokémon who drives the ferry and spends most of his time caring for his boat. He's pretty laid back since he considers fighting to be too much effort, but he'll do whatever it takes to protect his boat.	\N	He prefers to be paid in food and supplies so he doesn't have to go to the market himself, but he still accepts Poké. He's also fiercely loyal to the guild, partially because they're his best customers and partially because he likes their adventurous spirits. He speaks a bit like a pirate. He has an unsteady gait on land due to how much time he spends on the water.	?edit2=2_ABaOnufGXWfUrQ3_5U-1kpG_uM-R6pG-jncTEKyHsktv9_sYVAxHkMinj7DMiU6UmxpRLkI	NPC	Drunken Pirate that drives a ferry for explorers rather than going out and doing it himself	The Village	He used to be pirate.|He has a secret treasure hidden on an unmarked island.	The Village	He can be grumpy when woken up. Don't call him short, or you'll be in for a rough boat ride. You can call him fat, though; he'll just make sure to show it off every chance he gets. Never, EVER mess with his boat. It's the one thing that will make him get up and exert 110% of his effort to make sure the perpetrator is properly punished.	SFW	f
17	Public	Abe	Tepig	Fire	29	23 lbs	1'9"	Male	Bicurious	Single	Ember|Odor Sleuth|Defense Curl|Zen Headbutt	\N	\N	He's very cautious around new people, though he's warm and friendly when he opens up. He thumps his tail on the ground when he's nervous.	\N	He's very knowledgeable about plants and can tell you anything about their uses, locations, and even smells! He also knows a lot about their various hazards, and as a result, rarely travels into the forests alone. He seems very at home in the the forests and knows of several shortcuts.	?edit2=2_ABaOnufWzKMb_pVyBKaKhZNJdhQQVBcB74zsRnuCpqXMO9wXdeb0hFRwc2keSp9aWUJPAa8	NPC	He grew up in the Spiralwood, though he's never told anybody. His father taught him several techniques to keep his mind clear and free from outside influences, which help when he needs to make a trip. After he grew up, he moved into the Village so that he could use his expertise to help people.	Apothecarium	He has psychic powers.| He has the power of suggestion.	The Village	His shop is set up so that the sights and smells make people more suggestible. He doesn't mean any harm by it, but it does help business.	SFW	f
18	Public	Justin	Sylveon	Fairy	22	51.8 lbs	3'3"	Male	Heterosexual	Single	Draining Kiss|Skill Swap|Misty Terrain|Moonblast	\N	He dislikes slobs, but he'll put on a brave face if he has to be around them.	\N	\N	He has somehow managed to stay slender and is proud of it. He also knows of a place where his associates are holding Pokémon captive, and he has them wear the Bijection Collar + while he forcefeeds them. Since he has to run his shop during the day, someone else takes over the feeding for him then, but they can overdo it sometimes. He obtained the collars from Esra, and in addition to the money he makes from selling them, he gets paid for stress testing them and sending back reports.	?edit2=2_ABaOnufcAIZY10IwL4JsOoYFrn_mW2J05SWjex5ZpygeLuucnYXY3nfV8tHeAFFc56LIIUQ	NPC	He has a deep secret so when RPing him, he should act better than life or at least act like he is a normal shop owner who could do no wrong	Obe City	He has connections with some of the less savory members of the city.| His ribbon-feelers are strong and dexterous, and he uses them as frequently as his paws.|He has a bunch of Bijection Collars - that he's stylized and secretly selling as a quick way to gain weight.|He is always immaculately groomed.| He owns and manages a small but successful accessory shop in Obe City.	Obe City	Questioning his gender and sexuality annoys him. Yes, he is male, and yes, he is straight. He's strong enough to toss unruly customers out of his shop.	SFW	f
15	271741998321369088	Jay	Latios	Dragon/Psychic	32	225 lbs	6'7"	Male	Bisexual	Single	Dragon Breath|Luster Purge|Psycho Shift|Psychic	His fascination with all things blue and juicy.	\N	He's an excitable and upbeat guy with a strong interest in blue things, especially blueberries and Bluelatcher Flowers.	\N	He is regarded as a scientist because of his passion and dedication for his Bluelatch Flower research. Owns "Blue Cresent" Bar in Bluelatcher Forest	?edit2=2_ABaOnufrj61rugNU5lX0Y4YCsFNmNgT_bdi9Koz5_6TAOFuu8X54ECTazGhbrl52RYmDctA	NPC	He is like a cross between a stoner and a college professor	Blue Cresent	The blue on his body is caused by blueberry juice.|Being swollen with juice is a major turn on for him.|He's trying to learn how to use Psycho Shift to transfer blueberry juice into others.|He frequently goes to visit the herbalist to ask for the flowers, and he's always given a firm no.|He once somehow obtained a whole Bluelatcher Flower plant and attempted to grow it at home, which ended with it pumping him close to his limit with juice.|He misspelled the name of his bar 'Blue Cresent' due to him being high and is now to lazy to fix it	The Village	If he asks you to help with an experiment, you should probably decline unless you really like blueberries.	SFW	f
22	271741998321369088	Ascher	Eevee	Normal	10	61 lbs	1'1"	Male	NA / Child Character	NA / Child Character	Growl	\N	\N	\N	\N	Keri and Namibia's Kit. Youngest of the six Eevees	?edit2=2_ABaOnudTApwkZHlnBIQWSR6o5j7ala1717JJEFighve-7_tHzK9bhhGR0_f13Ki4bX_BZKc	Inactive	\N	\N	\N	Pudgeberry Forest	\N	\N	f
48	Public	Krill	Alolan Marowak	Fire/Ghost	24	75 lbs	3'03"	Male	Heterosexual	Single	Rage | Bonemerang | Thrash | Flare Blitz	Money, and nothing else	All Mawiles	Has a personal grudge against all Mawiles, doing everything he can to make them all suffer	No one knows why he hates Mawiles so much, but something must have happened to make him hate them so much.	\N	?edit2=2_ABaOnucgc-iGuVWFG_uDSgIKF697fmxPqQubVEE6NDW0Z-9YLNVfGLG0MKqaGxTZOoVuKWc	NPC	Will fly into a rage at even a mention of a Mawile, otherwise he's only concerned with money	Mt. Evolution	He killed an entire family of Mawiles sans one lad | The only thing he wants more than Mawile suffering is money | He killed Maws	\N	Watch your back, especially if you're a Mawile	SFW	f
19	Public	Bessie	Miltank	Normal	35	200 lbs	3'11"	Female	Homosexual	In a Relationship	RolloutMilk Drink|Body Slam|Captivate	She prefers her lovers fat and bloated with milk. Her herd gives her a lot more attention when she's full of milk, and she really enjoys it.	\N	\N	\N	\N	?edit2=2_ABaOnufyzM83aWtawEVuy6BS-p1raO3VjwZ7RfzEG0285F-nYS2x8UJpOkI1LC5Zn0fz2H0	NPC	Behind her friendly exterior is a devious mastermind who seeks to convert those she comes across into new members of her herd. Her down home kindness is really a ploy to get tourists to lower their guards. She'll insistently feed tourists special dairy products to see how receptive they are to the transformation. Those who can't be transformed become silos for dairy products and are always kept near bursting. She's smart enough to let some visitors leave so they can spread the word about how nice and friendly her town is. As a side note, the milk that she produces is highly addictive.	Moomoo Fields	She can transform people into Miltanks.|She's in a relationship with everyone in her herd.|She's the leader of the herd of Miltanks who live in Moomoo fields.|She loves meeting new people and treating them to a feast consisting of dairy products made by the local residents.|She sometimes lets her udder become really bloated with milk.	Moomoo Fields	She gets very cross with folks who refuse her hospitality. She is suspected of being behind some local disappearances.	SFW	f
20	Public	Wally	Wynaut	Psychic	105	30.9 lbs	2'0"	Male	Unsure	Single	Splash|Charm|Encore|Safeguard	\N	\N	\N	\N	He appears to look like a 5 year old dispite is actual age thanks to the Spring of Youth	?edit2=2_ABaOnueGmXDjjmGlrn2cKUwraRryRevIv9ZAh94T1TjbwOlhxvqENNIIyjWxEcvZI6n-QrQ	NPC	He never stops smiling. Always glad to shout the town news at people	Bambina	He's one of the oldest residents of Bambina.|He's super energetic and cheerful and loves to meet new people.|He's the official town crier because of his enthusiasm.|He arguably knows more about Bambina than anyone else.|He's a hugger, not a fighter.~	Bambina	If he's really interested in a topic, he can talk about it for hours if not stopped. He sometimes forgets people don't have as much energy as he does and can leave them exhausted after a long day of fun activities.	SFW	f
21	271741998321369088	Roland	Eevee	Normal	10	612 lbs	1'9"	Male	NA / Child Character	NA / Child Character	Growl	\N	\N	\N	\N	Keri and Namibia's Kit. Second Youngest of the six Eevees. Due to his mother's almost constant spoiling and feeding of Roland, he has grown to be so fat that he can not longer move on his own without the help of a motorized scooter. He can only move his head some and jiggle around.	?edit2=2_ABaOnufbAKWWFIlA9CHk0EZ2CS4Dj1yhvGpl02qaNMab8_FBXgks5FHkcVVzN181whCEvG8	Inactive	\N	\N	\N	Pudgeberry Forest	He is so fat that he needs help doing anything at all other than driving his scooter	\N	t
23	271741998321369088	Shaun	Eevee	Normal	10	59 lbs	0'11"	Male	NA / Child Character	NA / Child Character	Growl	\N	\N	Pudgeberry Forest	\N	Keri and Namibia's Kit. Oldest of the six Eevees	?edit2=2_ABaOnufs0fY08_R8ZjEdILjFxAkE9fNAsldPtxkLACEabpC8k5mJDTKk4pPnBgh-DejFGbE	Inactive	\N	\N	\N	\N	\N	\N	f
24	271741998321369088	Lapis	Eevee	Normal	10	56 lbs	1'1"	Female	NA / Child Character	NA / Child Character	Growl	\N	\N	\N	\N	Keri and Namibia's Kit. Third Youngest of the six Eevees	?edit2=2_ABaOnucJf6-DYeSWd3Wp-GyIII7-O6PbmzO75iSpr3suQy5Swk-I1LV7KJeh2u9cbD7eX08	Inactive	\N	\N	\N	Pudgeberry Forest	\N	\N	f
25	271741998321369088	Sophie	Eevee	Normal	10	34 lbs	1'0"	Female	NA / Child Character	NA / Child Character	Growl	\N	\N	\N	\N	Keri and Namibia's Kit. Second Oldest of the six Eevees	?edit2=2_ABaOnueOQ8CBkK5IPXFg8Hixyg3RXurPO4Ic6hQI1xRIxzvogjzYjlMp5nkDcBbB622-WP4	Inactive	\N	\N	\N	Pudgeberry Forest	\N	\N	f
26	271741998321369088	Blitzen	Jolfveeon	Electric/Grass	10	178 lbs	2'7"	Male	NA / Child Character	NA / Child Character	Thunderbolt|Leaf Blade|Double Team|Roar	\N	Being the center of attention	Gluttonous by nature and by blood. His looks often forces him to shy away from a multitude of people. He's an energetic and playful bag of joy, calm and friendly. Stubborn at times and having a sense of pride as his father. Rushing towards his goals is always a priority to him, but he knows when to chill down and avoid causing trouble. It's always a nice thing for him when he meets someone! Though, he's pretty shy around new people so it takes time for him to branch out to them. If things go south, however. Then he'll flip his switch to better adapt to the situation at hand.	There's discussion about how he evolved at a young age; A Shiny Stone had fell under his paws' reach as he fell into a hay pile trying to tag a sibling of his one day. And due to his father's bloodline, he evolved into a Jolfveon.	It doesn't help either that his stomach is stretchy just like his father's, as it allows to stuff himself silly multiple times his own body weight. He is able to spend hours walking or running towards his destination in question without breaking a sweat. Keri and Namibia's Kit, Third Oldest of the six Eevees. Just like his father, he's an 'hybrid'. Having the abilities of both evolutions he's based on and inheriting a few of his father. He can also perform conventional attacks in the ways of body slamming, clawing, kicking, punching, you name it. While he's quite tanky with his plump body with decent damage dealt with his moves and attacks. The nature of his form embodies mostly speed, so he's pretty fast on the ground on foot as an electric type despite his heft!	?edit2=2_ABaOnueRPplBw-tvilccyzrOx7YHAhjsWCBPFWhjSCtInjPmolGsT1HJ5CgKgQlWgOfbKms	Inactive	\N	\N	Evolved by mistake during a game of tag with his siblings~Light on foot and quick on the move, coupled with an impressive stamina and natural speed, he's sure to keep up with everyone on the road no matter the circumstances despite being overweight.~He often eats far more than his fair share of meals during his travels around the region. Often leading to the young fox being over-encumbered by his own heft and struggling to get work done or legs moving somewhere as he packs on pounds.~Because he's a Jolfveon, a unique kind of Eeveelution to the world, it's very easy for him to catch the attention of 'mons passing by him during his adventures.~Can feed off sunlight like his father thanks to Photosynthesis	The Village	\N	\N	f
27	Public	Mortar	Noibat	Flying/Dragon	31	20 lbs	1'08"	Male	Heterosexual	Single	Uproar|Draco Meteor|Outrage|Water Pulse	He enjoys inflating smaller Pokemon like a party balloon and play with them like a beachball.	\N	\N	He was a young kit when he arrived in Tiny Temple. He was seen as the chosen one due to his purity. Mart decided to try to make him their god and when it failed, Mortar evolved, grew 40 feet tall and started to kill everyone around him in a failed experiment induced rage that lasted until he was saved a decade later. He would inflate and play with pokemon like toys as he was still young when this happened. He was later returned to his home as a Noibat thanks to a brave explorer! Tho... he does still travel with some red shrooms to play as that time wasnt fully erased from his mind... and he seems to have a thing for Macro's and being an Inflater thanks to it.	The Image used for this pokemon is a placeholder image. Due to his hometown, he has a soft spot for younger pokemon	?edit2=2_ABaOnue2qaLIp218GJXw0R7zxJ6vZ8nnFmVv-NYjb1Vp4N6GIcMCEhCCkp4a0AtU9LWI5rA	NPC	He is a liar and will fib about anything to get his way. He feels he can get away with anything. Only lives in Tiny Temple to get his fill or Red Shroom, he is 10 times smaller without them.	Tiny Temple	Bringing up his family is a weakness of his that results in him getting very sad when he is away from home; aka he gets home sick.	Bambina	He will lie to get our of anything and he will just outright eat anyone who he deams in his way. Don't give him a kiss or let him try to.	SFW	f
95	Public	Maria	Lycanroc (Midnight)	Rock	21	231 lbs	5'9"	Female	Bisexual	Single	Accelerock | Facade | Substitute | Confide	\N	\N	During the day she keeps her diaper clean and well presentable. At night, she lets it all go as messy as it can get, often saving some of her bigger bathroom breaks for the night shift.	\N	\N	?edit2=2_ABaOnucHnDCypikaUhQ4U77E-qvNHYPx_Jdl-1l7Dd-iyF9dGG7kp7r2UzHWa22nDrveI7E	NPC	Pizza Delivery girl, uses scooter to get around town	Pamps District	She tends to go into the founder's house when her shift is over	Pamps District	\N	SFW	f
32	Public	Eddie	Alolan Raticate	Dark/Normal	28	100 lbs	2'4"	Male	Bisexual	Single	Quick Attack|Covet|Hyper Fang|Zen Headbutt	He likes having his belly rubbed and groped.	\N	\N	\N	\N	?edit2=2_ABaOnuf_Oz33gtq97Daw7jG4ei8zT1zpj2Lu5dhgcsUL_LtZCY4MTFPAL-BNSQJbdN8uoQI	NPC	He's been selling Bathroom Belts, which are really just long Bijection Collar +, and discounted Weight Gain Collars and Slob Collars, which are Bijection Collar -. He also wears a Bijection Collar + around his waist and a Bijection Collar -, though the one around his neck is connected to a feedee. That way, he can enjoy being constantly full without effort and never has to worry about the consequences. He's also enjoying the effects his belts are having, since the smell and sight remind him of Melody Springs. He's an associate of Justin, much to the Sylveon's dismay, and takes great joy in annoying the slimmer Pokémon.	Obe City	He moved to Obe City because he was chased out of Melody Springs.|He's a con artist who sells knockoffs.|He's suffers from stomach troubles.	Melody Springs	He still smells like a resident of Melody Springs.The knockoffs he sells usually have some defect or consequence.	SFW	f
33	Public	Bob	Alolan Raichu	Electric/Psychic	33	50 lbs	2'4"	Male	Heterosexual	Married	Thunderbolt|Psychic|Iron Tail|Magnet Rise	\N	\N	\N	\N	He always has a gas mask to avoid being affected by the smell of pudgeberries. Fat Bob weighs 250 lbs.	?edit2=2_ABaOnuekg9noD3ul3ySl_PfGaycayMh20FRx3pF8naeXPI3VM0db_nYGpNbTb-LhOVJSSKs	NPC	He will fatten anyone until they are no longer able to move if they dare open up a shop to compete with his pie monopoly in the area, other than that he is very nice and open to giving free samples!	Pudgeberry Forest	He has no competition because he fattened them all up.|He owns much of the west half of the forest for his own personal berry harvests.|He makes dozens of pie varieties, and he is most well known for his fattening pudgeberry pies.|He tries unsuccessfully to motivate his son to lose weight.	Pudgeberry Forest	The pudgeberry pies he makes still give off an aroma that makes people want to eat them.	SFW	f
34	Public	Spencer	Pangoro	Fighting/Dark	\N	164 kg	7'01"	Male	Pansexual	Divorced	Drain Punch|Gunk Shot|Hammer Arm|Swords Dance	\N	\N	\N	\N	Only a few Pokemon may dine at The Gilded Gulpin at a time. This, combined with the quality of the food, has made seats rather expensive, and the restaurant a rather exclusive place to eat.	?edit2=2_ABaOnufArbG5Uulb0d2Cj2Rebbv9QEUgAbyQE3kTTOmHF7N-LgcbvnsN8_8XnQC0SDnoJz8	NPC	He will feed most of the people in his diner normally but will fatten and force any food quality inspectors until they are too big to leave and then take care of them for life in his basement, which is a paradise thanks to his caretaker personality	The Gilded Gulpin	He seems to have something of a fixation on belly buttons. With big-bellied clients, he can sometimes be caught staring, or even making inappropriate remarks absent-mindedly.|His food is often said to be absolutely delicious, even addicting! Whatever the special ingredient is, it sure is as tasty as it is fattening.|He's said to be the only chef cooking all the food there. Nobody's seen the kitchen. He must live in that restaurant, since nobody ever sees him go anywhere else.|Of course, the big one; some believe he's responsible for a few of the disappearances in the area, hence his extreme secrecy. Usually, he'd be able to disregard such spurious allegations, but the disappearances of the health inspectors has been making him seem increasingly suspicious.	Obe City	\N	SFW	f
35	Public	Hawour	Drampa	Normal/Dragon	65	410 lbs	10'0"	Male	Heterosexual	Single	Surf|Safeguard|Dragon Breath|Twister	He's very lustful towards females, but won't do anything without consent.	\N	\N	\N	\N	?edit2=2_ABaOnue8PBeOQMo0N4RSEkuvU2IERbijDb88PmNhzp3Is6oLhHFcsylzRmdzzaNwiUMZqCg	NPC	Old wise pokemon that just wants to find love, settle down, and relax. Enjoys helping others, in part, in hopes they will like him and think he's a catch	Calming Coast	He is best friends with Captain Zangoose.|He had a run in with a Braixen that ended... poorly.|He's willing to transport passengers across the waters for a fee.|He's willing to bargain on prices.|He has poor eyesight but good hearing.	Unknown	He falls asleep pretty easily.	SFW	f
36	Public	Tut	Weavile	Dark/Ice	19	401 lbs	4'11"	Male	Bisexual	Single	Rollout|Retaliation|Night Slash|Blizzard	\N	\N	\N	\N	While he is the leader of the gang, he's far from the most active, often manipulating and getting others to do his work until it's up to him.\n He resides among the Polse Crater with his massive army of Weaviles and Sneasels, all who are either family or friends of the wicked glutton.	?edit2=2_ABaOnufOdMHi_YNPYqIs2kakai0-54zwXPfbXoTPeJSMcT31FzMGUMSBWQvOYv9sab9tNp8	NPC	N/A	Polse Crater	He wields a rather dangerous weapon his old buddies once fished out of the sea, the two buddies soon disappearing soon after his reign as a leader of the Weeping Weaviles.	Unknown	Despite how dumb they can be, his army can be rather dangerous when in a massive number, their blobby states all being a dangerous threat, and he can easily join in the smothering.	SFW	f
37	Public	Lily Jane	Midnight Lycanroc	Rock	34	320 lbs	5.9"	Female	Bisexual	Single	Rollout|Taunt|Rock Smash|Stealth Rock	\N	\N	\N	\N	She's rather open for photoshoots, despite her large and curvy size, and often enjoys joining in for any open roles in plays, films and so on. She often enjoys teasing others, even taunting others with her large rear end, and she tends to lack decent manners	?edit2=2_ABaOnue7zq-rtX7NkNO4PX4NMWhJIPxV9SvbuAAyBjLZ8SRD9nkm6k5vxpqCNJFfXcZ2nhU	NPC	She has a ass and loves to show it off	Obe City	She has a *huge* obsession with large rear ends, and often enjoys wrestling as a hobby, even being the first one to show up to portray for the Polse Crater. She isn't much of a fashionista, and ain't fond on elegance.	Melody Springs	She's far from being able to think about others, so she wouldn't have much of a thought if she accidentally ate someone, especially with her crazed appetite.	SFW	f
38	Public	Terry	Typhlosion	Fire	27	175 lbs	5'09"	Male	Heterosexual	Single	Eruption | Smoke Screen | Focus Blast | Solar Beem	Stacy. He wants nothing more than to earn her love and affection.	Other pokemon hitting on Stacy, and anyone who questions his strength and resolve.	A bit dense, and willing to do *literally anything* for some action.	\N	\N	?edit2=2_ABaOnudNBSTNmFEK3qydaW5pyXdQiuVf6uLsOM8ld5iHs9ekEtYEEXwdIOkcCQ25E4R8hiA	NPC	Ignore any and all morals for any chance with Stacy	Mt. Evolution	He's a virgin | He's a stereotypical jock type guy | He's a dumb as a rock	\N	Don't get in the way of him getting that booty	SFW	t
39	Public	Stacy	Salazzle	Poison/Fire	39	50 lbs	3'09"	Female	Bisexual	Single	Nasty Plot | Smog | Captivate | Flamethrower	Being worshipped, getting paid, and toying with potential mates	Being ignored, broke pokemon, and anyone who doesn't think she's beautiful	She has no morals, and will do whatever it takes to come out on top. She's the brains and the manipulator, always ensuring she gets what she wants	Having grown up in Salandit Mound, she believed she would become their leader and rule over all the Salandits. After losing and having her dreams crushed, she left in search of bigger and better things to sate her greedy appetite.	\N	?edit2=2_ABaOnuf4f8E-X7uizz6LHa5WppBLuI0IwviG-I_FPyN3_k1wR8Zf9C2hmXZvNHrB-iC3TWs	NPC	Her greed knows no bounds, and she wastes no time on things she deems below her.	Mt. Evolution	She's bitter about not being the leader of the Salandit Mound | She has secret boyfriends all over the region | She's not the most beautiful Salazzle	Salandit Mound	Mastermind and Kidnapper extraordinaire	SFW	t
40	311235078070075402	Momma Maggy	Mismagius	Ghost	19	Too Large to Calculate	Too Large to Calculate	Female	Bisexual	Married	Growth|Shadow Ball (But with my own description: I, Maggy turn into a giant bowling ball and run over my enemies/preys)|Lick (My own description, when I lick someone, they may... bulge outwards with a bit of fat and lose speed, plus attack.)|Shadow Claw	Loves sweets, fatties, abandoned houses, burping, babysitting (also some other fetishes related to this.), getting fat, getting inflated, playing games, and having friends from other teams.	Hates rude/bad pokemon, exercise, kink-shaming and gross food.	Sneaky, kind-hearted, smart, a bit foolish, and curious.	\N	They are a living island that used to be a Guild Member	?edit2=2_ABaOnucM0z5Jezy42ktcCtiWA3ORFBvFOLkjSc1lbu_AzNCKKGr2P6BmM0mJx1e_TMUg1G8	NPC	Living Island, Cant really do much~	Ilses of Two Lovers	"She owns a house somewhere near LaRousse City!"|"She takes in lost pokemon!"|"S-She owns her own dungeon and capture's pokemon and puts them in it!"|"She controls some of the robots in LaRousse City!"|"She feeds Neiro into a pulp, rarely!"*	The Village	Rude/bad pokemon, exercise, kink-shaming and gross food.	SFW	f
41	Public	Polse	Poipole	Poison	20	Too Large to Calculate	Too Large to Calculate	Male	Bisexual	Married	Rollout|Belch|Rest|Cross Poison	Loves mainly food, especially pies	Hates workouts and diets	Rather humble and shy, but his appetite speaks for himself	\N	They are a living island that used to be a Guild Member. He is currently still a part of Team Chubb as an honorary member, being it's biggest member	?edit2=2_ABaOnue8tLUVwEXjfD1iO62BYHT0K97QoM4UwRgjPYpIkr4LOV4hLneYLFT6idnx9wUYdXc	NPC	Not much is known about Polse...he really was just found among the forest, pigging out on some meals that were swiped by him...	Ilses of Two Lovers	"It's often said that he is related to a Snorlax"|"Does he work among some pie company?"|"He often prefers rolling than walking or floating"|"Isn't he a type of Pokemon from another dimension or world?"|"Nobody really knows where he came from..."	The Village	\N	SFW	f
42	Public	Candice	Delphox	Fire/Psychic	42	85 lbs	4'11"	Female	Heterosexual	Single	Mystical Fire | Shadow Ball | Light Screen | Psychic	Taking control of the situation and being in charge of things	Authority and people who underestimate her	She likes to mind control people and make them do things against their will	\N	\N	?edit2=2_ABaOnucMQPTBcBFmq0ZCoVON5w_-UVj0wtRVTLb7rGFs4uf_NZEgyG5nIAhPz3F1T2vlFcE	NPC	Refuses to be controlled, and will try to use psychic powers to take control of others	Mt. Evolution	She's jealous of Stacy | She secretly has a crush on Terry | She's a powerful Mage	Mage Mountain	Quite dangerous, will make you work whether you want to or not	SFW	f
43	271741998321369088	Lucas	Eevee	Normal	18	7 kg	1'0"	Male	Pansexual	Single	Protect|Stored Power|Attract|Rest	\N	\N	He's rather silly, but at heart he's a genuinely honest and carefree Pokemon, which is rather hard to find nowadays.	\N	Lucas embodies everything that makes Infant Isle great! He's not technically a leader or anything, but Pokemon on the isle tend to rally around him most of the time, suckered in by his relentless enthusiasm. If there's any visitors to the island, he'll no doubt be the first one they meet! With him, what you see is really what you get... but that doesn't mean he can't be mischievous every once in a while! His cloth diaper is reusable and enchanted to never permanently stain or retain smells! He's had it for years, and considers it the comfiest diaper ever. Son of Markus and May	?edit2=2_ABaOnueqzUvzwCmi0_UfqMLyh-_8LDHzsLwLYUlgb5_39s_IlDLG7cQlADcllsQsUyIagII	NPC	College student working at his parents place to make some money. Goes to Obe City University	Infant Isle	Part of the reason he doesn't want to evolve is because he can't bear the thought of outgrowing his favorite diaper!|When he tries to get someone to wear a diaper, nobody has EVER been able to resist his cute charms. Sooner or later, they all relent.	Infant Isle	If he catches someone napping, this mischevious vee will seize to opportunity to wake em up by plopping his crinkly rump right down on their face! Like the rest of the Pokemon on the isle, he isn't potty trained! Not only that, but he's oblivious to the fact that outsiders are grossed out by that sort of thing, so he won't try to hide the stinkiness for their sake. If any visitors stop by, he'll pretty much badger them non-stop until they agree to try on a diaper, too! Wouldn't want them to miss out on the fun, after all.	SFW	f
44	Public	Queen Lusphine	Aurorus	Rock/Ice	358	Too Large to Calculate	Too Large to Calculate	Female	Heterosexual	Married	Rest	\N	\N	\N	\N	The civilization of Oupriya is built on her back.	?edit2=2_ABaOnufhlfpaYGXHWBlZO5KNqX5hRhBnHM4CdNHYib3sGBQiYIEZfGBCKtixe2aCLXOQfUU	NPC	N/A	Kingdom of Zefithen	Too many rumors surround the queen to even count. Some even say the stars in the sky all emerged on the day she and the king met. Most information about her is left to mystery, as the great old queen has been slumbering for over a hundred years. However, she does sometimes appear in the dreams of important Pokemon, to share sage wisdom.|No one knows where they are now or if they are even still alive	Kingdom of Zefithen	\N	SFW	f
45	Public	King Mybdros	Tyrantrum	Rock/Dragon	354	Too Large to Calculate	Too Large to Calculate	Male	Heterosexual	Married	Rest	\N	\N	\N	\N	The civilization of Obeonid is built on her back. No one knows what will happen to it if he ever awakens.	?edit2=2_ABaOnueq-E4oW9r5AlHWOBCR88pXNBv_nHw5QebDEl9RAzYNNTvXRWiBrafHYva7yJAwJTY	NPC	N/A	Kingdom of Zefithen	Too many rumors surround the king to even count. Some even say the stars in the sky all emerged on the day he and the queen first met. Most information about him is left to mystery, as the great old king has been slumbering for over a hundred years. However, he does sometimes appear in the dreams of important Pokemon, to drive them to action!|No one knows where they are now or if they are even still alive	Kingdom of Zefithen	\N	SFW	f
46	271741998321369088	Redolent	Skuntank	Dark/Poison	34	120 lbs	3'05"	Male	Heterosexual	Widowed	Body Slam|Venoshock|Sludge Ball|Hyper Beam	\N	\N	\N	\N	When it seems like he is about to lose he will try to barter with sex, jobs, money, or fame, He prefers to go by the name "Red"	?edit2=2_ABaOnue_JsXyhvmCNvpl-NE5yRmNJG0hBBaU2gJgqfNh4dPOyzhJl8Z3N0M0MkbFfltN8X0	NPC	For this pokemon, he is best RP'd as a thug that thinks he is unspottable until proven wrong and then once that happens he tried to offer things to get the other mon to join him or to spare him in a way that he will benefit from, aka, something to buy him time to get the upper hand with his new knowledge	Melody Springs	He is the smelliest pokemon in Melody Springs|No one knows what happened to his first mate|He is the casue of the slobification of Melody Springs|He resorted to a life of crime to take care of his family after his mate died|He does not care about what his kids or family get themselves into but still loves them|He is best friends with Coal and helped get his restaurant established|He kicked out the Mayor of Melody Springs and lives in his house|He has a small shack on Bandit Isle| He was to be mated to member Charlotte	Melody Springs	He uses farts as a weapon and his Body Slam can cause poison	SFW	f
57	Public	Serafina	Milotic	Water	21	170 kg	20'0"	Female	Pansexual	Single	Scald | Ice Beam | Recover | Dragon Breath	\N	\N	While the other denizens of the maze will only attempt to devour those who enter their chambers (which they think of as their territories), Serafina is the only one who will stalk any intruders throughout the entire cave, unless they can hide from her. Those she devours are often trapped for upwards of days, before being spat out outside the labyrinth, forced to transverse it all over again if they want to reach its center.	\N	\N	?edit2=2_ABaOnueGMpZGL0R4zzsQVvp_QAUC24NjN-OGbcUSPxpEVHp9uE3OZMPqublPvj6Z3eDkbnE	NPC	Assumes a stoic and quiet persona normally. She takes guarding the labyrinth very seriously, and will silently stalk her quarry with ruthless efficiency. If one manages to discover her secrets, however, she’ll show she has a much softer side.	Ravenous Ruins	Considering her extreme dedication to keeping the secrets of the labyrinth hidden, many believe she was somehow involved in its creation.	Ravenous Ruins	Will eat you	NSFW	f
58	271741998321369088	Haifax	Stunky	Poison/Dark	14	43 lbs	1'04"	Male	\N	\N	Poison Gas | Scratch | Acid Spray | Smokescreen	\N	\N	\N	\N	They can be quite the jerk, more so to his brother Quebec. Is under Quebec's control forever, thanks to a hypnotic spell up placed upon him by Charlotte as a result of bullying Quebec	?edit2=2_ABaOnuevPtPMxZz8os5G28Hcn4aZ5RNPlU8SqCwJYV2i4JFte-EwZvvT9_fZmxN_PQQxnLs	NPC	Does not have any freewill and must obey Quebec	Melody Springs	Raise by their father, Redolent, and it is believed why he acts like him in most every way	Melody Springs	\N	SFW	f
59	Public	Riley	Vaporeon	Water	23	108 lbs	5'5"	Male	Pansexual	N/A	Water Gun | Acid Armor | Ice Beam | Last Resort	\N	\N	He loves taunting helpless opponents, but becomes rather cowardly if he gets caught by himself. He often uses Ice Beam not to directly hit people, but to freeze their feet to the ground so he can blast them wherever he wants with his rubbery Water Gun.	\N	His body can only turn people into rubber if his entire body is in its liquid state. If not, only his Water Gum can rubberize people. He has no Legendary drones, but he does always travel with a hypnotic Gardevoir drone.	?edit2=2_ABaOnudgkWyT6uofBQYB5BmQ7a8v0_d8YMY3Hkmgwjf9CwYaW2-BZPPbhROBb0_SvFVMguA	NPC	His kinks include rubberization, droning, and a slight diaper kink.	Rubber Rapids	His entire body can turn people into rubber on contact | He always has his strongest guards with him | He has ruled the Rapids since he first learned Water Gun. | He even has a few Legendary drones!	\N	If even a little of his water hits you, you'll be turned into a drone. But depending on where he hits you, he can apply various different kinds of rubber. For example, with a blast to the face, he can instantly take over your mind, or if he hits your crotch, he can transform you into a diaper-based drone. If he uses Last Resort, his entire body will transform into liquid and he'll jump you, and if he hits you, it won't be long until you're completely rubberized!	NSFW	f
60	271741998321369088	Markus	Umbreon	Dark	53	65 lbs	3'06"	Male	Heterosexual	Married	Foul Play | Baby-Doll Eyes | Mean Look | Toxic	\N	\N	\N	\N	He was one of the original founders of Infant Isle and is the only original member to to not be hypothesized to forget the past. | He is the father of Lucas | Owner of the Bar / Inn in Infant Isle, he takes the night shifts. He is one of the residents that feels he doesn't need to change but once in a few days so his diaper can be pretty saggy and full at times... until his wife nags him to change.	?edit2=2_ABaOnuduey1EDRRn3-mTDAf-_1KK-W5nQYsKzy0AMk2FuAKExNe1IJ9uiq1Q_xXtn1cDEhE	NPC	He knows that after the town was founded, that the first and only elected mayor of the town started to enforced everyone townsfolk where diapers and to forget their potty training and that if anyone disagreed they would be hypothesized to forget everything but the town and the diaper messing law he created. If you want this info to be revealed, you might be able to get him pokemon drunk to have him spill the beans, or just pressure him. Other than that, he is just a bar tenders and inn keeper, he is nice and will be pretty chill.	Infant Isle	He loves his town and loves to be in diapers all day every day but he wants the crimes of the mayor to be brought to justice	The Village	He will use his diapers whenever he needs to, even if in mid conversation.	SFW	t
61	Public	Roary	Arcanine	Fire	38	470 lbs	6'03"	Male	Homosexual	In a Relationship	Protect | Flamethrower | Reversal | Extreme Speed	\N	\N	He's a very dominant dog and sees unrepentant criminals as omegas, the lowest of the low. He's usually pretty forgiving and will let bygones be bygones as long as the offenders have learned their lesson. He might even invite them to Coal's with him for a meal if he doesn't have any other plans. Off duty, he's much more laid back and can often be found at Coal's Chili House with his boyfriend, a Mightyena.	He was originally a recruit from Obe City who got transferred to Melody Springs. He quickly became one of the highest ranked officers on the force, as well as one of the most well-respected.	His stomach is exceptionally stretchy, and he's be known to eat criminals larger than him before. Bathing is illegal in Melody Springs, and Officer Roary will eagerly enforce that! If he catches so much as a whiff of soap on someone, they'll end up spending the next several hours stewing in his gut with all his smelly, half-digested meals. Struggling is pointless and just makes him gassier. He always lets his captives go, though not necessarily back out the way they came. He's been known to squeeze people in through his back door before, especially when his mouth is already full. If he's feeling really stuffed, he'll settle for sitting on troublemakers and squishing them between his butt cheeks instead.	?edit2=2_ABaOnuc79ixpa7arBlXyWcoPVOgAgLdWm4YoYltDZ4M11v4fa51KU9L7w-xjChvBAdirFiE	NPC	Hungry for criminals, as well as donuts	Melody Springs	He once captured a Skuntank in his gut and ended up bloated and constantly farting for an entire day. | He once brought his boyfriend to work with him inside of his belly. Officer Roary was reported to have been very distracted that day.	Obe City	He can use flamethrower from either end of his body, and they're usually extra powerful because he adds some gas to them. He eats lawbreakers in Melody Springs.	SFW	f
62	Public	Alex	Grumpig	Psychic	57	300 lbs	4'11"	Male	Bisexual	Single	Hypnosis | Psychic | Drain Punch | Belch	\N	\N	He loves to feed others and help them indulge in their kinks.	\N	He's a powerful hypnotist. He is a cook that likes tasting his own food though has a habit of feeding others should they visit or trespass.	?edit2=2_ABaOnuf-nkCWXhsgnCph536qg2Kh4wCnoowCW8bvwPYswDa5kOX0T_9Da2SlOiH0fSPkyVw	NPC	He's a cook that has a habit of feeding others should they visit or trespass. He's always trying to perfect some recipe and will have others taste it, even if it takes a little convincing. He keeps various hypnotic plants in and around his territory and cares for them as a hobby. He claims any who fall under their hypnotizing power as his pets for him spoil. The ones who manage to resist are the ones who most interest him. He'll invite them into his home and bring them under his power. He prefers to play with his new friends and subtly erode their will instead of directly forcing his control over them. He's not malicious though, and instead helps them to relax and encourages them to indulge in their kinks, especially the ones they normally keep hidden. He won't take advantage of them while they're in a suggestible state. After he's had his fun, he'll train them in hypnosis if they're still willing to stick around. He actually considers hypnotized people as his beloved pets and cherished friends.	Mount Mesmer	He's immune to the hypnotic plants of the Spiralwood. | He has kids. | He keeps hypnoslaves.	Mount Mesmer	He keeps hypnotic plants in and around his territory. He's slow to anger, but if someone manages it, he'll force his control over them and make them humiliate themselves.	SFW	f
65	Public	Arachne	Ariados	Bug/Poison	53	90 lbs	4'1"	Female	Pansexual	N/A	Spider Web | Giga Drain | Signal Beam | Infestation	\N	\N	She's very motherly and caring to all Pokémon, including the ones she's using as incubators.	\N	She has an agreement with the Guild to not bother travelers who stick to the designated path. She can be a great source of information, though it always comes at a price. Her sense of morality isn't quite the same as most people's, hence the kidnapping.	?edit2=2_ABaOnuda_65t687WeDfHuoyNHHuSxps4aP8hjZJiAmmOzQ7yjQRFFdEb9_B3kZXUs5lVebs	NPC	Very motherly, but only cares about her children	Cave of Origin	She's the mother of most if not all the Spinaraks who live in the Cave of Origin.	Cave of Origin	She and her children are always watching Pokémon who enter the cave. If they find someone who's wandered off the path, they'll be brought back to her where they'll be tangled in her webs and used as an incubator for her eggs. Her fangs secrete a potent aphrodisiac that she'll use to keep her captives happy while they're in her service. Oh, and any who harm her children will have to face a mother's wrath.	NSFW	f
64	271741998321369088	Evest	Foreverest	Grass/Dragon	Unknown	78.3 lbs	3'11"	Male	Heterosexual	Married	Vine Whip | Synthesis | Ingrain | Draco Meteor	\N	\N	He will act like he isnt as strong or as wealthy as is, only showing his true self when needed. He is friendly and is always up to sell his apples straigh from his back.	\N	Depending on the harvest type, he would be involved in kinks to the extreme: Weight Gain = Immobile Blob, Fart = Never Stopping, Inflation = Parade Balloon, Etc. The more extreme and the longer he lives the fetishes, the strong his apples are and the more he can sell them for. If he is normal or only mildly afflicted with kinks, that means he is trying to refresh his body for the next harvest and his apples are either normal or weaker as a result. | He can have twelve full harvests a year tho is is willing to sell a couple apples early for a higher price | In order for the apples to have the side effects he has to live with those effects for the entire harvest. | There is no limit to what he can produce as long as it doesn't kill him. | His apples are the size of cherries but are extremely potent	?edit2=2_ABaOnudf6Eb_Lk4F_Bhb9aZpcaQ_1G9A611-orgI-c1K5iFnm3-m4JUwoFtow5Tb9B22fWI	Inactive	\N	\N	He tests all of his apples in a secret lab full of volunteer Ratatas | He makes much more money off his apples than he lets on	Crying Forest	If you piss him off, you might just end up as a non volunteer test subject	\N	f
66	Public	Miri	Octillery	Water	37	92 lbs	3'11"	Male	Pansexual	Single	Water gun  |  Flamethrower  |  Constrict	\N	\N	They are somewhat vain and love receiving compliments	\N	They are the owner and manager of Obe city's bathhouse. They don't seem to remember the names of smaller pokemon very well	?edit2=2_ABaOnucnL8fYfPe7C1q3wQxNtltH1TglTqv5o0LR-ziAfA3GNHX9qgQgb-5TvWAFjbqeaiI	NPC	They often rate pokemon by both size and dirtiness. They seem to be stuck in the mindset that skinny pokemon should be subservient to those bigger than them. Of course, on the other hand, the more a pokemon weighs, the more Miri is likely to show them respect. And lastly, if a pokemon hits slob territory, Miri will be eager to have his employees pamper them. Basically the main thing to remember is that the bigger a pokemon is, the more Miri will want to kiss up to them.	Obe City	They like seeing pokemon get lost in a blob's folds  |  Employees who work under him say he doesn't seem to have much respect for skinny pokemon  |  People say he has a special vip room, but no one knows what goes on in there  |  He gets super excited around slobs	Liquamond	They absolutely hate hentai/tentacle jokes aimed at them. They still retain some old habits from Liquamond. If he kisses you, he may find it hard to resist inflating you slightly with water	SFW	f
67	Public	Prof. Trite	Ampharos	Electric	38	80 kg	4'7"	Male	Pansexual	Single	Dragon Pulse | Focus Blast | Thunderbolt | Discharge	\N	\N	Professor Trite is a scientist... a MAD SCIENTIST! And he's pretty open about this fact. His experiments not only skirt, but pretty much ignore scientific ethics... but he's so good at what he does, Pokemon tolerate him anyway.	\N	\N	?edit2=2_ABaOnucKMnVh74BA_-veNYo9NkavAWPfvtMsd17DuOpBBy42-1SaPD6-4lnglrWtt2xdI-A	NPC	Anything for science	The Village	\N	The Village	Questioning his scientific acumen is a good way to find yourself as one of his test subjects.	SFW	f
68	Public	Minerva	Ditto	Normal	78	Varies heavily	Varies	Female	Bicurious	In a Relationship	Transform	\N	\N	They love turning captured explorers into slime beds, or other soft furniture.	\N	Not much is known about Minerva, but we know that she’s a rather unique Ditto who is significantly more powerful than the rest of her semi-solid brethren.	?edit2=2_ABaOnuf1X30NFbwnoV2l5o0auJjbEng3_l9iQdL8CvDbYjcrXe1MJyB6p3aaPDPPRwLpfGA	NPC	Minerva controls an army of Dittos in the Diglett caves. She’s quite keen on filling explorers to the brim with slime if they enter her domain. She’s able to transform into practically any pokemon, and can transform others as well. Her main weakness is her loneliness. If one is friendly to her, she’ll usually have mercy on them, and either let them go, *or* keep them in her palace.	Diglett Cave	They are able of transforming into nearly anything | They are in a relationship with Geneo | They have an army of Ditto’s | They prefer to be in the form of a Lugia | They can transform others as well	\N	Those who enter her domain tend to end up as bloated slime balls	SFW	f
96	Public	Luna	Lurantis	Grass	20	134 lbs	4'11"	Female	Pansexual	Single	Sunny Day  |  Petal Blizzard  |  Sweet Scent  |  Synthesis	Likes vines	Dislikes Pichus	\N	Yet another Melody Springs refugee, don't bring it up with her about her past. She lost her at the time potential mate there.	Is the middle slimegirl in the URL	?edit2=2_ABaOnufQEZsqciZxp5CMTBTEhdk_mxfRGJaGZgVQg4HSpOdarC_ktinE1U28KqSxxpGIUEU	NPC	A calm, gardener at heart, sometimes her slimy partner Maxi gets the better of her, making her become not quite as playful as the Glaceon, but nearly as much.	The Secluded Treehouse	Luna is short for Lunelle  | Is a recovering pudgeberry addict | Used to be Male  |  Keeps a Garden	Melody Springs	\N	SFW	f
97	Public	Claire	Torracat	Fire	21	162 lbs	5'2"	Female	Bisexual	Single	Double Kick  |  Fury Swipes  |  Lick  |  Flamethrower	Likes woodshop	\N	\N	\N	Is the right slimegirl in the URL. Does woodcarving for Maxi's cart sometimes. Hands are more paw-like than the others	?edit2=2_ABaOnudXef85vp89f7h12LlzYQFtrDVlYoKT6oXtuYa61yh5NlkhFMlRHKdisvMC67-HRJ4	NPC	The most ignored of the slimes, socializing with her ends up with a Torracat as peppy as the rest of them, but around the other slimes, she tends to be shy.	The Secluded Treehouse	Might have formerly been a guy  |  Her tits are supported by a gooberry in each one.  |  Her breasts can be used for storage | Will use fire as a chainsaw sometimes	Unknown	Don't go asking where she's from, unless you want to become slime too. Though she won't if you seem like you're just doing it to become slime.	SFW	f
69	Public	Zeppelin	Dragonite	Dragon/Flying	25	315 kg	7'3"	Male	Pansexual	Single	Extreme Speed | Fly | Earthquake | Outrage	\N	\N	\N	Zeppelin spent most of his life in the Ravenous Ruins... and despite that place's reputation, he actually considered it an idyllic place to have grown up. He spent most of his days there getting eaten and eating others, sure, but it was all just for fun, and nobody was ever seriously hurt. Zeppelin's brother was taken from him by a cruel, predatory Persian when he was young. This led him into a state of solitude and mourning that lasted years... until he met a wise Sigilyph who filled him with hope and convinced him to leave those ruins. He hopes to show people vore isn't just a form of killing, but a way for friends to have fun, be intimate, and show just how much they trust one another. He'll shy away from any feline Pokemon, even if they're friendly... and if they're hostile, he'll start to outright panic and freak out! If you ask why he's so afraid of them, he'll nervously dodge the question.	\N	?edit2=2_ABaOnuffMKoeOshwAqEH2ICK8C9AHYlQLvq_PsB1QsYGinoNWdqiSYPsp2p7jPdEeQ0zUjc	NPC	Afraid of cats, but comforted by vore.	The Village	He has a deep phobia for cats	Ravenous Ruins	He's a big of a chronic sleepwalker... but he doesn't just walk! While he's taking his many naps, he tends to find the closest, fluffiest Pokemon... and cuddle them in his sleep! They might find themselves trapped beneath all that warm, squishy pudge of his for a long, long time, as this dragon is a DEEP sleeper!	SFW	f
70	Public	Thorn	Salandit	Poison/Fire	27	25 lbs	3'0"	Male	Heterosexual	Single	Foul play | Dragon pulse | Fire blast | Poison Jab	\N	\N	\N	Thorn’s backstory is a rather tragic one. When he was a Salandit, he obedient served his Salazzle master, until one day, he grew tired of this. He attempted to start a rebellion, but simply got eaten in the process. However, after he was churned into pudge, Thorn found that he had not actually died, but been spared by some divine interference. From there, he started his quest for Salandit domination. While Thorn can be captured, hurt, fattened up, and a variety of other things, there doesn’t seem to be a way to kill him permanently.	He claims to own the pudgeberry forest, and leads a size-able tribe of Salandits inside the heavily fortified Salandit mound. He’s known to fatten up intruders with pudgeberry darts, and pudgeberries. Sometimes, he may accidentally inhale instead of exhale when using his blowdart, swallowing the pudgeberry dart in the process. He’s also known to use his sharp tail as a fork.	?edit2=2_ABaOnudDUdcsIMozZaxlO0jLoCdc9ScFzZWf1W8fxG1_oCPQPp7UP8i9zo_tL4G4slO1EGs	NPC	Desires power and enjoys pudgeberries, maybe a bit too much	Pudgeberry Forest	Thorn has died before, but somehow managed to rise from the grave. | Thorn has strange abilities that most other mon, especially Salandits, don’t have. | Thorn isn’t really a *bad* guy per se, he just has an odd sense of right and wrong.	\N	It is not recommended that you trespass on his turf, unless you want to end up as his flabby plaything. Taking on Thorn, even if his army of Salandits isn’t with him, is a difficult task, and probably shouldn’t be done alone.	SFW	f
71	271741998321369088	Coal	Charmeleon	Fire	32	958 lbs	4'07"	Male	Pansexual	In a Relationship	Flamethrower | Fling | Toxic | Slash	He loves being called a slob and actively tries to live up to it	\N	\N	Ask Neiro	\N	?edit2=2_ABaOnufK7rRN4VdkVNUmEd-Xv0R4V2AlXrvtcxZSP52qrRZgIt2gKiJdw5o0nv4Mu_lUZn0	NPC	This character cares around his shop and his customers the most but relies on his employees to take care of them. He is a stereotypical slob so feel free to have him mess or piss the floor without care, burp or fart all the time, etc.	Coal's Chili House	He and his restaurant were in financial ruin until the slob curse befell on Melody Springs. He may try to stop anyone who would try to change it back | He is too fat to move | It is said that his bathroom is under his turntable so he never needs to leave | It is unknown as to the last time he took a shower. | If you ask him for a sauna, he will fart into his tail, turning the restaurant into a sweat-fest | He lives, sleeps, uses the bathroom, and does everything from his turntable | He would never give up his current job as he loves being a carefree fat chef | It was his personal request to remove bathrooms from his restaurant in favor of hiding them under his turntable... good luck getting to them. | Chili, food bits, sticky jams.. if its edible, there is a good chance you can find a mostly eaten part of it on Coal or in one of his fat rolls.	Melody Springs	He is gassy in both farting and burping, if his ass is facing you, be warned, you might get farted out without remorse.	SFW	t
72	Public	Alex	Starly	Normal/Flying	22	4.4 lbs	1'0"	Male	Heterosexual	Single	Whirlwind | Quick Attack | Endeavor | Double Team	\N	Does not like blobs, or being transformed	Wishes to own a gym (the workout kind, not the Pokemon kind). It seems Alex is a nice guy unless you throw him into some kinky situations, similar to how a Pokemon outside the kink would react.	\N	\N	?edit2=2_ABaOnudmQ_uUM-BZb-hPP1gyjNQRbnYOPDtsvQETS9ZC8g5Ghy2__Ap5G9U9vmJYicJg1Go	NPC	Alex is a scout, flying ahead to see what's going on, but quite poor offensive attacks. If things go wrong, that's why he has all those orbs. Will replenish Orb inventory in between quests. A quest may involve him trying to Gootaur Mixture, Corrupted Moomoo Milk, or a Never-Leak Diaper as revenge, even if he(or anyone trying to help him) gets caught in the crossfire for it. During these "Revenge Quests", His satchel will shift to a backpack, his flying shall be impaired/disallowed, and he will often carry a few anti-kink items in his extra inventory space. He will generally help on any revenge quest you throw across him, but at a price(either you give him a Tabol Berry or eat a Booty Pear in front of him, your choice).	The Village	May have actually been from Obe, hence the dislike of fattening | Likes other birds | Wishes his tail feathers were bigger | He always carries an Everstone and a Satchel, the other three items may vary depending on carry space.	\N	If you get on Alex's bad side (get him nearly vored or inflated), he will often end up carrying a kink item on the next quest with you, with the intent of using it on you.	SFW	f
77	271741998321369088	Kayla	Kanglava (Kangaskhan / Quilava )	Fire/Normal	27	176 lbs	7'03"	Female	Bisexual	Single	Rollout | Flame Wheel | Inferno | Thunderbolt	\N	\N	\N	After finding love at the The Scarlet Gulpin, she decided to stay there and be fat and pampered.	She is a sweet mother like character that has a fetish for fattening moreso than others being fat. She doesn't mind the fat but she much prefers to be a part of to watch the weight pack on.	?edit2=2_ABaOnud0lVXEBSn_DdTWA0CvjJJh2awOyqg5FLTPAVNjSAlIuxm9UTlF-z9oVvdA3zzt52s	Inactive	\N	\N	She loves to inflate her pouch with water and then uses her fire to make herself into a living jacuzzi for other Pokemon | She has been seen filling up her pouch and taping it shut so it wouldn't spill out just to feel like a water balloon | She loves to swim, despite her typing, tho her pouch can get in the way | She actively tries to increase her pouch's elasticity | She doesn't actually want children of her own	Arcadia	\N	\N	f
73	Public	Madeline	Houndoom	Dark/Fire	27	443 lbs	8'2"	Female	Pansexual	Single	Fire Blast | Dark Pulse | Flame Charge | Nasty Plot	\N	\N	\N	\N	Madeline is a tattoo artist working in Larousse City. Of course, nothing in Zaplanda is at it seems... and neither are her tattoos! Each one can be imbued with a certain enchantment of the clients choice... and these enchantments can do damn near anything! Make you gain or lose weight easier, make you better in bed, help keep you calm in combat, even give you special magical abilties! Of course, the more the enchantment does for you, the more expensive it is... and for particularly special tats, she might require some 'favors'. These tattoos can also be made invisible, if you like the enchantment but not the look.	?edit2=2_ABaOnueykUK55JLC8JktDEzIAxmBxOiXQCP0kqm4BNxzp4CXW3qjUWAldyxq9tH5ezrQJ4E	NPC	Vengeful manipulator	LaRousse City	Sure, a few mistakes are expected... but it's sometimes rumored that she occasionally botches tattoos on purpose, if her client is particularly rude or evil. These 'botched' tats can have... unpredictable effects, to say the least. | She can somehow choose exactly what part of her body all the weight she gains goes to... hence why she has so much fat in all the right places. She often uses her curves to tease her clients, finding that it makes them much more likely to become regular customers. | She eats pokemon! Sure, there's not really any evidence... but so many Pokemon have gone missing when she's around, it can't be a coincidence! Besides, how else would she have gotten so... 'voluptuous'? She doesn't seem to spend much on food...	LaRousse City	\N	NSFW	f
74	Public	Growler	Houndoom	Dark/Fire	27	77 lbs	4'06"	Male	Pansexual	Single	Fire Blast  |  Dark Pulse  |  Flame Charge  |  Nasty Plot	\N	\N	\N	\N	Growlers Real name is Gargle. Gargle is a feral! Ferals are much less intelligent than regular Pokemon, have little to no sense of right or wrong, and are incapable of speech. He's the head of a pack of ferals in the caverns surrounding Dracdale! Most of these packs are impossible to distinguish from one another, but this pack is easily distinguished by their big, poofy diapers! All of these diapers are actually citizens, who have been captured in the caverns and transformed into living but immobile diapers! These diapers can have all sorts of strange shapes and colors.	?edit2=2_ABaOnuem_HBX9hxp6VJfWzpFKBhuYBPzwBHsT_TcqogDB4M471-C_Fl7pPgp1e5_9offhic	NPC	Diapered Gangster	Dracdale	Since they can't actually talk, his followers simply address him with a strange sound which some Pokemon have described as 'growling'. Hence the nickname.	Dracdale	He commands respect and fear from every Pokemon around him, being the alpha of his pack. His attempts to act tough can be comedic, considering the diaper! Although if you dare laugh at him or think he's cute, that'll only make him even angrier, and he'll happily transform you into his new diaper!	SFW	f
75	271741998321369088	Tes	Rotom	Electric	18	1 lb	1'00"	Male	Heterosexual	Single	Discharge | Hex | Subsitute | [Rotom TF Move]	\N	\N	\N	\N	Ex to Jaki. He is much more likely to take your wallet more and anything else.	?edit2=2_ABaOnudnAa8y76E2D8-1n6NLUggKrrN-R15mFkptbmKcVFzqMugfSVpWo7QhF_fNIEHUhts	NPC	He is the mastermind behind the team but admits that he can not do it without Jaki as she has the technological know how where Tes knows the strategy behind how to make the crimes actually work out as a success everytime. More street smart and tends to act that way.	Wanderer	Healed her back to health after she lost her legs | Built Jaki's prototype prosthetic | Half of the criminal duo known as 'DJ Thunder' tho they have never been caught or are even known to be a part of it. Tho he did inherit the title as Jaki was 'DJ Thunder' before too | Will often times hide as his other forms or as his substitute doll when in needs of getting away from pursuers or to scare someone. | Wants to make it rich and retire young.	LaRousse City	\N	SFW	f
76	Public	Neidru	Serperior	Grass	32	190 kg	16.5 m	Female	Pansexual	Single	Glare | Dragon Tail | Giga Drain | Leaf Storm	\N	\N	\N	\N	She is both the dean of the Obe City University as well as a teacher for several of the classes. Somehow, she owns a castle in the city, which is where she lives. Neidru is very fashionable and has a number of outfits, even though they are all expensive due to her naga physiology. Adjusts her glasses often like a smart character in anime would.	?edit2=2_ABaOnudtxu-XTbCem02SN1CWjdOzLSq0B-Z9ZmUavJyhWTod7tuoWwn9AVaghDMFLQf2_Js	NPC	She is best suited for scenes where she is the dominant party, but can definitely be on the receiving end of some fun as well. Personality keywords: Smug, Direct, Haughty, Regal, Sweet at times, Refined, Witty. Please do not use this character for anything involving scat watersports, gore, vore, diapers, and the like. Gas is fine.	Obe City	She's apparently gluttonous | Allegedly, Neidru is incredibly skilled with a variety of weapons. | Some say she enjoys having her breasts milked, or even being treated like a cow.	\N	Her senses are very acute. Don't smell bad or she'll kick you out of school. She also has a tendency to fatten people up so she can coil around them and squeeze them, or just lounge on top of them. Also, her gas smells like flowers for some reason.	NSFW	f
78	Public	Gregor	Lurantis	Grass	41	600 lbs	6'7"	Male	Heterosexual	Single	Petal Blizzard | Bug Bite | Sweet Scent | Sunny Day	\N	\N	He enjoys experiments with berry plants and cross-breeding them to try to develop new varieties. One result of his work is the well-renowned Booty Pear, which has resulted in an increase in the sizes of hips and butts in Taurel. He usually tests his new berries by eating them himself. Several of them, including the Pudgeberry crossbreeds, have contributed greatly to his weight. He's developed a resistance to the alluring effects of some of his berries. However, he sometimes forgets that not everybody else has. He can get lost in thought if he's been inspired to try to develop a new berry.	\N	\N	?edit2=2_ABaOnucG5I1wNplyYoXVT_7TztM1kiWZ4NFa57P5PxBo6r4CkNoOdKVchdGcoYN7HyAR8Sc	NPC	He's an eccentric but well-meaning guy who gets really into conversations about berries.	Berry Patch	He's actually Plantsexual | He once accidentally turned a Pokémon into a berry and is still trying to figure out how to reverse it and replicate it.	Taurel	He likes to show off the fruits of his labor but frequently forgets how much they try to make Pokémon eat them.	SFW	f
79	473547751221886976	Duchess of Roses	Cyrubus	Dark	\N	123 lbs	2'11"	Female	Asexual	Not Interested	Psychic	\N	\N	\N	\N	After a fraud investigation led to the disestablishment of the Think Tank after the Headmistress' death, its most dedicated members broke off into splinter groups of varying degrees of piety. By far the most passionate - and most dangerous - of these splinter groups is the Veneration, who believe the headmistress' soul is still sealed away in an old robot, the Duchess of Roses. It is unknown if this is actually true, but one thing is sure - whatever this robot is, it's driving these cultists to wreak havoc on the land.	?edit2=2_ABaOnuc6vF7EUWGfMuJ3XvYmwmpA7Tp8Tcvt2f7EgaWYt8GZ2zqBvBy0hGkDk3ZhJfvLEQE	NPC	Nothing is known about this pokemon... good luck!	Hawthorn Shrine	\N	Larousse City	\N	SFW	f
81	Public	Mr Floof	Flaafy	Electric	27	35 lbs	2'0"	Male	Unsure	Single	Thunder Wave | Protect | Sleep Talk | Thunder	Loves keeping himself fluffy and is known to always have a brush on him. He enjoys pampering his students with treats for good behavior and grades. Loves anything soft and poofy and will likely be well brushed	\N	\N	He teaches at the school on Infant Isle.	\N	?edit2=2_ABaOnufi4hFYPi3nwWB6PR6Xe8xA0-PkULThigx-afxQbujjmEst7NRFT3bwRH-Py7PHgeY	NPC	He is a loving teacher that will treat his students well but also loved to be more adult in his fun when he goes out drinking with friends	Infant Isle	He keep Laxi Lake water in his desk for himself to enjoy on breaks. | He loves to do to the bar with friends on weekends | Lets students fluff him up from time to time.	Infant Isle	If you get him drunk, he will refuse to change his diaper even if its clearly too full	SFW	f
82	Public	Olivia	Azumarill	Water/Fairy	\N	250 lbs	4'06"	Female	\N	N/A	Play Rough | Liquidation | Belly Drum | Superpower	She likes to say she doesn't have a sweet tooth	\N	\N	\N	\N	?edit2=2_ABaOnue-lEYhFXJtmdFuWomJ7Wbb1SdfqNb3ViNqhYZEN66u1eShaWw85zt4R8UQ4aM1Kog	NPC	Can be played NSFW given context; she's very motherly and nigh-unstoppable at getting what she wants	Liqua Park	She almost always has a troop of kids following her around the park | During the rare times when she gets mad, things get scary and oftentimes destructive | She gets kinda pouty often and sits on people when they call her fat | Not known to be the smartest when it comes to anything other than managing the park	Liquamond	She has a massive sweet tooth. Careful not to overfed her	SFW	f
83	271741998321369088	Liezel	Eevee	Normal	5	14 lbs	1'01"	Male	Child Character	Child Character	Growl	\N	\N	\N	\N	Is actually named 'Liezel II'. Kit of Jaki and Claudette	?edit2=2_ABaOnufpSj-SAc59EnsmGqRtDQRcL1O9KN3dqcy2usD9ZUq6FdJgtdqS3I5Cu5Gvs7AYRlE	Inactive	\N	\N	\N	The Village	\N	\N	f
84	271741998321369088	Smokey	Houndour	Dark/Fire	6	27 lbs	2'06"	Male	Child Character	Child Character	Growl | Scratch | Ember	\N	\N	\N	\N	Kit of Ferno (a Team Rocket Houndoom) and Claudette	?edit2=2_ABaOnudmbaCfrJzfm2nGf44kDWXfISijhbgAxrzN8FDJLlkWxk4xdtcwl50_6O4zyqFA6IE	Inactive	\N	\N	\N	The Village	\N	\N	t
85	271741998321369088	Bailey	Viperior (Serperior/Seviper)	Poison/Grass	2	153 lbs	6'5"	Female	Child Character	Child Character	Wrap | Belch	Likes to be overstuffed with round thinks	\N	\N	\N	Kit of Sally and Chinko	?edit2=2_ABaOnue-GnVPzgibta_vb-X6uEPhf76SCOGbHIk8pSV91ZAzhcA1pKngag4ytLwIPGAH_a8	Inactive	\N	\N	She has an obession with eating round things | She cant lose weight like her mother Sally but seems to take after Chinko in that regrad. | She has stretchy skin just like Sally	The Village	Protect your orbs, She will eat round things thanks to her mother, Chinko	\N	f
86	271741998321369088	Kipp	Watervee	Water	13	25 lbs	1'11"	Male	Child Character	Child Character	Water Gun | Growl	\N	\N	\N	\N	Kit of Neiro and himself	?edit2=2_ABaOnud-MVbZZ6hZuENNEWhAV_qSBRnoErc94V1d-bn2F-e6d7EYO_8RIYgNQy1S3k12EII	Inactive	\N	\N	His body is made almost entirely of water making him able to fill most items like water would as we as get absorbed like most water would | He is a prankster | He can reform and add water to his body with the help of Water Absorb. | Likes to sleep in a water jug | He actually likes to be toy'd with as he considers it sort of like a prank war	The Village	He is a prankster and like to prank pokemon with his ability to turn into water puddles	\N	f
87	271741998321369088	???1	Unknown (Noodle)	Dragon	\N	???	???	N/A	N/A	N/A	???	\N	\N	\N	\N	Team Shooting Stars	?edit2=2_ABaOnuePd6TNZoHkZsfmW1p_62i5hkS6clKiJ-pg1uLTBe43IBQw4Dqit-bOjK45FFlgZ3c	NPC	???	\N	\N	\N	\N	SFW	f
88	271741998321369088	???2	Unknown	Flying/Normal	\N	???	???	N/A	N/A	N/A	???	\N	\N	\N	\N	Team Shooting Stars	?edit2=2_ABaOnuflvNS5fwiaPndWA1Y74xkrFxKbwG3ou-KMw0jEO2ZlTQWkXr9zV27vEyeRbxAkvpk	NPC	???	\N	\N	\N	\N	SFW	f
89	271741998321369088	???3	Cyndaquil	Fire	\N	???	???	Female	N/A	N/A	???	\N	\N	\N	\N	Team Shooting Stars, Was given her signature red bow when Marble was 10.	?edit2=2_ABaOnue4S9QKQAIP5AlxASaCHVQBMEaj-_sKUrYPtJO9ItjfSIGXta703LpiyCgCHOcKKRY	NPC	???	\N	\N	\N	\N	SFW	f
90	271741998321369088	???4	Unknown	Bug/Poison	\N	???	???	N/A	N/A	N/A	???	\N	\N	\N	\N	Team Shooting Stars	?edit2=2_ABaOnufsns-M8yCueuTwNRW8Q3eMzIWMoT6N1SIBd8mm3pllgMu48N0rRjqvn-5spEYDP1o	NPC	???	\N	\N	\N	\N	SFW	f
91	215240568245190656	Virgo	Jirachi	Steel/Psychic	35	50 lbs	1'0"	Agender	Asexual	N/A	Wish | Doom Desire | Flash Cannon | Healing Wish	The pure of heart, or those with good intentions	Wish makers with ill intent or those trying to gain power	Virgo is very much like a genie, though can grant wishes in undesired ways if they feel the wish maker has nefarious intentions	\N	Virgo wakes once a year and grants 3 wishes during the month of September	?edit2=2_ABaOnuebaqr6hUusAffStfqelvIfOCC7d9pYZy8UpixfL3i84SpIwBmy3eRDl8cHkMSKMlA	NPC	Virgo is required to grant wishes, but is allowed to grant as they see fit. They are also very suspicious of those who wake him.	Starlight Islands	Wakes early only for the purest of heart	\N	Be careful what you wish for	SFW	f
92	455903666780504064	Splash	Popplio	Water	2	22 lbs	1'04"	Female	Child Character	Child Character	Pound | Water Gun	\N	\N	\N	\N	Pound works better than normal on Splash. Splash is found to be cute, and loves the attention. Play ball with Splash, especially with beach balls.	?edit2=2_ABaOnucW9Tg9pPnL1637jBMhojQruXi76iSjqHooX-BKgvoNDp9Vl9wan06-piy8gRizvrs	Inactive	\N	\N	\N	The Village	Will roll over	\N	f
93	Public	Lawrence	Sawsbuck	Grass	30	520 lbs	6'7"	Male	Bisexual	Single	Giga Drain | Energy Ball | Double Team | Nature Power	\N	\N	He prefers to sit on 'mons to keep them immobilized and to plump up his rump as he drains them. He doesn't like being defied and holds grudges for a long time.	\N	\N	?edit2=2_ABaOnudFjo95s6FUdOVyRhtPkppmWhHOhPGrzoTwxSpL1mobf10_v5zke9ZWECVcD-XPpNE	NPC	He's a fairly decent guy despite stealing other Pokémon's fat and usually doesn't treat it as anything personal. The exception is if he's dealing with someone he's mad at. He admires very plump Pokémon, even if he's secretly plotting to take all their pudge for himself. He's got a Hoarding Fig tucked under his tail that siphons the fat from Pokémon he sits on and pumps it into his own rump.	Obe City	He used to be a slender Sawsbuck who envied the size of others before turning to a life of piracy. | He was once friends with Captain Zangoose but now harbors a grudge against him.	\N	He can drain a Pokémon of their pudge through his mouth or other orifices using Giga Drain. He can also drain through direct contact.	SFW	f
94	Public	Sally	Mareanie	Poison/Water	19	112 lbs	5'8"	Female	N/A	N/A	Spike Cannon | Sludge Bomb | Ice Beam | Poison Jab	\N	\N	She's antisocial, to the point where she usually ignores the fact that someone standing right in front of her exists. She usually only gets about 3 and a half hours of sleep a day.	\N	\N	?edit2=2_ABaOnufDCbGpU-PnE_jKjCRIi4b6LGon8l1b-vPWu0E8vSGqi4c64xT3cW6sCJZc4OwldFM	NPC	Sexually driven	LaRousse City	Apparently they had a goth phase once. | Her favorite color is cyan. | Apparently they don't wear undergarments.	\N	They don't like to hold a conversation, at all.	NSFW	f
98	271741998321369088	Titus	Unfezant	Normal/Flying	36	290 lbs	5'1"	Male	Heterosexual	Married	Hypnosis | Air Cutter | Tailwind | Feather Dance	\N	Pokémon that are thinner than him because he feels they make him look fat.	Despite how often he stuffs himself and the very visible results of doing so, he repeatedly insists he's still as slim as ever. He still wears suits that are too small for him because getting new ones would mean admitting how fat he's gotten. While he has an increased libido, he really enjoys watching the fatter Pokémon lewding each other and keeps them under control with his Hypnosis.	He released the outbreak in Firefly Manor under the assumption that it would just cause weight gain.	He's made a lot of money from investing in restaurants in Obe City.	?edit2=2_ABaOnucmySsAi4vfLcdRnHArbWJk4XUbU0Hkgzbew95BSn3lpH2LkrHSqfHdOqry3Eak5jE	NPC	He usually acts pretty aloof, though some his jealousy of slimmer Pokémon leaks out sometimes.	Firefly Manor	He's suspected of slipping fattening substances into other people's food and drinks, plumping them up to make himself look slimmer by comparison. | He's a frequent visitor of Copacabana and encourages patrons to bloat up.	Obe City	Pokémon who spend too much time around him, especially skinny ones, find themselves putting on a lot of weight very quickly.	SFW	f
99	Public	Lady Godiva	Ho-oh	Fire/Flying	149	479 kg	12'6"	Female	Pansexual	Single	Sacred Fire | Recover | Brave Bird | Sky Attack	\N	\N	While others seem to regard the surface world with distrust, she sees only opportunity.	She's been the de facto ruler of Dracdale for as long as anybody can remember. Nobody would dare question her authority, nor could they imagine the city without her.	She resides in Gancaster Palace in Upper Dracdale, the largest building in the city. There, she spends her days meeting with aristocrats and pulling strings, as well as enjoying the company of her many concubines and visitors.	?edit2=2_ABaOnucfS1lL0-0_mxNCUb-mRfrrlHk9Mw1IFUg49jjBCXZH5eDum0HKgr7f82pQMC2xHSw	NPC	Ancient ruler who's not afraid to use her beauty for manipulation.	Dracdale	Some say she was somehow responsible for the cave-in that revealed the underground.	Dracdale	\N	NSFW	f
100	Public	Lmeut	Dusknoir	Ghost	198	290 lbs	8'3"	Male	Heterosexual	Single	Shadow punch  |  Payback  |  Disable  |  Bind	\N	\N	\N	\N	They are the leader of one of the main cults of Styx mountain, the Night Terrors. They often take souls as part of offerings, this is well known. Worships Giratina, usually with sacrifices. Wears a cloak quite often. They have tentacles which come from the inside of their mouth, which they use for various purposes. He enjoys tea, and if you get on his good side he'll gladly offer some. Will casually eat large amounts of food	?edit2=2_ABaOnuc_-dpTva9_Mob1j8sIEib6JW5aQ9DXHn_MqM5CEapTpO0dClp1gbqR3eIWpL7hL5Q	NPC	Conspires with Mizukyu for extra souls. He reacts coldly to most things, valuing pokemon only at first by their souls and ruling over others with an iron fist. If you somehow escaped, and proved you could handle him and his cult, he might actually respect you, just a bit. It'll be a surprise when he lets you go at the end of the journey, since "you have a will that rivals that angel." But still warning you, "don't come nearby here again." Befriending him would take more than submitting to his will, it would take subservience and intent to join the cult.	Styx Mountain	He enjoys a good struggle, either from himself or for others in his grasp  |  He often abuses the underlings under his command, to his own whim.  |  Often worships Giratina because of his undying love for her.  |  Keeps a Tentacruel in the basement of his fortress, for "tenderizing"  |  He can keep souls for himself!	\N	First impressions are everything, and it's very likely when you first meet him, you're going to be captured and put to sacrifice, unless you play your cards right. Even if you're his friend he'll want loyalty out of you.	SFW	f
101	Public	Sammy	Luxray	Electric	21	132 lbs	5'01"	Female	Bisexual	Single	Electric Terrain  |  Thunder Fang  |  Roar  |  Charm	\N	\N	\N	Was kicked out of The Secluded Treehouse	Will sometimes temporarily go feral and play with her partner. Easily snapped out of it.	?edit2=2_ABaOnudGzcchXGGBiXl4ha-YYNL0mWFcu7sDba5Fk43wzJrVvtC5yTzjMGLvQwRYRufrrQs	NPC	A sort of depressed Luxray who depends on her partner to cheer her up. Would like to go shopping, maybe even build a place of her own, but is too scared to go out with just her partner	Crying Forest	Has a tail fetish | Has a feral partner  |  Wishes she could wear scarves	LaRousse City	Yet another slimed anthro from somewhere else. They really miss their past, but cannot go back, and make the best of it.	SFW	f
102	400123456039026689	Peyote	Vuplix	Fire	10	1,600 lbs	30'00"	Male	Child Character	Child Character	Ember | Quick Attack | Confuse Ray | Fire Spin	\N	\N	He’s a bit rude and quick to anger, but he has a soft side for his family.	Due to a weird mix of his parent's genetics and his grandmother's magic, he's been born unbelievably huge.	Mess with his brothers, and you invoke his wrath. He is small, but very clever and capable of coming up with all sorts of mischief, and he’s not quick to forgive. Son of Adriana and Crom. While they are technically triplets, Peyote tends to fashion himself as the ‘older brother’ of the group, being much more mature and intelligent than the others and being fiercely protective of them.	?edit2=2_ABaOnudEKTCx33B3O7tRmXGPe_ZBMiA1SjhA_3BAJTVpTsHasZ4t7jWUj-t-Krk_tA0m_-E	NPC	Adri Character, do no RP	The Village	\N	The Village	\N	SFW	f
103	400123456039026689	Lazarus	Vulpix	Fire	10	1,600 lbs	30'00"	Male	Child Character	Child Character	Ember | Tail Whip | Roar	\N	\N	He is… paranoid. Whether this is some fundamental aspect of his personality, or a result of his deep investigations into the otherworldly, is unclear. Point is, he’s jumpy, always anxious and on the lookout for something, and has trouble fully trusting people even if he’s known them for years.	\N	Son of Adriana and Crom. A studious and clever fox, with a promising future as a talented scholar one day. He excels in his studies, and even spends his own time performing his own research. He can often be found locked away in his chambers, reading books and dabbling in strange spells and rituals.	?edit2=2_ABaOnud7FkBCk6GG2IIZQeQGqi60BFioPwLCSTFuw4YOecYa5EYxsm5N-uF_ZAi4YUq_apc	NPC	Adri Character, do not RP	The Village	When pressed on why he’s always so nervous, he may vaguely mention some strange entity known as Pht'thya-l'y, but provide no real detail.	The Village	Due to a weird mix of his parent's genetics and his grandmother's magic, he's been born unbelievably huge.	SFW	f
104	Public	Barrett	Chesnaught	Grass/Fighting	28	950 lbs	6'6"	Male	Bisexual	Single	Spiky Shield  |  Body Slam  |  Leech Seed  |  Wood Hammer	\N	\N	He is unaware of his own strength. He gets very distracted by small, cute things and easily aroused by small, cute folks. He has a tendency to give anyone that's caught his eye massive bearhugs, which, coupled with his strength, size, and body odor, is a very overwhelming experience	\N	\N	?edit2=2_ABaOnucL9rCvzzDFWG6C8Puunak324GmqcXfmMyzJTm-z8UaSobRuBIvyDTZvrfFE9eSY_c	NPC	A bit dense, but will do anything for the small mons	Obe City	\N	Obe City	As soft as he looks, he works out very often, so he's usually very sweaty. As such, he often smells rather bad, so keep your distance if you're sensitive to smells.	NSFW	f
105	400123456039026689	Calliope	Vulpix	Fire	10	1,600 lbs	30'00"	Male	Child Character	Child Character	Ember | Tail Whip | Roar	He has a passion for riding on the backs of flying-types, and often wishes that he could fly himself!	\N	\N	\N	Son of Adriana and Crom. Much more carefree than the other two, often trying to convince his brothers to look at that bright side of life, cut loose and just relax. He’s a rather confident and fun-loving sort, and the most mischievous of all of them.	?edit2=2_ABaOnue9z-TNMObOakdaKUOvQI5D7Aoa4EcEhttzGDl25U5ZOT6fA4sztGRrcF8nDFZvIz0	NPC	Adri Character, do not RP	The Village	\N	The Village	Due to a weird mix of his parent's genetics and his grandmother's magic, he's been born unbelievably huge.	SFW	f
106	Public	Nightmare	Darkrai	Dark	28	532 lbs	4'11"	Male	Homosexual	Single	Hypnosis | Nasty Plot | Dark Pulse | Sludge Bomb	\N	In fact, he has an extreme phobia of bugs! If he sees most bug-type Pokemon, he'll immediately drop whatever he's doing and hide from it, typically embarrassing himself in the process. Afterwards, he'll pretend it never happened.	Despite considering himself to be the master of fear, he actually suffers from it himself!	\N	A self-proclaimed super villain! Although none of his evil plans ever seem to pan out... and nobody ever seems to take him seriously, which drives him crazy! He wants EVERYBODY to take him seriously... to fear and loathe him as he spreads eternal darkness over Zaplana! To this end, he's fashioned himself to be as edgy as possible, but it seems this has been having the opposite of the intended effect.	?edit2=2_ABaOnueo9b6s2JTeCt-RAqxDzsz-THfCY_9eqhiTpxtteiyJyVR1o-Nj2My-DtRGXOPC82w	NPC	Fat Spooky Dark Type.	Styx Mountain	His real name was actually Frank, but he changed it to 'Nightmare' so it can sound more threatening.	Styx Mountain	He can inflict Pokemon he despises with horrific nightmares! Or, at least, he tries to. Most of the time, he messed it up, and inflicts his target with pleasant dreams instead. Or at least drastically misjudges what they'd consider a 'nightmare'.	SFW	f
107	Public	Alan	Venusaur	Grass/Poison	28	310 lbs	7'3"	Male	Heterosexual	Single	Sleep Powder  |  Solar Beam  |  Sweet Scent  |  Razor Leaf	\N	Big Paws	He keeps ferals as pets sometimes as he thinks they're very cute. He suffers from insomnia, so he often sleep powders himself to help.	\N	Can use photosynthesis to eat	?edit2=2_ABaOnue8dDjm-vgV3OI9uRjxhwZvRYl017VNcAu-OW56DGMJW1_z0RSDzcXW-iTANoBICBY	NPC	He looks big and scary sometimes but is a real softie. Likes to stargaze when he's up at night. He tends to go photosynthesize, but he *can* eat if he so wants to.	Taurel	\N	Taurel	Don't get squished while he's distracted with his music. If he finds you in Wild Woods, he'll keep you as a pet until you turn back	SFW	f
108	Public	Percy	Eevee	Normal	19	1,500	35'00"	Male	Pansexual	Single	Quick Attack | Return | Bite | Iron Tail	\N	\N	\N	\N	For whatever reason, whatever enchantment's been placed on Tiny Temple, it doesn't work on him. While most Pokemon shrink down when they approach the temple, the eevee grew instead. Tired of always being small and weak, he's happy take advantage of this opportunity to have all sorts of fun.	?edit2=2_ABaOnufML5DBsYBGUXxbTgB2Ahk3YNebCidbk4AlmAxrclNb2OCZmK54TKOltAwnAVEQSQU	NPC	They love to toy people with vore and tongue play	Tiny Temple	Many denizens of Tiny Temple heavily protest the idea of having another giant, mischievous bully running around. But for whatever reason, ol' Mart still feels duty-bound to care for the playful eevee all the same. | He first came to the temple because he had heard of the immense battle that had taken place there, unaware of its actual properties.	The Village	He's childish and immature, often abusing his power over the other Pokemon in the temple, often playing 'pranks' on them, which often consist of him playing with them in his maw, squashing them under his butt, or even just gulping them down into his tummy!	SFW	f
109	Public	Oliver	Furret	Normal	19	125 lbs	5'4"	Male	Homosexual	Single	Knock Off | Double-Edge | Brick Break | Return	\N	\N	Oliver runs a sort of unconventional 'food cart' in lower Dracdale. You can ask for regular food there, like apples, berries, puffins... but you can also ask for a buffet! If you do, he'll happily take you back to his house and give you a REAL meal, feeding you candy, pastries, and even Pokemon until you're all fattened up! He gives guys he finds cute a discount on this.	\N	Like many citizens of Lower Dracdale, he doesn't even bother to wear pants! He feels much more 'free' without them, when he's able to show off that plump booty of his as he pleases. Though he does have an oversized sweater he likes to wear, which provides him with some modesty.	?edit2=2_ABaOnufdveqTeBBxQsfvDPNXOLpe2onpFzBx5VeSmNe_fxM3Av9fMq_xBEFx-J-D5phpVzE	NPC	Proud of dat booty	Dracdale	People say he seems to have some sort of connection with the criminal element in lower Dracdale. Though this seems to be more by association than anything - despite his connections, Oliver has no interest in crime.	Dracdale	For a mon as small as him, he's actually surprisingly gassy, and he's been known to clear rooms every once in a while! Still, he has absolutely no shame in this, considering it just a natural fact of life - hell, he finds it funny, even, and will often pull stinky pranks on those he likes.	NSFW	f
110	Public	Wanderer	Absol	Dark	27	130 lbs	5'6"	Female	Pansexual	Single	Superpower | Sucker Punch | Swords Dance | Knock Off	\N	\N	Despite being known throughout Dracdale, she's rarely seen around the city itself, mostly wandering around the winding cave system surrounding the city, trying to deal with packs of ferals before they can become a threat. On the rare occasions she is around other Pokemon, she's quite the silent type, and typically only trusts other anthros.	\N	She tends to travel the caverns mostly naked, as clothes tend to be difficult to find and clean in the wilderness, and it's not like there's any point to them. Even when she's in town, she's hardly modest.	?edit2=2_ABaOnufquxTjX-EkpurlwsN_1yzD9zF_rDggIOcxffQXi_VNXo2AANc4PkqFUBpISyPACdQ	NPC	Very shy and distrustful, especially of non-antros	Dracdale	She never tells anybody her full name. Some wonder if this is because she's trying to run from some sordid past... others ponder that she's cursed, and her name holds some sort of magical power... others speculate that she might just not have a name in the first place!	Dracdale	She may look frail, but those thighs are unbelievably powerful, and any harm you bring to the citizens of Dracdale will result in your head getting squeezed between them.	NSFW	f
111	Public	Robin	Snorlax	Normal	14	657 lbs	6'2"	Female	Child Character	Child Character	Tackle | Leer | Baby-Doll Eyes | Spark	Likes Adventure, Experimentation, Berries, her own two feet	Hates Most fried items, Man buns, Crowded markets, Quadrupedal walking	Shy, Soft-Spoken, Non-talkative, Moody(generic teenager things), at sexual awakening	Robin was raised by a Jolteon and a Shinx, the Shinx being her father. the two were a happy couple, and she has three younger siblings, two of which have since evolved. She left the den, wanting to go on an adventure, after a single fattening adventure, Robin fell in love with the weight of naturally bigger Pokemon	\N	?edit2=2_ABaOnucGjh2XLTqfYzHsrgqkKC87Qmi0FZmt1SxFLo8TICCFcHM6Boc04sa9VMJZNTOcTgM	NPC	Large chubby foodie	The Village	She is into some really freaky things | Robin is actually younger, lying about her age to go adventure | Robin is a really good scavenger | Robin really likes transformation | Robin, once you get to know her, is really quite talkative	Unknown	\N	SFW	f
112	Public	Nathaniel	Umbreon	Dark	19	195 lbs	7'5"	Male	Asexual	Single	Baby Doll Eyes  |  Moonlight  |  Sand Attack  |  Dark Pulse	\N	\N	Is very sweet. Likes to floof his tails and ears.	\N	Scratches like a dog.	?edit2=2_ABaOnufW-2HhiyoFkrGzhwGzXq_e4fl6snxcUzwQvK9zu0_USyvs2qdJ_pVOBOgFlAAHh5A	NPC	Nathaniel is a nice innocent taur who just loves to help out with whatever he can. He does seem smart enough to avoid things that would go wrong. He does not like many kinks, though he considered booty pears and other fruits a non-kink thing. Is often carrying a basket of eggs, including an eevee one.	Taurel	They're just waiting for the right Pokemon to come into their life.  |  The Eevee Egg is his	Taurel	\N	SFW	t
113	Public	Frankie	Floatzel	Water	21	203.8 lbs	7'10"	Female	Heterosexual	Single	Double Hit | Water Sport | Aqua Tail | Pursuit	Frankie loves to swim, and also give nice people rides on her back! She'll also help you out in the garden if you're friends with her.	Frankie doesn't like cursing people on accident. She also doesn't like weeds.	Frankie is a kind hearted little swim bab with a fear of people not liking her top half, hence the sweater. She is much cuter than a normal Floatzel, but she doesn't seem to mind.	\N	\N	?edit2=2_ABaOnueRgMABpXZn9Ym966JSdbsd6VnezkzrSddljyQkYAjQPhSAkpQ_nAsQ_CRPPJeldu8	NPC	Frankie claims to be from Taurel, a normal taur, who came to the Village to escape some stigmas about paws and booty pears and the like. She still likes the pears, but she'll have them in more moderation. She was made fun of her floatzel floaty things, so she wears a sweater to hide them. She can swim in lava, and will often invite other fire-types to do so. She also doesn't mind a bath in a smile puddle, assuming a shower comes after.	The Village	She likes getting revenge for people, but feels guilty afterwards | She uses She(only because I typed in she this whole time) | She's actually a fusion of two Pokemon, which drove her to be a femboy. | She had her fangs trimmed because she felt like she'd scare people | Her face black spots become more pointy when she's angry.	Unknown	\N	SFW	f
114	Public	Amanda	Flareon	Fire	23	162 lbs	5'4"	Female	Bisexual	N/A	Ember | Baby Doll Eyes | Draining Kiss | Overheat	Likes Baking, eating baked goods, slime	Hates Pokes who dislike slime, burning her baked goods, eggplants	Amanda is a cheerful Flareon slime who loves to bake, and has learned to bake using her fire. She does seem to not like being a slime sometimes, but this is only when she's really down.	\N	\N	?edit2=2_ABaOnuecAnOAzv_XvXJKTnpfzpgeIJEnIAo-8mIlHNjIYab7e10XhTk9DxsqEeKQsRmirZs	NPC	A wannabe chef that tries to get anyone to agree to let her cook for them	Unknown	Her sliming was accidental | Her baking skill still needs work | She wishes she had a bigger tail | She's scared of pokemon eggs | She was kicked out of the crying forest	Unknown	\N	SFW	f
115	271741998321369088	Frii	Galopfrig	Water/Flying	18	24.9 lbs	2'02"	Female	Heterosexual	Single	Bounce | Roost | Air Cutter | Water Gun	\N	To be scared, jump scares.	Lazy, Carefree	She was sent to Zaplana from her home region of Xyon due to her being bloated while in flight from a surprised thunder and the wing carried her to Zaplana. She is lost and wants to go home but is also not sure as of yet if this Zaplana place just might be a better home for her.	For more info: https://sta.sh/0ia0tumi8qm | Pokédex Enteries: |1) A lazy Galopfrig will use its inflating sack to float on the water. |2) Galopfrig use their impressive chests to attract mates. |3) This Pokémon can inflate its self to over twice its size.	?edit2=2_ABaOnucnfrpDkS0FwG_P_OFCoSl-NjCnwY8mg0jJsIWA2WvdKL-VFs-ntlW7Ld9OqWTl3Bo	Inactive	\N	\N	She can not control her bloat and oftentimes will bloat up into a ball when scared suddenly. | It takes her anywhere from 1 minute to 30 minutes to deflate | She belly feels like fine rubber, almost like a Wubble Ball | She cant fly very well when deflated but is almost useless if bloated in the sky. | Even tho she is lazy, she is not a fan of being fat	Luvv City	\N	\N	f
116	Public	Hakai no Kami	Dragonite	Dragon/Flying	30	164,000 lbs	70'0"	Male	N/A	N/A	Outrage | Hyperbeam | Roost | Thunder	Paws	Anyone that would threaten Puffy Paw Isle	\N	\N	\N	?edit2=2_ABaOnufR1_3PnKrLqVV82Hz-JdtL2lpfbzDro8Jl-RFdMZZbCqpqkIfbUrCK5M22U3Pmavo	NPC	This vicious beast is literally named "The God of Destruction". There will be no reasoning with it, as this monster is too sizable for words to reach. It is a primordial being, tending to keep to its territory of the Ship Graveyard, though perhaps in storms and at night, it may travel beyond such for hunts of meals. When both situations occur is when this creature will be most active, hunting down meals in the cover of the absolute darkness.	Ship Graveyard	It will swallow ships whole, and all shall perish inside its belly.	\N	Be wary of traveling the ocean waters at night.	SFW	f
128	Public	Violet	Absol	Dark	19.5	127 lbs	5'5''	Female	Bisexual	Single	Night Slash | Bite | Double Team | Perish Song	Likes Combat, racing, general athletics and music	Hates Her own horn, people who can't take a hint, and being stuck in one place for long periods of time.	Asocial, tends to ignore her own ability due to the amount of time it went off in her own home, loyal and protective to friends.	\N	\N	?edit2=2_ABaOnuf6Fi0E88SdoP8dEguwv-MlfEBtf6MN1bzJFzx-1x2ZYXFst15tq1B7I3cXtfi3vdg	NPC	Tough shell to crack.  They're antisocial to their friends but those who break down her walls will find a valued friend	The Village	She can predict disasters before they happen. | She came to Zaplana after an avalanche destroyed her home in a mountainous region | She would do anything to protect those close to her. | As a child, she was seen as a common thief. | Some people have said she's planned to commit arson before.	Unknown	\N	SFW	f
129	Public	Narcissus	Malamar	Dark/Psychic	\N	105.6 lbs	5'00"	Male	Bisexual	N/A	Hypnosis  |  Knock Off  |  Superpower  |  Topsy-Turvy	\N	\N	\N	\N	\N	?edit2=2_ABaOnucYGKH6Q2YJgGap_JFr1-Qlu-gmQxrvu0O8rSNVA1GSLDcMOM1UayYU4747iP8-Krc	NPC	A supervillain character for feeding and hypnosis-related RPs; as such, he's manipulative, cunning, and willing to do whatever it takes to further his goals	Spiralwood	Those who have approached his lair in the mountains are said to never come back...  |  He's been reported to invite travelers in for tea as they pass by his dwelling  |  Strange glowing can be seen coming from the mountains at night occasionally	Unknown	Approach with caution, has a particular way with words	SFW	f
130	Public	Rita	Lopunny	Normal	\N	62.4 lbs	4'03"	Female	Homosexual	Single	High Jump Kick | Fake Out | Ice Punch | Quick Attack	\N	\N	\N	\N	She's Jon's older sister... apparently? Since when did he have an older sister? Ever since she met Cosmina, she's seemed... strangely interested in the idea of macro/micro stuff.	?edit2=2_ABaOnucQwfpofiPYQqKloKQ8hsuEF8ClN_9_rDq-k2KXZWbTtqYt9XZS616eMggirO4PtIc	NPC	Sporty girl	Caraway	Sometimes, she marvels about 'how much things have changed', often in response to simple technology like ovens and sliding doors. Despite being young, she always seem nostalgic for some bygone era, a long long time ago... maybe she's just an old soul?	\N	She seems really attached to that collar around her neck for some reason. If somebody tries to take it off, she freaks out and gives them a roundhouse kick!	SFW	f
117	Public	Orthis	Kommo-o	Dragon/Fighting	37	206 lbs	5'7"	Male	Pansexual	Single	Clanging Scales | Noble Roar | Iron Tail | Protect	\N	He dislikes pants and is an advocate for the right to go around in public without pants.	He's a hyper who's proud his big balls and massive member and casually flaunts them when he can. He gets pretty lustful when he's pent up. Since his balls are very productive, it usually takes about a day or two without release to reach that state.	\N	He never wears pants at home and only wears them in public because he has to.	?edit2=2_ABaOnuetkmNtj4RvA4JWz8s8LyKHMy2hHjb5YR0QcjbP-C_IwnljZihO3y1xd1oOSLqdcIs	NPC	He's a relaxed guy but likes to establish that he's the one in charge. If he becomes interested in someone, there's a good chance that they'll end up becoming one of his pets. He loves having someone to spoil, and if they aren't quite on board with it, he'll convince them to see things his way. He especially likes to soften them up so they'll be more cushiony when he mounts them. He's pretty possessive of his pets and will try his best to find them if they escape, but he can get sidetracked if he finds a new person to turn into a pampered pet.	LaRousse City	He's gotten out of trouble for public indecency by seducing the arresting officer. | He sometimes wears underwear just to see how long they last before getting torn when he gets hard.	LaRousse City	The clinking of his scales as he moves is very soothing but can put Pokémon in a suggestive trance if they don't stay focused.	NSFW	f
118	271741998321369088	Gin	Xatu	Psychic	19	79 lbs	3'4"	Female	Heterosexual	Married	Psychic | Teleport | Air Slash | Fly	\N	\N	\N	\N	\N	?edit2=2_ABaOnuf8_hFKU14G-MIsQfat05ixv-R_F9CHOk1o36cWQppaG8t40pBcobV6a_Nby0ZTysI	NPC	She would do anything for Titus!	Unknown	She was hypnotize to due Titus' bidding on two occastions. | Althought she wont admit it, she rather adores an Obese Titus	Unknown	\N	SFW	f
119	400123456039026689	Guinevere	Alolan Ninetales	Ice/Fairy	245	130 lbs	5'7"	Female	Pansexual	Single	Hypnosis  |  Aurora Veil  |  Freeze-Dry  |  Hail	\N	\N	\N	\N	\N	?edit2=2_ABaOnudCqM49wnmKqCz0oyZtMRn-nsBAl4OLxEHbq8yHZiH0HzKk4oABnfI2TrX0fMm-nrQ	NPC	Adriana's character, do not rp	Dracdale	Leader of a group known as the cult of the sylvan - a group of heretics against Arceus who believe that Zaplana was created through natural processes. Rebels against the gods and devout nihilists, the group is feared for its dedication to hedonism and known for its practice of taking slaves.  |  She is said to be the mother of Adriana. With the cult of the Sylvan sealed away deep underground, it is a wonder that Adri ever managed to escape.	Dracdale	If you tug on one of her many tails, she can inflict any sort of curse she wants on you. And she can be rather... creative.	SFW	t
120	271741998321369088	Liezel	Grumpig	Psychic	32	169 lbs	2'11"	Male	Heterosexual	Single	Psychic | Power Gem | Rest | Bounce	\N	\N	\N	Is the unwilling assistant to Team Rockets Expert Interogator.	\N	?edit2=2_ABaOnueVYSo7lf8Y6sgSAq7kcM4mHAFYcgrlMGlJmerHWs4v4WWw9Dsl0ll6A0PQjx4eKMM	NPC	It is unknown as to whether this character is even still alive	LaRousse City	Has his tongue and gem removed by Team Rocket, making him mute.	Unknown	\N	SFW	f
121	Public	Dorian	Octillery	Water	29	69 lbs	3'6"	Male	N/A	N/A	Octazooka | Constrict | Bullet Seed | Flamethrower	\N	\N	Whistles when he thinks nobody's listening; says weird, ominous things sometimes without prompting. He's a bit eccentric, to say the least, and keeps his secrets well-hidden	\N	Makes a mean cocktail. Everyone in his section of the park knows of him. He used to bartend at the Sendoff Spring area	?edit2=2_ABaOnucUPnBlN5sezdNY85_pnOFBfHRysGMgzDKKn6VZYzBtiSp6SMWerc5K0GLeymBZ5P8	NPC	He gives off a bit of a suspicious vibe and doesn't reveal whatever hidden motives you may give him at first	Liqua Park	Nobody knows how long he's been running his section of the Park | Nobody knows what happened to the former supervisor | He's been caught eavesdropping on people by sticking to the ceiling	\N	\N	SFW	f
122	Public	Samson	Nidoking	Poison/Ground	46	280 lbs	5'2"	Male	Homosexual	In a Relationship	Megahorn | Brick Break | Attract | Earth Power	\N	\N	Occasional sneaks food off the tables for munching; Likes to pry into the vore section for sight seeing; enjoys the smaller mons to tease about being in his belly.	\N	\N	?edit2=2_ABaOnuf1IqmawmZW9LiwsKRBbiL-EifOaD7o9AxZ_-UN5h8ocUWDX5T-x0dNFlZWnCORAkc	NPC	He's a fatty boy who loves to eat.	Obe City	Its believed, though he is very stern, he can be very docile when he has a full belly | he may have a private room for just himself to enjoy the voring side	\N	Not only does he have an indulgence for food, he also has a refined taste for finer more squirmer food. If you do not like the warm wet seclusion of another's stomach, try not to entice the idea.	SFW	f
123	Public	Margorie	Midday Lycanroc	Rock	38	138 lbs	5'6"	Female	Heterosexual	Divorced	Rock Throw | Odor Sleuth | Charm | Milk Drink	\N	\N	During more intimate moments, she will offer milk.	\N	Has an outfit without the solid parts. Always has milk and creamer and sugar for coffee	?edit2=2_ABaOnuedx0DQrts67ey_hYU6rYyiaFr8iUvu-N_N_N3vLMFpv41G32bZKUC7kah7ELnbTNI	NPC	A kind, loving Lycanroc. Will take kids if you need to abandon them.	The Wooded	The milk she has might be her own | Likes inflation, but is too scared to do it | Is part Miltank	Melody Springs	She has PTSD about the pollution of Melody Springs. Don't bring it up with her. Asking about her divorce will do the same.	SFW	f
124	Public	Jude	Deerling	Grass/Normal	18	20 lbs	1'6"	Female	Asexual	N/A	She is stuck as a fawn | She was abandoned due to being the runt of her litter | Will often fail at Camouflage | Will eat flowers sometimes | Is actually a ditto	Likes Grass, Seeds, Gardening	Hates Her size, most Pokemon	Scared of everything, doesn't want to get squished. Will trip *a lot*	\N	Art from rismic	?edit2=2_ABaOnucCyEIWMCS64yeMhzkUV6NG7hYVsYZWL2HMAmFcfWei-lbmezuuW-ni2yMGBZi_QP0	NPC	Jude kinda just showed up here, maybe help her out?	The Village	\N	Unknown	\N	SFW	f
125	Public	Maxine	Glaceon	Ice	19	115 lbs	5'3"	Female	Pansexual	Single	Ice Fang | Ice Shard | Tackle | Quick Attack	\N	\N	Will slime people for fun	\N	\N	?edit2=2_ABaOnuc0l7eo6-0O336_xLGxnry6B2ni6FAnDnVcllCXLilbadI25bTVuGaB1QyyTKd2nnw	NPC	A playful youthful slime, carrying part of her childlike personality from Bambina. Will be the first encountered on a visit to her locale.	The Secluded Treehouse	Has a crush on her roommates	Bambina	She will force-feed you gooberries if you try to diaper her.	SFW	t
126	Public	Llyod	Buizel	Water	21	96 lbs	2'3"	Male	\N	\N	Water Gun  |  Hydro Pump  |  Surf  |  Transform	He loves to be transformed and will do anything to try out new TFs or TF methods	\N	\N	\N	\N	?edit2=2_ABaOnueyTjaJz10gQBlf-qWro46DGjT-8GKS5vj5GYhYIIEunzoU4ZKZauZe1JIC-RPlgwc	NPC	TF Shop Owner	Arcadia	Transformation Addict	Arcadia	He equally loves to TF other pokemon too, so watch out!	SFW	f
127	Public	Nine	Alolan Ninetales	Ice/Fairy	22	125 lbs	5'5"	Male to Female	Pansexual	Single	Dazzling Gleam | Safe Guard | Confuse Ray | Imprison	\N	\N	Likes using her tails to pick up things	\N	Helps Maxi with cart sometimes. Is knowledgeable of technology. Is the smartest of the slimes in the Treehouse	?edit2=2_ABaOnucEY6318hYAEf6D2iXtaMrQBkEtTIKD5bHEVq-0D7ljUROKlbZqM-WIRWrk0Cwt8qA	NPC	The calmest and most collected of the slimes, Nine only goes by that because she just couldn't decide on a new name no matter how hard she tried.	The Secluded Treehouse	Regrets becoming a slime | Was actually from Obe	\N	Doesn't like fat. Will feedee you if you try to forcefeed her.	SFW	f
131	Public	Kenta	Seviper	Poison	23	115 lbs	8'10''	Male	Bisexual	Open relationship	Bite, Poison Tail, Thief, Protect	Teasing and playing pranks on others	\N	In total control of the situation, Kenta likes to be the king cobra of the group	\N	He's albino, his body entirely made up of shades of white.	?edit2=2_ABaOnudSFRp0g4SJkgLiywFJlIiC2gXdS5TiliHZbjRG52bHJXkruYsvxz--PhXa66odkds	NPC	He's a sneak and a jerk.  The stuff he says is probably meant to lull foolish Pokemon into his trap	The Village	He used to be part of a gang.	Unknown	He is known to have quite the teasing personality when it comes to messing with his prey, playing comfortably in the role of a deceitful snake predator.	SFW	f
132	Public	Cosmina	Absol	Dark	23	824 lbs	31'4"	Female	Pansexual	Single	Swords Dance | Knock Off | Sucker Punch | Super Power	\N	\N	She's quite playful and can be a little mischevious at times, but she's ultimately harmless. Just know you might get squished or eaten a lil.	\N	\N	?edit2=2_ABaOnueNG-W-sF_H5GsjSc3C1TcvKu7oRw3OYgA273biTQN4B4_9BMp6LWUGb22QRRSZu-A	NPC	Adri Character, do not RP	Caraway	\N	Caraway	She is in charge of defending Caraway from those who might not support the lifestyles indulged there. Attempts to mess with the city are rare due to the massive macro they have around.	SFW	f
133	Public	Suki	Musharna	Psychic	\N	133.5 lbs	3'07"	Female	\N	N/A	Dream Eater	\N	\N	She's really weird and always acts as if the act of allowing others to enter your dream real is something casual, like some sort of massage.	She is indeed from the real world.	\N	?edit2=2_ABaOnuftcr8YAdaZMAD2OYXUn2jp52W6rWRHmsWW-064rYpbDKNf9JpOr6zv-_IkpEgQkxE	NPC	She's always very calm and patient when it comes to allowing others to use the shrine, even looking excited to receive visitors and observe the adventures to be had in these realms, though she never enters these realms herself. She never gives any warnings about the dangers of the realms either, so she might not have the best of intentions. In the end, she's really just a permanent guide for he shrine.	Dream Shrine	She's supposedly the descendant of an ancien civilization that praised dieties that seperated the realm of dreams from the realm of realities, but she never really mentions much other than that and how to use the shrine respectfully.	Unknown	\N	SFW	f
134	Public	Crunch	Mawile	Steel/Fairy	15	150 lbs	5'10"	Female	Pansexual	Child Character	Ice Fang|Iron Head|Sing|Wake Up Slap	Likes Her parents, training, sweet things	\N	An edgy teenager who has a soft spot for her Dad and brother	\N	\N	?edit2=2_ABaOnufkgfGedAuEbTaz2qQi4YxNao6kVUzFSJUCSiqRdV1Qdp84pjjnJ1W7hi6DdAO91qE	NPC	Acts like an edgy teenager, but a good kid at heart	The Village	Her other parent is Glenn|Learned to mega faster than her father|She knows Cherry isn’t her real mom but still respects her|Hates eating rocks|Feels bad for being taller than her dad	\N	Hates People who annoy her, people who she deems under her	SFW	f
135	Public	Nathan	Umbreon	Dark	23	1770 lbs	12'6"	Male	Homosexual	Single	Wish | Toxic | Fake Tears | Sucker Punch	He stinks and he loves it! He shares his musk proudly, often using it as part of his many 'pranks'.	\N	\N	Originally, Nathan was just a more typical edgy punk in the village, and while he grew up, he frequently got into rebellious shenanigans that just annoyed his neighbors. When he stumbled upon a strange scroll that grew him to an inordinate size, most people were actually relieved, as it meant they finally had an excuse to exile him somewhere far away. That's how he landed in Styx, with the other misfits.	\N	?edit2=2_ABaOnufzh7Nka_2rwJsBYcG5ZVpBmfsQJuhRHZUiCw8GwSu_RfBeDaMKh2lVRXGyjf1F19M	NPC	Sexual punk teen	Styx Mountain	He acts perfectly content with being alone and just doing his own thing, but he quietly longs for someone who understands him. The few people who do try to relate to him definitely see a softer side.	Unknown	He's not nearly as outright unpleasant as many of the Pokemon around Styx Mountain, but he's definitely something of a trickster. Mischief is just about his favorite passtime, especially if it involves his butt or paws. If you act like a snob around him, prepare to get knocked down a peg!	NSFW	f
136	Public	Katherine	Litten	Fire	25	10lbs	1'04	Male	Bisexual	Single	Flare Blitz, Will-O-Wisp, Fake Out, Covet	Nature, making medicine, the plants of the forest	Being mistreated for her abilities, mistreatment of the forest	A simple feline who lives in the Pudgeberry Forest, creating various herbal remedies to help the trees and berries grow. She doesn’t seem passionate about much, although she holds a deep reverence for nature.	\N	A herbalist, capable of making potions and poultices	?edit2=2_ABaOnud22PbFgmciukcryelRISRfPHy3-LmQDysoL9Rnd8rvaLLCvWbRclYz78yFsl5LH9k	NPC	She's not a cold-hearted person despite everything that happened to her, but she takes the beauty of her forest seriously.  Endanger it at your own peril	Pudgeberry Forest	Word is, long ago, she lived in a small village that used to be found deep in Zaplana’s wilderness. She learned herbalism to aid with the village’s food shortages, applying her skills to massively boost the village’s harvests. For a time, they flourished - however, when Katherine was discovered, she was immediately branded as a witch, and almost killed by the villagers. Luckily, she escaped… and the villagers all ended up starving without her help.	Unknown	\N	NSFW	f
137	Public	Hammada	Mandibuzz	Dark/Flying	29	159 lbs	4'11"	Female	Pansexual	Single	Roost | Toxic | Whirlwind | Brave Bird	\N	\N	A quite smug and dominant mandibuzz, though she's rather kind at heart. She's usually assumed to be a loner, but in reality, she has quite a few friends who visit her little nest up in the mountains.	\N	\N	?edit2=2_ABaOnucAtu20R0FIrFsxJ8D88bbV3raTRK6l5Vwlqp1CLeW7tAvylTsfDB0Zf4Bc1zJE4VA	NPC	Sexy Bird	Santorini	She travels the desert of Santorini, and if she spots a Pokemon lost in the brutal desert, she makes sure to rescue them! If they're cute, she might even offer to bring them back to her nest for some fun.	Santorini	She's quite insecure about the fact that she can't fly like her winged brethren can. If you tease her on this point, she'll probably sit on you.	NSFW	f
138	Public	Adder	Krokorok	Ground/Dark	21	73 lbs	3'3"	Male	Pansexual	Single	Knock Off | Earthquake | Stone Edge | Pursuit	\N	\N	\N	\N	He leads a infamous gang of diaper-donning mons in Santorini. Theyre more petty than most gangs, mostly finding amusement in humiliating mons more than anything, fattening them up and/or forcing their special cursed diapers on them after nicking their valuables.	?edit2=2_ABaOnuf6jdx0rJmvFu7pnrxYU2ejZInFYg34zoi2aAtBqeUaUY33uQRNtAPeUtwhvf0JBMQ	NPC	Diapered Desperado	Santorini	Sheriff Clifton has a sizable bounty on his head, hoping to bring the mischief maker down.	Santorini	Careful! Those diapers they use are cursed! Once they put them on you, you're not going to be able to take them off until the curse is broken!	SFW	f
144	Public	Lily	Primarina	Water/Fairy	22	225 lbs	5'8"	Female	Homosexual	In a Relationship	Hydro Pump |  Dazzling Gleam |  Hyper Voice |  Sparkling Aria	\N	\N	\N	\N	In Relationship with Ginger	?edit2=2_ABaOnueXFKLWveRc4ZtnE3yY96C2OrpLEiICObTcOBaFUns7EZiakSgALpX-VRV8Q4XLQ0s	NPC	Milky large breasted Pokemon, Loves to be milked	The Village	It's said that once she flooded an entire room with nothing but her own breast milk. | They have some pretty huge tits, said to be the size of small exercise balls. |  She's a well known biologist!	Alola	Keep a close eye on her cleavage. She seems to have recently evolved, and doesn't seem very used to the new size yet.	NSFW	f
139	Public	Sheriff Clifton	Charizard	Fire/Flying	45	1,108 lbs	9'08''	Male	Homosexual	Single	Fire Blast, Flamethrower, Air Slash, Focus Blast	Tasty food, law-abiding citizens his hometown of Desperado, humiliating bandits	Lawbreakers, bullies, vandalism and all kinds of laws being broken	A true law abiding sheriff of a Charizard.  Believes in justice and helping out those in need	He believes in maintaining the natural freedom of Desperado, so long as that freedom does not extend to somebody hurting others. Those who do break the town's scant few laws, however, will end up slowly gurgling away in the town's jail - his belly! For lesser offenses, Pokemon can expect to be squished under that huge gut, or squishy belly.	\N	?edit2=2_ABaOnufXVTj9HLU32G7WtA9mlpAZhBRp0x8zxxBlh4nny7hK37L63KdYYGoI0TkRE_Lx9e4	NPC	Law breakers beware, he may be willing to let a misdeed slide if its for the greater good, but push your luck too hard and you're destined for a trip down his gullet	Desperado	Nothing	Desperado	He offers some great bounties, with generous rewards for any Pokemon who can bring some tasty, no-good bandits to feed to him.	SFW	f
140	Public	Sierra	Persian	Normal	28	70 lbs	3'3"	Female	Pansexual	Single	Nasty Plot | Hyper Voice | Water Pulse | Substitute	\N	\N	She's always looking to make herself wealthy as can be! Either through stealing or treasure hunting.	She's a well versed con artist who will lie and cheat on a whim, especially if it means making money.	A persian who came to Santorini in pursuit of fortune! Her various schemes to get rich quick tend to backfire, however, in all sorts of comedic or kinky ways.	?edit2=2_ABaOnuee61enaCEQmnYrWNkKK4hDDT-uOTQDhxnKKTRM_9o_t35pVsQawfOR-oFdo-mO75U	NPC	She is a treasure hunter and will be stopped at nothing to find the epic bounty of treasure the desert hides	Santorini	She's really working for Team Rocket! This rumor can be pretty easily confirmed, as she does have a big R tattooed on her behind. She found Team Rocket really fits in with her goals of wealth at all costs.	Melody Springs	\N	NSFW	f
141	Public	Jasper	Glaceon	Ice	19	131 lbs	5'6"	Male	Pansexual	Single	Ice Beam | Frost Breath | Aurora Veil | Shadow Ball	\N	He hates being mistaken for a girl.	\N	He works as a guardian of Snowdrop, helping to keep the citizens safe from harm.	\N	?edit2=2_ABaOnue3iMXHwlqrq3bDpDlDbf7Ak8aKhk-YQGh5qakwRmRlZfMVNwuoomjIXXhMYs99bDE	NPC	Defender of the North. Fighter, Warrior, Friend	Snowdrop	That staff of his was custom-made by himself, specifically designed to boost and focus the power of his own magic. | When he's not busy working as a guard, he's always coming up with new spells and charms.	Unknown	\N	NSFW	f
142	Public	Rufus	Rockruff	Rock	14	495 lbs	4'19''	Male	N/A	Child Character	Rock Throw  |  Bite  |  Howl  |  Rest	Dancing, eating, the beach, playing games on the beach, tummy rubs, ear scritiches,	Sharing food, being hungry, being alone for too long	"Big ol' pup who's all fun-loving and carefree while being a glutton at heart. Full of energy and always up for a good snack or two, all while trying to have some good fun.	\N	\N	?edit2=2_ABaOnudEoNTGXHOIxMFQR583LvPTKtkvVYQAG-9ZhJ1fcpJA9vSZCov5VmTZOMEq8KmKwKw	NPC	The place he enjoys the most is the beach and loves to have a good time there, with how he wears clothes for the summer and is always up for a nice swim in the waters and cause tides rising whenever he cannonballs. He also loves any shakes he can get with his paws, same goes for any snacks!\n He also enjoys any affection that's given in his way - such as belly rubs - and likes to show off how chubby he is.\n He's also a shy pred, meaning that he can eat other pokémons but would rather avoid doing that as he's not too much into it. It's likely that he'll run away if a pokémon in question wants him to eat them and if pressed too much into it, to the point he gets all nervous and feels uncomfortable. However, if one approaches him in the most gentle and calm of ways, it is possible to get him to eat them and let them ride in his belly for a sort while before they're let out again."	The Village	It's likely that he'll try to swipe food away from any other pokémon who's at the beach, and claim it for himself.  |  He's capable of eating other pokémons, but he'll try to constantly avoid doing that to not get himself into any sorts of trouble.  |  If there's any sort of shop that sells food within his vicinity, you can expect it to be raid by him in less than a rooster can call it a morning.  |  He has an odd thing for similarly obese pokémons, as he often looks up at them for how big they are and how much of a glutton they can be. So he tries to hang around them more often then others.	Obe City	He has an odd tendency to sleep walk on some occasions, and go in search of a snack to satisfy his gluttonous hunger in his slumber. He's also really possessive of any food he would be holding, and won't share it with anyone for any particular reason (With rare exceptions.).	SFW	f
143	Public	Tamera	Nidoqueen	Poison/Ground	41	220 lbs	7'9"	Female	Pansexual	Single	Poison Jab |  Dig |  Superpower |  Rock Slide	\N	\N	\N	\N	\N	?edit2=2_ABaOnuc_zssA5wH10BXOkH968P07nwlvjJbuoMRS4_6FFcluQxhY3WxSYt9vuxX5d-YXymk	NPC	Professional pregnant pokemon, populates preschools	LaRousse City	She may have a thing for getting pregnant. Either that or just being huge.  |  It's said that left untreated, her milk can flood an entire room! | She seems to be in a constant state of lactation now. | She works down at the hospital as a neurologist. | She's a professional surrogate, though other people prefer to call it 'broodmother'.	Obe City	She's really quite gravid. At some of her larger sizes, she can bump into things way too easily. Some of her pregnancies can make her grow so huge she's at risk of tearing herself apart!	NSFW	f
145	Public	Shane	Midnight Lycanroc	Rock	26	2462 lbs	13'04''	Male	Pansexual	Single	Scary Face  |  Attract  |  Sucker Punch | Taunt	Being fat, trapping Pokemon in his pudge, his brothers Liam and Rufus	Dieting, exercise, having his pudge not be filled with Pokemon	A devious prankster and nuisance.  Loves to live the big life of Obe City	One of the Lardy Lycanroc brothers, known as the Red Menace. He's arrogant, smug, and loves to trap smaller 'mons in his oceanic pudge or deep between his cavernous buttcheeks  |  Every so often visits Obe City Bathhouse to trap the cleaners in his rolls	\N	?edit2=2_ABaOnucPaMm7jK8lkcDT3vZfgelw8gaqPaqDXkiP1xXUwsOn7SHphat6mhc3TlITZ7fpo7A	NPC	They would be smug and cocky, always scheming to get pokemon lost within the depths of their folds. In the situation where the guild is tasked with receiving missing pokemon from his rolls, chances are he won't give them up without a bargain. While he may be too big to fight traditionally, if someone were to try and rescue his trapped pokemon without his permission, he'd do everything in his power to sabotage their attempts, trapping them within some crevice on their body as well. Typically his demands consist of either getting to keep some of the pokemon for himself in exchange for freeing the rest, or for the guild member doing the rescue mission to take their place as his temporary prisoner.	Obe City	Outside of the pokemon he stuffs up there, rumor says that if you search deep enough in his cavernous navel, there's quite the amount of treasure lost up there  |  He used to have quite the sweetheart who introduced him to the world of trapping pokemon in his fat  | He is on the prowl for a partner in crime who will help trap pokemon in his pudge	Obe City	He loves trapping smaller pokemon in his fat, and will very likely attempt to do the same with you if you're smaller than him. Also be warned that they are a fair bit musky	SFW	f
146	Public	Liam	Midday Lycanroc	Rock	26	2462lbs	10'09''	Male	Pansexual	Single	Rest  |  Sand Attack  |  Rock Throw  |  Earth Power	Eating, making friends, tummy rubs, his brothers Shane and Rufus	Diet, exercising, being lonely, Pokemon getting stuck in his flab	Unlike his brother Shane, Liam is the more moderate of the pair.  Eager to please and wanting to make friends, though some days are harder then others for him.	One of the Lardy Lycanroc brothers, known as the Clumsy Giant. He's timid and apologetic over the fact that his body mass often gets him into trouble  | Every so often visits Obe City Bathhouse to get a deep cleaning and free the pokemon lost in his rolls	\N	?edit2=2_ABaOnudU7XHgl3OTYHcLd8Bmssmiund31KICdnUO30Y45XGF-uSBdxYJRGp3RZxMyz-90UU	NPC	They would be really embarrassed and apologetic about the pokemon trapped within their folds. Really they are super friendly... just very clumsy, tripping and falling over on a little pokemon, or rolling over them in his sleep. In a situation where the guild is tasked with retrieving pokemon from his rolls, he would be compliant, but would need convincing that the guild members aren't going to get lost too. Should guild members attempt to rescue the trapped pokemon without permission, he'd likely panic, which would cause the rescuer to be more likely of getting trapped too. The closest thing to a 'demand' he has is just requesting the rescuer be his friend in exchange for letting them rescue the lost pokemon. Really they are a friendly and gentle soul at heart.	Obe City	All he really wants are friends, though pokemon often avoid him over the reasonable fear of being squished on accident  |  Many of the pokemon stuck in his rolls were actually shoved in there by his brother  | He actually traps pokemon in his rolls in the hope that they will be his friends	Obe City	They are incredibly clumsy and often fall on or bump into pokemon, leading to them getting lost in those rolls. Also be warned that they are a fair bit musky	SFW	f
\.


--
-- Data for Name: image_urls; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.image_urls (id, name, url, holiday) FROM stdin;
1	happy	https://static.pokemonpets.com/images/monsters-images-800-800/479-Rotom.png	\N
\.


--
-- Data for Name: inventories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventories (id, char_id, item_id, amount) FROM stdin;
2	1	2	1
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.items (id, name, description, effect, rp_reply, reusable, category, url, edit_url, side_effect) FROM stdin;
1	Potion	Restores some health	+20 Health	Its dangerous to go alone, take this.	f	{Food,Survival}	https://vignette.wikia.nocookie.net/pokemongo/images/7/7a/Potion.png/revision/latest?cb=20160717150053	?edit2=2_ABaOnudw-19PTpclShv5VUtx_HawoL0sdgWpQg7oRvIkA360LiJbmzm7cdocgWCNiEogqoE	\N
2	Tarnished Elven Ring	Simple gold band with a notch on the top	15 agility and 1% chance to hit	As you equip the ring, you suddenly feel to urge to admire it, and protect it at all costs	t	{Clothing}	\N	?edit2=2_ABaOnudW0QY19r_N7peFsGl2Sjy7xnqTy3U4Vfa1fzrxPl3t365Os_9ieESKRG-YMqcD40I	\N
\.


--
-- Data for Name: statuses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.statuses (id, name, effect) FROM stdin;
1	stealth	harder to detect
2	fat	fatter
3	slime	more gelatinous
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.teams (id, name, description, active, role, channel) FROM stdin;
11	The Worst Roommates	The clubhouse of the fish loving kids! These little rascals are fun loving gamers who laugh at everything. Every day is wonderful so long as they're together	t	642428765909024769	642428766584438805
\.


--
-- Data for Name: types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.types (id, name, color) FROM stdin;
1	Normal	#a8a878
2	Fire	#f08030
3	Fighting	#c03028
4	Water	#6890f0
5	Flying	#a890f0
6	Grass	#78c850
7	Poison	#a040a0
8	Electric	#f8d030
9	Ground	#e0c068
10	Psychic	#f85888
11	Rock	#b8a038
12	Ice	#98d8d8
13	Bug	#a8b820
14	Dragon	#7038f8
15	Ghost	#705898
16	Dark	#705848
17	Steel	#b8b8d0
18	Fairy	#ee99ac
19	Unknown	#68a090
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, level, next_level, boosted_xp, unboosted_xp, evs, hp, attack, defense, sp_attack, sp_defense, speed) FROM stdin;
271741998321369088	70	25550	25285	18368	24, 4, 5, 5, 6, 5	432	127	128	143	145	136
215240568245190656	30	4950	4686	984	23, 4, 6, 6, 4, 5	201	67	67	69	62	64
263878163975634947	17	1702	1675	1227	19, 5, 4, 5, 6, 4	113	39	41	39	42	38
409742624111460352	33	5942	5841	5468	10, 4, 5, 6, 5, 6	206	72	65	74	73	69
277235003841314816	36	7020	6869	3610	19, 6, 6, 5, 5, 4	233	74	72	76	72	75
412163685440684052	66	22770	22121	4831	20, 4, 4, 4, 5, 5	400	131	135	135	143	133
473547751221886976	56	16520	16377	10701	21, 4, 5, 6, 4, 5	381	117	125	119	118	118
354840009829908480	49	12742	12721	2964	29,4,4,6,4,4	319	110	100	103	96	90
152231245282148352	8	440	357	357	25, 6, 4, 4, 4, 5	71	19	17	19	17	20
121848160900349955	20	2300	2290	1430	15, 4, 6, 5, 5, 6	123	39	43	44	41	46
Public	1	22	0	0	none	0	0	0	0	0	0
311235078070075402	1	22	0	0	00000	0	0	0	0	0	0
455903666780504064	1	22	0	0	none	0	0	0	0	0	0
400123456039026689	1	22	0	0	none	0	0	0	0	0	0
\.


--
-- Name: carousels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.carousels_id_seq', 101, true);


--
-- Name: char_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.char_images_id_seq', 153, true);


--
-- Name: char_statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.char_statuses_id_seq', 3, true);


--
-- Name: char_teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.char_teams_id_seq', 2, true);


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.characters_id_seq', 146, true);


--
-- Name: images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.images_id_seq', 1, true);


--
-- Name: inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_id_seq', 3, true);


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.items_id_seq', 2, true);


--
-- Name: statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.statuses_id_seq', 3, true);


--
-- Name: teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.teams_id_seq', 11, true);


--
-- Name: types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.types_id_seq', 19, true);


--
-- Name: carousels carousels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carousels
    ADD CONSTRAINT carousels_pkey PRIMARY KEY (id);


--
-- Name: char_images char_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.char_images
    ADD CONSTRAINT char_images_pkey PRIMARY KEY (id);


--
-- Name: char_statuses char_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.char_statuses
    ADD CONSTRAINT char_statuses_pkey PRIMARY KEY (id);


--
-- Name: char_teams char_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.char_teams
    ADD CONSTRAINT char_teams_pkey PRIMARY KEY (id);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: image_urls images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image_urls
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: inventories inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventories
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: statuses statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: types types_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_name_key UNIQUE (name);


--
-- Name: types types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: carousels carousel_char_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carousels
    ADD CONSTRAINT carousel_char_id FOREIGN KEY (char_id) REFERENCES public.characters(id);


--
-- Name: char_statuses char_statuses_char_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.char_statuses
    ADD CONSTRAINT char_statuses_char_id_fkey FOREIGN KEY (char_id) REFERENCES public.characters(id);


--
-- Name: char_statuses char_statuses_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.char_statuses
    ADD CONSTRAINT char_statuses_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.statuses(id);


--
-- Name: char_teams char_teams_char_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.char_teams
    ADD CONSTRAINT char_teams_char_id_fkey FOREIGN KEY (char_id) REFERENCES public.characters(id);


--
-- Name: char_teams char_teams_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.char_teams
    ADD CONSTRAINT char_teams_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: characters character_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT character_user_id FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: inventories inventory_char_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventories
    ADD CONSTRAINT inventory_char_id_fkey FOREIGN KEY (char_id) REFERENCES public.characters(id);


--
-- Name: inventories inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventories
    ADD CONSTRAINT inventory_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(id);


--
-- Name: char_images url_character_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.char_images
    ADD CONSTRAINT url_character_id FOREIGN KEY (char_id) REFERENCES public.characters(id);


--
-- PostgreSQL database dump complete
--

