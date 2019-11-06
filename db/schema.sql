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
    rating character varying
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
-- Name: types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.types ALTER COLUMN id SET DEFAULT nextval('public.types_id_seq'::regclass);


--
-- Data for Name: carousels; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.carousels (id, message_id, char_id, options, image_id) FROM stdin;
46	640970691872686101	1	\N	\N
47	640971735445012503	1	\N	3
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
24	9	https://images-ext-2.discordapp.net/external/6sG2JwqdzaGDbM9dOsOQ1303N2vXZNkAtUy8sZ3hbR4/https/media.discordapp.net/attachments/599088586461020161/620117815642554368/unknown.png?width=80&height=74	SFW	Default
25	1	https://66.media.tumblr.com/c61502da7705c26020d35c5fef0fb446/tumblr_oinlc7e3oa1slli9po1_540.png	SFW	Evolved
26	1	https://i.pinimg.com/originals/b5/88/be/b588be5e036fd67540588f0e7b233b06.jpg	SFW	Vee
\.


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.characters (id, user_id, name, species, types, age, weight, height, gender, orientation, relationship, attacks, likes, dislikes, personality, backstory, other, edit_url, active, dm_notes, location, rumors, hometown, warnings, rating) FROM stdin;
1	215240568245190656	Mizukyu	Mimikyu	Ghost/Fairy	Old	1.5 lbs	0'8"	Female	Pansexual	Married	Shadow Claw | Play Rough | Psychic | Shadow Sneak	Cuddles, soft things, spooky stories, horror	Bullies, rejection, being exposed	I am shy and a bit recluse, but warm when you take the time to get to know me. I don't like when people try to see under my disguise, I've lost many friends that way (to death) including my spouse. Really, really really likes to dress up as other pokemon	Has existed more years than she cares to count. She is immortal, due to being a ghost. She has learned to carefully hide her appearance as to make sure not to accidentally kill more friends. Took up tailoring to make multiple disguises, because pretending to be a Pikachu forever is boring.	Switches disguising with moods. Has made them for all pokemon. Also a master shadow bender	?edit2=2_ABaOnuc3HZEyhI9EeApXcJtsBmDzqtzDGH5De46CfuRBxwVavQKAfTT_LZy_kMH0sz5H7gk	Active	\N	\N	Loves children | Hates washing and tailoring disguises | Surprisingly soft | Steals children | Wishes to be admired	\N	Horrific Eldritch Abomination	\N
2	271741998321369088	Neiro	Vaporeon	Water	33	125 lbs	3'03"	Male	Bisexual	Single	Water Gun|Hydro Pump|Ice Beam|Synchronoise	Likes to overeat, being in the rain, and playing with fat	Hates that his body absorbs any liquids	Carefree and a little bit lazy. Always up for fun things.	He was spoiled from the very beginning of his life. This resulted in him being a bit fat and lazy. He loved it tho but decided to make something more with his life by joining a rescue team. He also wanted to work on his skills as being taken care of his whole life made him pretty useless in battle.	He has the special ability Water Absorb. Neiro's body can bloat up to 250 times his normal size before his body stopped expanding. His tail can also bloat equal to that, making his total potential size 500 times	?edit2=2_ABaOnufidKuBLj5ecAtAjVd0CTTFoJhB0CqE9rM-WW0yeYSfnxeKjblep_Nru3f8jpOzkS4	Active	\N	\N	Uses Water Gun every time he sneezes.|His Water Absorb ability absorbs any liquids into his body.|Too much water makes him bloat like a sponge.|He can piss for an hour.|He is outstanding with his move execution and aim	The Village	Dont share a shower with him... 	\N
3	215240568245190656	Zumi	Noivern	Dragon/Flying	Young	120 lbs	3'0"	Male	\N	\N	Dragon Pulse | Screech | Bite | Wing Attack	Zumi loves games and all his friends. He also loves sweets and sour candy	Zumi doesn't like bullies or mean kids that constantly make fun of other kids or exclude them from the fun	Zumi is a fun loving Derg that likes to play with anyone and everyone! He also likes to play fun jokes on people or do a bit of spooking with his ghosty parents -- but he tries not to take it too far. He tries to protect his friends as much as he can, but theres only so much a little dragon can do	Zumi is a young dragon, and doesn't really remember much before coming to the guild house. He doesn't remember his birth parents, or when he met his ghost parents, but he isn't really bothered about it. All he knows, is that he loves his ghost parents and wants to make as many friends as he can!	\N	?edit2=2_ABaOnuf86ZAxBbQfeKlKe40wSsMNOKbAg8yb9OIS7GsZ1Qs8dtVRX13RLf4uJnuRawMf5io	Active	\N	\N	He was abandoned as a baby | He wishes he could fly faster | He was rescued by a ghostly couple | He doesn't scare easy | He's just a dumb kid	\N	Has a spooky set of parents that will ruin your day	\N
4	215240568245190656	Ozi	Gengar	Ghost/Poison	???	90 lbs	5'0"	Male	Straight	Married	Shadow Ball | Sludge Bomb | Psychic | Dazzling Gleam	Jokes and Spooks	Kill joys and Arrogance	Theres never a dull moment with Ozi! He likes to pull pranks and make people either laugh or scream. He loves his wife (Mizukyu) and son (Zumi) and will spook anyone who harms them to death. So long as you play nice, he's a great ghosty guy!	No one knows where Ozi came from, or why he came here, but he and his wife Mizukyu have caused a lot of mayhem in their many years together. He's been known to suddenly appear or disappear and even caused some unfortunate souls to go mad with insanity. Over time he's learned to dial back the spooks a bit, and even tried to make some new friends	Ozi sometimes causes trouble with his ghost powers, behaving a bit like the Cheshire Cat. He can be a bit slippery, but tries not to cause too much trouble	?edit2=2_ABaOnueS5nTN63soX4wQ0PVKa_tGFghbIpiYlW3kwGw4Cj09Fnio0qNLD47iyOC5H3f4oN4	Active	\N	\N	He taught Zumi how to fly | He's a surprisingly good father | Sometimes he doesn't know when to stop the jokes | His humor is not for everyone | I'm not totally convinced he's real	\N	Spooks ahead!	\N
5	215240568245190656	Neiro	Vaporeon	Water	\N	???	varies	Male	\N	\N	Duplicate | Pokemon | Attack	\N	\N	\N	\N	This is test entry	?edit2=2_ABaOnuc441lxr76HNkZnq7BJq0f_VFhK9OM8YMUGkIbQGKSU8apSzv6re4BevYVYi6QzmI8	Active	\N	\N	\N	\N	\N	\N
6	412163685440684052	Kipper	Mudkip	Water	26	20lbs	1'05''	Male	Gay	Single	Water Gun | Mud Slap | Protect | Surf	Water, Mud, His Teammates, Teasing Cecil	Injustice, not being able to evolve, getting picked on	Lazy bum who doesn't like to work, but can't ignore when someone is in need.	N/A	He's a surprisingly good chef, able to easily handle ingredients and mise en place despite being a tiny quadruped.	?edit2=2_ABaOnucXHjYrWRLF9ERHNJYBdtB1t25-lacSlSV1wrmrpgLUEK_swo7p-gtWWRXquXNBsyM	Active	\N	\N	He's easily distracted, like he gets lost in his thoughts a lot. | He's incredibly lazy and hates working. | He's quite the chef, his recipes sounds really good. | He's rather old for a stage 1 Pokémon. He probably can't evolve | I heard he's great to hang with when you're feeling really upset or depressed.	Zaplana	He's really sensitive about the fact that he can't evolve.  Tease him for that at your own risk.	\N
7	354840009829908480	Sarah	pyroar	Fire/Normal	20	179.7 lbs	4'11"	Female	pansexual	In a Relationship	strength | will-o-wisp | rest | dig	\N	\N	\N	\N	has 1 kit with yang the ninetails, intelligence gets lowered when she ingests a certain liquid	?edit2=2_ABaOnuf-HnF8bkanKrZ99PEPD_PWINX-c9HU_rQ_bg1oqFywrr9h_KbufnD98N9bFQ2Q2Fs	Active	\N	\N	\N	\N	\N	\N
8	473547751221886976	Avery	Sylbreon	Dark/Fairy	20	55 lbs	3'03"	M or F	Bi	Single	Moonblast | Dark Pulse | Venoshock | Misty Terrain	the cold, dry food, anything with running, swimming and water, love, berries, computers, DJ Thunder (AKA his idol), his friends, floof, hacking (usually ethical), and fashion despite being a feral.	heat, excessive food, bitter food, being teased, being told what to do, seeing people get hurt, his father, sadness, damaged electronics.	\N	\N	\N	?edit2=2_ABaOnufmQm1Ss0H-E8yfoZt636DRwCBgN2ZVrt-14dW2QyhHJxrnBEfj6Ie_s46TxqLuZNE	Active	\N	\N	\N	He lives at the Guild, but he's from the Woods.	\N	\N
9	473547751221886976	Avery	Sylbreon	Dark/Fairy	20	55 lbs	3'03"	M or F	Bisexual	Single	Moonblast | Dark Pulse | Venoshock | Misty Terrain	the cold, dry food, anything with running, swimming and water, love, berries, computers, DJ Thunder (AKA his idol), his friends, floof, hacking (usually ethical), and fashion despite being a feral.	heat, excessive food, bitter food, being teased, being told what to do, seeing people get hurt, his father, sadness, damaged electronics.	Avery… is a mixture of things, really. They were shy and nervous after leaving the solitude of their forest den, though nowadays they seem a lot more confident in themselves. Almost too confident… it’s a wonder they haven’t gotten themselves hurt. Avery is some degree of affectionate, and loves to cuddle and play, though he might be a bit… protective.\nThey are willing to do anything to protect those they call a friend, whether that be through battle or through other means. Generally battle, of course; Avery fancies themselves a superior combatant, and tends to give an (adorable) threatening glare to anyone that claims otherwise.	Avery was born in a small family of Eevees and Evoloxxes deep in the woods near the Village. They… was always fond of the moon, and trained throughout their kithood to become an Umbreon. They somewhat got their wish, and matured into a Sylbreon. They were born with the apparent ability to switch between sexes at will, which was the source of quite a lot of teasing from their siblings - this only served to push Avery to trying to become as strong as possible.\nOf course, his ability led to his father abandoning the family shortly after birth, though all Avery remembers of that day was that his mother had a notable scar on her cheek from that day onward.\nEventually, Avery left the forest and found the village, where he learned about DJ Thunder and was soon stuck in the library, trying to learn how to program and operate a computer - he was inspired by the Jolteon, and ended up as the cybersecurity expert in the Guild.	His ability is LUNAR CIRCLE which brings temporary and localized nightfall to the battlefield. All poison, dark, and ghost damage receives a 10% boost and gravity is reduced. (The reduction of gravity undos moves such as Smack Down and grants a 10% speed boost to flying-types upon entering the battle.) The Sylbreon is healed by 5% (rounding up) each turn.\n\nOther than that, the story about his father can be found @ https://docs.google.com/document/d/1fzAvUcG9KsygBJTbdu-aHRoKNV8AObmEE59kjiZT8gg/edit?usp=sharing\n\nHis character document in it's entirety can be found @ https://docs.google.com/document/d/1rNgJxp_6FDfz0GkX1qQWxBDSPsa3ZQiCF0D7d-fdMtQ/edit?usp=sharing	\N	Active	\N	\N	"Who cares? I heard he looks up to a thief!" | - "Could just be he doesn't like bigger figures. Anyway, doesn't he have a unique ability?" | - "Oh, yeah... I bet he's conspiring to rob the local marketplace right now." | - "Huh? Well, I dunno. Maybe that's why he never goes to Obe..." | - "D'ya think he's related to that Umbreon that came out of the woods a little over a decade ago?"	He lives at the Guild, but he's from the Woods.	\N	\N
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
\.


--
-- Name: carousels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.carousels_id_seq', 47, true);


--
-- Name: char_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.char_images_id_seq', 26, true);


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.characters_id_seq', 9, true);


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

