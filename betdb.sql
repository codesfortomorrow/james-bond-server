--
-- PostgreSQL database dump
--

-- Dumped from database version 14.12 (Debian 14.12-1.pgdg120+1)
-- Dumped by pg_dump version 14.12 (Debian 14.12-1.pgdg120+1)

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

ALTER TABLE ONLY public.casino_bets DROP CONSTRAINT casino_bets_pkey;
ALTER TABLE ONLY public.bets DROP CONSTRAINT bets_pkey;
ALTER TABLE public.casino_bets ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.bets ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.casino_bets_id_seq;
DROP TABLE public.casino_bets;
DROP SEQUENCE public.bets_id_seq;
DROP TABLE public.bets;
DROP EXTENSION ltree;
--
-- Name: ltree; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;


--
-- Name: EXTENSION ltree; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION ltree IS 'data type for hierarchical tree-like structures';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bets (
    id integer NOT NULL,
    user_id integer NOT NULL,
    bet_on character varying NOT NULL,
    price numeric(16,2) NOT NULL,
    stake numeric(16,2) NOT NULL,
    event_type character varying NOT NULL,
    competition character varying NOT NULL,
    event character varying NOT NULL,
    market character varying NOT NULL,
    status smallint DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    calc_fact smallint DEFAULT 0 NOT NULL,
    percent numeric(16,2) DEFAULT 100.0 NOT NULL,
    game_id integer NOT NULL,
    event_id integer NOT NULL,
    market_id numeric NOT NULL,
    selection_id integer NOT NULL,
    selection character varying NOT NULL,
    game_type character varying NOT NULL,
    path public.ltree NOT NULL,
    username character varying NOT NULL
);


ALTER TABLE public.bets OWNER TO postgres;

--
-- Name: bets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bets_id_seq OWNER TO postgres;

--
-- Name: bets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bets_id_seq OWNED BY public.bets.id;


--
-- Name: casino_bets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.casino_bets (
    id integer NOT NULL,
    user_id integer NOT NULL,
    casino character varying NOT NULL,
    nation character varying NOT NULL,
    market_id numeric NOT NULL,
    selection_id integer NOT NULL,
    rate numeric(16,2) NOT NULL,
    stake numeric(16,2) NOT NULL,
    game_type character varying NOT NULL,
    status smallint DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    bet_on character varying NOT NULL
);


ALTER TABLE public.casino_bets OWNER TO postgres;

--
-- Name: casino_bets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.casino_bets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.casino_bets_id_seq OWNER TO postgres;

--
-- Name: casino_bets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.casino_bets_id_seq OWNED BY public.casino_bets.id;


--
-- Name: bets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bets ALTER COLUMN id SET DEFAULT nextval('public.bets_id_seq'::regclass);


--
-- Name: casino_bets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.casino_bets ALTER COLUMN id SET DEFAULT nextval('public.casino_bets_id_seq'::regclass);


--
-- Data for Name: bets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bets (id, user_id, bet_on, price, stake, event_type, competition, event, market, status, created_at, updated_at, calc_fact, percent, game_id, event_id, market_id, selection_id, selection, game_type, path, username) FROM stdin;
4664	576	BACK	1.95	100.00	Cricket	N/A	Middlesex v Kent	fancy	0	2024-05-31 10:51:03.881907+00	2024-05-31 10:51:03.881907+00	0	500000.00	4	33307534	1.229415499	2501	MID Will Win the Toss(MID vs KEN)adv	fancy	0.576	DemoUser
4665	576	LAY	52.00	100.00	Cricket	N/A	Middlesex v Kent	session	0	2024-05-31 10:52:13.389761+00	2024-05-31 10:52:13.389761+00	1	100.00	4	33307534	1.229415499	1	6 over runs MID(MID vs KEN)adv	session	0.576	DemoUser
4666	576	LAY	52.00	100.00	Cricket	N/A	Middlesex v Kent	session	0	2024-05-31 10:52:55.977372+00	2024-05-31 10:52:55.977372+00	1	100.00	4	33307534	1.229415499	1	6 over runs MID(MID vs KEN)adv	session	0.576	DemoUser
4667	576	BACK	54.00	100.00	Cricket	N/A	Middlesex v Kent	session	0	2024-05-31 10:53:12.973145+00	2024-05-31 10:53:12.973145+00	1	100.00	4	33307534	1.229415499	1	6 over runs MID(MID vs KEN)adv	session	0.576	DemoUser
4669	576	LAY	6.00	100.00	Cricket	N/A	Middlesex v Kent	session	0	2024-05-31 11:00:31.561235+00	2024-05-31 11:00:31.561235+00	1	100.00	4	33307534	1.229415499	7	Match 1st over run(MID vs KEN)adv	session	0.576	DemoUser
4671	603	BACK	1.87	100.00	Tennis	N/A	Katarina Zavatska v Kateryna Baindl	MATCH_ODDS	0	2024-05-31 11:01:20.367921+00	2024-05-31 11:01:20.367921+00	0	100.00	2	33315718	1.229511444	42315957	Kateryna Baindl	match	0.575.587.603	user44
4672	602	LAY	2.62	100.00	Tennis	N/A	Barrientos/Cabral v Andreozzi/Hijikata	MATCH_ODDS	0	2024-05-31 11:05:27.331565+00	2024-05-31 11:05:27.331565+00	0	100.00	2	33309204	1.229439961	55104472	Barrientos/Cabral	match	0.575.587.602	user43
4679	593	LAY	2.14	100.00	Tennis	N/A	Katarina Zavatska v Kateryna Baindl	MATCH_ODDS	0	2024-05-31 11:44:45.777714+00	2024-05-31 11:44:45.777714+00	0	100.00	2	33315718	1.229511444	9635149	Katarina Zavatska	match	0.575.584.593	user22
4680	594	BACK	1.96	100.00	Cricket	N/A	Western Storm v Sunrisers	Match Odds	0	2024-05-31 11:46:09.632507+00	2024-05-31 11:46:09.632507+00	0	100.00	4	33313112	1.229482859	11445383	Western Storm	Match Odds	0.575.584.594	user23
4681	594	BACK	4.00	100.00	Cricket	N/A	Nottinghamshire 'vs' Northamptonshire	session	0	2024-05-31 11:46:41.011246+00	2024-05-31 11:46:41.011246+00	1	100.00	4	33314977	1.229505138	55	Most Wickets By a Bowler(NOT vs NOR)adv	session	0.575.584.594	user23
4683	595	BACK	1.31	100.00	Cricket	N/A	Scotland v Afghanistan	Match Odds	0	2024-05-31 11:48:12.594026+00	2024-05-31 11:48:12.594026+00	0	100.00	4	33310335	1.229451877	3786094	Afghanistan	Match Odds	0.575.584.595	user24
4687	578	BACK	1.96	200.00	Cricket	N/A	Western Storm v Sunrisers	Match Odds	0	2024-05-31 11:51:23.606334+00	2024-05-31 11:51:23.606334+00	0	100.00	4	33313112	1.229482859	11445383	Western Storm	Match Odds	0.575.578	user1
4678	593	LAY	1.14	100.00	Soccer	N/A	Daejeon Korail FC v Ulsan Citizen FC	MATCH_ODDS	1	2024-05-31 11:44:18.440852+00	2024-05-31 11:44:18.440852+00	0	100.00	1	33313837	1.229492441	23921184	Daejeon Korail FC	match	0.575.584.593	user22
4662	576	BACK	10.00	100.00	Soccer	N/A	Tosu v FC Tokyo	MATCH_ODDS	10	2024-05-31 10:48:39.62989+00	2024-05-31 10:48:39.62989+00	0	100.00	1	33305321	1.229377476	3455676	Tosu	match	0.576	DemoUser
4684	595	BACK	1.23	100.00	Soccer	N/A	Tosu v FC Tokyo	MATCH_ODDS	1	2024-05-31 11:48:37.162136+00	2024-05-31 11:48:37.162136+00	0	100.00	1	33305321	1.229377476	350849	FC Tokyo	match	0.575.584.595	user24
4663	576	LAY	5.30	100.00	Soccer	N/A	Tosu v FC Tokyo	MATCH_ODDS	1	2024-05-31 10:48:46.695102+00	2024-05-31 10:48:46.695102+00	0	100.00	1	33305321	1.229377476	58805	The Draw	match	0.576	DemoUser
4689	578	BACK	3.20	100.00	Tennis	N/A	Linette/Pera v Moratelli/Rosatello	MATCH_ODDS	10	2024-05-31 11:52:00.317341+00	2024-05-31 11:52:00.317341+00	0	100.00	2	33311211	1.229459876	55754643	Moratelli/Rosatello	match	0.575.578	user1
4676	592	BACK	2.80	100.00	Tennis	N/A	Goransson/Pel v Purcell/Thompson	MATCH_ODDS	10	2024-05-31 11:31:32.620428+00	2024-05-31 11:31:32.620428+00	0	100.00	2	33316789	1.229525930	38234364	Goransson/Pel	match	0.575.584.592	user21
4660	576	BACK	1.22	100.00	Tennis	N/A	Matos/Melo v Frantzen/Jebens	MATCH_ODDS	1	2024-05-31 10:45:19.466629+00	2024-05-31 10:45:19.466629+00	0	100.00	2	33308434	1.229431670	61289544	Matos/Melo	match	0.576	DemoUser
4661	576	LAY	1.27	100.00	Tennis	N/A	Matos/Melo v Frantzen/Jebens	MATCH_ODDS	10	2024-05-31 10:46:51.507854+00	2024-05-31 10:46:51.507854+00	0	100.00	2	33308434	1.229431670	61289544	Matos/Melo	match	0.576	DemoUser
4686	595	LAY	1.50	100.00	Tennis	N/A	Matos/Melo v Frantzen/Jebens	MATCH_ODDS	10	2024-05-31 11:49:41.888594+00	2024-05-31 11:49:41.888594+00	0	100.00	2	33308434	1.229431670	61289544	Matos/Melo	match	0.575.584.595	user24
4691	576	BACK	1.95	100.00	Cricket	N/A	Middlesex v Kent	fancy	0	2024-05-31 12:49:57.797871+00	2024-05-31 12:49:57.797871+00	0	500000.00	4	33307534	1.229415499	2501	MID Will Win the Toss(MID vs KEN)adv	fancy	0.576	DemoUser
4692	576	BACK	1.95	100.00	Cricket	N/A	Middlesex v Kent	fancy	0	2024-05-31 12:50:20.834052+00	2024-05-31 12:50:20.834052+00	0	500000.00	4	33307534	1.229415499	2502	KEN Will Win the Toss(MID vs KEN)adv	fancy	0.576	DemoUser
4693	576	LAY	52.00	100.00	Cricket	N/A	Middlesex v Kent	session	0	2024-05-31 12:50:35.061431+00	2024-05-31 12:50:35.061431+00	1	100.00	4	33307534	1.229415499	1	6 over runs MID(MID vs KEN)adv	session	0.576	DemoUser
4694	576	BACK	25.00	100.00	Cricket	N/A	Middlesex v Kent	session	0	2024-05-31 12:50:50.40737+00	2024-05-31 12:50:50.40737+00	1	90.00	4	33307534	1.229415499	21	D Bell-Drummond run(MID vs KEN)adv	session	0.576	DemoUser
4682	594	LAY	3.60	100.00	Soccer	N/A	Binh Duong v Ho Chi Minh City	MATCH_ODDS	1	2024-05-31 11:47:04.083291+00	2024-05-31 11:47:04.083291+00	0	100.00	1	33313856	1.229488854	58805	The Draw	match	0.575.584.594	user23
4675	592	BACK	3.65	100.00	Soccer	N/A	Roma v AC Milan	MATCH_ODDS	10	2024-05-31 11:30:06.674748+00	2024-05-31 11:30:06.674748+00	0	100.00	1	33312326	1.229501971	58805	The Draw	match	0.575.584.592	user21
4688	578	LAY	2.56	100.00	Soccer	N/A	Roma v AC Milan	MATCH_ODDS	1	2024-05-31 11:51:42.973774+00	2024-05-31 11:51:42.973774+00	0	100.00	1	33312326	1.229501971	127991	AC Milan	match	0.575.578	user1
4685	595	LAY	1.01	100.00	Tennis	N/A	Murkel Dellien v Stefano Travaglia	MATCH_ODDS	10	2024-05-31 11:49:23.435759+00	2024-05-31 11:49:23.435759+00	0	100.00	2	33313077	1.229481964	36157019	Murkel Dellien	match	0.575.584.595	user24
4696	576	BACK	3.30	100.00	Soccer	N/A	Norway (W) v Italy (W)	MATCH_ODDS	10	2024-05-31 12:52:27.275784+00	2024-05-31 12:52:27.275784+00	0	100.00	1	33310083	1.229449700	984619	Italy (W)	match	0.576	DemoUser
4674	592	BACK	1.72	100.00	Cricket	N/A	Durham v Warwickshire	Match Odds	1	2024-05-31 11:29:48.973753+00	2024-05-31 11:29:48.973753+00	0	100.00	4	33315095	1.229506187	2120	Warwickshire	Match Odds	0.575.584.592	user21
4690	576	BACK	2.26	100.00	Cricket	N/A	Middlesex v Kent	Match Odds	10	2024-05-31 12:49:47.636024+00	2024-05-31 12:49:47.636024+00	0	100.00	4	33307534	1.229415499	31378	Middlesex	Match Odds	0.576	DemoUser
4677	593	BACK	2.28	100.00	Cricket	N/A	Middlesex v Kent	Match Odds	10	2024-05-31 11:42:32.347033+00	2024-05-31 11:42:32.347033+00	0	100.00	4	33307534	1.229415499	31378	Middlesex	Match Odds	0.575.584.593	user22
4668	603	LAY	2.32	100.00	Cricket	N/A	Middlesex v Kent	Match Odds	1	2024-05-31 11:00:08.056796+00	2024-05-31 11:00:08.056796+00	0	100.00	4	33307534	1.229415499	31378	Middlesex	Match Odds	0.575.587.603	user44
4673	602	LAY	1.80	100.00	Cricket	N/A	Middlesex v Kent	Match Odds	10	2024-05-31 11:13:51.666274+00	2024-05-31 11:13:51.666274+00	0	100.00	4	33307534	1.229415499	5901	Kent	Match Odds	0.575.587.602	user43
4670	603	BACK	1.42	100.00	Soccer	N/A	Bolivia v Mexico	MATCH_ODDS	1	2024-05-31 11:00:51.234644+00	2024-05-31 11:00:51.234644+00	0	100.00	1	33314731	1.229502079	37944	Mexico	match	0.575.587.603	user44
4695	576	BACK	150.00	100.00	Soccer	N/A	Binh Duong v Ho Chi Minh City	MATCH_ODDS	10	2024-05-31 12:51:48.799113+00	2024-05-31 12:51:48.799113+00	0	100.00	1	33313856	1.229488854	2909643	Binh Duong	match	0.576	DemoUser
4698	592	BACK	3.70	1000.00	Tennis	N/A	Chun Hsin Tseng v Juan Carlos Prado Angelo	MATCH_ODDS	0	2024-05-31 13:19:00.706162+00	2024-05-31 13:19:00.706162+00	0	100.00	2	33313838	1.229494061	42465203	Juan Carlos Prado Angelo	match	0.575.584.592	user21
4703	595	BACK	2.38	500.00	Cricket	N/A	Nottinghamshire v Northamptonshire	Match Odds	0	2024-05-31 13:35:25.202538+00	2024-05-31 13:35:25.202538+00	0	100.00	4	33314977	1.229505138	475559	Northamptonshire	Match Odds	0.575.584.595	user24
4705	578	BACK	2.24	500.00	Cricket	N/A	The Blaze v Central Sparks	Match Odds	0	2024-05-31 13:37:15.537687+00	2024-05-31 13:37:15.537687+00	0	100.00	4	33313110	1.229482866	35736915	Central Sparks	Match Odds	0.575.578	user1
4708	580	BACK	1.65	500.00	Cricket	N/A	Western Storm v Sunrisers	Match Odds	0	2024-05-31 13:40:42.900888+00	2024-05-31 13:40:42.900888+00	0	100.00	4	33313112	1.229482859	11445383	Western Storm	Match Odds	0.575.580	user3
4711	581	BACK	3.15	200.00	Tennis	N/A	Doumbia/Reboul v Added/Arribage	MATCH_ODDS	1	2024-05-31 13:42:42.345076+00	2024-05-31 13:42:42.345076+00	0	100.00	2	33309203	1.229440019	49410419	Added/Arribage	match	0.575.581	user4
4697	595	BACK	2.22	1000.00	Soccer	N/A	Armenia (W) v Kazakhstan (W)	MATCH_ODDS	1	2024-05-31 13:15:43.962811+00	2024-05-31 13:15:43.962811+00	0	100.00	1	33314655	1.229501226	5373301	Armenia (W)	match	0.575.584.595	user24
4704	578	BACK	5.00	500.00	Soccer	N/A	Armenia (W) v Kazakhstan (W)	MATCH_ODDS	10	2024-05-31 13:36:59.026652+00	2024-05-31 13:36:59.026652+00	0	100.00	1	33314655	1.229501226	5905764	Kazakhstan (W)	match	0.575.578	user1
4706	579	BACK	4.40	200.00	Soccer	N/A	Armenia (W) v Kazakhstan (W)	MATCH_ODDS	10	2024-05-31 13:39:10.097014+00	2024-05-31 13:39:10.097014+00	0	100.00	1	33314655	1.229501226	5905764	Kazakhstan (W)	match	0.575.579	user2
4699	593	BACK	3.75	500.00	Soccer	N/A	Armenia (W) v Kazakhstan (W)	MATCH_ODDS	10	2024-05-31 13:23:47.145175+00	2024-05-31 13:23:47.145175+00	0	100.00	1	33314655	1.229501226	5905764	Kazakhstan (W)	match	0.575.584.593	user22
4707	579	LAY	1.80	200.00	Tennis	N/A	Peers/Safiullin v Bhambri/Olivetti	MATCH_ODDS	10	2024-05-31 13:39:33.645219+00	2024-05-31 13:39:33.645219+00	0	100.00	2	33308435	1.229431685	60702661	Peers/Safiullin	match	0.575.579	user2
4709	580	BACK	2.46	200.00	Tennis	N/A	Cornea/Darderi v Nys/Zielinski	MATCH_ODDS	10	2024-05-31 13:41:15.778055+00	2024-05-31 13:41:15.778055+00	0	100.00	2	33309200	1.229439923	69865644	Cornea/Darderi	match	0.575.580	user3
4700	593	LAY	3.60	1000.00	Tennis	N/A	Cornea/Darderi v Nys/Zielinski	MATCH_ODDS	1	2024-05-31 13:24:07.032696+00	2024-05-31 13:24:07.032696+00	0	100.00	2	33309200	1.229439923	69865644	Cornea/Darderi	match	0.575.584.593	user22
4702	594	LAY	2.74	1000.00	Tennis	N/A	Anastasia Potapova v Xinyu Wang	MATCH_ODDS	10	2024-05-31 13:34:19.710353+00	2024-05-31 13:34:19.710353+00	0	100.00	2	33315404	1.229507866	10554735	Anastasia Potapova	match	0.575.584.594	user23
4701	594	BACK	4.80	500.00	Soccer	N/A	FK Dainava Alytus v Hegelmann Litauen	MATCH_ODDS	10	2024-05-31 13:33:48.764288+00	2024-05-31 13:33:48.764288+00	0	100.00	1	33310609	1.229454796	11306796	FK Dainava Alytus	match	0.575.584.594	user23
4710	581	BACK	2.32	500.00	Cricket	N/A	Durham v Warwickshire	Match Odds	10	2024-05-31 13:42:02.126746+00	2024-05-31 13:42:02.126746+00	0	100.00	4	33315095	1.229506187	31374	Durham	Match Odds	0.575.581	user4
\.


--
-- Data for Name: casino_bets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.casino_bets (id, user_id, casino, nation, market_id, selection_id, rate, stake, game_type, status, created_at, updated_at, bet_on) FROM stdin;
\.


--
-- Name: bets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bets_id_seq', 4711, true);


--
-- Name: casino_bets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.casino_bets_id_seq', 1, true);


--
-- Name: bets bets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bets
    ADD CONSTRAINT bets_pkey PRIMARY KEY (id);


--
-- Name: casino_bets casino_bets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.casino_bets
    ADD CONSTRAINT casino_bets_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

