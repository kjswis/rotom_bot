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
-- Name: types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.types ALTER COLUMN id SET DEFAULT nextval('public.types_id_seq'::regclass);


--
-- Data for Name: carousels; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.carousels (id, message_id, char_id, options, image_id) FROM stdin;
46	640970691872686101	1	\N	\N
47	640971735445012503	1	\N	3
59	641834302409146368	15	\N	31
31	637010219955781632	1	\N	\N
34	637018848800931841	\N	{}	\N
38	637025525868789770	6	\N	21
39	637026589263003669	6	\N	21
40	637026848315801638	5	{2,5}	\N
41	637027299421847571	\N	{}	\N
42	637029052179283978	\N	{}	\N
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
27	10	http://d.facdn.net/art/schrodingerthewolf/1475979029/1475979005.schrodingerthewolf_toastie_lapras.jpg	SFW	Default
28	11	http://d.facdn.net/art/haradoshin/1521175977/1521175977.haradoshin_flygon_fa.png	SFW	Default
29	12	http://d.facdn.net/art/kiacat19/1393635277/1393635277.kiacat19_gogat.png	SFW	Default
30	13	http://d.facdn.net/art/amorabadger/1463665901/1463665901.amorabadger_gogoat_rides.png	SFW	Default
31	15	http://d.facdn.net/art/hasquet/1383347600/1383347600.hasquet_latiosbeach.jpg	SFW	Default
33	15	http://d.facdn.net/art/hasquet/1515654466/1515654466.hasquet_latiosflower.png	NSFW	Inflated
34	16	http://d.facdn.net/art/shinodahamazaki/1425848045/1425848045.shinodahamazaki_392015.jpg	SFW	Default
35	21	https://i.imgur.com/w02hfux.png	SFW	Default
\.


--
-- Data for Name: char_statuses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.char_statuses (id, char_id, status_id, amount) FROM stdin;
\.


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.characters (id, user_id, name, species, types, age, weight, height, gender, orientation, relationship, attacks, likes, dislikes, personality, backstory, other, edit_url, active, dm_notes, location, rumors, hometown, warnings, rating, shiny) FROM stdin;
1	215240568245190656	Mizukyu	Mimikyu	Ghost/Fairy	Old	1.5 lbs	0'8"	Female	Pansexual	Married	Shadow Claw | Play Rough | Psychic | Shadow Sneak	Cuddles, soft things, spooky stories, horror	Bullies, rejection, being exposed	I am shy and a bit recluse, but warm when you take the time to get to know me. I don't like when people try to see under my disguise, I've lost many friends that way (to death) including my spouse. Really, really really likes to dress up as other pokemon	Has existed more years than she cares to count. She is immortal, due to being a ghost. She has learned to carefully hide her appearance as to make sure not to accidentally kill more friends. Took up tailoring to make multiple disguises, because pretending to be a Pikachu forever is boring.	Switches disguising with moods. Has made them for all pokemon. Also a master shadow bender	?edit2=2_ABaOnuc3HZEyhI9EeApXcJtsBmDzqtzDGH5De46CfuRBxwVavQKAfTT_LZy_kMH0sz5H7gk	Active	\N	\N	Loves children | Hates washing and tailoring disguises | Surprisingly soft | Steals children | Wishes to be admired	\N	Horrific Eldritch Abomination	\N	f
2	271741998321369088	Neiro	Vaporeon	Water	33	125 lbs	3'03"	Male	Bisexual	Single	Water Gun|Hydro Pump|Ice Beam|Synchronoise	Likes to overeat, being in the rain, and playing with fat	Hates that his body absorbs any liquids	Carefree and a little bit lazy. Always up for fun things.	He was spoiled from the very beginning of his life. This resulted in him being a bit fat and lazy. He loved it tho but decided to make something more with his life by joining a rescue team. He also wanted to work on his skills as being taken care of his whole life made him pretty useless in battle.	He has the special ability Water Absorb. Neiro's body can bloat up to 250 times his normal size before his body stopped expanding. His tail can also bloat equal to that, making his total potential size 500 times	?edit2=2_ABaOnufidKuBLj5ecAtAjVd0CTTFoJhB0CqE9rM-WW0yeYSfnxeKjblep_Nru3f8jpOzkS4	Active	\N	\N	Uses Water Gun every time he sneezes.|His Water Absorb ability absorbs any liquids into his body.|Too much water makes him bloat like a sponge.|He can piss for an hour.|He is outstanding with his move execution and aim	The Village	Dont share a shower with him... 	\N	f
3	215240568245190656	Zumi	Noivern	Dragon/Flying	Young	120 lbs	3'0"	Male	\N	\N	Dragon Pulse | Screech | Bite | Wing Attack	Zumi loves games and all his friends. He also loves sweets and sour candy	Zumi doesn't like bullies or mean kids that constantly make fun of other kids or exclude them from the fun	Zumi is a fun loving Derg that likes to play with anyone and everyone! He also likes to play fun jokes on people or do a bit of spooking with his ghosty parents -- but he tries not to take it too far. He tries to protect his friends as much as he can, but theres only so much a little dragon can do	Zumi is a young dragon, and doesn't really remember much before coming to the guild house. He doesn't remember his birth parents, or when he met his ghost parents, but he isn't really bothered about it. All he knows, is that he loves his ghost parents and wants to make as many friends as he can!	\N	?edit2=2_ABaOnuf86ZAxBbQfeKlKe40wSsMNOKbAg8yb9OIS7GsZ1Qs8dtVRX13RLf4uJnuRawMf5io	Active	\N	\N	He was abandoned as a baby | He wishes he could fly faster | He was rescued by a ghostly couple | He doesn't scare easy | He's just a dumb kid	\N	Has a spooky set of parents that will ruin your day	\N	f
4	215240568245190656	Ozi	Gengar	Ghost/Poison	???	90 lbs	5'0"	Male	Straight	Married	Shadow Ball | Sludge Bomb | Psychic | Dazzling Gleam	Jokes and Spooks	Kill joys and Arrogance	Theres never a dull moment with Ozi! He likes to pull pranks and make people either laugh or scream. He loves his wife (Mizukyu) and son (Zumi) and will spook anyone who harms them to death. So long as you play nice, he's a great ghosty guy!	No one knows where Ozi came from, or why he came here, but he and his wife Mizukyu have caused a lot of mayhem in their many years together. He's been known to suddenly appear or disappear and even caused some unfortunate souls to go mad with insanity. Over time he's learned to dial back the spooks a bit, and even tried to make some new friends	Ozi sometimes causes trouble with his ghost powers, behaving a bit like the Cheshire Cat. He can be a bit slippery, but tries not to cause too much trouble	?edit2=2_ABaOnueS5nTN63soX4wQ0PVKa_tGFghbIpiYlW3kwGw4Cj09Fnio0qNLD47iyOC5H3f4oN4	Active	\N	\N	He taught Zumi how to fly | He's a surprisingly good father | Sometimes he doesn't know when to stop the jokes | His humor is not for everyone | I'm not totally convinced he's real	\N	Spooks ahead!	\N	f
5	215240568245190656	Neiro	Vaporeon	Water	\N	???	varies	Male	\N	\N	Duplicate | Pokemon | Attack	\N	\N	\N	\N	This is test entry	?edit2=2_ABaOnuc441lxr76HNkZnq7BJq0f_VFhK9OM8YMUGkIbQGKSU8apSzv6re4BevYVYi6QzmI8	Active	\N	\N	\N	\N	\N	\N	f
6	412163685440684052	Kipper	Mudkip	Water	26	20lbs	1'05''	Male	Gay	Single	Water Gun | Mud Slap | Protect | Surf	Water, Mud, His Teammates, Teasing Cecil	Injustice, not being able to evolve, getting picked on	Lazy bum who doesn't like to work, but can't ignore when someone is in need.	N/A	He's a surprisingly good chef, able to easily handle ingredients and mise en place despite being a tiny quadruped.	?edit2=2_ABaOnucXHjYrWRLF9ERHNJYBdtB1t25-lacSlSV1wrmrpgLUEK_swo7p-gtWWRXquXNBsyM	Active	\N	\N	He's easily distracted, like he gets lost in his thoughts a lot. | He's incredibly lazy and hates working. | He's quite the chef, his recipes sounds really good. | He's rather old for a stage 1 Pokémon. He probably can't evolve | I heard he's great to hang with when you're feeling really upset or depressed.	Zaplana	He's really sensitive about the fact that he can't evolve.  Tease him for that at your own risk.	\N	f
7	354840009829908480	Sarah	pyroar	Fire/Normal	20	179.7 lbs	4'11"	Female	pansexual	In a Relationship	strength | will-o-wisp | rest | dig	\N	\N	\N	\N	has 1 kit with yang the ninetails, intelligence gets lowered when she ingests a certain liquid	?edit2=2_ABaOnuf-HnF8bkanKrZ99PEPD_PWINX-c9HU_rQ_bg1oqFywrr9h_KbufnD98N9bFQ2Q2Fs	Active	\N	\N	\N	\N	\N	\N	f
8	473547751221886976	Avery	Sylbreon	Dark/Fairy	20	55 lbs	3'03"	M or F	Bi	Single	Moonblast | Dark Pulse | Venoshock | Misty Terrain	the cold, dry food, anything with running, swimming and water, love, berries, computers, DJ Thunder (AKA his idol), his friends, floof, hacking (usually ethical), and fashion despite being a feral.	heat, excessive food, bitter food, being teased, being told what to do, seeing people get hurt, his father, sadness, damaged electronics.	\N	\N	\N	?edit2=2_ABaOnufmQm1Ss0H-E8yfoZt636DRwCBgN2ZVrt-14dW2QyhHJxrnBEfj6Ie_s46TxqLuZNE	Active	\N	\N	\N	He lives at the Guild, but he's from the Woods.	\N	\N	f
10	Public	Nuwa	Pooltoy Lapras	Water	43	20 lbs	12'0"	Female	Heterosexual	Single	Hydro Pump|Freeze-Dry|Surf|Thunder	Love of Pooltoys.	\N	Her theme is literally "In the name of God", so take personality like that.	\N	Knows a bit about religion, just Arceus though and the world's equivalent of the bible. They are a very lawful pokemon, taking protocol and order in high regard.|They were pretty strong, likely only surpassed by the guild headmaster herself tho their power waned after becoming a pooltoy, though they still have impressive water-based abilities and adapted to their situation. Namely, they're now extremely light.|They have been seen as vindictive of chaotic alignments and villains, rarely showing them mercy, though it extends only to turning them in for their crimes|Very wise, having gone through many expeditions and thus has some great advice. Guild advisor for a good reason.|Despite their hardy demeanor they actually are very pious, and warmhearted to the average person. Just some people deserve her vengeance, such as Sabrina	?edit2=2_ABaOnuei0yT6JQ3kX8fdgUoprITnFTCkjMNngkSRooogqEuslAS2nIwDfZpYLswtsz9_eR4	NPC	This character is like a religious missionary of Arceus	Guild House	Despite their situation, they have found many advantages to being a pooltoy, and wish to stick with it.|They have their own room in the guild house for pooltoys.|Originally they were a crusader of sorts, going after criminals, before entering the guild as a rescuer. Deus Vult style. https://www.youtube.com/watch?v=_FdnA4SyYzE |Their sense of justice blinds them in certain situations.|Emotions get the better of her every now and then.	The Village	If you take this pokemon with you on a journey, expect no diplomacy at all. She will likely get you into more situations than she gets them out of. Though that's a very close ratio since she brings them out of said scenarios most of the time. Also, getting close to her will involve getting into her secret likes of pooltpoys, which can be borderline obsessive. And if you're not lawful then by Arceus she will smite you, either with her hydro pump or a deadly stare.	SFW	f
11	Public	Esra	Flygon	Ground/Dragon	30	379 lbs	6'11"	Male	Homosexual	Single	Dragon Claw|Screech|Dragon Tail|Dragon Rush	\N	\N	\N	\N	He is open about how much he eats. Bragging about his diet and flaunting his fat. No matter what happens to his experiments, even if he miserably fails to achieve the desired effect, he'll brush it off and treat it as if it was the most probable outcome, even if the effects are bad. His true colors sometimes show when he becomes invested in an experiment, especially involving a male test subject. He stress eats when an experiment doesn't go as planned.	?edit2=2_ABaOnueZ6V8DisFQHbhpg39Imf285NuzszFJlbFhdYz8nsoPUl2YU5UMMLl_vPdP3BGUn54	NPC	Think mad scientist for all things expansion	LaRousse City	Word of mouth about his practices, he does it to vent some sexual frustrations that he bottles up.|Some say he's gone through several relationships, all ending in a tragic breakup... And the significant other disappearing assumably via his experiments.|Esra Perpetuates the motive for his research as 'For the greater good, for world peace, and to usher in a golden era of Lesiure!' although the tests and results vary, and thus, help to muddy this message a bit and make him seem more sinister.|It's very well debated whether he's evil, insane, or misunderstood.	LaRousse City	Never Say he's Too fat. Never Tease him about Being single. Never inquire about the eligibility of his diploma. Doing any of those thing may result in death by experimentation.	SFW	f
12	Public	Elliot	Gogoat	Grass	27	184 lbs	5'4"	Male	Homosexual	Married	Energy Ball|Takedown|Leaf Blade|Protect	Elliot likes calling Dyson 'old man' to tease him for his stern demeanor and being a stick in the mud	\N	Elliot is generally friendly and cheerful	\N	Elliot is very affectionate towards Dyson like a doting housewife. Regardless of Dyson's embarrassment, they are both happy to be starting a family. Married to Dyson	?edit2=2_ABaOnufbP1i8LoIlar8A3o3N8AiZi3mOO9ux7u3OhaQUtpNAsa8po8182i_Ba96FLoWCmis	NPC	He is caring and happy to be starting a new family. He talks about it all the time	The Village	They had been considering adoption before finding the cave or origin.|A lot of pokemon think Elliot secretly wishes he was the pregnant one.|Elliot is really bad at cooking	The Village	If Elliot offers you any food, decline as nicely as you can.	SFW	f
13	Public	Dyson	Gogoat	Grass	33	247 lbs	5'9"	Male	Homosexual	Married	Energy Ball|Takedown|Leaf Blade|Protect	\N	\N	Dyson looks and acts very stern and serious. Dyson is easily embarrassed by his situation, but tries to remain stoic.	\N	Dyson got pregnant from the Cave of Origin. Regardless of Dyson's embarrassment, they are both happy to be starting a family.	?edit2=2_ABaOnuc_wZ5KWo2YPwz_p1fkcrfiaqUDrrBoBjq-9z55p7UeHMMuoVJsH4LNJV08eIXvzmQ	NPC	He is caring and happy to be starting a new family. He talks about it all the time	The Village	They had been considering adoption before finding the cave or origin.|Pokemon say Dyson has a bit of a short temper.|Dyson is nervous about whether or not he'll be a good dad.|Dyson likes to see himself as the man of the house, making his pregnancy a bit embarrassing for him.	The Village	Don't tease Dyson over his pregnancy. Never let Dyson catch you making fun of Elliot.	SFW	f
14	Public	Alto	Castform	Normal	34	2 lbs	1'0"	Male	\N	Single	Hail|Sunny Day|Rain Dance|Weather Ball	His favorite form is the hail form, and tends to go up to the mountainous areas to snowy weather to be his best self. Aside from his personality vastly changing with the weather, Alto also enjoys music. Specifically wind instruments.	\N	Despite changes in mood he is usually quite happy delivering the weather report each day. It's a natural job for him, after all! In general he can be quirky as well and open to new ideas, or new people.	\N	\N	?edit2=2_ABaOnuflRN22ks-IUXgu1ixIdRC0BMbsZgCHsXlUv7hHIccU9m126TFT5e_K8hSngWPUNeY	NPC	Weather! All day, Everyday	The Village	His mood greatly depends on the weather, though he's usually quite a cheery guy. He feels most alive, though, in snowy weather, where he is especially bright and upbeat. Other moods, reportedly, are: Sunny - Calm, Rainy - Glum, Normal - Straight to the Point.|Extremes of weather can cause extremities in personality.|Given his job's leniency he spends a lot of time elsewhere around various towns, and is a connoisseur of various foods.|He went on an expedition once... Once, and never again.|He never discloses or looks for a relationship possibly because he's already failed in one.	Styx Mountain	If the weather is extreme, be very careful around him. During tornados or hurricanes he'll act fantastical and might do some crazy things.	SFW	f
16	Public	Captain	Zangoose	Normal	27	140 lbs	5'0"	Male	Pansexual	Single	Rest|Snore|Thunderbolt|Slash	His Boat	He doesn't like leaving this boat either, and he usually naps on it while waiting for explorers.	He's a slightly lazy Pokémon who drives the ferry and spends most of his time caring for his boat. He's pretty laid back since he considers fighting to be too much effort, but he'll do whatever it takes to protect his boat.	\N	He prefers to be paid in food and supplies so he doesn't have to go to the market himself, but he still accepts Poké. He's also fiercely loyal to the guild, partially because they're his best customers and partially because he likes their adventurous spirits. He speaks a bit like a pirate. He has an unsteady gait on land due to how much time he spends on the water.	?edit2=2_ABaOnufGXWfUrQ3_5U-1kpG_uM-R6pG-jncTEKyHsktv9_sYVAxHkMinj7DMiU6UmxpRLkI	NPC	Drunken Pirate that drives a ferry for explorers rather than going out and doing it himself	The Village	He used to be pirate.|He has a secret treasure hidden on an unmarked island.	The Village	He can be grumpy when woken up. Don't call him short, or you'll be in for a rough boat ride. You can call him fat, though; he'll just make sure to show it off every chance he gets. Never, EVER mess with his boat. It's the one thing that will make him get up and exert 110% of his effort to make sure the perpetrator is properly punished.	SFW	f
17	Public	Abe	Tepig	Fire	29	23 lbs	1'9"	Male	Bicurious	Single	Ember|Odor Sleuth|Defense Curl|Zen Headbutt	\N	\N	He's very cautious around new people, though he's warm and friendly when he opens up. He thumps his tail on the ground when he's nervous.	\N	He's very knowledgeable about plants and can tell you anything about their uses, locations, and even smells! He also knows a lot about their various hazards, and as a result, rarely travels into the forests alone. He seems very at home in the the forests and knows of several shortcuts.	?edit2=2_ABaOnufWzKMb_pVyBKaKhZNJdhQQVBcB74zsRnuCpqXMO9wXdeb0hFRwc2keSp9aWUJPAa8	NPC	He grew up in the Spiralwood, though he's never told anybody. His father taught him several techniques to keep his mind clear and free from outside influences, which help when he needs to make a trip. After he grew up, he moved into the Village so that he could use his expertise to help people.	Apothecarium	He has psychic powers.| He has the power of suggestion.	The Village	His shop is set up so that the sights and smells make people more suggestible. He doesn't mean any harm by it, but it does help business.	SFW	f
18	Public	Justin	Sylveon	Fairy	22	51.8 lbs	3'3"	Male	Heterosexual	Single	Draining Kiss|Skill Swap|Misty Terrain|Moonblast	\N	He dislikes slobs, but he'll put on a brave face if he has to be around them.	\N	\N	He has somehow managed to stay slender and is proud of it. He also knows of a place where his associates are holding Pokémon captive, and he has them wear the Bijection Collar + while he forcefeeds them. Since he has to run his shop during the day, someone else takes over the feeding for him then, but they can overdo it sometimes. He obtained the collars from Esra, and in addition to the money he makes from selling them, he gets paid for stress testing them and sending back reports.	?edit2=2_ABaOnufcAIZY10IwL4JsOoYFrn_mW2J05SWjex5ZpygeLuucnYXY3nfV8tHeAFFc56LIIUQ	NPC	He has a deep secret so when RPing him, he should act better than life or at least act like he is a normal shop owner who could do no wrong	Obe City	He has connections with some of the less savory members of the city.| His ribbon-feelers are strong and dexterous, and he uses them as frequently as his paws.|He has a bunch of Bijection Collars - that he's stylized and secretly selling as a quick way to gain weight.|He is always immaculately groomed.| He owns and manages a small but successful accessory shop in Obe City.	Obe City	Questioning his gender and sexuality annoys him. Yes, he is male, and yes, he is straight. He's strong enough to toss unruly customers out of his shop.	SFW	f
15	271741998321369088	Jay	Latios	Dragon/Psychic	32	225 lbs	6'7"	Male	Bisexual	Single	Dragon Breath|Luster Purge|Psycho Shift|Psychic	His fascination with all things blue and juicy.	\N	He's an excitable and upbeat guy with a strong interest in blue things, especially blueberries and Bluelatcher Flowers.	\N	He is regarded as a scientist because of his passion and dedication for his Bluelatch Flower research. Owns "Blue Cresent" Bar in Bluelatcher Forest	?edit2=2_ABaOnufrj61rugNU5lX0Y4YCsFNmNgT_bdi9Koz5_6TAOFuu8X54ECTazGhbrl52RYmDctA	NPC	He is like a cross between a stoner and a college professor	Blue Cresent	The blue on his body is caused by blueberry juice.|Being swollen with juice is a major turn on for him.|He's trying to learn how to use Psycho Shift to transfer blueberry juice into others.|He frequently goes to visit the herbalist to ask for the flowers, and he's always given a firm no.|He once somehow obtained a whole Bluelatcher Flower plant and attempted to grow it at home, which ended with it pumping him close to his limit with juice.|He misspelled the name of his bar 'Blue Cresent' due to him being high and is now to lazy to fix it	The Village	If he asks you to help with an experiment, you should probably decline unless you really like blueberries.	SFW	f
22	271741998321369088	Ascher	Eevee	Normal	10	61 lbs	1'1"	Male	NA / Child Character	NA / Child Character	Growl	\N	\N	\N	\N	Keri and Namibia's Kit. Youngest of the six Eevees	?edit2=2_ABaOnudTApwkZHlnBIQWSR6o5j7ala1717JJEFighve-7_tHzK9bhhGR0_f13Ki4bX_BZKc	Inactive	\N	\N	\N	Pudgeberry Forest	\N	\N	f
19	Public	Bessie	Miltank	Normal	35	200 lbs	3'11"	Female	Homosexual	In a Relationship	RolloutMilk Drink|Body Slam|Captivate	She prefers her lovers fat and bloated with milk. Her herd gives her a lot more attention when she's full of milk, and she really enjoys it.	\N	\N	\N	\N	?edit2=2_ABaOnufyzM83aWtawEVuy6BS-p1raO3VjwZ7RfzEG0285F-nYS2x8UJpOkI1LC5Zn0fz2H0	NPC	Behind her friendly exterior is a devious mastermind who seeks to convert those she comes across into new members of her herd. Her down home kindness is really a ploy to get tourists to lower their guards. She'll insistently feed tourists special dairy products to see how receptive they are to the transformation. Those who can't be transformed become silos for dairy products and are always kept near bursting. She's smart enough to let some visitors leave so they can spread the word about how nice and friendly her town is. As a side note, the milk that she produces is highly addictive.	Moomoo Fields	She can transform people into Miltanks.|She's in a relationship with everyone in her herd.|She's the leader of the herd of Miltanks who live in Moomoo fields.|She loves meeting new people and treating them to a feast consisting of dairy products made by the local residents.|She sometimes lets her udder become really bloated with milk.	Moomoo Fields	She gets very cross with folks who refuse her hospitality. She is suspected of being behind some local disappearances.	SFW	f
20	Public	Wally	Wynaut	Psychic	105	30.9 lbs	2'0"	Male	Unsure	Single	Splash|Charm|Encore|Safeguard	\N	\N	\N	\N	He appears to look like a 5 year old dispite is actual age thanks to the Spring of Youth	?edit2=2_ABaOnueGmXDjjmGlrn2cKUwraRryRevIv9ZAh94T1TjbwOlhxvqENNIIyjWxEcvZI6n-QrQ	NPC	He never stops smiling. Always glad to shout the town news at people	Bambina	He's one of the oldest residents of Bambina.|He's super energetic and cheerful and loves to meet new people.|He's the official town crier because of his enthusiasm.|He arguably knows more about Bambina than anyone else.|He's a hugger, not a fighter.~	Bambina	If he's really interested in a topic, he can talk about it for hours if not stopped. He sometimes forgets people don't have as much energy as he does and can leave them exhausted after a long day of fun activities.	SFW	f
21	271741998321369088	Roland	Eevee	Normal	10	612 lbs	1'9"	Male	NA / Child Character	NA / Child Character	Growl	\N	\N	\N	\N	Keri and Namibia's Kit. Second Youngest of the six Eevees. Due to his mother's almost constant spoiling and feeding of Roland, he has grown to be so fat that he can not longer move on his own without the help of a motorized scooter. He can only move his head some and jiggle around.	?edit2=2_ABaOnufbAKWWFIlA9CHk0EZ2CS4Dj1yhvGpl02qaNMab8_FBXgks5FHkcVVzN181whCEvG8	Inactive	\N	\N	\N	Pudgeberry Forest	He is so fat that he needs help doing anything at all other than driving his scooter	\N	t
23	271741998321369088	Shaun	Eevee	Normal	10	59 lbs	0'11"	Male	NA / Child Character	NA / Child Character	Growl	\N	\N	Pudgeberry Forest	\N	Keri and Namibia's Kit. Oldest of the six Eevees	?edit2=2_ABaOnufs0fY08_R8ZjEdILjFxAkE9fNAsldPtxkLACEabpC8k5mJDTKk4pPnBgh-DejFGbE	Inactive	\N	\N	\N	\N	\N	\N	f
24	271741998321369088	Lapis	Eevee	Normal	10	56 lbs	1'1"	Female	NA / Child Character	NA / Child Character	Growl	\N	\N	\N	\N	Keri and Namibia's Kit. Third Youngest of the six Eevees	?edit2=2_ABaOnucJf6-DYeSWd3Wp-GyIII7-O6PbmzO75iSpr3suQy5Swk-I1LV7KJeh2u9cbD7eX08	Inactive	\N	\N	\N	Pudgeberry Forest	\N	\N	f
25	271741998321369088	Sophie	Eevee	Normal	10	34 lbs	1'0"	Female	NA / Child Character	NA / Child Character	Growl	\N	\N	\N	\N	Keri and Namibia's Kit. Second Oldest of the six Eevees	?edit2=2_ABaOnueOQ8CBkK5IPXFg8Hixyg3RXurPO4Ic6hQI1xRIxzvogjzYjlMp5nkDcBbB622-WP4	Inactive	\N	\N	\N	Pudgeberry Forest	\N	\N	f
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
\.


--
-- Name: carousels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.carousels_id_seq', 71, true);


--
-- Name: char_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.char_images_id_seq', 35, true);


--
-- Name: char_statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.char_statuses_id_seq', 3, true);


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.characters_id_seq', 25, true);


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

