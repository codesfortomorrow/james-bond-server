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
4672	602	LAY	2.62	100.00	Tennis	N/A	Barrientos/Cabral v Andreozzi/Hijikata	MATCH_ODDS	0	2024-05-31 11:05:27.331565+00	2024-05-31 11:05:27.331565+00	0	100.00	2	33309204	1.229439961	55104472	Barrientos/Cabral	match	0.575.587.602	user43
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
4671	603	BACK	1.87	100.00	Tennis	N/A	Katarina Zavatska v Kateryna Baindl	MATCH_ODDS	10	2024-05-31 11:01:20.367921+00	2024-05-31 11:01:20.367921+00	0	100.00	2	33315718	1.229511444	42315957	Kateryna Baindl	match	0.575.587.603	user44
4679	593	LAY	2.14	100.00	Tennis	N/A	Katarina Zavatska v Kateryna Baindl	MATCH_ODDS	10	2024-05-31 11:44:45.777714+00	2024-05-31 11:44:45.777714+00	0	100.00	2	33315718	1.229511444	9635149	Katarina Zavatska	match	0.575.584.593	user22
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
4712	593	BACK	1.04	500.00	Soccer	N/A	Shonan v G-Osaka	MATCH_ODDS	1	2024-06-01 07:38:44.383803+00	2024-06-01 07:38:44.383803+00	0	100.00	1	33305330	1.229377234	441083	G-Osaka	match	0.575.584.593	user22
4715	593	BACK	1.61	500.00	Tennis	N/A	Polina Kudermetova v Ella Seidel	MATCH_ODDS	1	2024-06-01 07:41:55.567536+00	2024-06-01 07:41:55.567536+00	0	100.00	2	33315662	1.229511485	20136621	Polina Kudermetova	match	0.575.584.593	user22
4727	600	BACK	4.00	100.00	Soccer	N/A	Hainan Star v Quanzhou Yaxin	MATCH_ODDS	10	2024-06-01 11:08:00.007249+00	2024-06-01 11:08:00.007249+00	0	100.00	1	33316370	1.229519153	46993484	Hainan Star	match	0.575.587.600	user41
4720	591	BACK	4.40	200.00	Soccer	N/A	Odra Bytom Odrzanski v Unia Turza Slaska	MATCH_ODDS	10	2024-06-01 10:53:42.607029+00	2024-06-01 10:53:42.607029+00	0	100.00	1	33319064	1.229558220	10074435	Unia Turza Slaska	match	0.575.582.591	user14
4717	576	BACK	2.82	100.00	Soccer	N/A	Suwon FC v Incheon Utd	MATCH_ODDS	1	2024-06-01 10:27:00.101524+00	2024-06-01 10:27:00.101524+00	0	100.00	1	33310502	1.229453825	7394845	Suwon FC	match	0.576	DemoUser
4718	588	BACK	4.30	200.00	Soccer	N/A	Ansan Greeners FC v Seongnam FC	MATCH_ODDS	10	2024-06-01 10:50:25.490705+00	2024-06-01 10:50:25.490705+00	0	100.00	1	33307732	1.229419405	12765833	Ansan Greeners FC	match	0.575.582.588	user11
4724	597	BACK	2.78	100.00	Soccer	N/A	Ansan Greeners FC v Seongnam FC	MATCH_ODDS	1	2024-06-01 11:00:59.995629+00	2024-06-01 11:00:59.995629+00	0	100.00	1	33307732	1.229419405	12479164	Seongnam FC	match	0.575.586.597	user32
4714	593	BACK	1.74	500.00	Tennis	N/A	Katarina Zavatska v Kateryna Baindl	MATCH_ODDS	10	2024-06-01 07:41:32.966105+00	2024-06-01 07:41:32.966105+00	0	100.00	2	33315718	1.229511444	42315957	Kateryna Baindl	match	0.575.584.593	user22
4713	593	BACK	2.04	500.00	Tennis	N/A	Katarina Zavatska v Kateryna Baindl	MATCH_ODDS	1	2024-06-01 07:41:10.869624+00	2024-06-01 07:41:10.869624+00	0	100.00	2	33315718	1.229511444	9635149	Katarina Zavatska	match	0.575.584.593	user22
4725	598	LAY	3.90	100.00	Tennis	N/A	Ben Shelton v Felix Auger-Aliassime	MATCH_ODDS	1	2024-06-01 11:05:07.03268+00	2024-06-01 11:05:07.03268+00	0	100.00	2	33315744	1.229511675	39460566	Ben Shelton	match	0.575.586.598	user33
4723	597	LAY	1.40	200.00	Soccer	N/A	Orkla v Lillestrom SK 2	MATCH_ODDS	10	2024-06-01 11:00:13.959139+00	2024-06-01 11:00:13.959139+00	0	100.00	1	33319214	1.229560404	2440427	Orkla	match	0.575.586.597	user32
4719	590	LAY	2.30	100.00	Tennis	N/A	Alex De Minaur v Jan-Lennard Struff	MATCH_ODDS	10	2024-06-01 10:52:49.432466+00	2024-06-01 10:52:49.432466+00	0	100.00	2	33315929	1.229513536	10109527	Alex De Minaur	match	0.575.582.590	user13
4728	601	BACK	3.15	200.00	Tennis	N/A	Alex De Minaur v Jan-Lennard Struff	MATCH_ODDS	1	2024-06-01 11:08:51.475989+00	2024-06-01 11:08:51.475989+00	0	100.00	2	33315929	1.229513536	10109527	Alex De Minaur	match	0.575.587.601	user42
4722	596	BACK	2.12	200.00	Tennis	N/A	Brandon Holt v Abdullah Shelbayh	MATCH_ODDS	10	2024-06-01 10:59:01.671273+00	2024-06-01 10:59:01.671273+00	0	100.00	2	33313793	1.229486310	10410230	Brandon Holt	match	0.575.586.596	user31
4721	591	BACK	1.78	200.00	Tennis	N/A	Sofia Costoulas v Cagla Buyukakcay	MATCH_ODDS	10	2024-06-01 10:53:57.792136+00	2024-06-01 10:53:57.792136+00	0	100.00	2	33315499	1.229511486	3051579	Cagla Buyukakcay	match	0.575.582.591	user14
4726	599	BACK	2.42	200.00	Tennis	N/A	Fernandez/Routliffe v Guo/Jiang	MATCH_ODDS	10	2024-06-01 11:05:57.282446+00	2024-06-01 11:05:57.282446+00	0	100.00	2	33311768	1.229464147	60662082	Guo/Jiang	match	0.575.586.599	user34
4729	604	BACK	1.53	100.00	Tennis	N/A	Fernandez/Routliffe v Guo/Jiang	MATCH_ODDS	1	2024-06-01 11:09:38.1008+00	2024-06-01 11:09:38.1008+00	0	100.00	2	33311768	1.229464147	40748997	Fernandez/Routliffe	match	0.575.587.604	user45
4716	595	BACK	1.77	1000.00	Cricket	N/A	Hampshire v Kent	Match Odds	1	2024-06-01 08:47:46.201595+00	2024-06-01 08:47:46.201595+00	0	100.00	4	33316882	1.229527267	3961	Hampshire	Match Odds	0.575.584.595	user24
4730	589	BACK	2.02	200.00	Cricket	N/A	Derbyshire v Leicestershire	Match Odds	1	2024-06-01 13:12:20.687503+00	2024-06-01 13:12:20.687503+00	0	100.00	4	33316877	1.229527252	31375	Derbyshire	Match Odds	0.575.582.589	user12
4731	589	BACK	1.06	500.00	Soccer	N/A	Albania v Liechtenstein	MATCH_ODDS	1	2024-06-03 08:26:36.227902+00	2024-06-03 08:26:36.227902+00	0	100.00	1	33316838	1.229526684	15285	Albania	match	0.575.582.589	user12
4732	589	LAY	1.47	500.00	Soccer	N/A	Germany v Ukraine	MATCH_ODDS	1	2024-06-03 08:42:50.197853+00	2024-06-03 08:42:50.197853+00	0	100.00	1	33307294	1.229408276	18	Germany	match	0.575.582.589	user12
4734	644	BACK	1.06	200.00	Tennis	N/A	Jelena Ostapenko v Elisabetta Cocciaretto	MATCH_ODDS	1	2024-06-17 14:19:43.671145+00	2024-06-17 14:19:43.671145+00	0	100.00	2	33351059	1.229917448	18848114	Elisabetta Cocciaretto	match	0.644	Test001
4738	644	BACK	1.98	100.00	Cricket	N/A	West Indies v Afghanistan	fancy	0	2024-06-17 14:33:35.85392+00	2024-06-17 14:33:35.85392+00	0	500000.00	4	33349185	1.229888986	2517	AFG Will Win the Toss(WI vs AFG)adv	fancy	0.644	Test001
4733	644	BACK	1000.00	100.00	Cricket	N/A	Netherlands Women v Hong Kong Women	Match Odds	10	2024-06-17 14:18:53.734623+00	2024-06-17 14:18:53.734623+00	0	100.00	4	33352938	1.229942562	60790163	Hong Kong Women	Match Odds	0.644	Test001
4737	644	BACK	1.89	100.00	Soccer	N/A	Belgium v Slovakia	Over/Under 2.5 Goals	10	2024-06-17 14:28:38.365744+00	2024-06-17 14:28:38.365744+00	0	100.00	1	32949292	1.223720216	47973	Over 2.5 Goals	Over/Under 2.5 Goals	0.644	Test001
4735	644	BACK	1.02	200.00	Cricket	N/A	New Zealand v Papua New Guinea	Match Odds	1	2024-06-17 14:20:05.502677+00	2024-06-17 14:20:05.502677+00	0	100.00	4	33350520	1.229910400	448	New Zealand	Match Odds	0.644	Test001
4736	644	BACK	2.96	200.00	Soccer	N/A	CA Fenix v Deportivo Merlo	MATCH_ODDS	10	2024-06-17 14:28:04.138897+00	2024-06-17 14:28:04.138897+00	0	100.00	1	33343674	1.229838820	58805	The Draw	match	0.644	Test001
4739	625	BACK	1.30	25000.00	Cricket	N/A	India Women v South Africa Women	Match Odds	1	2024-06-18 10:47:18.032172+00	2024-06-18 10:47:18.032172+00	0	100.00	4	33352266	1.229932191	2030174	India Women	Match Odds	0.625	Freeze999
4740	658	BACK	50.00	100.00	Tennis	N/A	Gauff/Pegula v Noskova/Siniakova	MATCH_ODDS	10	2024-06-20 13:55:18.110718+00	2024-06-20 13:55:18.110718+00	0	100.00	2	33351120	1.229918679	38604790	Gauff/Pegula	match	0.658	Test33
\.


--
-- Data for Name: casino_bets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.casino_bets (id, user_id, casino, nation, market_id, selection_id, rate, stake, game_type, status, created_at, updated_at, bet_on) FROM stdin;
\.


--
-- Name: bets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bets_id_seq', 4740, true);


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

