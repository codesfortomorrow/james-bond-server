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

ALTER TABLE ONLY public.userkyc DROP CONSTRAINT userkyc_userid_fkey;
ALTER TABLE ONLY public.password_history DROP CONSTRAINT password_history_userid_fkey;
ALTER TABLE ONLY public.withdrawaltransactions DROP CONSTRAINT withdrawaltransactions_pkey;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key5;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key4;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key3;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key2;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key1;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.userkyc DROP CONSTRAINT userkyc_pkey;
ALTER TABLE ONLY public.transactions DROP CONSTRAINT transactions_pkey;
ALTER TABLE ONLY public."settlement-transactions" DROP CONSTRAINT "settlement-transactions_pkey";
ALTER TABLE ONLY public.password_history DROP CONSTRAINT password_history_pkey;
ALTER TABLE ONLY public.otps DROP CONSTRAINT otps_pkey;
ALTER TABLE ONLY public.depositrequests DROP CONSTRAINT depositrequests_pkey;
ALTER TABLE ONLY public.casinotransactions DROP CONSTRAINT casinotransactions_pkey;
ALTER TABLE ONLY public.casino_games DROP CONSTRAINT casino_games_pkey;
ALTER TABLE ONLY public.adduserapis DROP CONSTRAINT adduserapis_pkey;
ALTER TABLE ONLY public.adduseraccounts DROP CONSTRAINT adduseraccounts_pkey;
ALTER TABLE ONLY public."adduserUpis" DROP CONSTRAINT "adduserUpis_pkey";
ALTER TABLE ONLY public."addBanners" DROP CONSTRAINT "addBanners_pkey";
ALTER TABLE ONLY public.activity_logs DROP CONSTRAINT activity_log_pkey;
ALTER TABLE ONLY public."QrCodes" DROP CONSTRAINT "QrCodes_upi_key";
ALTER TABLE ONLY public."QrCodes" DROP CONSTRAINT "QrCodes_pkey";
ALTER TABLE ONLY public."BankAccounts" DROP CONSTRAINT "BankAccounts_pkey";
ALTER TABLE public.withdrawaltransactions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.userkyc ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public."settlement-transactions" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.password_history ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.otps ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.depositrequests ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.casinotransactions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.adduserapis ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.adduseraccounts ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public."adduserUpis" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.activity_logs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public."BankAccounts" ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.withdrawaltransactions_id_seq;
DROP TABLE public.withdrawaltransactions;
DROP SEQUENCE public.users_id_seq;
DROP TABLE public.users;
DROP SEQUENCE public.userkyc_id_seq;
DROP TABLE public.userkyc;
DROP TABLE public.transactions;
DROP SEQUENCE public.transactions_id_seq;
DROP SEQUENCE public."settlement-transactions_id_seq";
DROP TABLE public."settlement-transactions";
DROP SEQUENCE public.password_history_id_seq;
DROP TABLE public.password_history;
DROP SEQUENCE public.otps_id_seq;
DROP TABLE public.otps;
DROP SEQUENCE public.depositrequests_id_seq;
DROP TABLE public.depositrequests;
DROP SEQUENCE public.casinotransactions_id_seq;
DROP TABLE public.casinotransactions;
DROP TABLE public.casino_games;
DROP SEQUENCE public.adduserapis_id_seq;
DROP TABLE public.adduserapis;
DROP SEQUENCE public.adduseraccounts_id_seq;
DROP TABLE public.adduseraccounts;
DROP SEQUENCE public."adduserUpis_id_seq";
DROP TABLE public."adduserUpis";
DROP TABLE public."addBanners";
DROP SEQUENCE public.activity_log_id_seq;
DROP TABLE public.activity_logs;
DROP TABLE public."QrCodes";
DROP SEQUENCE public."BankAccounts_id_seq";
DROP TABLE public."BankAccounts";
DROP TYPE public.enum_userkyc_isapproved;
DROP TYPE public.enum_userkyc_documentname;
DROP EXTENSION ltree;
--
-- Name: ltree; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;


--
-- Name: EXTENSION ltree; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION ltree IS 'data type for hierarchical tree-like structures';


--
-- Name: enum_userkyc_documentname; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_userkyc_documentname AS ENUM (
    'aadharCard',
    'panCard',
    'drivingLicense',
    'passport'
);


ALTER TYPE public.enum_userkyc_documentname OWNER TO postgres;

--
-- Name: enum_userkyc_isapproved; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_userkyc_isapproved AS ENUM (
    'aadharCard',
    'panCard',
    'drivingLicense',
    'passport'
);


ALTER TYPE public.enum_userkyc_isapproved OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: BankAccounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BankAccounts" (
    id integer NOT NULL,
    account_type character varying(255) NOT NULL,
    bank_name character varying(255) NOT NULL,
    account_number character varying(255) NOT NULL,
    ifsc_code character varying(255) NOT NULL,
    status boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    userid character varying,
    path character varying,
    acountholdername character varying
);


ALTER TABLE public."BankAccounts" OWNER TO postgres;

--
-- Name: BankAccounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."BankAccounts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."BankAccounts_id_seq" OWNER TO postgres;

--
-- Name: BankAccounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."BankAccounts_id_seq" OWNED BY public."BankAccounts".id;


--
-- Name: QrCodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."QrCodes" (
    id uuid NOT NULL,
    image character varying(255) NOT NULL,
    upi character varying(255) NOT NULL,
    status boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    userid character varying,
    path character varying
);


ALTER TABLE public."QrCodes" OWNER TO postgres;

--
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity_logs (
    id integer NOT NULL,
    user_id integer NOT NULL,
    activity character varying NOT NULL,
    ip character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.activity_logs OWNER TO postgres;

--
-- Name: activity_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.activity_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activity_log_id_seq OWNER TO postgres;

--
-- Name: activity_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.activity_log_id_seq OWNED BY public.activity_logs.id;


--
-- Name: addBanners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."addBanners" (
    id uuid NOT NULL,
    image character varying(255) NOT NULL,
    status boolean DEFAULT false NOT NULL,
    bannertype character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."addBanners" OWNER TO postgres;

--
-- Name: adduserUpis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."adduserUpis" (
    id integer NOT NULL,
    upi_id character varying(255) NOT NULL,
    upi_name character varying(255) NOT NULL,
    user_id integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."adduserUpis" OWNER TO postgres;

--
-- Name: adduserUpis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."adduserUpis_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."adduserUpis_id_seq" OWNER TO postgres;

--
-- Name: adduserUpis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."adduserUpis_id_seq" OWNED BY public."adduserUpis".id;


--
-- Name: adduseraccounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adduseraccounts (
    id integer NOT NULL,
    account_type character varying(255) NOT NULL,
    bank_name character varying(255) NOT NULL,
    account_number character varying(255) NOT NULL,
    ifsc_code character varying(255) NOT NULL,
    user_id integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    acountholdername character varying
);


ALTER TABLE public.adduseraccounts OWNER TO postgres;

--
-- Name: adduseraccounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adduseraccounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adduseraccounts_id_seq OWNER TO postgres;

--
-- Name: adduseraccounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adduseraccounts_id_seq OWNED BY public.adduseraccounts.id;


--
-- Name: adduserapis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adduserapis (
    id integer NOT NULL,
    upi_id character varying(255) NOT NULL,
    upi_name character varying(255) NOT NULL,
    user_id integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.adduserapis OWNER TO postgres;

--
-- Name: adduserapis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adduserapis_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adduserapis_id_seq OWNER TO postgres;

--
-- Name: adduserapis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adduserapis_id_seq OWNED BY public.adduserapis.id;


--
-- Name: casino_games; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.casino_games (
    title character varying(255),
    feature_group character varying(255),
    game_images text,
    has_freespins boolean,
    hd boolean,
    identifier character varying(255),
    identifier2 character varying(255),
    lines integer,
    multiplier integer,
    status boolean DEFAULT false,
    payout integer,
    producer character varying(255),
    provider character varying(255),
    restrictions text[],
    volatility_rating character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    id integer NOT NULL
);


ALTER TABLE public.casino_games OWNER TO postgres;

--
-- Name: casino_games_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.casino_games ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.casino_games_id_seq
    START WITH 7000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: casinotransactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.casinotransactions (
    id integer NOT NULL,
    game_id integer NOT NULL,
    user_id character varying(255) NOT NULL,
    game_code character varying(255),
    transaction_id character varying(255) NOT NULL,
    reference_id character varying(255) NOT NULL,
    provider_code character varying(255) NOT NULL,
    provider_transaction_id character varying(255) NOT NULL,
    amount numeric(16,2) NOT NULL,
    remark text NOT NULL,
    game_type character varying(255) NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    username character varying,
    path character varying
);


ALTER TABLE public.casinotransactions OWNER TO postgres;

--
-- Name: casinotransactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.casinotransactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.casinotransactions_id_seq OWNER TO postgres;

--
-- Name: casinotransactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.casinotransactions_id_seq OWNED BY public.casinotransactions.id;


--
-- Name: depositrequests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.depositrequests (
    id integer NOT NULL,
    "paymentMethod" character varying(255),
    utr character varying(255),
    img character varying(255),
    amount integer,
    "userId" integer,
    status character varying(255) DEFAULT 'pending'::character varying,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    username character varying(255),
    userpath character varying(255)
);


ALTER TABLE public.depositrequests OWNER TO postgres;

--
-- Name: depositrequests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.depositrequests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.depositrequests_id_seq OWNER TO postgres;

--
-- Name: depositrequests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.depositrequests_id_seq OWNED BY public.depositrequests.id;


--
-- Name: otps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otps (
    id integer NOT NULL,
    code character varying(255) NOT NULL,
    attempt integer DEFAULT 1 NOT NULL,
    lastsentat timestamp with time zone NOT NULL,
    retries integer DEFAULT 0 NOT NULL,
    target character varying(255) NOT NULL,
    lastcodeverified boolean DEFAULT false,
    blocked boolean DEFAULT false,
    createdat timestamp with time zone,
    updatedat timestamp with time zone
);


ALTER TABLE public.otps OWNER TO postgres;

--
-- Name: otps_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.otps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.otps_id_seq OWNER TO postgres;

--
-- Name: otps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.otps_id_seq OWNED BY public.otps.id;


--
-- Name: password_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_history (
    id integer NOT NULL,
    userid integer NOT NULL,
    remarks character varying(255),
    createdat timestamp with time zone,
    updatedat timestamp with time zone,
    path public.ltree
);


ALTER TABLE public.password_history OWNER TO postgres;

--
-- Name: password_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.password_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.password_history_id_seq OWNER TO postgres;

--
-- Name: password_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.password_history_id_seq OWNED BY public.password_history.id;


--
-- Name: settlement-transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."settlement-transactions" (
    id integer NOT NULL,
    "from" integer,
    "to" integer,
    amount numeric(16,2),
    receiver_balance numeric(16,2),
    betid integer,
    remark text,
    ap integer DEFAULT 0,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE public."settlement-transactions" OWNER TO postgres;

--
-- Name: settlement-transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."settlement-transactions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."settlement-transactions_id_seq" OWNER TO postgres;

--
-- Name: settlement-transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."settlement-transactions_id_seq" OWNED BY public."settlement-transactions".id;


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transactions_id_seq OWNER TO postgres;

--
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    id integer DEFAULT nextval('public.transactions_id_seq'::regclass) NOT NULL,
    "from" integer NOT NULL,
    "to" integer NOT NULL,
    amount numeric(16,2) NOT NULL,
    remark text NOT NULL,
    status smallint DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    sender_balance numeric(16,2) DEFAULT 0.0 NOT NULL,
    receiver_balance numeric(16,2) DEFAULT 0.0 NOT NULL,
    type character varying NOT NULL
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- Name: userkyc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userkyc (
    id integer NOT NULL,
    documentname public.enum_userkyc_documentname NOT NULL,
    documentdetail character varying(255) NOT NULL,
    frontimage character varying(255) NOT NULL,
    backimage character varying(255),
    userid integer NOT NULL,
    isapproved character varying(255) NOT NULL,
    createdat timestamp with time zone,
    updatedat timestamp with time zone,
    kycpercentage integer,
    reason text
);


ALTER TABLE public.userkyc OWNER TO postgres;

--
-- Name: userkyc_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.userkyc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.userkyc_id_seq OWNER TO postgres;

--
-- Name: userkyc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.userkyc_id_seq OWNED BY public.userkyc.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    fullname character varying(255),
    username character varying(255),
    password character varying(255) NOT NULL,
    dial_code character varying(255) DEFAULT ''::character varying,
    phone_number character varying(255) DEFAULT ''::character varying NOT NULL,
    city character varying(255),
    level smallint,
    path character varying(255),
    ap numeric(5,2) DEFAULT 100,
    parent_ap numeric(5,2) DEFAULT 0,
    balance numeric(16,2) DEFAULT 0,
    credit_amount numeric(16,2) DEFAULT 0,
    transaction_code character varying(40000),
    privileges json,
    user_type character varying(255) NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    remark text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    initial_setup boolean DEFAULT false NOT NULL,
    exposure_amount numeric(16,2) DEFAULT 0.0 NOT NULL,
    lock boolean DEFAULT false NOT NULL,
    bet_lock boolean DEFAULT false NOT NULL,
    "resetToken" character varying(255),
    is_deleted boolean DEFAULT false,
    email character varying,
    dob date,
    telegramid character varying(255),
    instagramid character varying(255),
    whatsappnumber character varying(255),
    "is-password-changed" boolean DEFAULT false,
    new_users_access boolean DEFAULT false
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: withdrawaltransactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.withdrawaltransactions (
    id integer NOT NULL,
    "userName" character varying(255) NOT NULL,
    "accountNo" character varying(255) NOT NULL,
    "ifscCode" character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    amount numeric(10,2) NOT NULL,
    status character varying(255) NOT NULL,
    userid integer NOT NULL,
    userpath character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    acountholdername character varying
);


ALTER TABLE public.withdrawaltransactions OWNER TO postgres;

--
-- Name: withdrawaltransactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.withdrawaltransactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.withdrawaltransactions_id_seq OWNER TO postgres;

--
-- Name: withdrawaltransactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.withdrawaltransactions_id_seq OWNED BY public.withdrawaltransactions.id;


--
-- Name: BankAccounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BankAccounts" ALTER COLUMN id SET DEFAULT nextval('public."BankAccounts_id_seq"'::regclass);


--
-- Name: activity_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs ALTER COLUMN id SET DEFAULT nextval('public.activity_log_id_seq'::regclass);


--
-- Name: adduserUpis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."adduserUpis" ALTER COLUMN id SET DEFAULT nextval('public."adduserUpis_id_seq"'::regclass);


--
-- Name: adduseraccounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adduseraccounts ALTER COLUMN id SET DEFAULT nextval('public.adduseraccounts_id_seq'::regclass);


--
-- Name: adduserapis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adduserapis ALTER COLUMN id SET DEFAULT nextval('public.adduserapis_id_seq'::regclass);


--
-- Name: casinotransactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.casinotransactions ALTER COLUMN id SET DEFAULT nextval('public.casinotransactions_id_seq'::regclass);


--
-- Name: depositrequests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depositrequests ALTER COLUMN id SET DEFAULT nextval('public.depositrequests_id_seq'::regclass);


--
-- Name: otps id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otps ALTER COLUMN id SET DEFAULT nextval('public.otps_id_seq'::regclass);


--
-- Name: password_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_history ALTER COLUMN id SET DEFAULT nextval('public.password_history_id_seq'::regclass);


--
-- Name: settlement-transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."settlement-transactions" ALTER COLUMN id SET DEFAULT nextval('public."settlement-transactions_id_seq"'::regclass);


--
-- Name: userkyc id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userkyc ALTER COLUMN id SET DEFAULT nextval('public.userkyc_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: withdrawaltransactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.withdrawaltransactions ALTER COLUMN id SET DEFAULT nextval('public.withdrawaltransactions_id_seq'::regclass);


--
-- Data for Name: BankAccounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."BankAccounts" (id, account_type, bank_name, account_number, ifsc_code, status, created_at, updated_at, userid, path, acountholdername) FROM stdin;
\.


--
-- Data for Name: QrCodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."QrCodes" (id, image, upi, status, created_at, updated_at, userid, path) FROM stdin;
a89b0620-5017-4d73-91c9-47afa412656c	https://staging-api.shiv11.com/api/user/43c238622977999a42e23d6802d2be5f.png	8503929598674@paytm	f	2024-04-23 12:51:12.446+00	2024-04-24 07:56:59.747+00	378	0.378
d3c1cedf-9ecf-40ed-843d-b81a1124daa1	https://staging-api.shiv11.com/api/user/19bf940adb61199dd9a7816b4dcaa0d1.png	rajeshsaini9598-1@okaxis	f	2024-04-28 09:08:21.747+00	2024-04-28 09:08:21.747+00	396	0.396
fe0d9fb8-5edd-4265-aedc-1eeb8d428341	https://staging-api.shiv11.com/api/user/339fca8e6186ce170f663e26f5de939e.png	1235462	f	2024-04-24 07:56:57.152+00	2024-05-21 07:59:27.6+00	367	0.365.367
5c7bb556-5528-4051-96f2-10343cc8ad7c	https://staging-api.shiv11.com/api/user/10ed60f04dbf72f4ac7bc343c6917610.jpeg	blacktiger5112@ybl	f	2024-05-26 16:46:45.746+00	2024-05-31 09:07:19.08+00	1	0
e2b0403c-c80c-4d75-8167-dd800a164ef7	https://staging-api.shiv11.com/api/user/13e9361c25e9386ab0766b0bd390e8da.jpeg	blacktigers@ybl	t	2024-05-26 13:18:59.414+00	2024-05-31 09:07:19.301+00	1	0
\.


--
-- Data for Name: activity_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activity_logs (id, user_id, activity, ip, created_at, updated_at) FROM stdin;
5278	1	Logged In	49.43.0.210	2024-05-31 08:50:34.704+00	2024-05-31 08:50:34.704+00
5279	1	Logged In	49.43.0.210	2024-05-31 09:02:38.572+00	2024-05-31 09:02:38.572+00
5280	575	Logged In	49.43.0.210	2024-05-31 09:16:44.8+00	2024-05-31 09:16:44.8+00
5281	575	Logged In	106.222.216.119	2024-05-31 09:20:04.248+00	2024-05-31 09:20:04.248+00
5282	575	Logged In	106.222.216.119	2024-05-31 09:20:04.277+00	2024-05-31 09:20:04.277+00
5283	575	Logged In	106.222.216.119	2024-05-31 09:20:04.28+00	2024-05-31 09:20:04.28+00
5284	576	Logged In	49.43.0.210	2024-05-31 09:20:50.762+00	2024-05-31 09:20:50.762+00
5285	575	Logged In	106.222.216.119	2024-05-31 09:29:12.06+00	2024-05-31 09:29:12.06+00
5286	575	Password changed	106.222.216.119	2024-05-31 09:29:52.815+00	2024-05-31 09:29:52.815+00
5287	575	Logged In	49.43.0.210	2024-05-31 09:30:10.434+00	2024-05-31 09:30:10.434+00
5288	575	Logged In	106.222.216.119	2024-05-31 09:30:12.696+00	2024-05-31 09:30:12.696+00
5289	1	Logged In	49.43.0.210	2024-05-31 09:30:16.034+00	2024-05-31 09:30:16.034+00
5290	575	Logged In	106.222.216.119	2024-05-31 09:47:20.261+00	2024-05-31 09:47:20.261+00
5291	577	Logged In	49.43.0.210	2024-05-31 09:51:33.164+00	2024-05-31 09:51:33.164+00
5292	577	Password changed	49.43.0.210	2024-05-31 09:51:53.264+00	2024-05-31 09:51:53.264+00
5293	577	Logged In	49.43.0.210	2024-05-31 09:52:03.842+00	2024-05-31 09:52:03.842+00
5294	1	Logged In	49.43.0.210	2024-05-31 09:53:40.005+00	2024-05-31 09:53:40.005+00
5295	582	Logged In	106.222.216.119	2024-05-31 09:58:33.043+00	2024-05-31 09:58:33.043+00
5296	582	Password changed	106.222.216.119	2024-05-31 09:59:16.499+00	2024-05-31 09:59:16.499+00
5297	582	Logged In	106.222.216.119	2024-05-31 09:59:49.027+00	2024-05-31 09:59:49.027+00
5298	1	Logged In	49.43.0.210	2024-05-31 10:01:10.178+00	2024-05-31 10:01:10.178+00
5299	584	Logged In	106.222.216.119	2024-05-31 10:05:04.525+00	2024-05-31 10:05:04.525+00
5300	584	Password changed	106.222.216.119	2024-05-31 10:18:17.26+00	2024-05-31 10:18:17.26+00
5301	584	Logged In	106.222.216.119	2024-05-31 10:18:32.379+00	2024-05-31 10:18:32.379+00
5302	586	Logged In	106.222.216.119	2024-05-31 10:22:24.534+00	2024-05-31 10:22:24.534+00
5303	586	Password changed	106.222.216.119	2024-05-31 10:22:59.943+00	2024-05-31 10:22:59.943+00
5304	586	Logged In	106.222.216.119	2024-05-31 10:23:18.752+00	2024-05-31 10:23:18.752+00
5305	587	Logged In	106.222.216.119	2024-05-31 10:30:26.787+00	2024-05-31 10:30:26.787+00
5306	587	Password changed	106.222.216.119	2024-05-31 10:31:07.187+00	2024-05-31 10:31:07.187+00
5307	587	Logged In	106.222.216.119	2024-05-31 10:31:25.644+00	2024-05-31 10:31:25.644+00
5308	604	Logged In	106.222.216.119	2024-05-31 10:48:54.009+00	2024-05-31 10:48:54.009+00
5309	604	Logged In	106.222.216.119	2024-05-31 10:51:30.215+00	2024-05-31 10:51:30.215+00
5310	582	Logged In	106.222.216.119	2024-05-31 10:57:11.828+00	2024-05-31 10:57:11.828+00
5311	588	Logged In	106.222.216.119	2024-05-31 10:57:57.004+00	2024-05-31 10:57:57.004+00
5312	603	Logged In	106.222.216.119	2024-05-31 10:58:33.747+00	2024-05-31 10:58:33.747+00
5313	576	Logged In	49.43.0.210	2024-05-31 11:00:52.842+00	2024-05-31 11:00:52.842+00
5314	602	Logged In	106.222.216.119	2024-05-31 11:02:16.129+00	2024-05-31 11:02:16.129+00
5315	603	Logged In	106.222.216.119	2024-05-31 11:15:50.677+00	2024-05-31 11:15:50.677+00
5316	603	Logged In	106.222.216.119	2024-05-31 11:15:59.393+00	2024-05-31 11:15:59.393+00
5317	603	Logged In	106.222.216.119	2024-05-31 11:16:05.549+00	2024-05-31 11:16:05.549+00
5318	602	Logged In	106.222.216.119	2024-05-31 11:16:12.031+00	2024-05-31 11:16:12.031+00
5319	602	Logged In	106.222.216.119	2024-05-31 11:16:13.729+00	2024-05-31 11:16:13.729+00
5320	602	Logged In	106.222.216.119	2024-05-31 11:16:16.209+00	2024-05-31 11:16:16.209+00
5321	602	Logged In	106.222.216.119	2024-05-31 11:17:11.372+00	2024-05-31 11:17:11.372+00
5322	1	Logged In	49.43.0.210	2024-05-31 11:18:37.207+00	2024-05-31 11:18:37.207+00
5323	592	Logged In	106.222.216.119	2024-05-31 11:25:34.797+00	2024-05-31 11:25:34.797+00
5324	584	Logged In	106.222.216.119	2024-05-31 11:31:50.709+00	2024-05-31 11:31:50.709+00
5325	593	Logged In	106.222.216.119	2024-05-31 11:38:49.585+00	2024-05-31 11:38:49.585+00
5326	594	Logged In	106.222.216.119	2024-05-31 11:45:17.993+00	2024-05-31 11:45:17.993+00
5327	595	Logged In	106.222.216.119	2024-05-31 11:47:43.903+00	2024-05-31 11:47:43.903+00
5328	578	Logged In	106.222.216.119	2024-05-31 11:50:57.855+00	2024-05-31 11:50:57.855+00
5329	1	Logged In	49.43.0.210	2024-05-31 12:06:39.867+00	2024-05-31 12:06:39.867+00
5330	1	Logged In	49.43.0.210	2024-05-31 12:06:44.769+00	2024-05-31 12:06:44.769+00
5331	1	Logged In	49.43.0.210	2024-05-31 12:07:17.589+00	2024-05-31 12:07:17.589+00
5332	576	Logged In	49.43.0.210	2024-05-31 12:13:01.812+00	2024-05-31 12:13:01.812+00
5333	578	Logged In	106.222.216.119	2024-05-31 12:26:22.518+00	2024-05-31 12:26:22.518+00
5334	582	Logged In	106.222.216.119	2024-05-31 12:26:57.073+00	2024-05-31 12:26:57.073+00
5335	575	Logged In	106.222.216.119	2024-05-31 12:28:20.059+00	2024-05-31 12:28:20.059+00
5336	575	Logged In	49.43.0.210	2024-05-31 12:41:28.172+00	2024-05-31 12:41:28.172+00
5337	1	Logged In	49.43.0.210	2024-05-31 12:45:28.259+00	2024-05-31 12:45:28.259+00
5338	595	Logged In	106.222.216.119	2024-05-31 12:48:32.618+00	2024-05-31 12:48:32.618+00
5339	584	Logged In	106.222.216.119	2024-05-31 13:00:55.337+00	2024-05-31 13:00:55.337+00
5340	1	Logged In	49.43.0.210	2024-05-31 13:10:47.532+00	2024-05-31 13:10:47.532+00
5341	592	Logged In	106.222.216.119	2024-05-31 13:17:21.95+00	2024-05-31 13:17:21.95+00
5342	593	Logged In	106.222.216.119	2024-05-31 13:21:51.325+00	2024-05-31 13:21:51.325+00
5343	594	Logged In	106.222.216.119	2024-05-31 13:33:11.44+00	2024-05-31 13:33:11.44+00
5344	595	Logged In	106.222.216.119	2024-05-31 13:34:52.162+00	2024-05-31 13:34:52.162+00
5345	578	Logged In	106.222.216.119	2024-05-31 13:36:38.062+00	2024-05-31 13:36:38.062+00
5346	579	Logged In	106.222.216.119	2024-05-31 13:37:43.705+00	2024-05-31 13:37:43.705+00
5347	580	Logged In	106.222.216.119	2024-05-31 13:40:07.127+00	2024-05-31 13:40:07.127+00
5348	581	Logged In	106.222.216.119	2024-05-31 13:41:44.475+00	2024-05-31 13:41:44.475+00
5349	1	Logged In	49.43.0.210	2024-06-01 04:39:48.495+00	2024-06-01 04:39:48.495+00
5350	1	Logged In	49.43.0.210	2024-06-01 04:51:45.234+00	2024-06-01 04:51:45.234+00
5351	575	Logged In	106.222.216.119	2024-06-01 04:53:42.731+00	2024-06-01 04:53:42.731+00
5352	589	Logged In	106.222.216.119	2024-06-01 05:00:13.57+00	2024-06-01 05:00:13.57+00
5353	576	Logged In	49.43.0.210	2024-06-01 05:05:43.614+00	2024-06-01 05:05:43.614+00
5354	592	Logged In	106.222.216.119	2024-06-01 05:27:35.86+00	2024-06-01 05:27:35.86+00
\.


--
-- Data for Name: addBanners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."addBanners" (id, image, status, bannertype, "createdAt", "updatedAt") FROM stdin;
ae777f1e-2bd8-49e6-b8b3-06cc885e8b86	https://staging-api.jamesbondcasinoroyale.com/\n/api/user/28c554ebdfbbac927647208e3fb6b630.jpeg	f	mobile	2024-05-31 14:20:32.235+00	2024-06-01 04:52:01.924+00
59705604-af2c-4b18-ae1b-8a255320b388	https://staging-api.jamesbondcasinoroyale.com/\n/api/user/2da3e73b4c0694e019920da4378c61e4.png	f	desktop	2024-05-31 13:50:23.18+00	2024-06-01 04:52:03.64+00
\.


--
-- Data for Name: adduserUpis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."adduserUpis" (id, upi_id, upi_name, user_id, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: adduseraccounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adduseraccounts (id, account_type, bank_name, account_number, ifsc_code, user_id, "createdAt", "updatedAt", acountholdername) FROM stdin;
78	bankaccount	DemoUser123	50100200245	D0909	576	2024-05-31 11:02:51.412+00	2024-05-31 11:02:51.412+00	demo
\.


--
-- Data for Name: adduserapis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adduserapis (id, upi_id, upi_name, user_id, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: casino_games; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.casino_games (title, feature_group, game_images, has_freespins, hd, identifier, identifier2, lines, multiplier, status, payout, producer, provider, restrictions, volatility_rating, created_at, updated_at, id) FROM stdin;
Blocky Block	basic	https://gis-static.com/games/KAGaming/6a9f6823d0994d839ee2c7145454d0d3.png	t	t	6a9f6823d0994d839ee2c7145454d0d3	6a9f6823d0994d839ee2c7145454d0d3	0	2519	t	96	KAGaming	KAGaming	{}	medium-high	\N	\N	119
Neon Shapes	basic	https://gis-static.com/games/4d29ca2d89cd74eb3502277a68b5704b5794a055.png	t	t	4d29ca2d89cd74eb3502277a68b5704b5794a055	4d29ca2d89cd74eb3502277a68b5704b5794a055	0	1274	t	96	Evoplay	Evoplay	{}	medium	\N	\N	150
Book of Mines	basic	https://gis-static.com/games/Turbogames/ad52ceeea4c24a44ae379f189a2e09a1.png	t	t	ad52ceeea4c24a44ae379f189a2e09a1	ad52ceeea4c24a44ae379f189a2e09a1	0	885	t	96	Turbogames	Turbogames	{}	low	\N	\N	1358
Single Deck Blackjack	basic	https://gis-static.com/games/Platipus/0a1370d167fa4f7a9314550aed918ec8.png	t	t	0a1370d167fa4f7a9314550aed918ec8	0a1370d167fa4f7a9314550aed918ec8	0	885	t	96	Platipus	Platipus	{}	high	\N	\N	1359
Ruletka Live	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e0399a084485c9b538fa15cf6758116559d43c09.png	t	t	e0399a084485c9b538fa15cf6758116559d43c09	e0399a084485c9b538fa15cf6758116559d43c09	0	1410	t	96	Evolution	Evolution	{}	medium	\N	\N	1152
Casino Marina Andar Bahar	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/3240527abe1a9c05f0bea138191a527624efaf14.png	t	t	3240527abe1a9c05f0bea138191a527624efaf14	3240527abe1a9c05f0bea138191a527624efaf14	0	1597	t	96	Ezugi	Ezugi	{}	high	\N	\N	651
Dragon Tiger	basic	https://gis-static.com/games/87e83bc1a570341dd95461838912920f4ffec79c.png	t	t	87e83bc1a570341dd95461838912920f4ffec79c	87e83bc1a570341dd95461838912920f4ffec79c	0	2165	t	96	Ezugi	Ezugi	{}	high	\N	\N	84
Baccarat no Commission	basic	https://gis-static.com/games/2a799abeb40fe26896b46caa7a188d469481853f.png	t	t	2a799abeb40fe26896b46caa7a188d469481853f	2a799abeb40fe26896b46caa7a188d469481853f	0	1265	t	96	Ezugi	Ezugi	{}	medium	\N	\N	85
LUCKY 7	basic	https://gis-static.com/games/fa5c7dd0da8b33be447c5c09b5668e233294e9da.png	t	t	fa5c7dd0da8b33be447c5c09b5668e233294e9da	fa5c7dd0da8b33be447c5c09b5668e233294e9da	0	10017	t	96	Ezugi	Ezugi	{}	very-high	\N	\N	91
Roulette Portomaso 2	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/b85eedcd644a81d2709e35f59984a03a49784d83.png	t	t	b85eedcd644a81d2709e35f59984a03a49784d83	b85eedcd644a81d2709e35f59984a03a49784d83	0	2170	t	96	Ezugi	Ezugi	{}	high	\N	\N	124
Rumba Blackjack	basic	https://gis-static.com/games/cbcb6bd2ee274c409ea70c616110d933c4b74eae.png	t	t	cbcb6bd2ee274c409ea70c616110d933c4b74eae	cbcb6bd2ee274c409ea70c616110d933c4b74eae	0	1270	t	96	Ezugi	Ezugi	{}	medium	\N	\N	125
32 Cards	basic	https://gis-static.com/games/05ff503ceb7715ec33fb738e17a0bd33.png	t	t	05ff503ceb7715ec33fb738e17a0bd33	05ff503ceb7715ec33fb738e17a0bd33	0	726	t	96	Ezugi	Ezugi	{}	low	\N	\N	169
Sic Bo	basic	https://gis-static.com/games/b23a4ab032c88e206ed066b54db51371489d1a90.png	t	t	b23a4ab032c88e206ed066b54db51371489d1a90	b23a4ab032c88e206ed066b54db51371489d1a90	0	2177	t	96	Ezugi	Ezugi	{}	high	\N	\N	172
Cricket War	basic	https://gis-static.com/games/60c52fae045b976a690a362a3b997f1ff1fa7346.png	t	t	60c52fae045b976a690a362a3b997f1ff1fa7346	60c52fae045b976a690a362a3b997f1ff1fa7346	0	10029	t	96	Ezugi	Ezugi	{}	very-high	\N	\N	179
Speed Cricket Baccarat	basic	https://gis-static.com/games/f19fe74f3a3dd53ba6541c0ac7194921e08af679.png	t	t	f19fe74f3a3dd53ba6541c0ac7194921e08af679	f19fe74f3a3dd53ba6541c0ac7194921e08af679	0	2178	t	96	Ezugi	Ezugi	{}	high	\N	\N	180
One Day Teen Patti	basic	https://gis-static.com/games/ea458c4f2a88cd811b47f27d915d8efd6e334815.png	t	t	ea458c4f2a88cd811b47f27d915d8efd6e334815	ea458c4f2a88cd811b47f27d915d8efd6e334815	0	728	t	96	Ezugi	Ezugi	{}	high	\N	\N	186
Blackjack Salon Privé	basic	https://gis-static.com/games/c743dc05bd242c74a46971d26de07fb8431b729d.png	t	t	c743dc05bd242c74a46971d26de07fb8431b729d	c743dc05bd242c74a46971d26de07fb8431b729d	0	10030	t	96	Ezugi	Ezugi	{}	very-high	\N	\N	187
Ultimate Sic Bo	basic	https://gis-static.com/games/540a4b3aeed3bd80bd96a57afc378703a90350ff.png	t	t	540a4b3aeed3bd80bd96a57afc378703a90350ff	540a4b3aeed3bd80bd96a57afc378703a90350ff	0	747	t	96	Ezugi	Ezugi	{}	low	\N	\N	318
EZ Dealer Roulette Thai	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/d5551890469542d199cf59e5cf4969a2.png	t	t	d5551890469542d199cf59e5cf4969a2	d5551890469542d199cf59e5cf4969a2	0	776	t	96	Ezugi	Ezugi	{}	low	\N	\N	518
Ultimate Andar Bahar	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/89666aedbbfac99340e04576657bbfc40c4cb9f3.png	t	t	89666aedbbfac99340e04576657bbfc40c4cb9f3	89666aedbbfac99340e04576657bbfc40c4cb9f3	0	779	t	96	Ezugi	Ezugi	{}	low	\N	\N	536
Knockout Baccarat	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/d1393b134e7c7cba068edf9ff8fc71a5f1b9f15c.png	t	t	d1393b134e7c7cba068edf9ff8fc71a5f1b9f15c	d1393b134e7c7cba068edf9ff8fc71a5f1b9f15c	0	794	t	96	Ezugi	Ezugi	{}	low	\N	\N	627
Ultimate Roulette	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/36e79031547ecd7e36bac46f0671652d49cce727.png	t	t	36e79031547ecd7e36bac46f0671652d49cce727	36e79031547ecd7e36bac46f0671652d49cce727	0	794	t	96	Ezugi	Ezugi	{}	high	\N	\N	628
Roleta da Sorte	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/2cfad95d4de44edd1fd013ee5a6ba3caca614077.png	t	t	2cfad95d4de44edd1fd013ee5a6ba3caca614077	2cfad95d4de44edd1fd013ee5a6ba3caca614077	0	1348	t	96	Ezugi	Ezugi	{}	medium	\N	\N	656
Blackjack da Sorte	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/1e3b723cb710c069008ed6f90ca96d825d3dfcb8.png	f	f	1e3b723cb710c069008ed6f90ca96d825d3dfcb8	1e3b723cb710c069008ed6f90ca96d825d3dfcb8	0	1098	t	96	Ezugi	Ezugi	{}	low	\N	\N	657
Dragon Tiger da Sorte	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/c552dc42a4145147fce6addb033789290ca723dd.png	t	t	c552dc42a4145147fce6addb033789290ca723dd	c552dc42a4145147fce6addb033789290ca723dd	0	2598	t	96	Ezugi	Ezugi	{}	medium-high	\N	\N	658
Russian Poker	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/2046a8f6ae9f45bfee056352da3c01ae2fb0f05c.jpg	t	t	2046a8f6ae9f45bfee056352da3c01ae2fb0f05c	2046a8f6ae9f45bfee056352da3c01ae2fb0f05c	0	1678	t	96	Ezugi	Ezugi	{}	high	\N	\N	1302
Ruleta del Sol	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/637346de5f001e55e3737987d5400b4e5b1213a8.jpg	t	t	637346de5f001e55e3737987d5400b4e5b1213a8	637346de5f001e55e3737987d5400b4e5b1213a8	0	878	t	96	Ezugi	Ezugi	{}	low	\N	\N	1303
EZ Dealer Roleta Brasileira	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/5d838012775541e79120902ffd916c2e.png	t	t	5d838012775541e79120902ffd916c2e	5d838012775541e79120902ffd916c2e	0	880	t	96	Ezugi	Ezugi	{}	low	\N	\N	1319
Namaste Roulette	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/99f2d694929c4af9bc4a30e0c6d7f0c5.png	f	f	99f2d694929c4af9bc4a30e0c6d7f0c5	99f2d694929c4af9bc4a30e0c6d7f0c5	0	1182	t	96	Ezugi	Ezugi	{}	low	\N	\N	1332
Speed Roulette	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/17e8185f0a3944389d4d431706277e42.png	t	t	17e8185f0a3944389d4d431706277e42	17e8185f0a3944389d4d431706277e42	0	2682	t	96	Ezugi	Ezugi	{}	medium-high	\N	\N	1333
Prestige Auto Roulette	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/dd76fd8d9a4f4a179c4ae722243d6715.png	t	t	dd76fd8d9a4f4a179c4ae722243d6715	dd76fd8d9a4f4a179c4ae722243d6715	0	1682	t	96	Ezugi	Ezugi	{}	high	\N	\N	1334
VIP Fortune Baccarat	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/fe3ba47383d246249918e84c1451ce80.png	t	t	fe3ba47383d246249918e84c1451ce80	fe3ba47383d246249918e84c1451ce80	0	882	t	96	Ezugi	Ezugi	{}	low	\N	\N	1335
Diamond Roulette	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Ezugi/09e5c2c980534e1fb0b9762f7036497a.png	t	t	09e5c2c980534e1fb0b9762f7036497a	09e5c2c980534e1fb0b9762f7036497a	0	882	t	96	Ezugi	Ezugi	{}	high	\N	\N	1336
Super Sic Bo	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/fdcd51f224335fd5a772087ba6a9a17ff1f6fea7.png	t	t	fdcd51f224335fd5a772087ba6a9a17ff1f6fea7	fdcd51f224335fd5a772087ba6a9a17ff1f6fea7	0	2627	t	96	Evolution	Evolution	{}	medium-high	\N	\N	888
Fan Tan	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a0afab3538f49db687fad055dbb047c84f634ec2.png	t	t	a0afab3538f49db687fad055dbb047c84f634ec2	a0afab3538f49db687fad055dbb047c84f634ec2	0	1627	t	96	Evolution	Evolution	{}	high	\N	\N	889
Lightning Baccarat	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/284a7f3265613acfab1762920e1d08e4789db07f.png	t	t	284a7f3265613acfab1762920e1d08e4789db07f	284a7f3265613acfab1762920e1d08e4789db07f	0	827	t	96	Evolution	Evolution	{}	low	\N	\N	890
Speed Baccarat A	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/7bf699a12c64bf47a7d4cade29ad2ef5dab1d0a7.png	t	t	7bf699a12c64bf47a7d4cade29ad2ef5dab1d0a7	7bf699a12c64bf47a7d4cade29ad2ef5dab1d0a7	0	827	t	96	Evolution	Evolution	{}	high	\N	\N	891
Speed Baccarat B	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/80b9edbb322b706c8e65e80c567ba531f3e53292.png	t	t	80b9edbb322b706c8e65e80c567ba531f3e53292	80b9edbb322b706c8e65e80c567ba531f3e53292	0	10129	t	96	Evolution	Evolution	{}	very-high	\N	\N	892
Speed Baccarat C	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/566e499d5883028f0aa783dfdb775dd8928f33b1.png	t	t	566e499d5883028f0aa783dfdb775dd8928f33b1	566e499d5883028f0aa783dfdb775dd8928f33b1	0	2278	t	96	Evolution	Evolution	{}	high	\N	\N	893
Speed Baccarat D	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4663803623bfbf71183b734aff199c0fbe101e4b.png	t	t	4663803623bfbf71183b734aff199c0fbe101e4b	4663803623bfbf71183b734aff199c0fbe101e4b	0	1378	t	96	Evolution	Evolution	{}	medium	\N	\N	894
Speed Baccarat E	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4ef0b6823a1e20f278d8c96ea319a1bee06bbc5d.png	f	f	4ef0b6823a1e20f278d8c96ea319a1bee06bbc5d	4ef0b6823a1e20f278d8c96ea319a1bee06bbc5d	0	1128	t	96	Evolution	Evolution	{}	low	\N	\N	895
Speed Baccarat F	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4c3cdc5e117e2a157f81d0de6c898d6e4244437a.png	t	t	4c3cdc5e117e2a157f81d0de6c898d6e4244437a	4c3cdc5e117e2a157f81d0de6c898d6e4244437a	0	2628	t	96	Evolution	Evolution	{}	medium-high	\N	\N	896
Speed Baccarat G	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4b3493bf1e0f902496ae3a4ddb19bc3ac3797633.png	t	t	4b3493bf1e0f902496ae3a4ddb19bc3ac3797633	4b3493bf1e0f902496ae3a4ddb19bc3ac3797633	0	1628	t	96	Evolution	Evolution	{}	high	\N	\N	897
Speed Baccarat H	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/f240091f71b950153a799234e48c05223b341fe1.png	t	t	f240091f71b950153a799234e48c05223b341fe1	f240091f71b950153a799234e48c05223b341fe1	0	828	t	96	Evolution	Evolution	{}	low	\N	\N	898
Speed Baccarat I	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/02fcb3f6aab08c5a514296ebe1ca6411b71fb7d7.png	t	t	02fcb3f6aab08c5a514296ebe1ca6411b71fb7d7	02fcb3f6aab08c5a514296ebe1ca6411b71fb7d7	0	828	t	96	Evolution	Evolution	{}	high	\N	\N	899
Speed Baccarat J	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/fbd8ade4f6fedf2f31ef2697ddf4909f1456f394.png	t	t	fbd8ade4f6fedf2f31ef2697ddf4909f1456f394	fbd8ade4f6fedf2f31ef2697ddf4909f1456f394	0	10130	t	96	Evolution	Evolution	{}	very-high	\N	\N	900
Speed Baccarat K	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/679a47762d37e45dee43c9e194aa9fc694987b58.png	t	t	679a47762d37e45dee43c9e194aa9fc694987b58	679a47762d37e45dee43c9e194aa9fc694987b58	0	2279	t	96	Evolution	Evolution	{}	high	\N	\N	901
Speed Baccarat L	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/82cc1a40c4f551045a4a20b4651e5a92c46aa8c7.png	t	t	82cc1a40c4f551045a4a20b4651e5a92c46aa8c7	82cc1a40c4f551045a4a20b4651e5a92c46aa8c7	0	1379	t	96	Evolution	Evolution	{}	medium	\N	\N	902
Speed Baccarat M	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a2e0fde3b2b964eebec7e8a3abb8ea856d1e56c2.png	f	f	a2e0fde3b2b964eebec7e8a3abb8ea856d1e56c2	a2e0fde3b2b964eebec7e8a3abb8ea856d1e56c2	0	1129	t	96	Evolution	Evolution	{}	low	\N	\N	903
Speed Baccarat N	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/69b1b24c9ba98a54d0057d6648ff98006cb25404.png	t	t	69b1b24c9ba98a54d0057d6648ff98006cb25404	69b1b24c9ba98a54d0057d6648ff98006cb25404	0	2629	t	96	Evolution	Evolution	{}	medium-high	\N	\N	904
Speed Baccarat O	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/1d70a947e0821320a58ab40bc170bd8e36d16387.png	t	t	1d70a947e0821320a58ab40bc170bd8e36d16387	1d70a947e0821320a58ab40bc170bd8e36d16387	0	1629	t	96	Evolution	Evolution	{}	high	\N	\N	905
Speed Baccarat P	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/35831323d520db02aac1a737e4f2707a9c8fa521.png	t	t	35831323d520db02aac1a737e4f2707a9c8fa521	35831323d520db02aac1a737e4f2707a9c8fa521	0	829	t	96	Evolution	Evolution	{}	low	\N	\N	906
Speed Baccarat Q	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3bf2745fb8326ab5df8b179fd5f721a75f3697cb.png	t	t	3bf2745fb8326ab5df8b179fd5f721a75f3697cb	3bf2745fb8326ab5df8b179fd5f721a75f3697cb	0	10190	t	96	Evolution	Evolution	{}	very-high	\N	\N	907
Speed Baccarat R	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/85395a515ba6d4dd469dfcb2a550074605bf00f0.png	t	t	85395a515ba6d4dd469dfcb2a550074605bf00f0	85395a515ba6d4dd469dfcb2a550074605bf00f0	0	829	t	96	Evolution	Evolution	{}	high	\N	\N	908
Speed Baccarat S	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c6c7babc2718c1df37941f8ec17fdce906267373.png	t	t	c6c7babc2718c1df37941f8ec17fdce906267373	c6c7babc2718c1df37941f8ec17fdce906267373	0	10131	t	96	Evolution	Evolution	{}	very-high	\N	\N	909
No Commission Speed Baccarat A	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/b57650c28d8bda5292b1dbcfbdc362e967ba2da4.png	t	t	b57650c28d8bda5292b1dbcfbdc362e967ba2da4	b57650c28d8bda5292b1dbcfbdc362e967ba2da4	0	2280	t	96	Evolution	Evolution	{}	high	\N	\N	910
No Commission Speed Baccarat B	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/fdce8cab635beed2ea13bb90d7fae1d7c9254b36.png	t	t	fdce8cab635beed2ea13bb90d7fae1d7c9254b36	fdce8cab635beed2ea13bb90d7fae1d7c9254b36	0	1380	t	96	Evolution	Evolution	{}	medium	\N	\N	911
No Commission Speed Baccarat C	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/60c981a0d6eed20c3a56c3397f74e34eb5f5bc91.png	f	f	60c981a0d6eed20c3a56c3397f74e34eb5f5bc91	60c981a0d6eed20c3a56c3397f74e34eb5f5bc91	0	1130	t	96	Evolution	Evolution	{}	low	\N	\N	912
Blackjack Classic 75	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6e86377ab42934981b579438f3476691d90efd2c.png	t	t	6e86377ab42934981b579438f3476691d90efd2c	6e86377ab42934981b579438f3476691d90efd2c	0	1645	t	96	Evolution	Evolution	{}	high	\N	\N	1034
No Commission Baccarat	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/342e6921d10bff9132e09f39ebc3a85442e3bfe3.png	t	t	342e6921d10bff9132e09f39ebc3a85442e3bfe3	342e6921d10bff9132e09f39ebc3a85442e3bfe3	0	2630	t	96	Evolution	Evolution	{}	medium-high	\N	\N	913
Baccarat A	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c02fc0a8fc084107686b785d7a70b7e4f0dd5283.png	t	t	c02fc0a8fc084107686b785d7a70b7e4f0dd5283	c02fc0a8fc084107686b785d7a70b7e4f0dd5283	0	1630	t	96	Evolution	Evolution	{}	high	\N	\N	914
Baccarat B	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/daa45285c1b9ccdd9f4c2f92161b89e309323a0e.png	t	t	daa45285c1b9ccdd9f4c2f92161b89e309323a0e	daa45285c1b9ccdd9f4c2f92161b89e309323a0e	0	830	t	96	Evolution	Evolution	{}	low	\N	\N	915
Baccarat C	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/0c917b41fd1cb4f8e1d710112c74994bf27280a1.png	t	t	0c917b41fd1cb4f8e1d710112c74994bf27280a1	0c917b41fd1cb4f8e1d710112c74994bf27280a1	0	830	t	96	Evolution	Evolution	{}	high	\N	\N	916
Baccarat Squeeze	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a7461099ed619507673b2b29081671be1e038e33.png	t	t	a7461099ed619507673b2b29081671be1e038e33	a7461099ed619507673b2b29081671be1e038e33	0	10132	t	96	Evolution	Evolution	{}	very-high	\N	\N	917
Baccarat Control Squeeze	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/79beaf41f75c877570189d1ad91bde146520fd2d.png	t	t	79beaf41f75c877570189d1ad91bde146520fd2d	79beaf41f75c877570189d1ad91bde146520fd2d	0	2281	t	96	Evolution	Evolution	{}	high	\N	\N	918
Salon Privé Baccarat A	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/73e93d1b055a1c0e948cadc8a2566acfccb0ca02.png	t	t	73e93d1b055a1c0e948cadc8a2566acfccb0ca02	73e93d1b055a1c0e948cadc8a2566acfccb0ca02	0	1381	t	96	Evolution	Evolution	{}	medium	\N	\N	919
Salon Privé Baccarat B	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/aa82c972eb996b885577f3fcb1f2b3333ad503fb.png	f	f	aa82c972eb996b885577f3fcb1f2b3333ad503fb	aa82c972eb996b885577f3fcb1f2b3333ad503fb	0	1131	t	96	Evolution	Evolution	{}	low	\N	\N	920
Salon Privé Baccarat C	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6c8f12c3014044cbd18021bd1dab1d20140cf2be.png	t	t	6c8f12c3014044cbd18021bd1dab1d20140cf2be	6c8f12c3014044cbd18021bd1dab1d20140cf2be	0	2631	t	96	Evolution	Evolution	{}	medium-high	\N	\N	921
Salon Privé Baccarat D	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/f83d78d425642c3d1082ab75451bd99de7a194aa.png	t	t	f83d78d425642c3d1082ab75451bd99de7a194aa	f83d78d425642c3d1082ab75451bd99de7a194aa	0	1631	t	96	Evolution	Evolution	{}	high	\N	\N	922
Salon Privé Baccarat E	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4f2cb522271220515b5b056e2d89ecf2593de6ea.png	t	t	4f2cb522271220515b5b056e2d89ecf2593de6ea	4f2cb522271220515b5b056e2d89ecf2593de6ea	0	831	t	96	Evolution	Evolution	{}	low	\N	\N	923
Craps	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/2455e896cb98e0dfa27285891cdb355b0ac882f1.png	t	t	2455e896cb98e0dfa27285891cdb355b0ac882f1	2455e896cb98e0dfa27285891cdb355b0ac882f1	0	831	t	96	Evolution	Evolution	{}	high	\N	\N	924
Classic Speed Blackjack 1	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/622511287be515eb3e4f491cd8c21558517abdd5.png	t	t	622511287be515eb3e4f491cd8c21558517abdd5	622511287be515eb3e4f491cd8c21558517abdd5	0	10133	t	96	Evolution	Evolution	{}	very-high	\N	\N	925
Classic Speed Blackjack 2	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/825da805917c09fc2f64b4d6466867a5d07d3f41.png	t	t	825da805917c09fc2f64b4d6466867a5d07d3f41	825da805917c09fc2f64b4d6466867a5d07d3f41	0	2282	t	96	Evolution	Evolution	{}	high	\N	\N	926
BlackJack Lucky Sevens	basic	https://gis-static.com/games/3b98aa535d4f492eaa2fe04b7d826105.png	t	t	3b98aa535d4f492eaa2fe04b7d826105	3b98aa535d4f492eaa2fe04b7d826105	0	710	t	96	Evoplay	Evoplay	{}	low	\N	\N	59
Oasis Poker Classic	basic	https://gis-static.com/games/9bd86604547d46bba82703143cdf7fdf.png	t	t	9bd86604547d46bba82703143cdf7fdf	9bd86604547d46bba82703143cdf7fdf	0	710	t	96	Evoplay	Evoplay	{}	high	\N	\N	60
Four Aces	basic	https://gis-static.com/games/12cf8fe7cdb347c1b1d1d06edc0caa0e.png	t	t	12cf8fe7cdb347c1b1d1d06edc0caa0e	12cf8fe7cdb347c1b1d1d06edc0caa0e	0	10012	t	96	Evoplay	Evoplay	{}	very-high	\N	\N	61
Red Queen	basic	https://gis-static.com/games/f0442bb5f18f4cd4b70eed8887aa6124.png	t	t	f0442bb5f18f4cd4b70eed8887aa6124	f0442bb5f18f4cd4b70eed8887aa6124	0	2161	t	96	Evoplay	Evoplay	{}	high	\N	\N	62
Thimbles	basic	https://gis-static.com/games/d6f5758f36784fe19d83578c391705e1.png	t	t	d6f5758f36784fe19d83578c391705e1	d6f5758f36784fe19d83578c391705e1	0	1261	t	96	Evoplay	Evoplay	{}	medium	\N	\N	63
European Roulette	basic	https://gis-static.com/games/b43c2be0f8f1464d8992f145d7619850.png	f	f	b43c2be0f8f1464d8992f145d7619850	b43c2be0f8f1464d8992f145d7619850	0	1011	t	96	Evoplay	Evoplay	{}	low	\N	\N	64
Baccarat 777	basic	https://gis-static.com/games/72233f9eee7d486e8f66e63433914d8b.png	t	t	72233f9eee7d486e8f66e63433914d8b	72233f9eee7d486e8f66e63433914d8b	0	2511	t	96	Evoplay	Evoplay	{}	medium-high	\N	\N	65
Rock vs Paper	basic	https://gis-static.com/games/307bbaec6ff6433da22a7891885667e9.png	t	t	307bbaec6ff6433da22a7891885667e9	307bbaec6ff6433da22a7891885667e9	0	1511	t	96	Evoplay	Evoplay	{}	high	\N	\N	66
American Roulette 3D Classic	basic	https://gis-static.com/games/2fc59408eeea454d94998f8e365b9e11.png	t	t	2fc59408eeea454d94998f8e365b9e11	2fc59408eeea454d94998f8e365b9e11	0	711	t	96	Evoplay	Evoplay	{}	low	\N	\N	67
High Striker	basic	https://gis-static.com/games/b0d93376a8fa4725bc066844626701fd.png	t	t	b0d93376a8fa4725bc066844626701fd	b0d93376a8fa4725bc066844626701fd	0	711	t	96	Evoplay	Evoplay	{}	high	\N	\N	68
Poker Teen Patti	basic	https://gis-static.com/games/78f5c97bca0e47ebbcb04edc48ae3e2e.png	t	t	78f5c97bca0e47ebbcb04edc48ae3e2e	78f5c97bca0e47ebbcb04edc48ae3e2e	0	10013	t	96	Evoplay	Evoplay	{}	very-high	\N	\N	69
Courier Sweeper	basic	https://gis-static.com/games/c5e6762e038e4f36a35ed04034372d5a.png	t	t	c5e6762e038e4f36a35ed04034372d5a	c5e6762e038e4f36a35ed04034372d5a	0	2162	t	96	Evoplay	Evoplay	{}	high	\N	\N	70
Classic Speed Blackjack 3	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e0a4147317e2fecd3e8992ce52e2e6ef8dbd89e7.png	t	t	e0a4147317e2fecd3e8992ce52e2e6ef8dbd89e7	e0a4147317e2fecd3e8992ce52e2e6ef8dbd89e7	0	1382	t	96	Evolution	Evolution	{}	medium	\N	\N	927
Classic Speed Blackjack 4	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/f67d87c4bc79de13e7206f6025cfd0e4983b06ef.png	f	f	f67d87c4bc79de13e7206f6025cfd0e4983b06ef	f67d87c4bc79de13e7206f6025cfd0e4983b06ef	0	1132	t	96	Evolution	Evolution	{}	low	\N	\N	928
Classic Speed Blackjack 5	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3dbf0332ebc6be71807889d218097c83273fbf7d.png	t	t	3dbf0332ebc6be71807889d218097c83273fbf7d	3dbf0332ebc6be71807889d218097c83273fbf7d	0	2632	t	96	Evolution	Evolution	{}	medium-high	\N	\N	929
Classic Speed Blackjack 6	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/9c73770afcc22543ad5b6b5bb0d4a1b3aa79e527.png	t	t	9c73770afcc22543ad5b6b5bb0d4a1b3aa79e527	9c73770afcc22543ad5b6b5bb0d4a1b3aa79e527	0	1632	t	96	Evolution	Evolution	{}	high	\N	\N	930
Classic Speed Blackjack 8	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4f45a4c21409a32931ae76926fc42e11e4c8bb23.png	t	t	4f45a4c21409a32931ae76926fc42e11e4c8bb23	4f45a4c21409a32931ae76926fc42e11e4c8bb23	0	832	t	96	Evolution	Evolution	{}	low	\N	\N	931
Classic Speed Blackjack 9	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/0b4f8710a01f7e792c7684376ca72b96915f4d93.png	t	t	0b4f8710a01f7e792c7684376ca72b96915f4d93	0b4f8710a01f7e792c7684376ca72b96915f4d93	0	832	t	96	Evolution	Evolution	{}	high	\N	\N	932
Classic Speed Blackjack 10	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6137bc6a601f571f4a1564710940cfd0e3b5ebd2.png	t	t	6137bc6a601f571f4a1564710940cfd0e3b5ebd2	6137bc6a601f571f4a1564710940cfd0e3b5ebd2	0	10134	t	96	Evolution	Evolution	{}	very-high	\N	\N	933
Classic Speed Blackjack 11	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/fa1ca2d798a8bbf6e754b1593959c34ae5e1ff93.png	t	t	fa1ca2d798a8bbf6e754b1593959c34ae5e1ff93	fa1ca2d798a8bbf6e754b1593959c34ae5e1ff93	0	2283	t	96	Evolution	Evolution	{}	high	\N	\N	934
Classic Speed Blackjack 12	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d93bb66f58f540ef03685966eaa68bfffe007416.png	t	t	d93bb66f58f540ef03685966eaa68bfffe007416	d93bb66f58f540ef03685966eaa68bfffe007416	0	1383	t	96	Evolution	Evolution	{}	medium	\N	\N	935
Classic Speed Blackjack 13	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/829bd384c78a17c8f75238b7251647b39ef3804c.png	f	f	829bd384c78a17c8f75238b7251647b39ef3804c	829bd384c78a17c8f75238b7251647b39ef3804c	0	1133	t	96	Evolution	Evolution	{}	low	\N	\N	936
Classic Speed Blackjack 14	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/28cb7a0d6f393c24f42ac3c86e16cf79acec70d1.png	t	t	28cb7a0d6f393c24f42ac3c86e16cf79acec70d1	28cb7a0d6f393c24f42ac3c86e16cf79acec70d1	0	2633	t	96	Evolution	Evolution	{}	medium-high	\N	\N	937
Classic Speed Blackjack 15	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c1d64069a4079ad4c032575279dc2ee1297be85e.png	t	t	c1d64069a4079ad4c032575279dc2ee1297be85e	c1d64069a4079ad4c032575279dc2ee1297be85e	0	1633	t	96	Evolution	Evolution	{}	high	\N	\N	938
Classic Speed Blackjack 16	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8eb074c31315e91d8a0564e650f93ac37ae7e9c2.png	t	t	8eb074c31315e91d8a0564e650f93ac37ae7e9c2	8eb074c31315e91d8a0564e650f93ac37ae7e9c2	0	833	t	96	Evolution	Evolution	{}	low	\N	\N	939
Classic Speed Blackjack 17	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/1cef008d114f2ea4183af6e635b88327f6325d60.png	t	t	1cef008d114f2ea4183af6e635b88327f6325d60	1cef008d114f2ea4183af6e635b88327f6325d60	0	833	t	96	Evolution	Evolution	{}	high	\N	\N	940
Classic Speed Blackjack 18	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/386794892271180e93fe5b682e7c47461d6cdcb9.png	t	t	386794892271180e93fe5b682e7c47461d6cdcb9	386794892271180e93fe5b682e7c47461d6cdcb9	0	10135	t	96	Evolution	Evolution	{}	very-high	\N	\N	941
Classic Speed Blackjack 19	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/2fcb37b893c0a0fc550c537d0d5a96d4c49690d7.png	t	t	2fcb37b893c0a0fc550c537d0d5a96d4c49690d7	2fcb37b893c0a0fc550c537d0d5a96d4c49690d7	0	2284	t	96	Evolution	Evolution	{}	high	\N	\N	942
Classic Speed Blackjack 21	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4873a38a919b37b79f963d7c8386c3c775d492ac.png	t	t	4873a38a919b37b79f963d7c8386c3c775d492ac	4873a38a919b37b79f963d7c8386c3c775d492ac	0	1384	t	96	Evolution	Evolution	{}	medium	\N	\N	943
Classic Speed Blackjack 22	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/2a003041c9eb41c19258fd1725e84bddf413939b.png	f	f	2a003041c9eb41c19258fd1725e84bddf413939b	2a003041c9eb41c19258fd1725e84bddf413939b	0	1134	t	96	Evolution	Evolution	{}	low	\N	\N	944
Classic Speed Blackjack 23	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/73c1d386758b1adf1f5b76e7752431d1212a8bb2.png	t	t	73c1d386758b1adf1f5b76e7752431d1212a8bb2	73c1d386758b1adf1f5b76e7752431d1212a8bb2	0	2634	t	96	Evolution	Evolution	{}	medium-high	\N	\N	945
Circus Bingo	basic	https://gis-static.com/games/Caleta/960f1b855dce4e5eaccbf02b31abac0f.png	t	t	960f1b855dce4e5eaccbf02b31abac0f	960f1b855dce4e5eaccbf02b31abac0f	0	720	t	96	Caleta	Caleta	{}	low	\N	\N	129
Classic Speed Blackjack 24	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/003387b6dafba9b6f2cc6a3e7ab8fde7154d2874.png	t	t	003387b6dafba9b6f2cc6a3e7ab8fde7154d2874	003387b6dafba9b6f2cc6a3e7ab8fde7154d2874	0	1634	t	96	Evolution	Evolution	{}	high	\N	\N	946
Classic Speed Blackjack 26	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8b82789603b9fe4f9549e5aae269a9d823771295.png	t	t	8b82789603b9fe4f9549e5aae269a9d823771295	8b82789603b9fe4f9549e5aae269a9d823771295	0	834	t	96	Evolution	Evolution	{}	low	\N	\N	947
Classic Speed Blackjack 27	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/78de78f9b0fe12411bbcf6037c6d9e154e76e2d7.png	t	t	78de78f9b0fe12411bbcf6037c6d9e154e76e2d7	78de78f9b0fe12411bbcf6037c6d9e154e76e2d7	0	834	t	96	Evolution	Evolution	{}	high	\N	\N	948
Classic Speed Blackjack 28	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e690240de0a55cfe2734a7ff007874690b95ad6b.png	t	t	e690240de0a55cfe2734a7ff007874690b95ad6b	e690240de0a55cfe2734a7ff007874690b95ad6b	0	10136	t	96	Evolution	Evolution	{}	very-high	\N	\N	949
Football Manager	basic	https://gis-static.com/games/748b2c62fab0584cdaf241f9c6ac82bb2b550b4e.png	t	t	748b2c62fab0584cdaf241f9c6ac82bb2b550b4e	748b2c62fab0584cdaf241f9c6ac82bb2b550b4e	0	715	t	96	Evoplay	Evoplay	{}	high	\N	\N	90
Classic Speed Blackjack 29	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/50933796870bfbbe4e133e7db6aa68aba8f8d251.png	t	t	50933796870bfbbe4e133e7db6aa68aba8f8d251	50933796870bfbbe4e133e7db6aa68aba8f8d251	0	2285	t	96	Evolution	Evolution	{}	high	\N	\N	950
Classic Speed Blackjack 30	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/1ce393384d1baa572229c2297c87980633691b4e.png	t	t	1ce393384d1baa572229c2297c87980633691b4e	1ce393384d1baa572229c2297c87980633691b4e	0	1385	t	96	Evolution	Evolution	{}	medium	\N	\N	951
Classic Speed Blackjack 31	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3df6a38d34e14d09f94d8c8f6eb023bb47a4e642.png	f	f	3df6a38d34e14d09f94d8c8f6eb023bb47a4e642	3df6a38d34e14d09f94d8c8f6eb023bb47a4e642	0	1135	t	96	Evolution	Evolution	{}	low	\N	\N	952
Classic Speed Blackjack 32	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4f00bdace6afcd804e2a3de01135a22e1fb5a1a3.png	t	t	4f00bdace6afcd804e2a3de01135a22e1fb5a1a3	4f00bdace6afcd804e2a3de01135a22e1fb5a1a3	0	2635	t	96	Evolution	Evolution	{}	medium-high	\N	\N	953
Classic Speed Blackjack 33	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/eb7deae296860f67901911f1c2778376f043254b.png	t	t	eb7deae296860f67901911f1c2778376f043254b	eb7deae296860f67901911f1c2778376f043254b	0	1635	t	96	Evolution	Evolution	{}	high	\N	\N	954
Classic Speed Blackjack 34	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/05a698f1d841d4ba8316289f1d47f56a682d8da9.png	t	t	05a698f1d841d4ba8316289f1d47f56a682d8da9	05a698f1d841d4ba8316289f1d47f56a682d8da9	0	835	t	96	Evolution	Evolution	{}	low	\N	\N	955
Classic Speed Blackjack 35	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d74c51e4ef79e7565c48063536163ce322db9037.png	t	t	d74c51e4ef79e7565c48063536163ce322db9037	d74c51e4ef79e7565c48063536163ce322db9037	0	835	t	96	Evolution	Evolution	{}	high	\N	\N	956
Classic Speed Blackjack 36	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/03051cf7e5a638dddcdf11a5f2307a4c626f5360.png	t	t	03051cf7e5a638dddcdf11a5f2307a4c626f5360	03051cf7e5a638dddcdf11a5f2307a4c626f5360	0	10137	t	96	Evolution	Evolution	{}	very-high	\N	\N	957
Classic Speed Blackjack 37	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d7197c2daf78645b676fa5b2ab6bdb6014bfbb6f.png	t	t	d7197c2daf78645b676fa5b2ab6bdb6014bfbb6f	d7197c2daf78645b676fa5b2ab6bdb6014bfbb6f	0	2286	t	96	Evolution	Evolution	{}	high	\N	\N	958
Classic Speed Blackjack 38	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6052e622b4d9f81c8b8731d027384a93b2ac9216.png	t	t	6052e622b4d9f81c8b8731d027384a93b2ac9216	6052e622b4d9f81c8b8731d027384a93b2ac9216	0	1386	t	96	Evolution	Evolution	{}	medium	\N	\N	959
Classic Speed Blackjack 39	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d946684ce4d477b3490b944cc91bb71a539eeed4.png	f	f	d946684ce4d477b3490b944cc91bb71a539eeed4	d946684ce4d477b3490b944cc91bb71a539eeed4	0	1136	t	96	Evolution	Evolution	{}	low	\N	\N	960
Classic Speed Blackjack 40	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/13a69cb59a73970a93ec5d22a2f8b9d165b05735.png	t	t	13a69cb59a73970a93ec5d22a2f8b9d165b05735	13a69cb59a73970a93ec5d22a2f8b9d165b05735	0	2636	t	96	Evolution	Evolution	{}	medium-high	\N	\N	961
Classic Speed Blackjack 41	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a56758b56c3defe4081e76a8ca52e8dd1d91c5c6.png	t	t	a56758b56c3defe4081e76a8ca52e8dd1d91c5c6	a56758b56c3defe4081e76a8ca52e8dd1d91c5c6	0	1636	t	96	Evolution	Evolution	{}	high	\N	\N	962
Classic Speed Blackjack 42	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/63bef8aa1eba6689a6ce0588e35cefd5c6b7a962.png	t	t	63bef8aa1eba6689a6ce0588e35cefd5c6b7a962	63bef8aa1eba6689a6ce0588e35cefd5c6b7a962	0	836	t	96	Evolution	Evolution	{}	low	\N	\N	963
Classic Speed Blackjack 43	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/9a87996a2c8bd081856323077c273192ad527490.png	t	t	9a87996a2c8bd081856323077c273192ad527490	9a87996a2c8bd081856323077c273192ad527490	0	836	t	96	Evolution	Evolution	{}	high	\N	\N	964
Classic Speed Blackjack 44	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e1073768b3de2510c7719f14fa5ca8b9bfec507e.png	t	t	e1073768b3de2510c7719f14fa5ca8b9bfec507e	e1073768b3de2510c7719f14fa5ca8b9bfec507e	0	10138	t	96	Evolution	Evolution	{}	very-high	\N	\N	965
Classic Speed Blackjack 45	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/75cc731f7d5b6f43f7e10ff71533623d89a316ae.png	t	t	75cc731f7d5b6f43f7e10ff71533623d89a316ae	75cc731f7d5b6f43f7e10ff71533623d89a316ae	0	2287	t	96	Evolution	Evolution	{}	high	\N	\N	966
Classic Speed Blackjack 46	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e21aac9108c0f719c633f8f0d0ded144cf2f88e1.png	t	t	e21aac9108c0f719c633f8f0d0ded144cf2f88e1	e21aac9108c0f719c633f8f0d0ded144cf2f88e1	0	1387	t	96	Evolution	Evolution	{}	medium	\N	\N	967
Classic Speed Blackjack 47	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a7dcd7bc214ccf5a3977d5d8ec6e3050e7d89425.png	f	f	a7dcd7bc214ccf5a3977d5d8ec6e3050e7d89425	a7dcd7bc214ccf5a3977d5d8ec6e3050e7d89425	0	1137	t	96	Evolution	Evolution	{}	low	\N	\N	968
Classic Speed Blackjack 48	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/16ce213502d89ab9884c23b7dbccb7dcf16143f3.png	t	t	16ce213502d89ab9884c23b7dbccb7dcf16143f3	16ce213502d89ab9884c23b7dbccb7dcf16143f3	0	2637	t	96	Evolution	Evolution	{}	medium-high	\N	\N	969
Classic Speed Blackjack 49	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8b6e63ca2540781ce91399189ac800892d0ce16f.png	t	t	8b6e63ca2540781ce91399189ac800892d0ce16f	8b6e63ca2540781ce91399189ac800892d0ce16f	0	1637	t	96	Evolution	Evolution	{}	high	\N	\N	970
Classic Speed Blackjack 50	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c083c4886ac087dede6b7a3b5bd0da4448b90384.png	t	t	c083c4886ac087dede6b7a3b5bd0da4448b90384	c083c4886ac087dede6b7a3b5bd0da4448b90384	0	837	t	96	Evolution	Evolution	{}	low	\N	\N	971
Baccarat	basic	https://gis-static.com/games/KAGaming/fb5d85130a4d4d50bc70b7128b80dbf0.png	t	t	fb5d85130a4d4d50bc70b7128b80dbf0	fb5d85130a4d4d50bc70b7128b80dbf0	0	1519	t	96	KAGaming	KAGaming	{}	high	\N	\N	120
Classic Speed Blackjack 51	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/1de0298ef63fea0594c8639c7b13f6bbf6f11b2d.png	t	t	1de0298ef63fea0594c8639c7b13f6bbf6f11b2d	1de0298ef63fea0594c8639c7b13f6bbf6f11b2d	0	837	t	96	Evolution	Evolution	{}	high	\N	\N	972
Classic Speed Blackjack 52	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4e0c02fc9e02fc706f836ef2623e6b5c7f5586c2.png	t	t	4e0c02fc9e02fc706f836ef2623e6b5c7f5586c2	4e0c02fc9e02fc706f836ef2623e6b5c7f5586c2	0	10139	t	96	Evolution	Evolution	{}	very-high	\N	\N	973
Classic Speed Blackjack 53	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/70318bc803d7581ab204f133a992bf7ea2d928c3.png	t	t	70318bc803d7581ab204f133a992bf7ea2d928c3	70318bc803d7581ab204f133a992bf7ea2d928c3	0	2288	t	96	Evolution	Evolution	{}	high	\N	\N	974
Classic Speed Blackjack 54	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e639441dd9e42a577532c43acff071953926e52f.png	t	t	e639441dd9e42a577532c43acff071953926e52f	e639441dd9e42a577532c43acff071953926e52f	0	1388	t	96	Evolution	Evolution	{}	medium	\N	\N	975
Classic Speed Blackjack 55	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/2264148482d32a557c2d058d731829401e85b1e2.png	f	f	2264148482d32a557c2d058d731829401e85b1e2	2264148482d32a557c2d058d731829401e85b1e2	0	1138	t	96	Evolution	Evolution	{}	low	\N	\N	976
Classic Speed Blackjack 56	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c1a7d2c8cba6d96ba55351334ca35e10b4b2a187.png	t	t	c1a7d2c8cba6d96ba55351334ca35e10b4b2a187	c1a7d2c8cba6d96ba55351334ca35e10b4b2a187	0	2638	t	96	Evolution	Evolution	{}	medium-high	\N	\N	977
Classic Speed Blackjack 57	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/830105fc721cd815fd3e58a7589eb1ea30765be2.png	t	t	830105fc721cd815fd3e58a7589eb1ea30765be2	830105fc721cd815fd3e58a7589eb1ea30765be2	0	1638	t	96	Evolution	Evolution	{}	high	\N	\N	978
Classic Speed Blackjack 58	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4b873875adc8dadf4de479b48de768177bcd85f7.png	t	t	4b873875adc8dadf4de479b48de768177bcd85f7	4b873875adc8dadf4de479b48de768177bcd85f7	0	838	t	96	Evolution	Evolution	{}	low	\N	\N	979
Classic Speed Blackjack 59	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/11a3244c966ecc971a88aead0db369887213220c.png	t	t	11a3244c966ecc971a88aead0db369887213220c	11a3244c966ecc971a88aead0db369887213220c	0	838	t	96	Evolution	Evolution	{}	high	\N	\N	980
Classic Speed Blackjack 60	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/15619a29b0884755990b10a42bc89136a40b5b10.png	t	t	15619a29b0884755990b10a42bc89136a40b5b10	15619a29b0884755990b10a42bc89136a40b5b10	0	10140	t	96	Evolution	Evolution	{}	very-high	\N	\N	981
Classic Speed Blackjack 61	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4eb0f7b9aeb0230d3ded45a0435682ee2f13441c.png	t	t	4eb0f7b9aeb0230d3ded45a0435682ee2f13441c	4eb0f7b9aeb0230d3ded45a0435682ee2f13441c	0	2289	t	96	Evolution	Evolution	{}	high	\N	\N	982
Classic Speed Blackjack 62	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/dc82a5951c087e06585561323e7f72eb543086d0.png	t	t	dc82a5951c087e06585561323e7f72eb543086d0	dc82a5951c087e06585561323e7f72eb543086d0	0	1389	t	96	Evolution	Evolution	{}	medium	\N	\N	983
Classic Speed Blackjack 63	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ca98048dd6236af2064f28e7ec0d40886d8327c6.png	f	f	ca98048dd6236af2064f28e7ec0d40886d8327c6	ca98048dd6236af2064f28e7ec0d40886d8327c6	0	1139	t	96	Evolution	Evolution	{}	low	\N	\N	984
Classic Speed Blackjack 64	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/7054b26056f6464bde31e4fac1ce744ecd5b8e7b.png	t	t	7054b26056f6464bde31e4fac1ce744ecd5b8e7b	7054b26056f6464bde31e4fac1ce744ecd5b8e7b	0	2639	t	96	Evolution	Evolution	{}	medium-high	\N	\N	985
Classic Speed Blackjack 65	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8c1d6d2fe82af15ac9e3c09345dfcdc25ee766a1.png	t	t	8c1d6d2fe82af15ac9e3c09345dfcdc25ee766a1	8c1d6d2fe82af15ac9e3c09345dfcdc25ee766a1	0	1639	t	96	Evolution	Evolution	{}	high	\N	\N	986
Classic Speed Blackjack 66	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/38eb53937bb0ef1150d177aeddd00ab1daebc55a.png	t	t	38eb53937bb0ef1150d177aeddd00ab1daebc55a	38eb53937bb0ef1150d177aeddd00ab1daebc55a	0	839	t	96	Evolution	Evolution	{}	low	\N	\N	987
Free Bet Blackjack	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4aaa92e30014adc1345ca3e8503bd8e478aa4a9d.png	t	t	4aaa92e30014adc1345ca3e8503bd8e478aa4a9d	4aaa92e30014adc1345ca3e8503bd8e478aa4a9d	0	839	t	96	Evolution	Evolution	{}	high	\N	\N	988
Power Blackjack	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/81c09f4678c04b7b1d032d8f7d706e223baed4ff.png	t	t	81c09f4678c04b7b1d032d8f7d706e223baed4ff	81c09f4678c04b7b1d032d8f7d706e223baed4ff	0	10141	t	96	Evolution	Evolution	{}	very-high	\N	\N	989
Infinite Blackjack	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/805d3d0267a195ce9d3d55e4be8648dbc29d84f3.png	t	t	805d3d0267a195ce9d3d55e4be8648dbc29d84f3	805d3d0267a195ce9d3d55e4be8648dbc29d84f3	0	2290	t	96	Evolution	Evolution	{}	high	\N	\N	990
Blackjack Classic 8	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/83eb89deb4f5b8ed0b6f74adddf119668261772a.png	t	t	83eb89deb4f5b8ed0b6f74adddf119668261772a	83eb89deb4f5b8ed0b6f74adddf119668261772a	0	1390	t	96	Evolution	Evolution	{}	medium	\N	\N	991
Bingo Samba Rio	basic	https://gis-static.com/games/Caleta/a09dc0ad25ef4d20b7969d57e3de96b9.png	t	t	a09dc0ad25ef4d20b7969d57e3de96b9	a09dc0ad25ef4d20b7969d57e3de96b9	0	720	t	96	Caleta	Caleta	{}	high	\N	\N	130
Blackjack Classic 9	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c9de13abc228ba06cf7b599f0bfb24920b6cbda1.png	f	f	c9de13abc228ba06cf7b599f0bfb24920b6cbda1	c9de13abc228ba06cf7b599f0bfb24920b6cbda1	0	1140	t	96	Evolution	Evolution	{}	low	\N	\N	992
Blackjack Classic 17	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/32f994014d543b1f4b6d140e23f60e724b45b8c2.png	t	t	32f994014d543b1f4b6d140e23f60e724b45b8c2	32f994014d543b1f4b6d140e23f60e724b45b8c2	0	2640	t	96	Evolution	Evolution	{}	medium-high	\N	\N	993
Keno Neon	basic	https://gis-static.com/games/TripleProfitsGames/bc9a7f86212d4b59967390e1cc2377c1.png	f	f	bc9a7f86212d4b59967390e1cc2377c1	bc9a7f86212d4b59967390e1cc2377c1	0	1024	t	96	TripleProfitsGames	TripleProfitsGames	{}	low	\N	\N	151
Blackjack Classic 18	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/bca2a91e739d5faf4e0587cd5da40af60bbe0f01.png	t	t	bca2a91e739d5faf4e0587cd5da40af60bbe0f01	bca2a91e739d5faf4e0587cd5da40af60bbe0f01	0	1640	t	96	Evolution	Evolution	{}	high	\N	\N	994
Blackjack Classic 20	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/cffc78edc09c8e1132c0512cfc454596766f8735.png	t	t	cffc78edc09c8e1132c0512cfc454596766f8735	cffc78edc09c8e1132c0512cfc454596766f8735	0	840	t	96	Evolution	Evolution	{}	low	\N	\N	995
Blackjack Classic 24	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/2437440cdf3bdaf6c56dfc37e129eb346a0997de.png	t	t	2437440cdf3bdaf6c56dfc37e129eb346a0997de	2437440cdf3bdaf6c56dfc37e129eb346a0997de	0	840	t	96	Evolution	Evolution	{}	high	\N	\N	996
Blackjack Classic 25	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/fcbe22c167d2e7eaaea82783b779eb36c9d569bc.png	t	t	fcbe22c167d2e7eaaea82783b779eb36c9d569bc	fcbe22c167d2e7eaaea82783b779eb36c9d569bc	0	10142	t	96	Evolution	Evolution	{}	very-high	\N	\N	997
Blackjack Classic 26	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/5f2ffeea4e2849382fbcae346801be547ba7441d.png	t	t	5f2ffeea4e2849382fbcae346801be547ba7441d	5f2ffeea4e2849382fbcae346801be547ba7441d	0	2291	t	96	Evolution	Evolution	{}	high	\N	\N	998
Blackjack Classic 29	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/47979645508e596ea8233bef9526fc0283e5c85e.png	t	t	47979645508e596ea8233bef9526fc0283e5c85e	47979645508e596ea8233bef9526fc0283e5c85e	0	1391	t	96	Evolution	Evolution	{}	medium	\N	\N	999
Blackjack Classic 30	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/648562bc7612da9697752ad7a1d280d8e022740e.png	f	f	648562bc7612da9697752ad7a1d280d8e022740e	648562bc7612da9697752ad7a1d280d8e022740e	0	1141	t	96	Evolution	Evolution	{}	low	\N	\N	1000
Blackjack Classic 35	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/cd6bf7b52a3d6abeff55e011bc647ac220cc5fb6.png	t	t	cd6bf7b52a3d6abeff55e011bc647ac220cc5fb6	cd6bf7b52a3d6abeff55e011bc647ac220cc5fb6	0	2641	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1001
Blackjack Classic 43	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6520ef442c9700fa2d3a1b0030de9abe7dd3c3ba.png	t	t	6520ef442c9700fa2d3a1b0030de9abe7dd3c3ba	6520ef442c9700fa2d3a1b0030de9abe7dd3c3ba	0	1641	t	96	Evolution	Evolution	{}	high	\N	\N	1002
Blackjack Classic 44	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/58d53a52fdef1cd9b5cea024a000e2daf292baae.png	t	t	58d53a52fdef1cd9b5cea024a000e2daf292baae	58d53a52fdef1cd9b5cea024a000e2daf292baae	0	841	t	96	Evolution	Evolution	{}	low	\N	\N	1003
Blackjack Classic 45	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ae301ce1d2685db755e3a2e962d7018b22a8ae24.png	t	t	ae301ce1d2685db755e3a2e962d7018b22a8ae24	ae301ce1d2685db755e3a2e962d7018b22a8ae24	0	841	t	96	Evolution	Evolution	{}	high	\N	\N	1004
Blackjack Classic 46	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/bc318dca298811f2633c19348548429cb2a0be5a.png	t	t	bc318dca298811f2633c19348548429cb2a0be5a	bc318dca298811f2633c19348548429cb2a0be5a	0	10143	t	96	Evolution	Evolution	{}	very-high	\N	\N	1005
Blackjack Classic 47	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/00ab431096ac45c02539a045f65e05d1d7532e2c.png	t	t	00ab431096ac45c02539a045f65e05d1d7532e2c	00ab431096ac45c02539a045f65e05d1d7532e2c	0	2292	t	96	Evolution	Evolution	{}	high	\N	\N	1006
Blackjack Classic 48	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a84f8eba27cdec986b44d5f8aa4307c0eef1df1c.png	t	t	a84f8eba27cdec986b44d5f8aa4307c0eef1df1c	a84f8eba27cdec986b44d5f8aa4307c0eef1df1c	0	1392	t	96	Evolution	Evolution	{}	medium	\N	\N	1007
Blackjack Classic 49	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8bdb475a1b13c1220d01a6ca7326b8b697cf1c94.png	f	f	8bdb475a1b13c1220d01a6ca7326b8b697cf1c94	8bdb475a1b13c1220d01a6ca7326b8b697cf1c94	0	1142	t	96	Evolution	Evolution	{}	low	\N	\N	1008
Blackjack Classic 76	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/0f74d4e877932f1d185db5fbe92d557ccb9ecc54.png	t	t	0f74d4e877932f1d185db5fbe92d557ccb9ecc54	0f74d4e877932f1d185db5fbe92d557ccb9ecc54	0	845	t	96	Evolution	Evolution	{}	low	\N	\N	1035
Blackjack Classic 50	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/91614eb4d6a033b99fba9c1320a328e9f740e519.png	t	t	91614eb4d6a033b99fba9c1320a328e9f740e519	91614eb4d6a033b99fba9c1320a328e9f740e519	0	2642	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1009
Blackjack Classic 51	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a5e3cf7a7a59f1d4af82c8ef1fe486843acc2590.png	t	t	a5e3cf7a7a59f1d4af82c8ef1fe486843acc2590	a5e3cf7a7a59f1d4af82c8ef1fe486843acc2590	0	1642	t	96	Evolution	Evolution	{}	high	\N	\N	1010
Blackjack Classic 52	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/23b9ba2d6230e52df203dc83796bcd751b39f037.png	t	t	23b9ba2d6230e52df203dc83796bcd751b39f037	23b9ba2d6230e52df203dc83796bcd751b39f037	0	842	t	96	Evolution	Evolution	{}	low	\N	\N	1011
Blackjack Classic 53	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c9caaca57cefdcc3e1c562ff2f23f0aa1a04f2da.png	t	t	c9caaca57cefdcc3e1c562ff2f23f0aa1a04f2da	c9caaca57cefdcc3e1c562ff2f23f0aa1a04f2da	0	842	t	96	Evolution	Evolution	{}	high	\N	\N	1012
Blackjack Classic 54	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ee4ff32da54f50e7560ae248bd84b0adefa08846.png	t	t	ee4ff32da54f50e7560ae248bd84b0adefa08846	ee4ff32da54f50e7560ae248bd84b0adefa08846	0	10144	t	96	Evolution	Evolution	{}	very-high	\N	\N	1013
Lucky Crumbling	basic	https://gis-static.com/games/5503c58aeaa5a937ec8a6a190725240961cf1f26.png	t	t	5503c58aeaa5a937ec8a6a190725240961cf1f26	5503c58aeaa5a937ec8a6a190725240961cf1f26	0	1278	t	96	Evoplay	Evoplay	{}	medium	\N	\N	181
Classic Wheel	basic	https://gis-static.com/games/96cec95a3ddf81426a9f8baa2324ad4fab797f24.png	f	f	96cec95a3ddf81426a9f8baa2324ad4fab797f24	96cec95a3ddf81426a9f8baa2324ad4fab797f24	0	1028	t	96	Betgames	Betgames	{}	low	\N	\N	182
Penalty Series	basic	https://gis-static.com/games/fa611fb5296929fb8815a74fc724d0fc9d4a475c.png	t	t	fa611fb5296929fb8815a74fc724d0fc9d4a475c	fa611fb5296929fb8815a74fc724d0fc9d4a475c	0	2528	t	96	Evoplay	Evoplay	{}	medium-high	\N	\N	183
Teen Patti 20-20	basic	https://gis-static.com/games/7bcc5e3ecb8c2de6e1f259c30d8e7c9b1281698f.png	t	t	7bcc5e3ecb8c2de6e1f259c30d8e7c9b1281698f	7bcc5e3ecb8c2de6e1f259c30d8e7c9b1281698f	0	1528	t	96	OneTouch	OneTouch	{}	high	\N	\N	184
Blackjack Classic 55	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/866436e34446582d8dfe8ff1ff219e5735ce2fb7.png	t	t	866436e34446582d8dfe8ff1ff219e5735ce2fb7	866436e34446582d8dfe8ff1ff219e5735ce2fb7	0	2293	t	96	Evolution	Evolution	{}	high	\N	\N	1014
Blackjack Classic 56	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ade8378cc32cae98350bf70aa3c9af5cfefef00c.png	t	t	ade8378cc32cae98350bf70aa3c9af5cfefef00c	ade8378cc32cae98350bf70aa3c9af5cfefef00c	0	1393	t	96	Evolution	Evolution	{}	medium	\N	\N	1015
Blackjack Classic 57	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/03151b80ac1a35ed58b7b0258ec4aaef08a2c937.png	f	f	03151b80ac1a35ed58b7b0258ec4aaef08a2c937	03151b80ac1a35ed58b7b0258ec4aaef08a2c937	0	1143	t	96	Evolution	Evolution	{}	low	\N	\N	1016
Blackjack Classic 58	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/b6d3da829a406675664a19be184cad4a3104af15.png	t	t	b6d3da829a406675664a19be184cad4a3104af15	b6d3da829a406675664a19be184cad4a3104af15	0	2643	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1017
Blackjack Classic 59	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3a632353b369290b38f3eb4b8d1b030ee0cead8b.png	t	t	3a632353b369290b38f3eb4b8d1b030ee0cead8b	3a632353b369290b38f3eb4b8d1b030ee0cead8b	0	1643	t	96	Evolution	Evolution	{}	high	\N	\N	1018
Blackjack Classic 60	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/48d8946e761b3e57a81c1927e524e647498a204b.png	t	t	48d8946e761b3e57a81c1927e524e647498a204b	48d8946e761b3e57a81c1927e524e647498a204b	0	843	t	96	Evolution	Evolution	{}	low	\N	\N	1019
Blackjack Classic 61	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/b002d7f9e28608ad7fc30d2789517dcf4e2a2cc7.png	t	t	b002d7f9e28608ad7fc30d2789517dcf4e2a2cc7	b002d7f9e28608ad7fc30d2789517dcf4e2a2cc7	0	843	t	96	Evolution	Evolution	{}	high	\N	\N	1020
Blackjack Classic 62	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/86e7cf8a85b44a47eca3ebcc231ca4124907691e.png	t	t	86e7cf8a85b44a47eca3ebcc231ca4124907691e	86e7cf8a85b44a47eca3ebcc231ca4124907691e	0	10145	t	96	Evolution	Evolution	{}	very-high	\N	\N	1021
Blackjack Classic 63	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d361d59dfc337da295c9759ed4dd26a78df30252.png	t	t	d361d59dfc337da295c9759ed4dd26a78df30252	d361d59dfc337da295c9759ed4dd26a78df30252	0	2294	t	96	Evolution	Evolution	{}	high	\N	\N	1022
Blackjack Classic 64	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8976f9a4f5e93ecad8a3cfa80cf77778348ee664.png	t	t	8976f9a4f5e93ecad8a3cfa80cf77778348ee664	8976f9a4f5e93ecad8a3cfa80cf77778348ee664	0	1394	t	96	Evolution	Evolution	{}	medium	\N	\N	1023
Blackjack Classic 65	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/0cf85dff0c977ea88802f8b3089983ba107565e0.png	f	f	0cf85dff0c977ea88802f8b3089983ba107565e0	0cf85dff0c977ea88802f8b3089983ba107565e0	0	1144	t	96	Evolution	Evolution	{}	low	\N	\N	1024
Blackjack Classic 66	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/53114d06e7fe0092d8b080077dc8f19aaa6c650a.png	t	t	53114d06e7fe0092d8b080077dc8f19aaa6c650a	53114d06e7fe0092d8b080077dc8f19aaa6c650a	0	2644	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1025
Blackjack Classic 67	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6d29f4981db5a4ee5d8c5f0911ad5ab7e2571f9b.png	t	t	6d29f4981db5a4ee5d8c5f0911ad5ab7e2571f9b	6d29f4981db5a4ee5d8c5f0911ad5ab7e2571f9b	0	1644	t	96	Evolution	Evolution	{}	high	\N	\N	1026
Blackjack Classic 68	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/2c6f681b4729517403212e124ba25e2b9cccd21b.png	t	t	2c6f681b4729517403212e124ba25e2b9cccd21b	2c6f681b4729517403212e124ba25e2b9cccd21b	0	844	t	96	Evolution	Evolution	{}	low	\N	\N	1027
Blackjack Classic 69	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c671ebf353643f8c38a482d8f29c71ff2754b53a.png	t	t	c671ebf353643f8c38a482d8f29c71ff2754b53a	c671ebf353643f8c38a482d8f29c71ff2754b53a	0	844	t	96	Evolution	Evolution	{}	high	\N	\N	1028
Blackjack Classic 70	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a34f915e3f56cec7adf9b8db107a98bb73211729.png	t	t	a34f915e3f56cec7adf9b8db107a98bb73211729	a34f915e3f56cec7adf9b8db107a98bb73211729	0	10146	t	96	Evolution	Evolution	{}	very-high	\N	\N	1029
Blackjack Classic 71	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d2654a788e6993437187d693a6a8abfb19a1931b.png	t	t	d2654a788e6993437187d693a6a8abfb19a1931b	d2654a788e6993437187d693a6a8abfb19a1931b	0	2295	t	96	Evolution	Evolution	{}	high	\N	\N	1030
Blackjack Classic 72	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/13345fb3668831419497c87c8c1f61f918033d6d.png	t	t	13345fb3668831419497c87c8c1f61f918033d6d	13345fb3668831419497c87c8c1f61f918033d6d	0	1395	t	96	Evolution	Evolution	{}	medium	\N	\N	1031
Blackjack Classic 73	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/101a6f3df5b510ebb6f6ce10614e2bc71f62068e.png	f	f	101a6f3df5b510ebb6f6ce10614e2bc71f62068e	101a6f3df5b510ebb6f6ce10614e2bc71f62068e	0	1145	t	96	Evolution	Evolution	{}	low	\N	\N	1032
Blackjack Classic 74	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/66e3f88eefa65644e7c10226325860661cd83599.png	t	t	66e3f88eefa65644e7c10226325860661cd83599	66e3f88eefa65644e7c10226325860661cd83599	0	2645	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1033
Blackjack Classic 77	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d3c241f03222c89e2fd6eb025148c97962ca0eb6.png	t	t	d3c241f03222c89e2fd6eb025148c97962ca0eb6	d3c241f03222c89e2fd6eb025148c97962ca0eb6	0	845	t	96	Evolution	Evolution	{}	high	\N	\N	1036
Blackjack Classic 78	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/78e4af72cd9a94cf33b08398da80e14837b49bce.png	t	t	78e4af72cd9a94cf33b08398da80e14837b49bce	78e4af72cd9a94cf33b08398da80e14837b49bce	0	10147	t	96	Evolution	Evolution	{}	very-high	\N	\N	1037
Blackjack Classic 79	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3c823b25d2bee3a9e8fc99068e831961e32b9024.png	t	t	3c823b25d2bee3a9e8fc99068e831961e32b9024	3c823b25d2bee3a9e8fc99068e831961e32b9024	0	2296	t	96	Evolution	Evolution	{}	high	\N	\N	1038
Blackjack Classic 80	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/fbf14a5b597d31db2ce4d00796ac895fc6200c92.png	t	t	fbf14a5b597d31db2ce4d00796ac895fc6200c92	fbf14a5b597d31db2ce4d00796ac895fc6200c92	0	1396	t	96	Evolution	Evolution	{}	medium	\N	\N	1039
Blackjack Classic 81	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3b3e696c1da5d4e56f22d5be70e2ec3d1841e6e0.png	f	f	3b3e696c1da5d4e56f22d5be70e2ec3d1841e6e0	3b3e696c1da5d4e56f22d5be70e2ec3d1841e6e0	0	1146	t	96	Evolution	Evolution	{}	low	\N	\N	1040
Blackjack Classic 7	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c8d629b73bbf97a4abafa5acf9d2123f003ff985.png	t	t	c8d629b73bbf97a4abafa5acf9d2123f003ff985	c8d629b73bbf97a4abafa5acf9d2123f003ff985	0	2646	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1041
Classic Speed Blackjack 7	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/09684ad58013e67f1ec18319487fdbc92b0d9e86.png	t	t	09684ad58013e67f1ec18319487fdbc92b0d9e86	09684ad58013e67f1ec18319487fdbc92b0d9e86	0	2347	t	96	Evolution	Evolution	{}	high	\N	\N	1042
Classic Speed Blackjack 20	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d24bbc6a26e4a8af393f545788b905a9ab51b01f.png	t	t	d24bbc6a26e4a8af393f545788b905a9ab51b01f	d24bbc6a26e4a8af393f545788b905a9ab51b01f	0	1646	t	96	Evolution	Evolution	{}	high	\N	\N	1043
Classic Speed Blackjack 25	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6ef48cf13eeff581518882eb6f957836a7cb6857.png	t	t	6ef48cf13eeff581518882eb6f957836a7cb6857	6ef48cf13eeff581518882eb6f957836a7cb6857	0	846	t	96	Evolution	Evolution	{}	low	\N	\N	1044
Blackjack A	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/57d707c1da9b02a54f5e4b7551b92649d3cf6593.png	t	t	57d707c1da9b02a54f5e4b7551b92649d3cf6593	57d707c1da9b02a54f5e4b7551b92649d3cf6593	0	846	t	96	Evolution	Evolution	{}	high	\N	\N	1045
Blackjack B	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/955dbfc3726ad0f42c7e30dd6aa3bd824937a101.png	t	t	955dbfc3726ad0f42c7e30dd6aa3bd824937a101	955dbfc3726ad0f42c7e30dd6aa3bd824937a101	0	10148	t	96	Evolution	Evolution	{}	very-high	\N	\N	1046
Speed Blackjack K	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e653938fda6463130ce5adbbf53ca8a6a15449c4.png	t	t	e653938fda6463130ce5adbbf53ca8a6a15449c4	e653938fda6463130ce5adbbf53ca8a6a15449c4	0	2297	t	96	Evolution	Evolution	{}	high	\N	\N	1047
Blackjack Party	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d47ce81523f8f329cca8a3d92cd7c36a6271c62a.png	t	t	d47ce81523f8f329cca8a3d92cd7c36a6271c62a	d47ce81523f8f329cca8a3d92cd7c36a6271c62a	0	1397	t	96	Evolution	Evolution	{}	medium	\N	\N	1048
Speed VIP Blackjack A	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/26ebe60e88bd36082b3063637527b3a23f8b0c19.png	f	f	26ebe60e88bd36082b3063637527b3a23f8b0c19	26ebe60e88bd36082b3063637527b3a23f8b0c19	0	1147	t	96	Evolution	Evolution	{}	low	\N	\N	1049
Speed VIP Blackjack B	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ceb69dce9a364faf902ad2738d009e034b1a33a8.png	t	t	ceb69dce9a364faf902ad2738d009e034b1a33a8	ceb69dce9a364faf902ad2738d009e034b1a33a8	0	2647	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1050
Speed VIP Blackjack C	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c63de698e975eb4ff05189433cd9ed8e650ee843.png	t	t	c63de698e975eb4ff05189433cd9ed8e650ee843	c63de698e975eb4ff05189433cd9ed8e650ee843	0	1647	t	96	Evolution	Evolution	{}	high	\N	\N	1051
Speed VIP Blackjack D	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/bcc603738edda529b8cc218b2f0a696f421cf4fd.png	t	t	bcc603738edda529b8cc218b2f0a696f421cf4fd	bcc603738edda529b8cc218b2f0a696f421cf4fd	0	847	t	96	Evolution	Evolution	{}	low	\N	\N	1052
Baccarat BB	basic	https://gis-static.com/games/BarbaraBang/25cbdf7b82824296b8a8a2164ba79bdd.png	t	t	25cbdf7b82824296b8a8a2164ba79bdd	25cbdf7b82824296b8a8a2164ba79bdd	0	10187	t	96	BarbaraBang	BarbaraBang	{}	very-high	\N	\N	1360
Speed VIP Blackjack E	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8c18941b6abea9330365f70e010c8caa74aa37a9.png	t	t	8c18941b6abea9330365f70e010c8caa74aa37a9	8c18941b6abea9330365f70e010c8caa74aa37a9	0	847	t	96	Evolution	Evolution	{}	high	\N	\N	1053
Speed VIP Blackjack F	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3025ec399c08767461b17a293f9faac96b369449.png	t	t	3025ec399c08767461b17a293f9faac96b369449	3025ec399c08767461b17a293f9faac96b369449	0	10149	t	96	Evolution	Evolution	{}	very-high	\N	\N	1054
Speed VIP Blackjack G	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d337183e6ee75933e6ce10e1d35371e81617a4ae.png	t	t	d337183e6ee75933e6ce10e1d35371e81617a4ae	d337183e6ee75933e6ce10e1d35371e81617a4ae	0	2298	t	96	Evolution	Evolution	{}	high	\N	\N	1055
Blackjack VIP 1	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e72af92ea163e23171c71cb6925c6482d1dc9a4c.png	t	t	e72af92ea163e23171c71cb6925c6482d1dc9a4c	e72af92ea163e23171c71cb6925c6482d1dc9a4c	0	1398	t	96	Evolution	Evolution	{}	medium	\N	\N	1056
Blackjack VIP 2	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c7a2218fbf200131adbc4d3a6c2763585ab2bdff.png	f	f	c7a2218fbf200131adbc4d3a6c2763585ab2bdff	c7a2218fbf200131adbc4d3a6c2763585ab2bdff	0	1148	t	96	Evolution	Evolution	{}	low	\N	\N	1057
Blackjack VIP 3	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/f02ca1a0beef6964634b4086fb79da2c3a0fc6dd.png	t	t	f02ca1a0beef6964634b4086fb79da2c3a0fc6dd	f02ca1a0beef6964634b4086fb79da2c3a0fc6dd	0	2648	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1058
Blackjack VIP 4	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/7ef28b9ed9a48576972dd448b048299d47680eba.png	t	t	7ef28b9ed9a48576972dd448b048299d47680eba	7ef28b9ed9a48576972dd448b048299d47680eba	0	1648	t	96	Evolution	Evolution	{}	high	\N	\N	1059
Blackjack VIP 5	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c24c6d718ebaeff7ada3886e3114f32d24713dd8.png	t	t	c24c6d718ebaeff7ada3886e3114f32d24713dd8	c24c6d718ebaeff7ada3886e3114f32d24713dd8	0	848	t	96	Evolution	Evolution	{}	low	\N	\N	1060
Blackjack VIP 6	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c58e9ab134e91e98a1925221584b8e1823166e0d.png	t	t	c58e9ab134e91e98a1925221584b8e1823166e0d	c58e9ab134e91e98a1925221584b8e1823166e0d	0	848	t	96	Evolution	Evolution	{}	high	\N	\N	1061
Blackjack VIP 7	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/effe21dfd2f7fb30ca6e575f8a90e5e86af9f0ee.png	t	t	effe21dfd2f7fb30ca6e575f8a90e5e86af9f0ee	effe21dfd2f7fb30ca6e575f8a90e5e86af9f0ee	0	10150	t	96	Evolution	Evolution	{}	very-high	\N	\N	1062
Blackjack VIP 8	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/83cc96023c73e8938b98043d2dc814f20341c71d.png	t	t	83cc96023c73e8938b98043d2dc814f20341c71d	83cc96023c73e8938b98043d2dc814f20341c71d	0	2299	t	96	Evolution	Evolution	{}	high	\N	\N	1063
Blackjack VIP 9	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/cfb3e2f978407c59278ffe0f498dd0498958b1b4.png	t	t	cfb3e2f978407c59278ffe0f498dd0498958b1b4	cfb3e2f978407c59278ffe0f498dd0498958b1b4	0	1399	t	96	Evolution	Evolution	{}	medium	\N	\N	1064
Blackjack VIP 10	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/344a142657c094c5cdf3cc6256ce836e22d1c0a5.png	f	f	344a142657c094c5cdf3cc6256ce836e22d1c0a5	344a142657c094c5cdf3cc6256ce836e22d1c0a5	0	1149	t	96	Evolution	Evolution	{}	low	\N	\N	1065
Blackjack VIP 11	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d525a2c598dfeb9591a9f9ce61359ec288666dc4.png	t	t	d525a2c598dfeb9591a9f9ce61359ec288666dc4	d525a2c598dfeb9591a9f9ce61359ec288666dc4	0	2649	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1066
Blackjack VIP 12	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/85884426f4a4abfda72cf93aac9dd6b977f3106a.png	t	t	85884426f4a4abfda72cf93aac9dd6b977f3106a	85884426f4a4abfda72cf93aac9dd6b977f3106a	0	1649	t	96	Evolution	Evolution	{}	high	\N	\N	1067
Blackjack VIP 13	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/edc3e1bebf6371e870c0eedc738df7b527007e1d.png	t	t	edc3e1bebf6371e870c0eedc738df7b527007e1d	edc3e1bebf6371e870c0eedc738df7b527007e1d	0	849	t	96	Evolution	Evolution	{}	low	\N	\N	1068
Blackjack VIP 14	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/f9a79abbf4491d395370747f54f9e43e33bb54ba.png	t	t	f9a79abbf4491d395370747f54f9e43e33bb54ba	f9a79abbf4491d395370747f54f9e43e33bb54ba	0	849	t	96	Evolution	Evolution	{}	high	\N	\N	1069
Blackjack VIP 15	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8605c6ba777a6f2a30734937e64f3834fb2ed276.png	t	t	8605c6ba777a6f2a30734937e64f3834fb2ed276	8605c6ba777a6f2a30734937e64f3834fb2ed276	0	10151	t	96	Evolution	Evolution	{}	very-high	\N	\N	1070
Blackjack VIP 16	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a2737f7430940bfaa68d9e9da38fa5331b58b12c.png	t	t	a2737f7430940bfaa68d9e9da38fa5331b58b12c	a2737f7430940bfaa68d9e9da38fa5331b58b12c	0	2300	t	96	Evolution	Evolution	{}	high	\N	\N	1071
Blackjack VIP 17	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8c1a84052623a5856190d6aa865c9ac03b43965b.png	t	t	8c1a84052623a5856190d6aa865c9ac03b43965b	8c1a84052623a5856190d6aa865c9ac03b43965b	0	1400	t	96	Evolution	Evolution	{}	medium	\N	\N	1072
Blackjack VIP 18	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/cc9e044ab449737325eb5ac01c812a3727e9cf33.png	f	f	cc9e044ab449737325eb5ac01c812a3727e9cf33	cc9e044ab449737325eb5ac01c812a3727e9cf33	0	1150	t	96	Evolution	Evolution	{}	low	\N	\N	1073
Blackjack VIP 19	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d717d64257e213caf7b80c97f540ecdf14863ffa.png	t	t	d717d64257e213caf7b80c97f540ecdf14863ffa	d717d64257e213caf7b80c97f540ecdf14863ffa	0	2650	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1074
Blackjack C	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/9ae2724e2c9e00424c928f1a9257fb7652f30143.png	t	t	9ae2724e2c9e00424c928f1a9257fb7652f30143	9ae2724e2c9e00424c928f1a9257fb7652f30143	0	1650	t	96	Evolution	Evolution	{}	high	\N	\N	1075
Speed Blackjack L	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/114e2a8bed11ad6688455d03702f9f698eb243a2.png	t	t	114e2a8bed11ad6688455d03702f9f698eb243a2	114e2a8bed11ad6688455d03702f9f698eb243a2	0	850	t	96	Evolution	Evolution	{}	low	\N	\N	1076
Speed Blackjack D	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/38aaf34ec025a0d363bdb8ad91be0daa08c2e3ac.png	t	t	38aaf34ec025a0d363bdb8ad91be0daa08c2e3ac	38aaf34ec025a0d363bdb8ad91be0daa08c2e3ac	0	850	t	96	Evolution	Evolution	{}	high	\N	\N	1077
Speed Blackjack M	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/9d1d759504b5e9aa37d7839e05598ca8a0784dfc.png	t	t	9d1d759504b5e9aa37d7839e05598ca8a0784dfc	9d1d759504b5e9aa37d7839e05598ca8a0784dfc	0	10152	t	96	Evolution	Evolution	{}	very-high	\N	\N	1078
Speed Blackjack E	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/b4dd5208d3bcfe8805bddb6d3ab2e54e289588fc.png	t	t	b4dd5208d3bcfe8805bddb6d3ab2e54e289588fc	b4dd5208d3bcfe8805bddb6d3ab2e54e289588fc	0	2301	t	96	Evolution	Evolution	{}	high	\N	\N	1079
Speed Blackjack G	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/181449aff0a9e75fa5042ddf2c36a9280d762c80.png	t	t	181449aff0a9e75fa5042ddf2c36a9280d762c80	181449aff0a9e75fa5042ddf2c36a9280d762c80	0	1401	t	96	Evolution	Evolution	{}	medium	\N	\N	1080
Speed Blackjack H	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/01c648a72c096082b7f8892a8d15a8a084607a62.png	f	f	01c648a72c096082b7f8892a8d15a8a084607a62	01c648a72c096082b7f8892a8d15a8a084607a62	0	1151	t	96	Evolution	Evolution	{}	low	\N	\N	1081
Speed Blackjack I	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ca866099d6fa887189263e529dbea98d09105f61.png	t	t	ca866099d6fa887189263e529dbea98d09105f61	ca866099d6fa887189263e529dbea98d09105f61	0	2651	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1082
Speed Blackjack J	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/f10c3e2f54a98c78077615095c93b97a406629b7.png	t	t	f10c3e2f54a98c78077615095c93b97a406629b7	f10c3e2f54a98c78077615095c93b97a406629b7	0	1651	t	96	Evolution	Evolution	{}	high	\N	\N	1083
Blackjack Silver A	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/dbe7baa2f5eca4a71d2d74dd55ee452db4277f04.png	t	t	dbe7baa2f5eca4a71d2d74dd55ee452db4277f04	dbe7baa2f5eca4a71d2d74dd55ee452db4277f04	0	851	t	96	Evolution	Evolution	{}	low	\N	\N	1084
Blackjack Silver B	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/444cbc05c73a97a27a53732f8598e337f003acae.png	t	t	444cbc05c73a97a27a53732f8598e337f003acae	444cbc05c73a97a27a53732f8598e337f003acae	0	851	t	96	Evolution	Evolution	{}	high	\N	\N	1085
Blackjack Silver C	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/192c3aad439ef261e4ee735e0b27b693ae234ffa.png	t	t	192c3aad439ef261e4ee735e0b27b693ae234ffa	192c3aad439ef261e4ee735e0b27b693ae234ffa	0	10153	t	96	Evolution	Evolution	{}	very-high	\N	\N	1086
Blackjack Silver D	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/75d9ebffa7e779c4bb3d3bfecd9cc4263e8ccff2.png	t	t	75d9ebffa7e779c4bb3d3bfecd9cc4263e8ccff2	75d9ebffa7e779c4bb3d3bfecd9cc4263e8ccff2	0	2302	t	96	Evolution	Evolution	{}	high	\N	\N	1087
Blackjack Silver E	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c1d98bde83e9529756d9eb6910006650d756d0aa.png	t	t	c1d98bde83e9529756d9eb6910006650d756d0aa	c1d98bde83e9529756d9eb6910006650d756d0aa	0	1402	t	96	Evolution	Evolution	{}	medium	\N	\N	1088
Blackjack Silver F	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6758a45a25f9cdf2e807bd57ea5e3db22eed5f7c.png	f	f	6758a45a25f9cdf2e807bd57ea5e3db22eed5f7c	6758a45a25f9cdf2e807bd57ea5e3db22eed5f7c	0	1152	t	96	Evolution	Evolution	{}	low	\N	\N	1089
Blackjack Silver G	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8dcadb4c7003156ef35ced3fbc67b3362a918542.png	t	t	8dcadb4c7003156ef35ced3fbc67b3362a918542	8dcadb4c7003156ef35ced3fbc67b3362a918542	0	2652	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1090
Blackjack VIP A	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e9e5d177fd2f44fce749f6b54e80803e1142b453.png	t	t	e9e5d177fd2f44fce749f6b54e80803e1142b453	e9e5d177fd2f44fce749f6b54e80803e1142b453	0	1652	t	96	Evolution	Evolution	{}	high	\N	\N	1091
Blackjack VIP B	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/55ec047300f074079f1afe122edcd43a5e119152.png	t	t	55ec047300f074079f1afe122edcd43a5e119152	55ec047300f074079f1afe122edcd43a5e119152	0	852	t	96	Evolution	Evolution	{}	low	\N	\N	1092
Blackjack VIP C	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/00e549cc6803f2aaf202ce8f06933811e1e0d784.png	t	t	00e549cc6803f2aaf202ce8f06933811e1e0d784	00e549cc6803f2aaf202ce8f06933811e1e0d784	0	852	t	96	Evolution	Evolution	{}	high	\N	\N	1093
Blackjack VIP D	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ada7644db431391fc490de73cf1bca311d39f443.png	t	t	ada7644db431391fc490de73cf1bca311d39f443	ada7644db431391fc490de73cf1bca311d39f443	0	10154	t	96	Evolution	Evolution	{}	very-high	\N	\N	1094
Blackjack VIP E	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/829f8e49929bc2dd9069b9b4a9d9931ae1e644f9.png	t	t	829f8e49929bc2dd9069b9b4a9d9931ae1e644f9	829f8e49929bc2dd9069b9b4a9d9931ae1e644f9	0	2303	t	96	Evolution	Evolution	{}	high	\N	\N	1095
Blackjack VIP F	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/1bf8a6ffb11a4f3e731c25d2c9886bbfd0570761.png	t	t	1bf8a6ffb11a4f3e731c25d2c9886bbfd0570761	1bf8a6ffb11a4f3e731c25d2c9886bbfd0570761	0	1403	t	96	Evolution	Evolution	{}	medium	\N	\N	1096
Blackjack VIP G	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/83e1a91745bd44b51c1bfe025802346b18416773.png	f	f	83e1a91745bd44b51c1bfe025802346b18416773	83e1a91745bd44b51c1bfe025802346b18416773	0	1153	t	96	Evolution	Evolution	{}	low	\N	\N	1097
Blackjack VIP H	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3a7a0f8b8a0cb9dddf400cb1351195428306b2ed.png	t	t	3a7a0f8b8a0cb9dddf400cb1351195428306b2ed	3a7a0f8b8a0cb9dddf400cb1351195428306b2ed	0	2653	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1098
Blackjack VIP I	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/0f909c6d21245c0af513838521146bfafd08dc05.png	t	t	0f909c6d21245c0af513838521146bfafd08dc05	0f909c6d21245c0af513838521146bfafd08dc05	0	1653	t	96	Evolution	Evolution	{}	high	\N	\N	1099
Blackjack VIP J	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/fb957d09b7af3f7fb45e4bf30c6d5dda31588abe.png	t	t	fb957d09b7af3f7fb45e4bf30c6d5dda31588abe	fb957d09b7af3f7fb45e4bf30c6d5dda31588abe	0	853	t	96	Evolution	Evolution	{}	low	\N	\N	1100
Blackjack VIP K	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/891e3ae90240a495e0293e299ebd250e16ccccd7.png	t	t	891e3ae90240a495e0293e299ebd250e16ccccd7	891e3ae90240a495e0293e299ebd250e16ccccd7	0	853	t	96	Evolution	Evolution	{}	high	\N	\N	1101
Blackjack VIP L	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/5402c31f4355fe4b768c77b2b618acef34926b62.png	t	t	5402c31f4355fe4b768c77b2b618acef34926b62	5402c31f4355fe4b768c77b2b618acef34926b62	0	10155	t	96	Evolution	Evolution	{}	very-high	\N	\N	1102
Blackjack VIP M	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a79b3c713e41f755b4baacd7007088c1b709c9e9.png	t	t	a79b3c713e41f755b4baacd7007088c1b709c9e9	a79b3c713e41f755b4baacd7007088c1b709c9e9	0	2304	t	96	Evolution	Evolution	{}	high	\N	\N	1103
Blackjack VIP N	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/9529616644d4dab68c625ba16c32be124649c76d.png	t	t	9529616644d4dab68c625ba16c32be124649c76d	9529616644d4dab68c625ba16c32be124649c76d	0	1404	t	96	Evolution	Evolution	{}	medium	\N	\N	1104
Blackjack VIP O	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d030ac9c4c977e48e67694c5cc24a2301af4199b.png	f	f	d030ac9c4c977e48e67694c5cc24a2301af4199b	d030ac9c4c977e48e67694c5cc24a2301af4199b	0	1154	t	96	Evolution	Evolution	{}	low	\N	\N	1105
Blackjack VIP P	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/752428e89191f43bf5f8972f5fb70bb06adc281f.png	t	t	752428e89191f43bf5f8972f5fb70bb06adc281f	752428e89191f43bf5f8972f5fb70bb06adc281f	0	2654	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1106
Blackjack VIP Q	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/336393a2f94db433f55a480892d8cf83033c3d61.png	t	t	336393a2f94db433f55a480892d8cf83033c3d61	336393a2f94db433f55a480892d8cf83033c3d61	0	1654	t	96	Evolution	Evolution	{}	high	\N	\N	1107
Blackjack VIP R	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d46e5b46c4788436e07da9f77cb2bd6bf16dcc3e.png	t	t	d46e5b46c4788436e07da9f77cb2bd6bf16dcc3e	d46e5b46c4788436e07da9f77cb2bd6bf16dcc3e	0	854	t	96	Evolution	Evolution	{}	low	\N	\N	1108
Blackjack VIP S	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8d0a24dda767eb9ac484420a69fc29f9bc46a95c.png	t	t	8d0a24dda767eb9ac484420a69fc29f9bc46a95c	8d0a24dda767eb9ac484420a69fc29f9bc46a95c	0	854	t	96	Evolution	Evolution	{}	high	\N	\N	1109
Blackjack VIP T	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ecc93a9d2890322dce3a03f9ba95eb67ce673508.png	t	t	ecc93a9d2890322dce3a03f9ba95eb67ce673508	ecc93a9d2890322dce3a03f9ba95eb67ce673508	0	10156	t	96	Evolution	Evolution	{}	very-high	\N	\N	1110
Blackjack VIP U	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/446fc3bf132af962294e52785ff7f444912cf7b9.png	t	t	446fc3bf132af962294e52785ff7f444912cf7b9	446fc3bf132af962294e52785ff7f444912cf7b9	0	2305	t	96	Evolution	Evolution	{}	high	\N	\N	1111
Blackjack VIP V	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ca6c9f780a6641fc2bbbe392a433dfb697ede6cf.png	t	t	ca6c9f780a6641fc2bbbe392a433dfb697ede6cf	ca6c9f780a6641fc2bbbe392a433dfb697ede6cf	0	1405	t	96	Evolution	Evolution	{}	medium	\N	\N	1112
Blackjack VIP X	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e3d31e6f79872619e88bed5977052ea04805cb44.png	f	f	e3d31e6f79872619e88bed5977052ea04805cb44	e3d31e6f79872619e88bed5977052ea04805cb44	0	1155	t	96	Evolution	Evolution	{}	low	\N	\N	1113
Roulette American Pro	basic	https://gis-static.com/games/341519daee586d87d6068a5f6c2a23bb81d7cd5a.png	t	t	341519daee586d87d6068a5f6c2a23bb81d7cd5a	341519daee586d87d6068a5f6c2a23bb81d7cd5a	0	744	t	96	Espressogames	Espressogames	{}	low	\N	\N	296
Blackjack VIP Z	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/44eb5fb1d4a3b42480dde1f6cbf299c1c0351d28.png	t	t	44eb5fb1d4a3b42480dde1f6cbf299c1c0351d28	44eb5fb1d4a3b42480dde1f6cbf299c1c0351d28	0	2655	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1114
Blackjack VIP Alpha	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/b73dd699709f7bc9f7a50e362eb6c24bd7d5afd3.png	t	t	b73dd699709f7bc9f7a50e362eb6c24bd7d5afd3	b73dd699709f7bc9f7a50e362eb6c24bd7d5afd3	0	1655	t	96	Evolution	Evolution	{}	high	\N	\N	1115
Blackjack VIP Beta	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/7c91c7fef4dc34beffe5ceed43286cf0bd563cbd.png	t	t	7c91c7fef4dc34beffe5ceed43286cf0bd563cbd	7c91c7fef4dc34beffe5ceed43286cf0bd563cbd	0	855	t	96	Evolution	Evolution	{}	low	\N	\N	1116
Blackjack VIP Gamma	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a3b8bb6e074d8285b9eae7f7b4a627ea59af63a4.png	t	t	a3b8bb6e074d8285b9eae7f7b4a627ea59af63a4	a3b8bb6e074d8285b9eae7f7b4a627ea59af63a4	0	855	t	96	Evolution	Evolution	{}	high	\N	\N	1117
Blackjack Platinum VIP	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/f3fd47dc4ef45cc4b97fc511ed324012024031d6.png	t	t	f3fd47dc4ef45cc4b97fc511ed324012024031d6	f3fd47dc4ef45cc4b97fc511ed324012024031d6	0	10157	t	96	Evolution	Evolution	{}	very-high	\N	\N	1118
Blackjack Fortune VIP	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/b657f73cd0c782c40edbeeb8bde95ee9c7cd0734.png	t	t	b657f73cd0c782c40edbeeb8bde95ee9c7cd0734	b657f73cd0c782c40edbeeb8bde95ee9c7cd0734	0	2306	t	96	Evolution	Evolution	{}	high	\N	\N	1119
Blackjack Grand VIP	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/9389c577d9f278a157d1389f7e610819d87d337f.png	t	t	9389c577d9f278a157d1389f7e610819d87d337f	9389c577d9f278a157d1389f7e610819d87d337f	0	1406	t	96	Evolution	Evolution	{}	medium	\N	\N	1120
Blackjack Diamond VIP	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/20386842aa7ba36147edbc1f49814924d8706228.png	f	f	20386842aa7ba36147edbc1f49814924d8706228	20386842aa7ba36147edbc1f49814924d8706228	0	1156	t	96	Evolution	Evolution	{}	low	\N	\N	1121
Salon Privé Blackjack A	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/bc9b960e1820ccf9d4a59034ce28f179d9df368f.png	t	t	bc9b960e1820ccf9d4a59034ce28f179d9df368f	bc9b960e1820ccf9d4a59034ce28f179d9df368f	0	2656	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1122
Salon Privé Blackjack B	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/050e3a97de40c9dff7971160b30269cbd9c217f9.png	t	t	050e3a97de40c9dff7971160b30269cbd9c217f9	050e3a97de40c9dff7971160b30269cbd9c217f9	0	1656	t	96	Evolution	Evolution	{}	high	\N	\N	1123
Salon Privé Blackjack C	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/42327e9436eb84bcd777a58149aec61caa575050.png	t	t	42327e9436eb84bcd777a58149aec61caa575050	42327e9436eb84bcd777a58149aec61caa575050	0	856	t	96	Evolution	Evolution	{}	low	\N	\N	1124
Salon Privé Blackjack D	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/dd48c5872585b6e3d55229de385256b5366d2de3.png	t	t	dd48c5872585b6e3d55229de385256b5366d2de3	dd48c5872585b6e3d55229de385256b5366d2de3	0	856	t	96	Evolution	Evolution	{}	high	\N	\N	1125
Salon Privé Blackjack E	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/96668ed0389e12f4ff5c4f7cb1948fe74945b826.png	t	t	96668ed0389e12f4ff5c4f7cb1948fe74945b826	96668ed0389e12f4ff5c4f7cb1948fe74945b826	0	10158	t	96	Evolution	Evolution	{}	very-high	\N	\N	1126
Salon Privé Blackjack F	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/dfbf7bdd3e55e08d130ca57dbbae5f5d79ddbfc8.png	t	t	dfbf7bdd3e55e08d130ca57dbbae5f5d79ddbfc8	dfbf7bdd3e55e08d130ca57dbbae5f5d79ddbfc8	0	2307	t	96	Evolution	Evolution	{}	high	\N	\N	1127
Lightning Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/47a3a0b7b6679059997c9518dbc7b7db957838a5.png	t	t	47a3a0b7b6679059997c9518dbc7b7db957838a5	47a3a0b7b6679059997c9518dbc7b7db957838a5	0	1407	t	96	Evolution	Evolution	{}	medium	\N	\N	1128
Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/b82c658f4b1403a2eba98b2375df60ee965e3fe6.png	f	f	b82c658f4b1403a2eba98b2375df60ee965e3fe6	b82c658f4b1403a2eba98b2375df60ee965e3fe6	0	1157	t	96	Evolution	Evolution	{}	low	\N	\N	1129
Immersive Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/fb73a2e4eadfee6d030b993246b366d67a66fb4e.png	t	t	fb73a2e4eadfee6d030b993246b366d67a66fb4e	fb73a2e4eadfee6d030b993246b366d67a66fb4e	0	2657	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1130
Instant Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/fde91629e1b343c78eca717aa7ed1f5a649236fd.png	t	t	fde91629e1b343c78eca717aa7ed1f5a649236fd	fde91629e1b343c78eca717aa7ed1f5a649236fd	0	1657	t	96	Evolution	Evolution	{}	high	\N	\N	1131
Auto-Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/5ea95af91adde51c37106baf92ad0829e1e22036.png	t	t	5ea95af91adde51c37106baf92ad0829e1e22036	5ea95af91adde51c37106baf92ad0829e1e22036	0	857	t	96	Evolution	Evolution	{}	low	\N	\N	1132
Speed Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/be4a9ec7618f51a16783e2af8b44ef1fa121d2b1.png	t	t	be4a9ec7618f51a16783e2af8b44ef1fa121d2b1	be4a9ec7618f51a16783e2af8b44ef1fa121d2b1	0	857	t	96	Evolution	Evolution	{}	high	\N	\N	1133
VIP Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/294637d7102ca123930190cca9ac7987842faabe.png	t	t	294637d7102ca123930190cca9ac7987842faabe	294637d7102ca123930190cca9ac7987842faabe	0	10159	t	96	Evolution	Evolution	{}	very-high	\N	\N	1134
Grand Casino Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e3ed5d6fa2d2ecfc52e505fba7d19337bc3d258f.png	t	t	e3ed5d6fa2d2ecfc52e505fba7d19337bc3d258f	e3ed5d6fa2d2ecfc52e505fba7d19337bc3d258f	0	2308	t	96	Evolution	Evolution	{}	high	\N	\N	1135
French Roulette Gold	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/1e9ef2ddc84189970524a6093a02bc7cb2d7cd3d.png	t	t	1e9ef2ddc84189970524a6093a02bc7cb2d7cd3d	1e9ef2ddc84189970524a6093a02bc7cb2d7cd3d	0	1408	t	96	Evolution	Evolution	{}	medium	\N	\N	1136
American Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/37fb3504dffb48802c3f609934b6c71de1f941fa.png	f	f	37fb3504dffb48802c3f609934b6c71de1f941fa	37fb3504dffb48802c3f609934b6c71de1f941fa	0	1158	t	96	Evolution	Evolution	{}	low	\N	\N	1137
Double Ball Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4ffe1905ebc4ca1712284f3d06d6a00946fd2394.png	t	t	4ffe1905ebc4ca1712284f3d06d6a00946fd2394	4ffe1905ebc4ca1712284f3d06d6a00946fd2394	0	2658	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1138
Speed Auto Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/26d67f56b501adb8d3dbf30b7823fc6788d3533f.png	t	t	26d67f56b501adb8d3dbf30b7823fc6788d3533f	26d67f56b501adb8d3dbf30b7823fc6788d3533f	0	1658	t	96	Evolution	Evolution	{}	high	\N	\N	1139
Auto-Roulette VIP	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6b42cc8dc058b6fddb7f3e80afa007cdc0a66675.png	t	t	6b42cc8dc058b6fddb7f3e80afa007cdc0a66675	6b42cc8dc058b6fddb7f3e80afa007cdc0a66675	0	858	t	96	Evolution	Evolution	{}	low	\N	\N	1140
Benelux Slingshot	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/93a559e86b5a0b4da0b6357a9b9b42400c857f42.png	t	t	93a559e86b5a0b4da0b6357a9b9b42400c857f42	93a559e86b5a0b4da0b6357a9b9b42400c857f42	0	858	t	96	Evolution	Evolution	{}	high	\N	\N	1141
London Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/69ad05a32a3cf6d09f0cdfa1482a6d58d74d1a76.png	t	t	69ad05a32a3cf6d09f0cdfa1482a6d58d74d1a76	69ad05a32a3cf6d09f0cdfa1482a6d58d74d1a76	0	10160	t	96	Evolution	Evolution	{}	very-high	\N	\N	1142
Salon Privé Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ca3c72232c27cd28adb91e79b6a8cb515e3bb85c.png	t	t	ca3c72232c27cd28adb91e79b6a8cb515e3bb85c	ca3c72232c27cd28adb91e79b6a8cb515e3bb85c	0	2309	t	96	Evolution	Evolution	{}	high	\N	\N	1143
Hippodrome Grand Casino	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/78d64f3ff2ed8b7a7aae7976cea9bd43ded13183.png	t	t	78d64f3ff2ed8b7a7aae7976cea9bd43ded13183	78d64f3ff2ed8b7a7aae7976cea9bd43ded13183	0	1409	t	96	Evolution	Evolution	{}	medium	\N	\N	1144
Casino Malta Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/1a782aa3692e8ca61d9842d309d6857cb861343e.png	f	f	1a782aa3692e8ca61d9842d309d6857cb861343e	1a782aa3692e8ca61d9842d309d6857cb861343e	0	1159	t	96	Evolution	Evolution	{}	low	\N	\N	1145
Arabic Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/eb2d528baa5af14dab208fe0f7cf54f830e2a605.png	t	t	eb2d528baa5af14dab208fe0f7cf54f830e2a605	eb2d528baa5af14dab208fe0f7cf54f830e2a605	0	2659	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1146
Dansk Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4824e5f39628312b4a2aa27a91237e3f01cbb279.png	t	t	4824e5f39628312b4a2aa27a91237e3f01cbb279	4824e5f39628312b4a2aa27a91237e3f01cbb279	0	1659	t	96	Evolution	Evolution	{}	high	\N	\N	1147
Deutsches Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4a21e48400ecc10a28f6e84007f510989292ecd0.png	t	t	4a21e48400ecc10a28f6e84007f510989292ecd0	4a21e48400ecc10a28f6e84007f510989292ecd0	0	859	t	96	Evolution	Evolution	{}	low	\N	\N	1148
Roulette Francophone	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d0162193c4372cd61605fc23a945e2755aa03d75.png	t	t	d0162193c4372cd61605fc23a945e2755aa03d75	d0162193c4372cd61605fc23a945e2755aa03d75	0	859	t	96	Evolution	Evolution	{}	high	\N	\N	1149
La Partage Francophone	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/0a7ee741e63369ae7c0549fa3aa1a5a780224c1a.png	t	t	0a7ee741e63369ae7c0549fa3aa1a5a780224c1a	0a7ee741e63369ae7c0549fa3aa1a5a780224c1a	0	10161	t	96	Evolution	Evolution	{}	very-high	\N	\N	1150
Norsk Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/30cc2d2c2d179d07523d3021d46f5983bbb63132.png	t	t	30cc2d2c2d179d07523d3021d46f5983bbb63132	30cc2d2c2d179d07523d3021d46f5983bbb63132	0	2310	t	96	Evolution	Evolution	{}	high	\N	\N	1151
Suomalainen Ruletti	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/21ed01585f1fd596d8cd33986dfc21dfb2664adc.png	f	f	21ed01585f1fd596d8cd33986dfc21dfb2664adc	21ed01585f1fd596d8cd33986dfc21dfb2664adc	0	1160	t	96	Evolution	Evolution	{}	low	\N	\N	1153
Svensk Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d098f0a3c1f6d937b08b58895f89d77bdd258d93.png	t	t	d098f0a3c1f6d937b08b58895f89d77bdd258d93	d098f0a3c1f6d937b08b58895f89d77bdd258d93	0	2660	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1154
Japanese Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/5607293652990057895464b51237dc28002416a5.png	t	t	5607293652990057895464b51237dc28002416a5	5607293652990057895464b51237dc28002416a5	0	1660	t	96	Evolution	Evolution	{}	high	\N	\N	1155
Türkçe Rulet 2	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d3d2c502e69e89e6d71443abda6918313efec0fc.png	t	t	d3d2c502e69e89e6d71443abda6918313efec0fc	d3d2c502e69e89e6d71443abda6918313efec0fc	0	860	t	96	Evolution	Evolution	{}	low	\N	\N	1156
Venezia Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e27cc2f6517827c57742f28dd110f6cee04d9fff.png	t	t	e27cc2f6517827c57742f28dd110f6cee04d9fff	e27cc2f6517827c57742f28dd110f6cee04d9fff	0	860	t	96	Evolution	Evolution	{}	high	\N	\N	1157
Venezia La Partage	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8fc17896b540217c5cbf9d0ce685b81dd361d897.png	t	t	8fc17896b540217c5cbf9d0ce685b81dd361d897	8fc17896b540217c5cbf9d0ce685b81dd361d897	0	10162	t	96	Evolution	Evolution	{}	very-high	\N	\N	1158
Bucharest Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/bea316efe356aefa8eb8637239e17e6974f7a8ad.png	t	t	bea316efe356aefa8eb8637239e17e6974f7a8ad	bea316efe356aefa8eb8637239e17e6974f7a8ad	0	2311	t	96	Evolution	Evolution	{}	high	\N	\N	1159
Bucharest Auto-Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8648cda08724fa0ea5aeff244a8587358187d2ab.png	t	t	8648cda08724fa0ea5aeff244a8587358187d2ab	8648cda08724fa0ea5aeff244a8587358187d2ab	0	1411	t	96	Evolution	Evolution	{}	medium	\N	\N	1160
Lucky 6	basic	https://gis-static.com/games/88a211816b162c58a7b09f98c70f3fd27517b375.png	f	f	88a211816b162c58a7b09f98c70f3fd27517b375	88a211816b162c58a7b09f98c70f3fd27517b375	0	1002	t	96	Betgames	Betgames	{}	low	\N	\N	8
Auto Lightning Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/2764b62cd6bd6c4a387a9e5b880b45a301784f51.png	f	f	2764b62cd6bd6c4a387a9e5b880b45a301784f51	2764b62cd6bd6c4a387a9e5b880b45a301784f51	0	1161	t	96	Evolution	Evolution	{}	low	\N	\N	1161
Side Bet City	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/1e5e1296ad9210cd3f4c452461a592267c963e17.png	t	t	1e5e1296ad9210cd3f4c452461a592267c963e17	1e5e1296ad9210cd3f4c452461a592267c963e17	0	2661	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1162
Casino Holdem	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/832636a1c742dfb2012b1600df2ff02d4cadf39b.png	t	t	832636a1c742dfb2012b1600df2ff02d4cadf39b	832636a1c742dfb2012b1600df2ff02d4cadf39b	0	1661	t	96	Evolution	Evolution	{}	high	\N	\N	1163
2 Hand Casino Holdem	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/dc3fea85a69643bd45835cdc0abf2c2b7b49ee23.png	t	t	dc3fea85a69643bd45835cdc0abf2c2b7b49ee23	dc3fea85a69643bd45835cdc0abf2c2b7b49ee23	0	861	t	96	Evolution	Evolution	{}	low	\N	\N	1164
Ultimate Texas Holdem	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/398105ae06d65f5ff081b6bc44a519946a8229b4.png	t	t	398105ae06d65f5ff081b6bc44a519946a8229b4	398105ae06d65f5ff081b6bc44a519946a8229b4	0	861	t	96	Evolution	Evolution	{}	high	\N	\N	1165
Three Card Poker	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c059caeb161569ceba977e8e396697db071bb0c5.png	t	t	c059caeb161569ceba977e8e396697db071bb0c5	c059caeb161569ceba977e8e396697db071bb0c5	0	10163	t	96	Evolution	Evolution	{}	very-high	\N	\N	1166
Caribbean Stud Poker	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/f9b0cd329d8270b6d91f125a56dafd2babda9ea7.png	t	t	f9b0cd329d8270b6d91f125a56dafd2babda9ea7	f9b0cd329d8270b6d91f125a56dafd2babda9ea7	0	2312	t	96	Evolution	Evolution	{}	high	\N	\N	1167
Texas Holdem Bonus Poker	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a0373207f1cc8472da971fe04c49198f4e912329.png	t	t	a0373207f1cc8472da971fe04c49198f4e912329	a0373207f1cc8472da971fe04c49198f4e912329	0	1412	t	96	Evolution	Evolution	{}	medium	\N	\N	1168
Crazy Time	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/f5477233821dcbe2367df4237f18fbac5b506b84.png	f	f	f5477233821dcbe2367df4237f18fbac5b506b84	f5477233821dcbe2367df4237f18fbac5b506b84	0	1162	t	96	Evolution	Evolution	{}	low	\N	\N	1169
Monopoly Live	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ff771a90b7b1f70b99bab999f1d28971faf0709e.png	t	t	ff771a90b7b1f70b99bab999f1d28971faf0709e	ff771a90b7b1f70b99bab999f1d28971faf0709e	0	2662	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1170
Dream Catcher	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/b0cdc5de471d2a138bfe2ede76a1d4f446d16d32.png	t	t	b0cdc5de471d2a138bfe2ede76a1d4f446d16d32	b0cdc5de471d2a138bfe2ede76a1d4f446d16d32	0	1662	t	96	Evolution	Evolution	{}	high	\N	\N	1171
Türkçe Futbol Stüdyosu	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6a95f35abb12b8aa1bb7f79b9ed8d9d6026c9ffb.png	t	t	6a95f35abb12b8aa1bb7f79b9ed8d9d6026c9ffb	6a95f35abb12b8aa1bb7f79b9ed8d9d6026c9ffb	0	862	t	96	Evolution	Evolution	{}	low	\N	\N	1172
Football studio	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/85be4822dc92885ab10733b363addab169b2ec8c.png	t	t	85be4822dc92885ab10733b363addab169b2ec8c	85be4822dc92885ab10733b363addab169b2ec8c	0	951	t	96	Evolution	Evolution	{}	low	\N	\N	1173
Lightning Dice	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e16daf75ba6d5fe76a6bdcb543d23454a244948f.png	t	t	e16daf75ba6d5fe76a6bdcb543d23454a244948f	e16daf75ba6d5fe76a6bdcb543d23454a244948f	0	862	t	96	Evolution	Evolution	{}	high	\N	\N	1174
Cash or Crash	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/420a15f156009c3277c481aa20a55fcb43e7d5b2.png	t	t	420a15f156009c3277c481aa20a55fcb43e7d5b2	420a15f156009c3277c481aa20a55fcb43e7d5b2	0	10164	t	96	Evolution	Evolution	{}	very-high	\N	\N	1175
Mega Ball	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3bbbb69fa069fb4eb990780e352a7e3883fd7dd6.png	t	t	3bbbb69fa069fb4eb990780e352a7e3883fd7dd6	3bbbb69fa069fb4eb990780e352a7e3883fd7dd6	0	2313	t	96	Evolution	Evolution	{}	high	\N	\N	1176
20 Dice Clovers	basic	https://gis-static.com/games/CTInteractive/e50ac3209508b6931ed82102339df36f66c3958f.png	t	t	e50ac3209508b6931ed82102339df36f66c3958f	e50ac3209508b6931ed82102339df36f66c3958f	0	1436	t	96	CTInteractive	CTInteractive	{}	medium	\N	\N	1362
First Person American Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/fbd63bd329829f09aa7d0ad8bb37fe506763e7c9.png	t	t	fbd63bd329829f09aa7d0ad8bb37fe506763e7c9	fbd63bd329829f09aa7d0ad8bb37fe506763e7c9	0	1413	t	96	Evolution	Evolution	{}	medium	\N	\N	1177
First Person Lightning Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/5a09f91b670034ed47733591366f522d95a59ba2.png	f	f	5a09f91b670034ed47733591366f522d95a59ba2	5a09f91b670034ed47733591366f522d95a59ba2	0	1163	t	96	Evolution	Evolution	{}	low	\N	\N	1178
First Person Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c49a719d48932062ac94d53bf25e3d65eed1e07a.png	t	t	c49a719d48932062ac94d53bf25e3d65eed1e07a	c49a719d48932062ac94d53bf25e3d65eed1e07a	0	10219	t	96	Evolution	Evolution	{}	very-high	\N	\N	1179
First Person Blackjack	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/95b3777e643e5e9f07ba36757e5789cf51f2de66.png	t	t	95b3777e643e5e9f07ba36757e5789cf51f2de66	95b3777e643e5e9f07ba36757e5789cf51f2de66	0	2663	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1180
First Person Mega Ball	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/5e1b1a65deade9e8890e1248387846f0140079df.png	t	t	5e1b1a65deade9e8890e1248387846f0140079df	5e1b1a65deade9e8890e1248387846f0140079df	0	1663	t	96	Evolution	Evolution	{}	high	\N	\N	1181
First Person Dream Catcher	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4f733b04e9908ac3d1aac8c5bac5a039d8e722dc.png	t	t	4f733b04e9908ac3d1aac8c5bac5a039d8e722dc	4f733b04e9908ac3d1aac8c5bac5a039d8e722dc	0	863	t	96	Evolution	Evolution	{}	low	\N	\N	1182
First Person Dragon Tiger	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/61658de2e2d5ad24abaf8031e7c382c5efff0835.png	t	t	61658de2e2d5ad24abaf8031e7c382c5efff0835	61658de2e2d5ad24abaf8031e7c382c5efff0835	0	863	t	96	Evolution	Evolution	{}	high	\N	\N	1183
Dice Duel	basic	https://gis-static.com/games/b5bf9542babb2f4f5e470d0af800fb70d4ca5966.png	t	t	b5bf9542babb2f4f5e470d0af800fb70d4ca5966	b5bf9542babb2f4f5e470d0af800fb70d4ca5966	0	2502	t	96	Betgames	Betgames	{}	medium-high	\N	\N	9
First Person Baccarat	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/67606b5228304db49f2b53b576062b68aed8b361.png	t	t	67606b5228304db49f2b53b576062b68aed8b361	67606b5228304db49f2b53b576062b68aed8b361	0	10165	t	96	Evolution	Evolution	{}	very-high	\N	\N	1184
FIRST PERSON LOBBY	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a456c7be1d628a280fb4207d080b0c88ff77d5cc.png	t	t	a456c7be1d628a280fb4207d080b0c88ff77d5cc	a456c7be1d628a280fb4207d080b0c88ff77d5cc	0	2314	t	96	Evolution	Evolution	{}	high	\N	\N	1185
GAME SHOWS LOBBY	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/1b1620ba13bdb924be7bf98de033c0974ec8ad96.png	t	t	1b1620ba13bdb924be7bf98de033c0974ec8ad96	1b1620ba13bdb924be7bf98de033c0974ec8ad96	0	1414	t	96	Evolution	Evolution	{}	medium	\N	\N	1186
POKER LOBBY	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8e55b637128df4be805acb4a19e655d2a20f3f49.png	f	f	8e55b637128df4be805acb4a19e655d2a20f3f49	8e55b637128df4be805acb4a19e655d2a20f3f49	0	1164	t	96	Evolution	Evolution	{}	low	\N	\N	1187
BACCARAT LOBBY	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/831490123d264c296b3f9b390a7a8d03d921276a.png	t	t	831490123d264c296b3f9b390a7a8d03d921276a	831490123d264c296b3f9b390a7a8d03d921276a	0	2664	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1188
BLACKJACK LOBBY	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/19d7273fa118a1b53319693700c9502c8167e27a.png	t	t	19d7273fa118a1b53319693700c9502c8167e27a	19d7273fa118a1b53319693700c9502c8167e27a	0	1664	t	96	Evolution	Evolution	{}	high	\N	\N	1189
ROULETTE LOBBY	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c39f95b92c81cbb9f6fc8a62786e40cbe1b00cb7.png	t	t	c39f95b92c81cbb9f6fc8a62786e40cbe1b00cb7	c39f95b92c81cbb9f6fc8a62786e40cbe1b00cb7	0	864	t	96	Evolution	Evolution	{}	low	\N	\N	1190
TOP GAMES LOBBY	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/1a1ff606542da3a04b69d7cb2f2917e7eadbe47c.png	t	t	1a1ff606542da3a04b69d7cb2f2917e7eadbe47c	1a1ff606542da3a04b69d7cb2f2917e7eadbe47c	0	864	t	96	Evolution	Evolution	{}	high	\N	\N	1191
Deal Or No Deal	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/419e691ac82a4bb55d83e98604bd3cad41e8f9ed.png	t	t	419e691ac82a4bb55d83e98604bd3cad41e8f9ed	419e691ac82a4bb55d83e98604bd3cad41e8f9ed	0	10166	t	96	Evolution	Evolution	{}	very-high	\N	\N	1192
Texas Holdem	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/15204fade855f71a369e500856a6d252f41e6518.png	t	t	15204fade855f71a369e500856a6d252f41e6518	15204fade855f71a369e500856a6d252f41e6518	0	2315	t	96	Evolution	Evolution	{}	high	\N	\N	1193
Triple Card Poker	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/1eef879860d05af92a69c2338adb77bd48f80e21.png	t	t	1eef879860d05af92a69c2338adb77bd48f80e21	1eef879860d05af92a69c2338adb77bd48f80e21	0	1415	t	96	Evolution	Evolution	{}	medium	\N	\N	1194
Bac Bo	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3466459d0e3283c13c93958710c5e0aa4331d5ba.png	f	f	3466459d0e3283c13c93958710c5e0aa4331d5ba	3466459d0e3283c13c93958710c5e0aa4331d5ba	0	1165	t	96	Evolution	Evolution	{}	low	\N	\N	1195
Salon Privé Baccarat F	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e0f723438cc2fb60da0ce113bf32ae828faf1e8d.png	t	t	e0f723438cc2fb60da0ce113bf32ae828faf1e8d	e0f723438cc2fb60da0ce113bf32ae828faf1e8d	0	2665	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1196
Salon Privé Baccarat G	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/be2076ef9a9540c32e1351b2277a63fa187b44df.png	t	t	be2076ef9a9540c32e1351b2277a63fa187b44df	be2076ef9a9540c32e1351b2277a63fa187b44df	0	1665	t	96	Evolution	Evolution	{}	high	\N	\N	1197
Salon Privé Blackjack G	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/f64282787ee20b7357de31f737795f276893d145.png	t	t	f64282787ee20b7357de31f737795f276893d145	f64282787ee20b7357de31f737795f276893d145	0	865	t	96	Evolution	Evolution	{}	low	\N	\N	1198
Türkçe Lightning Rulet	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8f21dfca2e04c323a3bc2bd73a0f502654458d8c.png	t	t	8f21dfca2e04c323a3bc2bd73a0f502654458d8c	8f21dfca2e04c323a3bc2bd73a0f502654458d8c	0	865	t	96	Evolution	Evolution	{}	high	\N	\N	1199
Super Andar Bahar	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/336238b0364674c0e6e8052b51feedfd21acadbb.png	t	t	336238b0364674c0e6e8052b51feedfd21acadbb	336238b0364674c0e6e8052b51feedfd21acadbb	0	10167	t	96	Evolution	Evolution	{}	very-high	\N	\N	1200
XXXTreme Lightning Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/9d0b332ea1b0b544d65eaa529ae00f3d6c2d4664.png	t	t	9d0b332ea1b0b544d65eaa529ae00f3d6c2d4664	9d0b332ea1b0b544d65eaa529ae00f3d6c2d4664	0	2316	t	96	Evolution	Evolution	{}	high	\N	\N	1201
Speed VIP Blackjack J	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/67e2487097429b74b5e359253dba1ad96169b724.png	t	t	67e2487097429b74b5e359253dba1ad96169b724	67e2487097429b74b5e359253dba1ad96169b724	0	1416	t	96	Evolution	Evolution	{}	medium	\N	\N	1202
Speed VIP Blackjack I	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a844ab2f509972343e20935272fe22b89828de36.png	f	f	a844ab2f509972343e20935272fe22b89828de36	a844ab2f509972343e20935272fe22b89828de36	0	1166	t	96	Evolution	Evolution	{}	low	\N	\N	1203
Crazy Coin Flip	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/fbc82d71ad054ebca5409f40ae7491437c19d75f.png	t	t	fbc82d71ad054ebca5409f40ae7491437c19d75f	fbc82d71ad054ebca5409f40ae7491437c19d75f	0	2666	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1204
Speed Baccarat T	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/79aad98eb2e727b7a68c060e50edd43cfa2f46a6.png	t	t	79aad98eb2e727b7a68c060e50edd43cfa2f46a6	79aad98eb2e727b7a68c060e50edd43cfa2f46a6	0	1666	t	96	Evolution	Evolution	{}	high	\N	\N	1205
Speed Baccarat U	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/2d93a871d3c83e215011df9093a676090c6b443b.png	t	t	2d93a871d3c83e215011df9093a676090c6b443b	2d93a871d3c83e215011df9093a676090c6b443b	0	866	t	96	Evolution	Evolution	{}	low	\N	\N	1206
Speed Baccarat V	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/7fdc7954d16c61e91e64388fe1ff20b6a1609621.png	t	t	7fdc7954d16c61e91e64388fe1ff20b6a1609621	7fdc7954d16c61e91e64388fe1ff20b6a1609621	0	866	t	96	Evolution	Evolution	{}	high	\N	\N	1207
Bet-on-Poker	basic	https://gis-static.com/games/75f5ca9e9d9cd3566bb7d95ee214dfebbf62b29b.png	t	t	75f5ca9e9d9cd3566bb7d95ee214dfebbf62b29b	75f5ca9e9d9cd3566bb7d95ee214dfebbf62b29b	0	1502	t	96	Betgames	Betgames	{}	high	\N	\N	10
Speed Baccarat W	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/26699a7d229b96b3d7aa12a92c709365bcc0afdf.png	t	t	26699a7d229b96b3d7aa12a92c709365bcc0afdf	26699a7d229b96b3d7aa12a92c709365bcc0afdf	0	10168	t	96	Evolution	Evolution	{}	very-high	\N	\N	1208
Speed Baccarat X	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/b49df02ae183b1b86b8e977135e0b53427c5981f.png	t	t	b49df02ae183b1b86b8e977135e0b53427c5981f	b49df02ae183b1b86b8e977135e0b53427c5981f	0	2317	t	96	Evolution	Evolution	{}	high	\N	\N	1209
Speed VIP Blackjack K	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/07213ecd4426a194c3da65ecd5f42499ff4f4f38.png	t	t	07213ecd4426a194c3da65ecd5f42499ff4f4f38	07213ecd4426a194c3da65ecd5f42499ff4f4f38	0	1417	t	96	Evolution	Evolution	{}	medium	\N	\N	1210
Speed VIP Blackjack L	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/b45bb28a984e33f14698d669ac300b8ec6736690.png	f	f	b45bb28a984e33f14698d669ac300b8ec6736690	b45bb28a984e33f14698d669ac300b8ec6736690	0	1167	t	96	Evolution	Evolution	{}	low	\N	\N	1211
Speed VIP Blackjack M	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/83eb845c4456f01f55ded7135f0ce7548b1cddc3.png	t	t	83eb845c4456f01f55ded7135f0ce7548b1cddc3	83eb845c4456f01f55ded7135f0ce7548b1cddc3	0	2667	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1212
Blackjack VIP 25	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/eac147138e6c1f77de992c6e9448d1d73575227e.png	t	t	eac147138e6c1f77de992c6e9448d1d73575227e	eac147138e6c1f77de992c6e9448d1d73575227e	0	2368	t	96	Evolution	Evolution	{}	high	\N	\N	1213
Blackjack VIP 26	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/498e5b38e0d04c18e8bd39801537261f544540c0.png	t	t	498e5b38e0d04c18e8bd39801537261f544540c0	498e5b38e0d04c18e8bd39801537261f544540c0	0	1667	t	96	Evolution	Evolution	{}	high	\N	\N	1214
Blackjack VIP 27	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/0a366c3c9c862e63a75a0bbe433638ae04d7651b.png	t	t	0a366c3c9c862e63a75a0bbe433638ae04d7651b	0a366c3c9c862e63a75a0bbe433638ae04d7651b	0	867	t	96	Evolution	Evolution	{}	low	\N	\N	1215
Blackjack Classic 82	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/5566b5a0e79826bed839bd7a221343d0415ab1f0.png	t	t	5566b5a0e79826bed839bd7a221343d0415ab1f0	5566b5a0e79826bed839bd7a221343d0415ab1f0	0	867	t	96	Evolution	Evolution	{}	high	\N	\N	1216
Blackjack Classic 83	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/549e183042f6452d340079a3bc95c67d9e2ddd23.png	t	t	549e183042f6452d340079a3bc95c67d9e2ddd23	549e183042f6452d340079a3bc95c67d9e2ddd23	0	10169	t	96	Evolution	Evolution	{}	very-high	\N	\N	1217
Blackjack Classic 84	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/51fb598a50994d8becc8f2a80ac551854ab3ddb3.png	t	t	51fb598a50994d8becc8f2a80ac551854ab3ddb3	51fb598a50994d8becc8f2a80ac551854ab3ddb3	0	2318	t	96	Evolution	Evolution	{}	high	\N	\N	1218
Blackjack Classic 85	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/fe8eb69d6c6c6121cac82d90d0399c0005909908.png	t	t	fe8eb69d6c6c6121cac82d90d0399c0005909908	fe8eb69d6c6c6121cac82d90d0399c0005909908	0	1418	t	96	Evolution	Evolution	{}	medium	\N	\N	1219
Blackjack Classic 86	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/f3894fe2a8eef91489527cd9c9a16a5bebd3ee0d.png	f	f	f3894fe2a8eef91489527cd9c9a16a5bebd3ee0d	f3894fe2a8eef91489527cd9c9a16a5bebd3ee0d	0	1168	t	96	Evolution	Evolution	{}	low	\N	\N	1220
Blackjack Classic 87	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c6fd898068235aa7cb537e72fd61026d6afff181.png	t	t	c6fd898068235aa7cb537e72fd61026d6afff181	c6fd898068235aa7cb537e72fd61026d6afff181	0	2668	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1221
Monopoly Big Baller	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/39e4443647b2dd86bd26699297e6583d189e46e3.png	t	t	39e4443647b2dd86bd26699297e6583d189e46e3	39e4443647b2dd86bd26699297e6583d189e46e3	0	1668	t	96	Evolution	Evolution	{}	high	\N	\N	1222
Bucharest Infinite Free Bet Blackjack	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6d3cdfb9732562b53524992e72d6423508805300.png	t	t	6d3cdfb9732562b53524992e72d6423508805300	6d3cdfb9732562b53524992e72d6423508805300	0	868	t	96	Evolution	Evolution	{}	low	\N	\N	1223
Lightning Blackjack	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/07fcecdb347c7abcaeff4da46739c0d975e1ff98.png	t	t	07fcecdb347c7abcaeff4da46739c0d975e1ff98	07fcecdb347c7abcaeff4da46739c0d975e1ff98	0	868	t	96	Evolution	Evolution	{}	high	\N	\N	1224
Blackjack Clasico en Español 1	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3812d7cf0fed4d182222b95fcea7680594aa3dad.png	t	t	3812d7cf0fed4d182222b95fcea7680594aa3dad	3812d7cf0fed4d182222b95fcea7680594aa3dad	0	10170	t	96	Evolution	Evolution	{}	very-high	\N	\N	1225
Blackjack Clasico en Español 2	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a42b5bb7c4d15bb1f3e4df30483f9cc1b152831a.png	t	t	a42b5bb7c4d15bb1f3e4df30483f9cc1b152831a	a42b5bb7c4d15bb1f3e4df30483f9cc1b152831a	0	2319	t	96	Evolution	Evolution	{}	high	\N	\N	1226
Blackjack Clasico en Español 3	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/50dbe45f148713d43b36d5392d6cf964a8025488.png	t	t	50dbe45f148713d43b36d5392d6cf964a8025488	50dbe45f148713d43b36d5392d6cf964a8025488	0	1419	t	96	Evolution	Evolution	{}	medium	\N	\N	1227
Blackjack Clássico em Português 1	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/2a5b99edb1ac73d32bbcd3a00e1ad7425ac187bb.png	f	f	2a5b99edb1ac73d32bbcd3a00e1ad7425ac187bb	2a5b99edb1ac73d32bbcd3a00e1ad7425ac187bb	0	1169	t	96	Evolution	Evolution	{}	low	\N	\N	1228
Blackjack Clássico em Português 2	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/73b6d8683292f79d9286404b137e3a7af01050cd.png	t	t	73b6d8683292f79d9286404b137e3a7af01050cd	73b6d8683292f79d9286404b137e3a7af01050cd	0	2669	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1229
Klasik Blackjack	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/292c8aae3ccecdffa8958c8ddf09ef8fabf5e3d5.png	t	t	292c8aae3ccecdffa8958c8ddf09ef8fabf5e3d5	292c8aae3ccecdffa8958c8ddf09ef8fabf5e3d5	0	1669	t	96	Evolution	Evolution	{}	high	\N	\N	1230
Klasik Blackjack 2	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/70fb38f917f7ea054cdf5f2a3e32a983043e2e63.png	t	t	70fb38f917f7ea054cdf5f2a3e32a983043e2e63	70fb38f917f7ea054cdf5f2a3e32a983043e2e63	0	869	t	96	Evolution	Evolution	{}	low	\N	\N	1231
Klasik Blackjack 3	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d3b360a7e41575b68b24de7e7353fbd94be8bcb3.png	t	t	d3b360a7e41575b68b24de7e7353fbd94be8bcb3	d3b360a7e41575b68b24de7e7353fbd94be8bcb3	0	869	t	96	Evolution	Evolution	{}	high	\N	\N	1232
Klasik Blackjack 4	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/b70abb8c44334c0e2af9377b5e7271772848b512.png	t	t	b70abb8c44334c0e2af9377b5e7271772848b512	b70abb8c44334c0e2af9377b5e7271772848b512	0	10171	t	96	Evolution	Evolution	{}	very-high	\N	\N	1233
Klasik Blackjack 5	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/238edca926600f128a7d961c5196b68c720ef29e.png	t	t	238edca926600f128a7d961c5196b68c720ef29e	238edca926600f128a7d961c5196b68c720ef29e	0	2320	t	96	Evolution	Evolution	{}	high	\N	\N	1234
Klasik Blackjack 8	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3a3d165c33f6355674ec7bf150f24c218b3c52a0.png	t	t	3a3d165c33f6355674ec7bf150f24c218b3c52a0	3a3d165c33f6355674ec7bf150f24c218b3c52a0	0	1420	t	96	Evolution	Evolution	{}	medium	\N	\N	1235
Klasik Blackjack 9	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/31d5401413b5bff6cec242dddedf5bfe158bf100.png	f	f	31d5401413b5bff6cec242dddedf5bfe158bf100	31d5401413b5bff6cec242dddedf5bfe158bf100	0	1170	t	96	Evolution	Evolution	{}	low	\N	\N	1236
Klasik Speed Blackjack 1	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e33e5392f9f4f9594da87476db5fc051961f309a.png	t	t	e33e5392f9f4f9594da87476db5fc051961f309a	e33e5392f9f4f9594da87476db5fc051961f309a	0	2670	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1237
Klasik Speed Blackjack 2	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/7b79aa9a467e5fad87cc252d667c550f0cb4eab8.png	t	t	7b79aa9a467e5fad87cc252d667c550f0cb4eab8	7b79aa9a467e5fad87cc252d667c550f0cb4eab8	0	1670	t	96	Evolution	Evolution	{}	high	\N	\N	1238
VIP Blackjack en Español	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d749f6685eab7923e0aec0e2167639b2f6e1e5ef.png	t	t	d749f6685eab7923e0aec0e2167639b2f6e1e5ef	d749f6685eab7923e0aec0e2167639b2f6e1e5ef	0	870	t	96	Evolution	Evolution	{}	low	\N	\N	1239
VIP Blackjack em Português	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/eac004d17b0d2943fa160862d1445064259747ed.png	t	t	eac004d17b0d2943fa160862d1445064259747ed	eac004d17b0d2943fa160862d1445064259747ed	0	870	t	96	Evolution	Evolution	{}	high	\N	\N	1240
Ruleta Bola Rapida en Vivo	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/891f94cdeb9329d060b9dc7aeebc33c240342c93.png	t	t	891f94cdeb9329d060b9dc7aeebc33c240342c93	891f94cdeb9329d060b9dc7aeebc33c240342c93	0	10172	t	96	Evolution	Evolution	{}	very-high	\N	\N	1241
Italian Lightning Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/8bdfcdb082b8dc388ff68e8c863bd5673538c606.png	t	t	8bdfcdb082b8dc388ff68e8c863bd5673538c606	8bdfcdb082b8dc388ff68e8c863bd5673538c606	0	2321	t	96	Evolution	Evolution	{}	high	\N	\N	1242
Korean Dealer Lightning Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/24431a0f22895e77e70561a447d9559084c979e9.png	t	t	24431a0f22895e77e70561a447d9559084c979e9	24431a0f22895e77e70561a447d9559084c979e9	0	1421	t	96	Evolution	Evolution	{}	medium	\N	\N	1243
Hindi Lightning Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a45f61d745eb5f14197221e15e1d0e90d0152574.png	f	f	a45f61d745eb5f14197221e15e1d0e90d0152574	a45f61d745eb5f14197221e15e1d0e90d0152574	0	1171	t	96	Evolution	Evolution	{}	low	\N	\N	1244
Roleta Relâmpago	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/df514de082ea8bdb86ce6dfb127d17b015ecc897.png	t	t	df514de082ea8bdb86ce6dfb127d17b015ecc897	df514de082ea8bdb86ce6dfb127d17b015ecc897	0	2671	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1245
Roleta Ao Vivo	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/09e77d9736e957e8142f7cef6961a75ee5db5d60.png	t	t	09e77d9736e957e8142f7cef6961a75ee5db5d60	09e77d9736e957e8142f7cef6961a75ee5db5d60	0	1671	t	96	Evolution	Evolution	{}	high	\N	\N	1246
Dragonara Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/dd56a31ab05c37613d240dd8a65523651dcae03b.png	t	t	dd56a31ab05c37613d240dd8a65523651dcae03b	dd56a31ab05c37613d240dd8a65523651dcae03b	0	871	t	96	Evolution	Evolution	{}	low	\N	\N	1247
Casino Holdem Italia	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/74ec72f2eff80f2f014fb24d977a15bd8ab4eb69.png	t	t	74ec72f2eff80f2f014fb24d977a15bd8ab4eb69	74ec72f2eff80f2f014fb24d977a15bd8ab4eb69	0	871	t	96	Evolution	Evolution	{}	high	\N	\N	1248
Korean Dealer Baseball Studio	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3414c33ae47574464a5732144c107fed1d841dbd.png	t	t	3414c33ae47574464a5732144c107fed1d841dbd	3414c33ae47574464a5732144c107fed1d841dbd	0	10173	t	96	Evolution	Evolution	{}	very-high	\N	\N	1249
Mega Bola	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a4a528645679b2961a6b8e3a503cc357f804a820.png	t	t	a4a528645679b2961a6b8e3a503cc357f804a820	a4a528645679b2961a6b8e3a503cc357f804a820	0	2322	t	96	Evolution	Evolution	{}	high	\N	\N	1250
Dead Or Alive	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/bb040531b349f0ee9d7c7dc1a352feae84b6a1f3.png	t	t	bb040531b349f0ee9d7c7dc1a352feae84b6a1f3	bb040531b349f0ee9d7c7dc1a352feae84b6a1f3	0	1422	t	96	Evolution	Evolution	{}	medium	\N	\N	1251
Crazy Time A	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ad06ad214e6f5b2ca16ee23ca2a4fd71a10b85f3.png	f	f	ad06ad214e6f5b2ca16ee23ca2a4fd71a10b85f3	ad06ad214e6f5b2ca16ee23ca2a4fd71a10b85f3	0	1172	t	96	Evolution	Evolution	{}	low	\N	\N	1252
Golden Wealth Baccarat	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ee6f236e7225556546e7d0e9e8264c5953918a23.png	t	t	ee6f236e7225556546e7d0e9e8264c5953918a23	ee6f236e7225556546e7d0e9e8264c5953918a23	0	2672	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1253
Salon Privé Blackjack J	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/2eb814e91c482ce124b64194141e73dbf062f161.png	t	t	2eb814e91c482ce124b64194141e73dbf062f161	2eb814e91c482ce124b64194141e73dbf062f161	0	1672	t	96	Evolution	Evolution	{}	high	\N	\N	1254
Salon Privé Blackjack H	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/5a003f0d0baa30e9279aec156a40b2c22ee19960.png	t	t	5a003f0d0baa30e9279aec156a40b2c22ee19960	5a003f0d0baa30e9279aec156a40b2c22ee19960	0	872	t	96	Evolution	Evolution	{}	low	\N	\N	1255
Free Bet Blackjack 2	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/bdb2a9e4ad68a2d88f901ef7177792a7c0053ec6.png	t	t	bdb2a9e4ad68a2d88f901ef7177792a7c0053ec6	bdb2a9e4ad68a2d88f901ef7177792a7c0053ec6	0	872	t	96	Evolution	Evolution	{}	high	\N	\N	1256
Klasik Blackjack 12	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/24e6c84e1b0e1579b68beca92aca2ad77d394a7a.png	t	t	24e6c84e1b0e1579b68beca92aca2ad77d394a7a	24e6c84e1b0e1579b68beca92aca2ad77d394a7a	0	10174	t	96	Evolution	Evolution	{}	very-high	\N	\N	1257
Free Bet Blackjack 6	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ece84d5284e7bde8237b1aa9729840c019a1561b.png	t	t	ece84d5284e7bde8237b1aa9729840c019a1561b	ece84d5284e7bde8237b1aa9729840c019a1561b	0	2323	t	96	Evolution	Evolution	{}	high	\N	\N	1258
Dead or Alive Saloon	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d4f3b5b1c47b7f95359aaccc7857f1e0bfc1c14f.png	t	t	d4f3b5b1c47b7f95359aaccc7857f1e0bfc1c14f	d4f3b5b1c47b7f95359aaccc7857f1e0bfc1c14f	0	1423	t	96	Evolution	Evolution	{}	medium	\N	\N	1259
Salon Privé Blackjack I	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/9b256dc57863a612e0af288c2da5bf53719f4861.png	f	f	9b256dc57863a612e0af288c2da5bf53719f4861	9b256dc57863a612e0af288c2da5bf53719f4861	0	1173	t	96	Evolution	Evolution	{}	low	\N	\N	1260
Salon Privé Baccarat H	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/10b6cba5305b4e5a8929f26ceaa617df7505f9c0.png	t	t	10b6cba5305b4e5a8929f26ceaa617df7505f9c0	10b6cba5305b4e5a8929f26ceaa617df7505f9c0	0	2673	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1261
Free Bet Blackjack 3	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c71c55bd1ce101af95fec4d241f274d7a5acc777.png	t	t	c71c55bd1ce101af95fec4d241f274d7a5acc777	c71c55bd1ce101af95fec4d241f274d7a5acc777	0	1673	t	96	Evolution	Evolution	{}	high	\N	\N	1262
Free Bet Blackjack 7	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/9bb26229a8aaedcf58858ee386e57665a24a4a5c.png	t	t	9bb26229a8aaedcf58858ee386e57665a24a4a5c	9bb26229a8aaedcf58858ee386e57665a24a4a5c	0	873	t	96	Evolution	Evolution	{}	low	\N	\N	1263
Free Bet Blackjack 4	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3db4d5c80c3421ae68a96eadcb2cfa7a4a3478cd.png	t	t	3db4d5c80c3421ae68a96eadcb2cfa7a4a3478cd	3db4d5c80c3421ae68a96eadcb2cfa7a4a3478cd	0	873	t	96	Evolution	Evolution	{}	high	\N	\N	1264
Salon Privé Baccarat J	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3fe4eb9fba6e5fb7e393b76e3c60186f4691e850.png	t	t	3fe4eb9fba6e5fb7e393b76e3c60186f4691e850	3fe4eb9fba6e5fb7e393b76e3c60186f4691e850	0	10175	t	96	Evolution	Evolution	{}	very-high	\N	\N	1265
Salon Privé Baccarat I	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/3b56ae32851102b8e865f8968407ebe7bb512607.png	t	t	3b56ae32851102b8e865f8968407ebe7bb512607	3b56ae32851102b8e865f8968407ebe7bb512607	0	2324	t	96	Evolution	Evolution	{}	high	\N	\N	1266
Football Studio Dice	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6457d7fb0ef6f1cce8fbbb220812e484e43ba505.png	t	t	6457d7fb0ef6f1cce8fbbb220812e484e43ba505	6457d7fb0ef6f1cce8fbbb220812e484e43ba505	0	1424	t	96	Evolution	Evolution	{}	medium	\N	\N	1267
Free Bet Blackjack 1	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/43ead20421e27b93c82eb53ef797791bd9dd4578.png	f	f	43ead20421e27b93c82eb53ef797791bd9dd4578	43ead20421e27b93c82eb53ef797791bd9dd4578	0	1174	t	96	Evolution	Evolution	{}	low	\N	\N	1268
Free Bet Blackjack 5	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/eec2a9e6bbd8765f5897a1d5be0e99d1ebca1ef0.png	t	t	eec2a9e6bbd8765f5897a1d5be0e99d1ebca1ef0	eec2a9e6bbd8765f5897a1d5be0e99d1ebca1ef0	0	2674	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1269
Korean Speed Baccarat A	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/534e35ef9b7522396355a1d70ca2e70e82190218.png	t	t	534e35ef9b7522396355a1d70ca2e70e82190218	534e35ef9b7522396355a1d70ca2e70e82190218	0	1674	t	96	Evolution	Evolution	{}	high	\N	\N	1270
Korean Speed Baccarat B	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a887ae8e6f2547a2c8afff60afde0bdaae005c99.png	t	t	a887ae8e6f2547a2c8afff60afde0bdaae005c99	a887ae8e6f2547a2c8afff60afde0bdaae005c99	0	874	t	96	Evolution	Evolution	{}	low	\N	\N	1271
Korean Speed Baccarat C	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ab53212633f627852cd37d93374375de15a5da28.png	t	t	ab53212633f627852cd37d93374375de15a5da28	ab53212633f627852cd37d93374375de15a5da28	0	874	t	96	Evolution	Evolution	{}	high	\N	\N	1272
Korean Speaking Speed Baccarat	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/5b00895b997737d663c483e3870236f32a89e53b.png	t	t	5b00895b997737d663c483e3870236f32a89e53b	5b00895b997737d663c483e3870236f32a89e53b	0	10176	t	96	Evolution	Evolution	{}	very-high	\N	\N	1273
Korean Speaking Speed Baccarat 2	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/d70f697f229ff6851ce3ad7cceaa6f9e01a30c74.png	t	t	d70f697f229ff6851ce3ad7cceaa6f9e01a30c74	d70f697f229ff6851ce3ad7cceaa6f9e01a30c74	0	2325	t	96	Evolution	Evolution	{}	high	\N	\N	1274
Korean Dealer Speed Blackjack	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/90c2a7d0481f1f715ab8a9b7714238acda38b673.png	t	t	90c2a7d0481f1f715ab8a9b7714238acda38b673	90c2a7d0481f1f715ab8a9b7714238acda38b673	0	1425	t	96	Evolution	Evolution	{}	medium	\N	\N	1275
Korean Dealer Power Blackjack	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/0397e55420be56ff4e28558c48098b376f47936c.png	f	f	0397e55420be56ff4e28558c48098b376f47936c	0397e55420be56ff4e28558c48098b376f47936c	0	1175	t	96	Evolution	Evolution	{}	low	\N	\N	1276
Extra Chilli Epic Spins	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/4a88a76639800dcc7d49f18ef560bfbd48476077.png	t	t	4a88a76639800dcc7d49f18ef560bfbd48476077	4a88a76639800dcc7d49f18ef560bfbd48476077	0	2675	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1277
Classic Blackjack 10	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/894e238e96c69d68dea53a0c0a2413bfa10a5c85.png	t	t	894e238e96c69d68dea53a0c0a2413bfa10a5c85	894e238e96c69d68dea53a0c0a2413bfa10a5c85	0	1675	t	96	Evolution	Evolution	{}	high	\N	\N	1278
Classic Blackjack 11	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/64759817da253d227956ac4c718d2aff66c18ade.png	t	t	64759817da253d227956ac4c718d2aff66c18ade	64759817da253d227956ac4c718d2aff66c18ade	0	875	t	96	Evolution	Evolution	{}	low	\N	\N	1279
Speed Baccarat Z	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/82ce4a04cf02c65fa264c3ef3c26e8e3e1d33d9a.png	t	t	82ce4a04cf02c65fa264c3ef3c26e8e3e1d33d9a	82ce4a04cf02c65fa264c3ef3c26e8e3e1d33d9a	0	875	t	96	Evolution	Evolution	{}	high	\N	\N	1280
10-Hand Video Poker	basic	https://gis-static.com/games/Boldplay/2dc7abc4ac0a4d368bfa16b79470688e.png	t	t	2dc7abc4ac0a4d368bfa16b79470688e	2dc7abc4ac0a4d368bfa16b79470688e	0	773	t	96	Boldplay	Boldplay	{}	high	\N	\N	495
Wild Joker Scratch	basic	https://gis-static.com/games/Boldplay/d54df4a94edd487c961cf124610637fc.png	t	t	d54df4a94edd487c961cf124610637fc	d54df4a94edd487c961cf124610637fc	0	2224	t	96	Boldplay	Boldplay	{}	high	\N	\N	497
Speed Baccarat 1	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/268baa9d4ec142fd89e08611d63a27a95363de9f.png	t	t	268baa9d4ec142fd89e08611d63a27a95363de9f	268baa9d4ec142fd89e08611d63a27a95363de9f	0	10177	t	96	Evolution	Evolution	{}	very-high	\N	\N	1281
Blackjack Classic 88	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/b0dabe000b2bf0c9f2ba616d569044c986655f79.png	f	f	b0dabe000b2bf0c9f2ba616d569044c986655f79	b0dabe000b2bf0c9f2ba616d569044c986655f79	0	1176	t	96	Evolution	Evolution	{}	low	\N	\N	1284
Funky Time	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c65d0ada7bd9700f29af036c402622d61dcfff53.png	t	t	c65d0ada7bd9700f29af036c402622d61dcfff53	c65d0ada7bd9700f29af036c402622d61dcfff53	0	2676	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1285
First Person Craps	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6209c8cb004d30f3aa4facc2a0b0cb3a919c61a0.png	t	t	6209c8cb004d30f3aa4facc2a0b0cb3a919c61a0	6209c8cb004d30f3aa4facc2a0b0cb3a919c61a0	0	1676	t	96	Evolution	Evolution	{}	high	\N	\N	1286
First Person Golden Wealth Baccarat	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c068cd0ece08509fdbdb32e517d3d64abee779d7.png	t	t	c068cd0ece08509fdbdb32e517d3d64abee779d7	c068cd0ece08509fdbdb32e517d3d64abee779d7	0	876	t	96	Evolution	Evolution	{}	low	\N	\N	1287
Klasik Speed Blackjack 3	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/887fb1c4506ff3e01479e57b315d5623636e9283.png	t	t	887fb1c4506ff3e01479e57b315d5623636e9283	887fb1c4506ff3e01479e57b315d5623636e9283	0	876	t	96	Evolution	Evolution	{}	high	\N	\N	1288
Gold Vault Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6c936568fb807b9851c47f5b3479c8c623a736ae.png	t	t	6c936568fb807b9851c47f5b3479c8c623a736ae	6c936568fb807b9851c47f5b3479c8c623a736ae	0	10178	t	96	Evolution	Evolution	{}	very-high	\N	\N	1289
Gonzos Treasure Map	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/496fb569f3faac4a2a97285e74ad05860377ffd1.png	t	t	496fb569f3faac4a2a97285e74ad05860377ffd1	496fb569f3faac4a2a97285e74ad05860377ffd1	0	2327	t	96	Evolution	Evolution	{}	high	\N	\N	1290
Dragon Tiger	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6d373f878df2f2db003fdd2ee9814a410e52420a.png	t	t	6d373f878df2f2db003fdd2ee9814a410e52420a	6d373f878df2f2db003fdd2ee9814a410e52420a	0	1427	t	96	Evolution	Evolution	{}	medium	\N	\N	1291
First Person Lightning Lotto	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/119f2724e5f871516f9126c599568e863efda638.png	f	f	119f2724e5f871516f9126c599568e863efda638	119f2724e5f871516f9126c599568e863efda638	0	1177	t	96	Evolution	Evolution	{}	low	\N	\N	1292
Lightning Lotto	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/c7b7559e965afb49d770e2cb3e3f90ae01642590.png	t	t	c7b7559e965afb49d770e2cb3e3f90ae01642590	c7b7559e965afb49d770e2cb3e3f90ae01642590	0	2677	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1293
Punto Banco	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/2df655bf3087fef5df3f94fd045306d730fb26b6.png	t	t	2df655bf3087fef5df3f94fd045306d730fb26b6	2df655bf3087fef5df3f94fd045306d730fb26b6	0	1677	t	96	Evolution	Evolution	{}	high	\N	\N	1294
Crazy Pachinko	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ee84df60cbcd08f4c60e97291c09f8b8dc374462.png	t	t	ee84df60cbcd08f4c60e97291c09f8b8dc374462	ee84df60cbcd08f4c60e97291c09f8b8dc374462	0	10180	t	96	Evolution	Evolution	{}	very-high	\N	\N	1305
Red Door Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ac05a9bf4d7e0093ba8757c9121513bede9eb564.png	t	t	ac05a9bf4d7e0093ba8757c9121513bede9eb564	ac05a9bf4d7e0093ba8757c9121513bede9eb564	0	2329	t	96	Evolution	Evolution	{}	high	\N	\N	1306
Instant Super Sic Bo	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/18504c52ea2c4f63b0b4d889f5ccd58c.png	t	t	18504c52ea2c4f63b0b4d889f5ccd58c	18504c52ea2c4f63b0b4d889f5ccd58c	0	2681	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1325
Video Poker	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/a2497f032065458abebb309d38363f9e.png	t	t	a2497f032065458abebb309d38363f9e	a2497f032065458abebb309d38363f9e	0	1681	t	96	Evolution	Evolution	{}	high	\N	\N	1326
First Person XXXtreme Lightning Roulette	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/2a15281bb0a34164a7e2680c4a1546b9.png	t	t	2a15281bb0a34164a7e2680c4a1546b9	2a15281bb0a34164a7e2680c4a1546b9	0	881	t	96	Evolution	Evolution	{}	low	\N	\N	1327
First person Top Card	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/10946ed0386547b09362c31b9549b379.png	t	t	10946ed0386547b09362c31b9549b379	10946ed0386547b09362c31b9549b379	0	1684	t	96	Evolution	Evolution	{}	high	\N	\N	1349
First Person Video Poker	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/fd1148e04e304cada117cfab67424f12.png	t	t	fd1148e04e304cada117cfab67424f12	fd1148e04e304cada117cfab67424f12	0	884	t	96	Evolution	Evolution	{}	low	\N	\N	1350
First Person Deal or No Deal	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/0d9772445c7e4d9d92469c4e60a59d5c.png	t	t	0d9772445c7e4d9d92469c4e60a59d5c	0d9772445c7e4d9d92469c4e60a59d5c	0	884	t	96	Evolution	Evolution	{}	high	\N	\N	1351
First Person Lightning Blackjack	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/b6193a96f3ee420a91a450166ae58a34.png	t	t	b6193a96f3ee420a91a450166ae58a34	b6193a96f3ee420a91a450166ae58a34	0	10186	t	96	Evolution	Evolution	{}	very-high	\N	\N	1352
First Person Prosperity Tree Baccarat	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/f9dc851a29324b52b671e3aeec79c193.png	t	t	f9dc851a29324b52b671e3aeec79c193	f9dc851a29324b52b671e3aeec79c193	0	2335	t	96	Evolution	Evolution	{}	high	\N	\N	1353
Bingo Cientista Doidão	basic	https://gis-static.com/games/Caleta/af19e14315dc4b0ea6de24307b87ecb3.png	t	t	af19e14315dc4b0ea6de24307b87ecb3	af19e14315dc4b0ea6de24307b87ecb3	0	1520	t	96	Caleta	Caleta	{}	high	\N	\N	128
First Person Super Sic Bo	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/10462899dc7e4fd0a5b9462f49109043.png	t	t	10462899dc7e4fd0a5b9462f49109043	10462899dc7e4fd0a5b9462f49109043	0	1435	t	96	Evolution	Evolution	{}	medium	\N	\N	1354
Peek Baccarat	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/aab5b21a69654112815bc27d5975863d.png	f	f	aab5b21a69654112815bc27d5975863d	aab5b21a69654112815bc27d5975863d	0	1185	t	96	Evolution	Evolution	{}	low	\N	\N	1355
Surfing Beauties Video Bingo	basic	https://gis-static.com/games/Boldplay/fe88559d0e2e9fb756df4750160e19bdc8abf62f.png	t	t	fe88559d0e2e9fb756df4750160e19bdc8abf62f	fe88559d0e2e9fb756df4750160e19bdc8abf62f	0	1328	t	96	Boldplay	Boldplay	{}	medium	\N	\N	523
Prosperity Tree Baccarat	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/6c154c3c05af4b699375b8c89ec43503.png	t	t	6c154c3c05af4b699375b8c89ec43503	6c154c3c05af4b699375b8c89ec43503	0	2685	t	96	Evolution	Evolution	{}	medium-high	\N	\N	1356
Teen Patti	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/f89093959ee541e297e8d2f3ffb20fee.png	t	t	f89093959ee541e297e8d2f3ffb20fee	f89093959ee541e297e8d2f3ffb20fee	0	1685	t	96	Evolution	Evolution	{}	high	\N	\N	1357
Stock Market	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/ae26847c79d64a855008ed18b007b74b1fa168f1.png	t	t	ae26847c79d64a855008ed18b007b74b1fa168f1	ae26847c79d64a855008ed18b007b74b1fa168f1	0	2336	t	96	Evolution	Evolution	{}	high	\N	\N	1361
Aviator	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Spribe/cd3380ed05f94f1da361bc705b4881dd.png	t	t	cd3380ed05f94f1da361bc705b4881dd	cd3380ed05f94f1da361bc705b4881dd	0	1622	t	96	Spribe	Spribe	{}	high	\N	\N	848
Dice	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Spribe/6882dcc94d95462aaade03fb66ad6d90.png	t	t	6882dcc94d95462aaade03fb66ad6d90	6882dcc94d95462aaade03fb66ad6d90	0	822	t	96	Spribe	Spribe	{}	low	\N	\N	849
Goal	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Spribe/e1a8aa76c5924972883f357fca522a90.png	t	t	e1a8aa76c5924972883f357fca522a90	e1a8aa76c5924972883f357fca522a90	0	822	t	96	Spribe	Spribe	{}	high	\N	\N	850
Hilo	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Spribe/0d1a068790a14b6d8f85ddc7a65395f4.png	t	t	0d1a068790a14b6d8f85ddc7a65395f4	0d1a068790a14b6d8f85ddc7a65395f4	0	10124	t	96	Spribe	Spribe	{}	very-high	\N	\N	851
Hotline	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Spribe/cebc5d7afc1a41179744cb76e4a7827c.png	t	t	cebc5d7afc1a41179744cb76e4a7827c	cebc5d7afc1a41179744cb76e4a7827c	0	2273	t	96	Spribe	Spribe	{}	high	\N	\N	852
Mines	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Spribe/87a2921a356c42859bd585c769b77ad1.png	t	t	87a2921a356c42859bd585c769b77ad1	87a2921a356c42859bd585c769b77ad1	0	1373	t	96	Spribe	Spribe	{}	medium	\N	\N	853
Plinko	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Spribe/e0009532f4134a4986cb701b2280ab8e.png	f	f	e0009532f4134a4986cb701b2280ab8e	e0009532f4134a4986cb701b2280ab8e	0	1123	t	96	Spribe	Spribe	{}	low	\N	\N	854
Keno	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Spribe/be94db56c8bb4a22b9dbdba4513008ec.png	t	t	be94db56c8bb4a22b9dbdba4513008ec	be94db56c8bb4a22b9dbdba4513008ec	0	2623	t	96	Spribe	Spribe	{}	medium-high	\N	\N	855
Mini Roulette	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Spribe/cb03cecc1fc0465fb281e85d4ef679c4.png	t	t	cb03cecc1fc0465fb281e85d4ef679c4	cb03cecc1fc0465fb281e85d4ef679c4	0	1623	t	96	Spribe	Spribe	{}	high	\N	\N	856
European Roulette	basic	https://gis-static.com/games/KAGaming/bd179a3132e74cd0aca1ed69fe3e8589.png	t	t	bd179a3132e74cd0aca1ed69fe3e8589	bd179a3132e74cd0aca1ed69fe3e8589	0	1342	t	96	KAGaming	KAGaming	{}	medium	\N	\N	607
Baccarat	basic	https://gis-static.com/games/VibraGaming/623042900b55df2087fc7d8b93220d85992290b1.png	f	f	623042900b55df2087fc7d8b93220d85992290b1	623042900b55df2087fc7d8b93220d85992290b1	0	1092	t	96	VibraGaming	VibraGaming	{}	low	\N	\N	608
Dice Disco: MEGA STACKS	basic	https://gis-static.com/games/Mascot/b3dfd47ac95f4078ad0a59121cf0ac7e.png	t	t	b3dfd47ac95f4078ad0a59121cf0ac7e	b3dfd47ac95f4078ad0a59121cf0ac7e	0	10097	t	96	Mascot	Mascot	{}	very-high	\N	\N	637
Aloha! Tiki Bar dice	basic	https://gis-static.com/games/Mascot/42180bf0e6b640a4bb96c53dc6bb2482.png	t	t	42180bf0e6b640a4bb96c53dc6bb2482	42180bf0e6b640a4bb96c53dc6bb2482	0	2246	t	96	Mascot	Mascot	{}	high	\N	\N	638
Bombay Blackjack	basic	https://gis-static.com/games/OneTouch/4fe10bababcb7ef029f73e80623cf488ab787e69.png	t	t	4fe10bababcb7ef029f73e80623cf488ab787e69	4fe10bababcb7ef029f73e80623cf488ab787e69	0	1346	t	96	OneTouch	OneTouch	{}	medium	\N	\N	639
KA Fish Party	basic	https://gis-static.com/games/KAGaming/63f9ea5d682e428e9dc19b91ab71eb6c.png	t	t	63f9ea5d682e428e9dc19b91ab71eb6c	63f9ea5d682e428e9dc19b91ab71eb6c	0	920	t	96	KAGaming	KAGaming	{}	high	\N	\N	640
Roulette	basic	https://gis-static.com/games/XProgaming/f354478aa85477dac9d9097b6a3b3648724b79bd.jpg	f	f	f354478aa85477dac9d9097b6a3b3648724b79bd	f354478aa85477dac9d9097b6a3b3648724b79bd	0	1001	t	96	XProgaming	XProgaming	{}	low	\N	\N	1
Blackjack	basic	https://gis-static.com/games/XProgaming/cb2d3bc6e2ce0532610c97b412723ac9a57337ac.jpg	t	t	cb2d3bc6e2ce0532610c97b412723ac9a57337ac	cb2d3bc6e2ce0532610c97b412723ac9a57337ac	0	1501	t	96	XProgaming	XProgaming	{}	high	\N	\N	2
Baccarat	basic	https://gis-static.com/games/XProgaming/2d590c3c6f239c2babde26d25d298957d556f93c.jpg	t	t	2d590c3c6f239c2babde26d25d298957d556f93c	2d590c3c6f239c2babde26d25d298957d556f93c	0	701	t	96	XProgaming	XProgaming	{}	low	\N	\N	3
Sic-Bo	basic	https://gis-static.com/games/XProgaming/5b7d61206828c23ef9ebf51e4b21f8a657ebfd3f.jpg	t	t	5b7d61206828c23ef9ebf51e4b21f8a657ebfd3f	5b7d61206828c23ef9ebf51e4b21f8a657ebfd3f	0	701	t	96	XProgaming	XProgaming	{}	high	\N	\N	4
Lucky 7	basic	https://gis-static.com/games/d4c5e1a2cba22ea543c6407b96f7a00cca665b48.png	t	t	d4c5e1a2cba22ea543c6407b96f7a00cca665b48	d4c5e1a2cba22ea543c6407b96f7a00cca665b48	0	10003	t	96	Betgames	Betgames	{}	very-high	\N	\N	5
Lucky 5	basic	https://gis-static.com/games/93509d7a9350eeed630807d5e941b70ebf0380be.png	t	t	93509d7a9350eeed630807d5e941b70ebf0380be	93509d7a9350eeed630807d5e941b70ebf0380be	0	2152	t	96	Betgames	Betgames	{}	high	\N	\N	6
Wheel Of Fortune	basic	https://gis-static.com/games/1c1c362e5d6f4a158054ac704c7da311d5c5b562.png	t	t	1c1c362e5d6f4a158054ac704c7da311d5c5b562	1c1c362e5d6f4a158054ac704c7da311d5c5b562	0	1252	t	96	Betgames	Betgames	{}	medium	\N	\N	7
Baccarat	basic	https://gis-static.com/games/1566861abf92c6f502d0f2c2a4d47461ff626d7c.png	t	t	1566861abf92c6f502d0f2c2a4d47461ff626d7c	1566861abf92c6f502d0f2c2a4d47461ff626d7c	0	702	t	96	Betgames	Betgames	{}	low	\N	\N	11
War Of Bets	basic	https://gis-static.com/games/608717ff036b04119fc0e3054b5f2d83431fedf5.png	t	t	608717ff036b04119fc0e3054b5f2d83431fedf5	608717ff036b04119fc0e3054b5f2d83431fedf5	0	702	t	96	Betgames	Betgames	{}	high	\N	\N	12
Black Jack VIP	basic	https://gis-static.com/games/cb1bf4924197653242438c79e5b449ce282dbc1a.png	t	t	cb1bf4924197653242438c79e5b449ce282dbc1a	cb1bf4924197653242438c79e5b449ce282dbc1a	0	10004	t	96	Platipus	Platipus	{}	very-high	\N	\N	13
Baccarat Mini	basic	https://gis-static.com/games/b14eed72ba525592e08368ecca1be74cc078f151.png	t	t	b14eed72ba525592e08368ecca1be74cc078f151	b14eed72ba525592e08368ecca1be74cc078f151	0	2153	t	96	Platipus	Platipus	{}	high	\N	\N	14
Baccarat VIP	basic	https://gis-static.com/games/35be53e1d9b5eab047fc957928bd22d3037e570a.png	t	t	35be53e1d9b5eab047fc957928bd22d3037e570a	35be53e1d9b5eab047fc957928bd22d3037e570a	0	1253	t	96	Platipus	Platipus	{}	medium	\N	\N	15
Black Jack	basic	https://gis-static.com/games/c297c18b30649d175db289ad8fce84bbb126e67a.png	f	f	c297c18b30649d175db289ad8fce84bbb126e67a	c297c18b30649d175db289ad8fce84bbb126e67a	0	1003	t	96	Mascot	Mascot	{}	low	\N	\N	16
Baccarat	basic	https://gis-static.com/games/73dfee0f3eb4a957fd0be44bb625e6e9822022ba.png	t	t	73dfee0f3eb4a957fd0be44bb625e6e9822022ba	73dfee0f3eb4a957fd0be44bb625e6e9822022ba	0	2503	t	96	Mascot	Mascot	{}	medium-high	\N	\N	17
American Roulette	basic	https://gis-static.com/games/97b44e87f1ae3b71dc5c7e92913cc77234a1580e.png	t	t	97b44e87f1ae3b71dc5c7e92913cc77234a1580e	97b44e87f1ae3b71dc5c7e92913cc77234a1580e	0	1503	t	96	BGaming	BGaming	{}	high	\N	\N	18
Multihand Blackjack Pro	basic	https://gis-static.com/games/27edf85d499c935982b9ced360157b2569a012dc.png	t	t	27edf85d499c935982b9ced360157b2569a012dc	27edf85d499c935982b9ced360157b2569a012dc	0	703	t	96	BGaming	BGaming	{}	low	\N	\N	19
European Roulette	basic	https://gis-static.com/games/c732011a78e064eebb47e077cbfb6c8e8283843d.png	t	t	c732011a78e064eebb47e077cbfb6c8e8283843d	c732011a78e064eebb47e077cbfb6c8e8283843d	0	703	t	96	BGaming	BGaming	{}	high	\N	\N	20
French Roulette	basic	https://gis-static.com/games/5026e867f9101af117d2fb0ca192e1730f7f737a.png	t	t	5026e867f9101af117d2fb0ca192e1730f7f737a	5026e867f9101af117d2fb0ca192e1730f7f737a	0	10005	t	96	BGaming	BGaming	{}	very-high	\N	\N	21
Heads and Tails	basic	https://gis-static.com/games/a273119050eb1ff5ec84997066e93f3b478c762e.png	t	t	a273119050eb1ff5ec84997066e93f3b478c762e	a273119050eb1ff5ec84997066e93f3b478c762e	0	2154	t	96	BGaming	BGaming	{}	high	\N	\N	22
Jogo Do Bicho	basic	https://gis-static.com/games/a1332b8d0bff44b8f75d366c248a02c719ce42cd.png	t	t	a1332b8d0bff44b8f75d366c248a02c719ce42cd	a1332b8d0bff44b8f75d366c248a02c719ce42cd	0	1254	t	96	BGaming	BGaming	{}	medium	\N	\N	23
Minesweeper	basic	https://gis-static.com/games/34e4dad686571ec3c91fba121215fbc98f117a47.png	f	f	34e4dad686571ec3c91fba121215fbc98f117a47	34e4dad686571ec3c91fba121215fbc98f117a47	0	1004	t	96	BGaming	BGaming	{}	low	\N	\N	24
Multihand Blackjack	basic	https://gis-static.com/games/772c50b6e70a91f89f0266e2ebfb9992/BGaming/c82de21cc34b6d1e388bba87b0b2b4b2d05c7e69.png	t	t	c82de21cc34b6d1e388bba87b0b2b4b2d05c7e69	c82de21cc34b6d1e388bba87b0b2b4b2d05c7e69	0	2504	t	96	BGaming	BGaming	{}	medium-high	\N	\N	25
Plinko	basic	https://gis-static.com/games/9eee9764948c4c300c1c575b7fdb36d0478a016e.png	t	t	9eee9764948c4c300c1c575b7fdb36d0478a016e	9eee9764948c4c300c1c575b7fdb36d0478a016e	0	1504	t	96	BGaming	BGaming	{}	high	\N	\N	26
Rocket Dice	basic	https://gis-static.com/games/198afd5d577beee0c6dc9fc91adb82347b18bb83.png	t	t	198afd5d577beee0c6dc9fc91adb82347b18bb83	198afd5d577beee0c6dc9fc91adb82347b18bb83	0	704	t	96	BGaming	BGaming	{}	low	\N	\N	27
Scratch Dice	basic	https://gis-static.com/games/9360a6055380bf3a837cf5910c993a8734ebafda.png	t	t	9360a6055380bf3a837cf5910c993a8734ebafda	9360a6055380bf3a837cf5910c993a8734ebafda	0	704	t	96	BGaming	BGaming	{}	high	\N	\N	28
Speedy 7	basic	https://gis-static.com/games/cd5fd48f354dedfa6468a3dd4c4b3d51eabf50dc.png	t	t	cd5fd48f354dedfa6468a3dd4c4b3d51eabf50dc	cd5fd48f354dedfa6468a3dd4c4b3d51eabf50dc	0	10006	t	96	Betgames	Betgames	{}	very-high	\N	\N	29
Baccarat Pro	basic	https://gis-static.com/games/84cf8ef0c0ad8d0071666ae6e552bdc18a861887.png	t	t	84cf8ef0c0ad8d0071666ae6e552bdc18a861887	84cf8ef0c0ad8d0071666ae6e552bdc18a861887	0	2155	t	96	Platipus	Platipus	{}	high	\N	\N	30
Andar Bahar	basic	https://gis-static.com/games/XProgaming/6f77a7938281be0ce4404e4dd10e1c055c603e20.jpg	t	t	6f77a7938281be0ce4404e4dd10e1c055c603e20	6f77a7938281be0ce4404e4dd10e1c055c603e20	0	1255	t	96	XProgaming	XProgaming	{}	medium	\N	\N	31
6+ Poker	basic	https://gis-static.com/games/5687990baddbb934621c0b80b0f5f989f521d1a5.png	f	f	5687990baddbb934621c0b80b0f5f989f521d1a5	5687990baddbb934621c0b80b0f5f989f521d1a5	0	1005	t	96	Betgames	Betgames	{}	low	\N	\N	32
High low	basic	https://gis-static.com/games/8d6e0bc0c7fd4e54e0e12003aa73ec875e36a699.png	t	t	8d6e0bc0c7fd4e54e0e12003aa73ec875e36a699	8d6e0bc0c7fd4e54e0e12003aa73ec875e36a699	0	2505	t	96	Betsolutions	Betsolutions	{}	medium-high	\N	\N	33
Zeppelin	basic	https://gis-static.com/games/cd0128cf16a2fd94d1b7546657f64d94080956be.png	t	t	cd0128cf16a2fd94d1b7546657f64d94080956be	cd0128cf16a2fd94d1b7546657f64d94080956be	0	1505	t	96	Betsolutions	Betsolutions	{}	high	\N	\N	34
Dice	basic	https://gis-static.com/games/c8afa9b2a85bf5e9770eb8406c15e8e79b91d752.png	t	t	c8afa9b2a85bf5e9770eb8406c15e8e79b91d752	c8afa9b2a85bf5e9770eb8406c15e8e79b91d752	0	705	t	96	Betsolutions	Betsolutions	{}	low	\N	\N	35
Mines	basic	https://gis-static.com/games/454d59f1a8eb1546433bf2440519f89644880f4c.png	t	t	454d59f1a8eb1546433bf2440519f89644880f4c	454d59f1a8eb1546433bf2440519f89644880f4c	0	705	t	96	Betsolutions	Betsolutions	{}	high	\N	\N	36
Plinko	basic	https://gis-static.com/games/bced615f3ff1482972e7246597e3230f0b0b67be.jpeg	t	t	bced615f3ff1482972e7246597e3230f0b0b67be	bced615f3ff1482972e7246597e3230f0b0b67be	0	10007	t	96	Betsolutions	Betsolutions	{}	very-high	\N	\N	37
Blackjack Supreme Multi Hand Perfect Pairs	basic	https://gis-static.com/games/a355f1838e0684b4eceb98d0876ba450f830c6da.png	t	t	a355f1838e0684b4eceb98d0876ba450f830c6da	a355f1838e0684b4eceb98d0876ba450f830c6da	0	2156	t	96	OneTouch	OneTouch	{}	high	\N	\N	38
Blackjack Supreme Single Hand Perfect Pairs	basic	https://gis-static.com/games/04101f97265a92b44bd591af127330cac89be702.png	t	t	04101f97265a92b44bd591af127330cac89be702	04101f97265a92b44bd591af127330cac89be702	0	1256	t	96	OneTouch	OneTouch	{}	medium	\N	\N	39
Dragon Tiger	basic	https://gis-static.com/games/404efaa68d461e4f9bf1f41eb5124e8cb819128f.png	f	f	404efaa68d461e4f9bf1f41eb5124e8cb819128f	404efaa68d461e4f9bf1f41eb5124e8cb819128f	0	1006	t	96	OneTouch	OneTouch	{}	low	\N	\N	40
Baccarat Supreme No Commission	basic	https://gis-static.com/games/f7758288f5a7126ff0620d34528327290ea80360.png	t	t	f7758288f5a7126ff0620d34528327290ea80360	f7758288f5a7126ff0620d34528327290ea80360	0	707	t	96	OneTouch	OneTouch	{}	low	\N	\N	41
Baccarat Supreme	basic	https://gis-static.com/games/dda68bb78a9f4b08c05b470dc81e41fa8fd615c0.png	t	t	dda68bb78a9f4b08c05b470dc81e41fa8fd615c0	dda68bb78a9f4b08c05b470dc81e41fa8fd615c0	0	707	t	96	OneTouch	OneTouch	{}	high	\N	\N	42
High Hand Hold`em Poker	basic	https://gis-static.com/games/71915624f2a0f411e3d02c2f2d407a0cf980ed17.png	t	t	71915624f2a0f411e3d02c2f2d407a0cf980ed17	71915624f2a0f411e3d02c2f2d407a0cf980ed17	0	2158	t	96	OneTouch	OneTouch	{}	high	\N	\N	43
In Between Poker	basic	https://gis-static.com/games/ca112305a2cca481643016b498784f5287573bd6.png	t	t	ca112305a2cca481643016b498784f5287573bd6	ca112305a2cca481643016b498784f5287573bd6	0	10009	t	96	OneTouch	OneTouch	{}	very-high	\N	\N	44
Andar Bahar	basic	https://gis-static.com/games/d28c9fb3b6aca17e87cbcb9bfc0e29217dc7eceb.png	t	t	d28c9fb3b6aca17e87cbcb9bfc0e29217dc7eceb	d28c9fb3b6aca17e87cbcb9bfc0e29217dc7eceb	0	1258	t	96	OneTouch	OneTouch	{}	medium	\N	\N	45
Wheel of Fortune	basic	https://gis-static.com/games/f9d0b7627d0fd3027cc0ae6ecd1bab156ab65f0a.png	t	t	f9d0b7627d0fd3027cc0ae6ecd1bab156ab65f0a	f9d0b7627d0fd3027cc0ae6ecd1bab156ab65f0a	0	2159	t	96	OneTouch	OneTouch	{}	high	\N	\N	46
Roulette	basic	https://gis-static.com/games/25aa3cf6dab045f516877fd46c4bc5d5fad1b9ae.png	t	t	25aa3cf6dab045f516877fd46c4bc5d5fad1b9ae	25aa3cf6dab045f516877fd46c4bc5d5fad1b9ae	0	1259	t	96	OneTouch	OneTouch	{}	medium	\N	\N	47
Blackjack Classic Perfect Pairs	basic	https://gis-static.com/games/d39722a1c9dcda354e0bc1c1e23a07fc3df4740c.png	f	f	d39722a1c9dcda354e0bc1c1e23a07fc3df4740c	d39722a1c9dcda354e0bc1c1e23a07fc3df4740c	0	1009	t	96	OneTouch	OneTouch	{}	low	\N	\N	48
Baccarat No Commission	basic	https://gis-static.com/games/55b147f965fc0729bae2883afe01d56f6ff4eb72.png	t	t	55b147f965fc0729bae2883afe01d56f6ff4eb72	55b147f965fc0729bae2883afe01d56f6ff4eb72	0	2509	t	96	OneTouch	OneTouch	{}	medium-high	\N	\N	49
Russian Poker	basic	https://gis-static.com/games/286c55c640e55ad7d89492445acc757658bf6698.png	t	t	286c55c640e55ad7d89492445acc757658bf6698	286c55c640e55ad7d89492445acc757658bf6698	0	1509	t	96	OneTouch	OneTouch	{}	high	\N	\N	50
Blackjack Classic	basic	https://gis-static.com/games/66d5bba5dbe943616f477c71c4580535246861ae.png	t	t	66d5bba5dbe943616f477c71c4580535246861ae	66d5bba5dbe943616f477c71c4580535246861ae	0	709	t	96	OneTouch	OneTouch	{}	low	\N	\N	51
Baccarat	basic	https://gis-static.com/games/913055a5124b715329aa1cb93bfb28d5a9f06b1c.png	t	t	913055a5124b715329aa1cb93bfb28d5a9f06b1c	913055a5124b715329aa1cb93bfb28d5a9f06b1c	0	709	t	96	OneTouch	OneTouch	{}	high	\N	\N	52
Hold’em Poker	basic	https://gis-static.com/games/b753a3c19b2cd72ad9b9cd0399b3f2440f0331d4.png	t	t	b753a3c19b2cd72ad9b9cd0399b3f2440f0331d4	b753a3c19b2cd72ad9b9cd0399b3f2440f0331d4	0	10011	t	96	OneTouch	OneTouch	{}	very-high	\N	\N	53
Sic Bo	basic	https://gis-static.com/games/d73696022c9562df90f22220b3b43d3953d1f1c3.png	t	t	d73696022c9562df90f22220b3b43d3953d1f1c3	d73696022c9562df90f22220b3b43d3953d1f1c3	0	2160	t	96	OneTouch	OneTouch	{}	high	\N	\N	54
Golden Chip Roulette	basic	https://gis-static.com/games/58bd9c22f7338410ad392ce45e3b8ab0ae88d9f8.png	t	t	58bd9c22f7338410ad392ce45e3b8ab0ae88d9f8	58bd9c22f7338410ad392ce45e3b8ab0ae88d9f8	0	1260	t	96	Yggdrasil	Yggdrasil	{}	medium	\N	\N	55
Roll The Dice	basic	https://gis-static.com/games/d48daeba557e41ce90efa610b05ea3b4.png	f	f	d48daeba557e41ce90efa610b05ea3b4	d48daeba557e41ce90efa610b05ea3b4	0	1010	t	96	Evoplay	Evoplay	{}	low	\N	\N	56
Heads & Tails	basic	https://gis-static.com/games/6dd92e63d70c4ad3ad54dd6ddd0fcabd.png	t	t	6dd92e63d70c4ad3ad54dd6ddd0fcabd	6dd92e63d70c4ad3ad54dd6ddd0fcabd	0	2510	t	96	Evoplay	Evoplay	{}	medium-high	\N	\N	57
More or Less	basic	https://gis-static.com/games/94dc195d989c4c26a3028154c2ba0f77.png	t	t	94dc195d989c4c26a3028154c2ba0f77	94dc195d989c4c26a3028154c2ba0f77	0	1510	t	96	Evoplay	Evoplay	{}	high	\N	\N	58
Scratch Match	basic	https://gis-static.com/games/432824aba253452ab1e580ef384ac614.png	t	t	432824aba253452ab1e580ef384ac614	432824aba253452ab1e580ef384ac614	0	1262	t	96	Evoplay	Evoplay	{}	medium	\N	\N	71
Magic Wheel	basic	https://gis-static.com/games/db1d18070431422184f2e2b0358e87d2.png	f	f	db1d18070431422184f2e2b0358e87d2	db1d18070431422184f2e2b0358e87d2	0	1012	t	96	Evoplay	Evoplay	{}	low	\N	\N	72
Bomb Squad	basic	https://gis-static.com/games/f7745384a1f24aff829441d230935292.png	t	t	f7745384a1f24aff829441d230935292	f7745384a1f24aff829441d230935292	0	2512	t	96	Evoplay	Evoplay	{}	medium-high	\N	\N	73
Texas Holdem Poker	basic	https://gis-static.com/games/0fd19555085421d297a7100bc4591205b9c1d754.png	f	f	0fd19555085421d297a7100bc4591205b9c1d754	0fd19555085421d297a7100bc4591205b9c1d754	0	1015	t	96	Evoplay	Evoplay	{}	low	\N	\N	86
Texas Holdem Bonus	basic	https://gis-static.com/games/9580fd012fe7faaf1bcd6fd9ebc61ed9d072fef3.png	t	t	9580fd012fe7faaf1bcd6fd9ebc61ed9d072fef3	9580fd012fe7faaf1bcd6fd9ebc61ed9d072fef3	0	2515	t	96	Evoplay	Evoplay	{}	medium-high	\N	\N	87
Penalty Shoot Out	basic	https://gis-static.com/games/0b943d7851deebc1fe854684eef1d75032234c8a.png	t	t	0b943d7851deebc1fe854684eef1d75032234c8a	0b943d7851deebc1fe854684eef1d75032234c8a	0	1515	t	96	Evoplay	Evoplay	{}	high	\N	\N	88
Mine Field	basic	https://gis-static.com/games/fc5bd16daea3c798917a29f2ccf505adea494e5e.png	t	t	fc5bd16daea3c798917a29f2ccf505adea494e5e	fc5bd16daea3c798917a29f2ccf505adea494e5e	0	715	t	96	Evoplay	Evoplay	{}	low	\N	\N	89
Wheel of Time	basic	https://gis-static.com/games/c90eaac005c3d83ead96f8adcf037cff3f3f7c51.png	t	t	c90eaac005c3d83ead96f8adcf037cff3f3f7c51	c90eaac005c3d83ead96f8adcf037cff3f3f7c51	0	2166	t	96	Evoplay	Evoplay	{}	high	\N	\N	92
Book of Keno	basic	https://gis-static.com/games/65a1c5d2af7411d6be1f5205cb323df6d7932780.png	t	t	65a1c5d2af7411d6be1f5205cb323df6d7932780	65a1c5d2af7411d6be1f5205cb323df6d7932780	0	714	t	96	Evoplay	Evoplay	{}	high	\N	\N	93
Pachin Girl	basic	https://gis-static.com/games/955f750fba11bf81a52fac6cec7d3b038b9044cf.png	t	t	955f750fba11bf81a52fac6cec7d3b038b9044cf	955f750fba11bf81a52fac6cec7d3b038b9044cf	0	1266	t	96	Evoplay	Evoplay	{}	medium	\N	\N	94
88 Bingo 88	basic	https://gis-static.com/games/6638a5399b4f641e0e1371fd329ab6cafbb66ee8.png	f	f	6638a5399b4f641e0e1371fd329ab6cafbb66ee8	6638a5399b4f641e0e1371fd329ab6cafbb66ee8	0	1016	t	96	Belatra Games	Belatra Games	{}	low	\N	\N	95
American Roulette	basic	https://gis-static.com/games/29e6dcde1cd11b432106af0937cb9e4e558b8689.png	t	t	29e6dcde1cd11b432106af0937cb9e4e558b8689	29e6dcde1cd11b432106af0937cb9e4e558b8689	0	2516	t	96	Belatra Games	Belatra Games	{}	medium-high	\N	\N	96
European Roulette	basic	https://gis-static.com/games/5f60f72027f3650108907d92c55702953674befd.png	t	t	5f60f72027f3650108907d92c55702953674befd	5f60f72027f3650108907d92c55702953674befd	0	1516	t	96	Belatra Games	Belatra Games	{}	high	\N	\N	97
Just A Bingo	basic	https://gis-static.com/games/79fa40baa209370530a06338143ef5fa492c96f0.png	t	t	79fa40baa209370530a06338143ef5fa492c96f0	79fa40baa209370530a06338143ef5fa492c96f0	0	716	t	96	Belatra Games	Belatra Games	{}	high	\N	\N	98
Bingo Soccer	basic	https://gis-static.com/games/be9e4cb4e2d12f58599a569e2aabf09546ca5a4e.png	t	t	be9e4cb4e2d12f58599a569e2aabf09546ca5a4e	be9e4cb4e2d12f58599a569e2aabf09546ca5a4e	0	10018	t	96	Belatra Games	Belatra Games	{}	very-high	\N	\N	99
Lucky Roulette	basic	https://gis-static.com/games/9085932146ecb38f7256b31fa4aacf54fe89bd49.png	t	t	9085932146ecb38f7256b31fa4aacf54fe89bd49	9085932146ecb38f7256b31fa4aacf54fe89bd49	0	2167	t	96	Belatra Games	Belatra Games	{}	high	\N	\N	100
Piggy Bank Scratch	basic	https://gis-static.com/games/9b7e7f404bef2c57beb02e45ae0ccf52a660490b.png	t	t	9b7e7f404bef2c57beb02e45ae0ccf52a660490b	9b7e7f404bef2c57beb02e45ae0ccf52a660490b	0	1267	t	96	Belatra Games	Belatra Games	{}	medium	\N	\N	101
Xmas KenoCat	basic	https://gis-static.com/games/4d883e94bdfc031753694800629e5d874c8c4da6.png	f	f	4d883e94bdfc031753694800629e5d874c8c4da6	4d883e94bdfc031753694800629e5d874c8c4da6	0	1017	t	96	Evoplay	Evoplay	{}	low	\N	\N	102
Fishing God	basic	https://gis-static.com/games/Spadegaming/46db64427se391c74141bc4169d41cgcdeb646d3e.png	t	t	46db64427se391c74141bc4169d41cgcdeb646d3e	46db64427se391c74141bc4169d41cgcdeb646d3e	0	2517	t	96	Spadegaming	Spadegaming	{}	medium-high	\N	\N	103
Fishing War	basic	https://gis-static.com/games/Spadegaming/05bbbc22fs8397f0434145cd5498b5g7f901418f7.png	t	t	05bbbc22fs8397f0434145cd5498b5g7f901418f7	05bbbc22fs8397f0434145cd5498b5g7f901418f7	0	1517	t	96	Spadegaming	Spadegaming	{}	high	\N	\N	104
King of Jumping Scratch	basic	https://gis-static.com/games/bc3a08d83f402e1331ebff9ebd6c9e7c871a9cd4.jpeg	t	t	bc3a08d83f402e1331ebff9ebd6c9e7c871a9cd4	bc3a08d83f402e1331ebff9ebd6c9e7c871a9cd4	0	717	t	96	Belatra Games	Belatra Games	{}	low	\N	\N	105
European Roulette	basic	https://gis-static.com/games/b799a2aa9884bf311fb673cd54b12ec71359e134.png	t	t	b799a2aa9884bf311fb673cd54b12ec71359e134	b799a2aa9884bf311fb673cd54b12ec71359e134	0	717	t	96	Platipus	Platipus	{}	high	\N	\N	106
European Roulette	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Spearhead Studios/6370a69b570a4a0fd769cabc4f76215e.png	t	t	6370a69b570a4a0fd769cabc4f76215e	6370a69b570a4a0fd769cabc4f76215e	0	10019	t	96	Spearhead Studios	Spearhead Studios	{}	very-high	\N	\N	107
King Octopus	basic	https://gis-static.com/games/KAGaming/1ba1b920bc824c538e44756bed9f6667.png	t	t	1ba1b920bc824c538e44756bed9f6667	1ba1b920bc824c538e44756bed9f6667	0	2168	t	96	KAGaming	KAGaming	{}	high	\N	\N	108
Romance of the Three Kingdoms	basic	https://gis-static.com/games/KAGaming/1defa77493db46ef9f53ba67d385e804.png	t	t	1defa77493db46ef9f53ba67d385e804	1defa77493db46ef9f53ba67d385e804	0	1268	t	96	KAGaming	KAGaming	{}	medium	\N	\N	109
Golden Dragon	basic	https://gis-static.com/games/KAGaming/4176204002ac4d9493495928133306bf.png	f	f	4176204002ac4d9493495928133306bf	4176204002ac4d9493495928133306bf	0	1018	t	96	KAGaming	KAGaming	{}	low	\N	\N	110
AirCombat 1942	basic	https://gis-static.com/games/KAGaming/709d80f13d4b4d3d9a4955ffbdf5d1c7.png	t	t	709d80f13d4b4d3d9a4955ffbdf5d1c7	709d80f13d4b4d3d9a4955ffbdf5d1c7	0	2518	t	96	KAGaming	KAGaming	{}	medium-high	\N	\N	111
Space Cat	basic	https://gis-static.com/games/KAGaming/6fdaa320813842f88b43c81febf4e080.png	t	t	6fdaa320813842f88b43c81febf4e080	6fdaa320813842f88b43c81febf4e080	0	1518	t	96	KAGaming	KAGaming	{}	high	\N	\N	112
KA Fish Hunter	basic	https://gis-static.com/games/KAGaming/cec94918486c4de399efc78841c60724.png	t	t	cec94918486c4de399efc78841c60724	cec94918486c4de399efc78841c60724	0	718	t	96	KAGaming	KAGaming	{}	low	\N	\N	113
Animal Fishing	basic	https://gis-static.com/games/KAGaming/e510c0efe0004749881eff5d9ea45a62.png	t	t	e510c0efe0004749881eff5d9ea45a62	e510c0efe0004749881eff5d9ea45a62	0	718	t	96	KAGaming	KAGaming	{}	high	\N	\N	114
Fishing Expedition	basic	https://gis-static.com/games/KAGaming/cdcde38c67b84e2fa4526b84c85eec45.png	t	t	cdcde38c67b84e2fa4526b84c85eec45	cdcde38c67b84e2fa4526b84c85eec45	0	10020	t	96	KAGaming	KAGaming	{}	very-high	\N	\N	115
Blocky Block 2	basic	https://gis-static.com/games/KAGaming/fcd6f92ce7044fdfad2db48121e01383.png	t	t	fcd6f92ce7044fdfad2db48121e01383	fcd6f92ce7044fdfad2db48121e01383	0	2169	t	96	KAGaming	KAGaming	{}	high	\N	\N	116
Shock Tower	basic	https://gis-static.com/games/KAGaming/03a47a8409284625ac4effaeaa20a58d.png	t	t	03a47a8409284625ac4effaeaa20a58d	03a47a8409284625ac4effaeaa20a58d	0	1269	t	96	KAGaming	KAGaming	{}	medium	\N	\N	117
Dragon Ball	basic	https://gis-static.com/games/KAGaming/36e9c6669b8f4182ae353d620b40367a.png	f	f	36e9c6669b8f4182ae353d620b40367a	36e9c6669b8f4182ae353d620b40367a	0	1019	t	96	KAGaming	KAGaming	{}	low	\N	\N	118
Super Keno	basic	https://gis-static.com/games/KAGaming/6103712a2f1d4092a340abd297362beb.png	t	t	6103712a2f1d4092a340abd297362beb	6103712a2f1d4092a340abd297362beb	0	719	t	96	KAGaming	KAGaming	{}	low	\N	\N	121
Super Video Poker	basic	https://gis-static.com/games/KAGaming/2e7cf5c6c6864a9e9bc9eb2b6654d726.png	t	t	2e7cf5c6c6864a9e9bc9eb2b6654d726	2e7cf5c6c6864a9e9bc9eb2b6654d726	0	719	t	96	KAGaming	KAGaming	{}	high	\N	\N	122
Fruit Mountain	basic	https://gis-static.com/games/KAGaming/c06ac51a026046ba8daf965d993a0101.png	t	t	c06ac51a026046ba8daf965d993a0101	c06ac51a026046ba8daf965d993a0101	0	10021	t	96	KAGaming	KAGaming	{}	very-high	\N	\N	123
Bingo Bruxaria	basic	https://gis-static.com/games/Caleta/16552ac8c2b8439cb01e60cbd9d6b52a.png	f	f	16552ac8c2b8439cb01e60cbd9d6b52a	16552ac8c2b8439cb01e60cbd9d6b52a	0	1020	t	96	Caleta	Caleta	{}	low	\N	\N	126
Bingo Trevo da Sorte	basic	https://gis-static.com/games/Caleta/f5b6b5435c364885a187f6a7328e77a9.png	t	t	f5b6b5435c364885a187f6a7328e77a9	f5b6b5435c364885a187f6a7328e77a9	0	2520	t	96	Caleta	Caleta	{}	medium-high	\N	\N	127
Bingo Gênio	basic	https://gis-static.com/games/Caleta/7d75af44c492417a88d00ec1b042f9c1.png	t	t	7d75af44c492417a88d00ec1b042f9c1	7d75af44c492417a88d00ec1b042f9c1	0	934	t	96	Caleta	Caleta	{}	high	\N	\N	131
Bingo Iglu	basic	https://gis-static.com/games/Caleta/0ba542ee16d1449cbf7cf3aa8bdb5073.png	t	t	0ba542ee16d1449cbf7cf3aa8bdb5073	0ba542ee16d1449cbf7cf3aa8bdb5073	0	10022	t	96	Caleta	Caleta	{}	very-high	\N	\N	132
Banana Bingo	basic	https://gis-static.com/games/Caleta/942502f84acc42f7a426a5d668d70d0e.png	t	t	942502f84acc42f7a426a5d668d70d0e	942502f84acc42f7a426a5d668d70d0e	0	2171	t	96	Caleta	Caleta	{}	high	\N	\N	133
Banana Keno	basic	https://gis-static.com/games/Caleta/6b00a42469b44121945882ca8f8e9ec7.png	t	t	6b00a42469b44121945882ca8f8e9ec7	6b00a42469b44121945882ca8f8e9ec7	0	1271	t	96	Caleta	Caleta	{}	medium	\N	\N	134
Magical Keno	basic	https://gis-static.com/games/Caleta/bea225dcc64b48f4af4d012e5251d364.png	f	f	bea225dcc64b48f4af4d012e5251d364	bea225dcc64b48f4af4d012e5251d364	0	1021	t	96	Caleta	Caleta	{}	low	\N	\N	135
Bingo Hortinha	basic	https://gis-static.com/games/Caleta/5589ccfc86eb41e4800b2261a31927ad.png	t	t	5589ccfc86eb41e4800b2261a31927ad	5589ccfc86eb41e4800b2261a31927ad	0	2521	t	96	Caleta	Caleta	{}	medium-high	\N	\N	136
Bingo Saga Loca	basic	https://gis-static.com/games/Caleta/1abba795b6b944ca921340ef1ab0e4d7.png	t	t	1abba795b6b944ca921340ef1ab0e4d7	1abba795b6b944ca921340ef1ab0e4d7	0	1521	t	96	Caleta	Caleta	{}	high	\N	\N	137
Bingo Pirata	basic	https://gis-static.com/games/Caleta/292ca59e0d8e4f20a23ffdf3a1570ff5.png	t	t	292ca59e0d8e4f20a23ffdf3a1570ff5	292ca59e0d8e4f20a23ffdf3a1570ff5	0	721	t	96	Caleta	Caleta	{}	low	\N	\N	138
Bingo Señor Taco	basic	https://gis-static.com/games/Caleta/71ab2b84d9b245b882f0dd4745a8a134.png	t	t	71ab2b84d9b245b882f0dd4745a8a134	71ab2b84d9b245b882f0dd4745a8a134	0	721	t	96	Caleta	Caleta	{}	high	\N	\N	139
Bingo Señorita Calavera	basic	https://gis-static.com/games/Caleta/8546e4b3c21540608bb7d9bdae7730cc.png	t	t	8546e4b3c21540608bb7d9bdae7730cc	8546e4b3c21540608bb7d9bdae7730cc	0	10023	t	96	Caleta	Caleta	{}	very-high	\N	\N	140
Bingolaço	basic	https://gis-static.com/games/Caleta/58b56a1fc5a74d138972b62f719ad648.png	t	t	58b56a1fc5a74d138972b62f719ad648	58b56a1fc5a74d138972b62f719ad648	0	2172	t	96	Caleta	Caleta	{}	high	\N	\N	141
Bingolícia	basic	https://gis-static.com/games/Caleta/b10dfd8b82964c6a8cd133d1dab6423f.png	t	t	b10dfd8b82964c6a8cd133d1dab6423f	b10dfd8b82964c6a8cd133d1dab6423f	0	1272	t	96	Caleta	Caleta	{}	medium	\N	\N	142
Jungle Keno	basic	https://gis-static.com/games/Caleta/ed48dc251974466a9a7939a17863a18c.png	f	f	ed48dc251974466a9a7939a17863a18c	ed48dc251974466a9a7939a17863a18c	0	1022	t	96	Caleta	Caleta	{}	low	\N	\N	143
Betina Bingo	basic	https://gis-static.com/games/Caleta/2897f0ce6703408dbeaf15fda936d106.png	t	t	2897f0ce6703408dbeaf15fda936d106	2897f0ce6703408dbeaf15fda936d106	0	2522	t	96	Caleta	Caleta	{}	medium-high	\N	\N	144
Atomico Lotto	basic	https://gis-static.com/games/Caleta/32c25da658cf44b888f36329128af8b8.png	t	t	32c25da658cf44b888f36329128af8b8	32c25da658cf44b888f36329128af8b8	0	1522	t	96	Caleta	Caleta	{}	high	\N	\N	145
Bingo Fada da Fortuna	basic	https://gis-static.com/games/Caleta/cebcf6adf69441229436d672e62f5e08.png	t	t	cebcf6adf69441229436d672e62f5e08	cebcf6adf69441229436d672e62f5e08	0	722	t	96	Caleta	Caleta	{}	low	\N	\N	146
Bingo Tornado	basic	https://gis-static.com/games/Caleta/486fc82723ee43219a8cb0b5b3255f4d.png	t	t	486fc82723ee43219a8cb0b5b3255f4d	486fc82723ee43219a8cb0b5b3255f4d	0	722	t	96	Caleta	Caleta	{}	high	\N	\N	147
Mysteries of the East	basic	https://gis-static.com/games/18c514e04524f12c927e809a9ddb36626e3bd6aa.png	t	t	18c514e04524f12c927e809a9ddb36626e3bd6aa	18c514e04524f12c927e809a9ddb36626e3bd6aa	0	10024	t	96	Evoplay	Evoplay	{}	very-high	\N	\N	148
Sic Bo	basic	https://gis-static.com/games/2a32b65b9fe6dd29b7e72c7755cc47ed9ee2ed3a.png	t	t	2a32b65b9fe6dd29b7e72c7755cc47ed9ee2ed3a	2a32b65b9fe6dd29b7e72c7755cc47ed9ee2ed3a	0	2174	t	96	Belatra Games	Belatra Games	{}	high	\N	\N	149
Dragon/Tiger	basic	https://gis-static.com/games/TripleProfitsGames/543ecfcb13d14129abcad94bef505226.png	t	t	543ecfcb13d14129abcad94bef505226	543ecfcb13d14129abcad94bef505226	0	2524	t	96	TripleProfitsGames	TripleProfitsGames	{}	medium-high	\N	\N	152
Sic-Bo	basic	https://gis-static.com/games/TripleProfitsGames/556fea6c221c4e36b7d2f65eb29f4dbd.png	t	t	556fea6c221c4e36b7d2f65eb29f4dbd	556fea6c221c4e36b7d2f65eb29f4dbd	0	1524	t	96	TripleProfitsGames	TripleProfitsGames	{}	high	\N	\N	153
San Gong	basic	https://gis-static.com/games/TripleProfitsGames/bccecb01fc5b4e75ac9701dda7ce1a98.png	t	t	bccecb01fc5b4e75ac9701dda7ce1a98	bccecb01fc5b4e75ac9701dda7ce1a98	0	724	t	96	TripleProfitsGames	TripleProfitsGames	{}	low	\N	\N	154
Super 6 Baccarat	basic	https://gis-static.com/games/TripleProfitsGames/b1e4fc6796bc4ac4a4f02f218bf2fbd0.png	t	t	b1e4fc6796bc4ac4a4f02f218bf2fbd0	b1e4fc6796bc4ac4a4f02f218bf2fbd0	0	724	t	96	TripleProfitsGames	TripleProfitsGames	{}	high	\N	\N	155
Super Baccarat	basic	https://gis-static.com/games/TripleProfitsGames/1285e959dbce4cfda8ab8bfc8a6f4d2d.png	t	t	1285e959dbce4cfda8ab8bfc8a6f4d2d	1285e959dbce4cfda8ab8bfc8a6f4d2d	0	2175	t	96	TripleProfitsGames	TripleProfitsGames	{}	high	\N	\N	156
Andar Bahar	basic	https://gis-static.com/games/af7bb1da44e576c30666da7a31799d1fbf62cec1.png	t	t	af7bb1da44e576c30666da7a31799d1fbf62cec1	af7bb1da44e576c30666da7a31799d1fbf62cec1	0	1275	t	96	Betgames	Betgames	{}	medium	\N	\N	157
PlingoBall	basic	https://gis-static.com/games/5f7db2e48938f8deabd0aae92ffd60f7ac75f462.png	f	f	5f7db2e48938f8deabd0aae92ffd60f7ac75f462	5f7db2e48938f8deabd0aae92ffd60f7ac75f462	0	1025	t	96	Evoplay	Evoplay	{}	low	\N	\N	158
Teen Patti 20/20	basic	https://gis-static.com/games/0a73e3d38c9ce4659cd4dbc66c3355901f834db0.jpeg	t	t	0a73e3d38c9ce4659cd4dbc66c3355901f834db0	0a73e3d38c9ce4659cd4dbc66c3355901f834db0	0	2525	t	96	XProgaming	XProgaming	{}	medium-high	\N	\N	159
Halloween Scratchcard	basic	https://gis-static.com/games/339723924d7d54601a353304ee67a5c9d97d53b5.png	t	t	339723924d7d54601a353304ee67a5c9d97d53b5	339723924d7d54601a353304ee67a5c9d97d53b5	0	1525	t	96	Caleta	Caleta	{}	high	\N	\N	160
Alien Hunter	basic	https://gis-static.com/games/f0cbade3a85414f1c277dc9c8d472239a24a07f5.png	t	t	f0cbade3a85414f1c277dc9c8d472239a24a07f5	f0cbade3a85414f1c277dc9c8d472239a24a07f5	0	725	t	96	Spadegaming	Spadegaming	{}	low	\N	\N	161
Zombie Party	basic	https://gis-static.com/games/09e822a9345ef9ff16c98b2c7e1c4c1b6034b958.png	t	t	09e822a9345ef9ff16c98b2c7e1c4c1b6034b958	09e822a9345ef9ff16c98b2c7e1c4c1b6034b958	0	725	t	96	Spadegaming	Spadegaming	{}	high	\N	\N	162
Casino Hold'em	basic	https://gis-static.com/games/2b7dbbca300cc60b16c849e34016f13af349ad4b.png	t	t	2b7dbbca300cc60b16c849e34016f13af349ad4b	2b7dbbca300cc60b16c849e34016f13af349ad4b	0	10027	t	96	Mascot	Mascot	{}	very-high	\N	\N	163
Trevo da Sorte Scratchcard	basic	https://gis-static.com/games/fe7e1a2afed56456287a4509d488381818aae9a9.png	t	t	fe7e1a2afed56456287a4509d488381818aae9a9	fe7e1a2afed56456287a4509d488381818aae9a9	0	2176	t	96	Caleta	Caleta	{}	high	\N	\N	164
Boto Bingo	basic	https://gis-static.com/games/165f23673900994baa3311260e957a9725e224eb.png	t	t	165f23673900994baa3311260e957a9725e224eb	165f23673900994baa3311260e957a9725e224eb	0	1276	t	96	Caleta	Caleta	{}	medium	\N	\N	165
Bingo Halloween	basic	https://gis-static.com/games/c5a7f2fab933a23b9735e36b13680a6c6f98b112.png	f	f	c5a7f2fab933a23b9735e36b13680a6c6f98b112	c5a7f2fab933a23b9735e36b13680a6c6f98b112	0	1026	t	96	Caleta	Caleta	{}	low	\N	\N	166
Bonanza Wheel	basic	https://gis-static.com/games/6e7a9fcfaafc086af8f16ca37fcc1c1395d54ef7.png	t	t	6e7a9fcfaafc086af8f16ca37fcc1c1395d54ef7	6e7a9fcfaafc086af8f16ca37fcc1c1395d54ef7	0	2526	t	96	Evoplay	Evoplay	{}	medium-high	\N	\N	167
Halloween Keno	basic	https://gis-static.com/games/55a68abddf3a8e7eab0afa47294b2fed5fc02aa9.png	t	t	55a68abddf3a8e7eab0afa47294b2fed5fc02aa9	55a68abddf3a8e7eab0afa47294b2fed5fc02aa9	0	1526	t	96	Caleta	Caleta	{}	high	\N	\N	168
Save the Hamster	basic	https://gis-static.com/games/f847b0bb49cb89d8cf7e6d2c60e5b6211f125554.png	t	t	f847b0bb49cb89d8cf7e6d2c60e5b6211f125554	f847b0bb49cb89d8cf7e6d2c60e5b6211f125554	0	726	t	96	Evoplay	Evoplay	{}	high	\N	\N	170
Poker Ways	basic	https://gis-static.com/games/dfad67bc66cc0fcf251ca498677db4a5016faf18.png	t	t	dfad67bc66cc0fcf251ca498677db4a5016faf18	dfad67bc66cc0fcf251ca498677db4a5016faf18	0	10028	t	96	Spadegaming	Spadegaming	{}	very-high	\N	\N	171
Roll to Luck	basic	https://gis-static.com/games/e3fb99c163a0e90a08ab692ad67919a2e4e0c11c.png	t	t	e3fb99c163a0e90a08ab692ad67919a2e4e0c11c	e3fb99c163a0e90a08ab692ad67919a2e4e0c11c	0	1277	t	96	Evoplay	Evoplay	{}	medium	\N	\N	173
Poseidon's Secret	basic	https://gis-static.com/games/KAGaming/5717ddb615524338b646e27ba28ce51e.png	f	f	5717ddb615524338b646e27ba28ce51e	5717ddb615524338b646e27ba28ce51e	0	1027	t	96	KAGaming	KAGaming	{}	low	\N	\N	174
Mermaid Hunter	basic	https://gis-static.com/games/KAGaming/894e6883034c470da7773f620f5dfa47.png	t	t	894e6883034c470da7773f620f5dfa47	894e6883034c470da7773f620f5dfa47	0	2527	t	96	KAGaming	KAGaming	{}	medium-high	\N	\N	175
Won Won Catching	basic	https://gis-static.com/games/KAGaming/518b5cbe2afa43ca9df816f194eb2531.png	t	t	518b5cbe2afa43ca9df816f194eb2531	518b5cbe2afa43ca9df816f194eb2531	0	1527	t	96	KAGaming	KAGaming	{}	high	\N	\N	176
Bingo Billion Llama	basic	https://gis-static.com/games/5c1eca9eb8a9f224937e058aa763c0bdcae65469.png	t	t	5c1eca9eb8a9f224937e058aa763c0bdcae65469	5c1eca9eb8a9f224937e058aa763c0bdcae65469	0	727	t	96	Caleta	Caleta	{}	low	\N	\N	177
Halloween Lotto	basic	https://gis-static.com/games/f32e946f5e04fd941cc7ca50ce45c9360981a780.png	t	t	f32e946f5e04fd941cc7ca50ce45c9360981a780	f32e946f5e04fd941cc7ca50ce45c9360981a780	0	727	t	96	Caleta	Caleta	{}	high	\N	\N	178
Bingo Gatinho	basic	https://gis-static.com/games/f05e9d15a8b0973cafd1524eb37d628082171f38.png	t	t	f05e9d15a8b0973cafd1524eb37d628082171f38	f05e9d15a8b0973cafd1524eb37d628082171f38	0	728	t	96	Caleta	Caleta	{}	low	\N	\N	185
Fast Gold Dragon Tiger	basic	https://gis-static.com/games/0ad7692882f976678bf12964d0c172fde97f4526.png	t	t	0ad7692882f976678bf12964d0c172fde97f4526	0ad7692882f976678bf12964d0c172fde97f4526	0	2179	t	96	XProgaming	XProgaming	{}	high	\N	\N	188
Space XY	basic	https://gis-static.com/games/f10da42ab4693d959775180a33b5c7ff51e3cde9.png	t	t	f10da42ab4693d959775180a33b5c7ff51e3cde9	f10da42ab4693d959775180a33b5c7ff51e3cde9	0	1279	t	96	BGaming	BGaming	{}	medium	\N	\N	189
Burning Pearl Bingo	basic	https://gis-static.com/games/f624ed082b9280306e3f8daaaf4bc5f1/EurasianGamingBingo/3cf061fd37854c7294ce460fd9d4aaeb.png	f	f	3cf061fd37854c7294ce460fd9d4aaeb	3cf061fd37854c7294ce460fd9d4aaeb	0	1029	t	96	EurasianGamingBingo	EurasianGamingBingo	{}	low	\N	\N	190
Neptune Bingo	basic	https://gis-static.com/games/f624ed082b9280306e3f8daaaf4bc5f1/EurasianGamingBingo/da5d7c25dcb24b1e9b75a4ff712abaa1.png	t	t	da5d7c25dcb24b1e9b75a4ff712abaa1	da5d7c25dcb24b1e9b75a4ff712abaa1	0	2529	t	96	EurasianGamingBingo	EurasianGamingBingo	{}	medium-high	\N	\N	191
Cryptomania Bingo	basic	https://gis-static.com/games/f624ed082b9280306e3f8daaaf4bc5f1/EurasianGamingBingo/1336f300a21b41e99220f9ceb66121d6.png	t	t	1336f300a21b41e99220f9ceb66121d6	1336f300a21b41e99220f9ceb66121d6	0	1529	t	96	EurasianGamingBingo	EurasianGamingBingo	{}	high	\N	\N	192
Caishen Riches Bingo	basic	https://gis-static.com/games/f624ed082b9280306e3f8daaaf4bc5f1/EurasianGamingBingo/f8a85cef1b254d4f983eb86c830bb9a4.png	t	t	f8a85cef1b254d4f983eb86c830bb9a4	f8a85cef1b254d4f983eb86c830bb9a4	0	729	t	96	EurasianGamingBingo	EurasianGamingBingo	{}	low	\N	\N	193
Chilli Hunter Bingo	basic	https://gis-static.com/games/f624ed082b9280306e3f8daaaf4bc5f1/EurasianGamingBingo/46732291888f4716860c08899d3869e5.png	t	t	46732291888f4716860c08899d3869e5	46732291888f4716860c08899d3869e5	0	729	t	96	EurasianGamingBingo	EurasianGamingBingo	{}	high	\N	\N	194
American Blackjack	basic	https://gis-static.com/games/Nucleus/7d30a06c7baf44d483be5fb7d821a52e.png	t	t	7d30a06c7baf44d483be5fb7d821a52e	7d30a06c7baf44d483be5fb7d821a52e	0	10031	t	96	Nucleus	Nucleus	{}	very-high	\N	\N	195
Baccarat	basic	https://gis-static.com/games/Nucleus/43e710f336264f9c80231ddd458d6974.png	f	f	43e710f336264f9c80231ddd458d6974	43e710f336264f9c80231ddd458d6974	0	1032	t	96	Nucleus	Nucleus	{}	low	\N	\N	196
Draw Hi-Lo	basic	https://gis-static.com/games/Nucleus/1dec4f9bf4cc46caa1fc13922fe037e7.png	t	t	1dec4f9bf4cc46caa1fc13922fe037e7	1dec4f9bf4cc46caa1fc13922fe037e7	0	2532	t	96	Nucleus	Nucleus	{}	medium-high	\N	\N	197
Pai Gow	basic	https://gis-static.com/games/Nucleus/d00d3b6d17a34118a1d55a5925756afa.png	t	t	d00d3b6d17a34118a1d55a5925756afa	d00d3b6d17a34118a1d55a5925756afa	0	1532	t	96	Nucleus	Nucleus	{}	high	\N	\N	198
Red Dog	basic	https://gis-static.com/games/Nucleus/56bf81876c2742f9b88a943e80dcd19d.png	t	t	56bf81876c2742f9b88a943e80dcd19d	56bf81876c2742f9b88a943e80dcd19d	0	732	t	96	Nucleus	Nucleus	{}	low	\N	\N	199
Three Card Rummy	basic	https://gis-static.com/games/Nucleus/1d15f16e106341198c99ca59ef07a1c5.png	t	t	1d15f16e106341198c99ca59ef07a1c5	1d15f16e106341198c99ca59ef07a1c5	0	732	t	96	Nucleus	Nucleus	{}	high	\N	\N	200
21 Burn Black Jack	basic	https://gis-static.com/games/Nucleus/143ee49b65fa4612b2e76046150fef25.png	t	t	143ee49b65fa4612b2e76046150fef25	143ee49b65fa4612b2e76046150fef25	0	10034	t	96	Nucleus	Nucleus	{}	very-high	\N	\N	201
European Blackjack	basic	https://gis-static.com/games/Nucleus/e8ff16ef87cd415e8c65f9126f33e33b.png	t	t	e8ff16ef87cd415e8c65f9126f33e33b	e8ff16ef87cd415e8c65f9126f33e33b	0	2183	t	96	Nucleus	Nucleus	{}	high	\N	\N	202
Single Deck Blackjack	basic	https://gis-static.com/games/Nucleus/98a7cace6dea4bb78802ef509664b695.png	t	t	98a7cace6dea4bb78802ef509664b695	98a7cace6dea4bb78802ef509664b695	0	1283	t	96	Nucleus	Nucleus	{}	medium	\N	\N	203
Caribbean Poker	basic	https://gis-static.com/games/Nucleus/68f5951ad1ba4b9d8d50448e97de65bf.png	f	f	68f5951ad1ba4b9d8d50448e97de65bf	68f5951ad1ba4b9d8d50448e97de65bf	0	1033	t	96	Nucleus	Nucleus	{}	low	\N	\N	204
Oasis Poker	basic	https://gis-static.com/games/Nucleus/774b229773614a5b96eadb88c17add65.png	t	t	774b229773614a5b96eadb88c17add65	774b229773614a5b96eadb88c17add65	0	2533	t	96	Nucleus	Nucleus	{}	medium-high	\N	\N	205
Pirate 21	basic	https://gis-static.com/games/Nucleus/e03eebd99e8346809ffbe830a2a1f75f.png	t	t	e03eebd99e8346809ffbe830a2a1f75f	e03eebd99e8346809ffbe830a2a1f75f	0	1533	t	96	Nucleus	Nucleus	{}	high	\N	\N	206
Pontoon	basic	https://gis-static.com/games/Nucleus/ad2b9aa3926d4b92aac2a98e33a0f300.png	t	t	ad2b9aa3926d4b92aac2a98e33a0f300	ad2b9aa3926d4b92aac2a98e33a0f300	0	733	t	96	Nucleus	Nucleus	{}	low	\N	\N	207
Triple Edge Poker	basic	https://gis-static.com/games/Nucleus/824eef2c399d4cbb88fbb673c862cf8e.png	t	t	824eef2c399d4cbb88fbb673c862cf8e	824eef2c399d4cbb88fbb673c862cf8e	0	733	t	96	Nucleus	Nucleus	{}	high	\N	\N	208
Super 7 Blackjack	basic	https://gis-static.com/games/Nucleus/2d748969b66f4b42ba56d3a7c2fd359a.png	t	t	2d748969b66f4b42ba56d3a7c2fd359a	2d748969b66f4b42ba56d3a7c2fd359a	0	10035	t	96	Nucleus	Nucleus	{}	very-high	\N	\N	209
War	basic	https://gis-static.com/games/Nucleus/9b7521b24a5441998a949274cbe08576.png	t	t	9b7521b24a5441998a949274cbe08576	9b7521b24a5441998a949274cbe08576	0	2184	t	96	Nucleus	Nucleus	{}	high	\N	\N	210
European Roulette	basic	https://gis-static.com/games/Nucleus/f1dd84a43c39439092e82738c3c6963b.png	t	t	f1dd84a43c39439092e82738c3c6963b	f1dd84a43c39439092e82738c3c6963b	0	1284	t	96	Nucleus	Nucleus	{}	medium	\N	\N	211
American Roulette	basic	https://gis-static.com/games/Nucleus/cf53925e48a6410abd502406830e43c1.png	f	f	cf53925e48a6410abd502406830e43c1	cf53925e48a6410abd502406830e43c1	0	1034	t	96	Nucleus	Nucleus	{}	low	\N	\N	212
VIP European Roulette	basic	https://gis-static.com/games/Nucleus/001c9c9e36874c3a8f1a99a8631af3d4.png	t	t	001c9c9e36874c3a8f1a99a8631af3d4	001c9c9e36874c3a8f1a99a8631af3d4	0	2534	t	96	Nucleus	Nucleus	{}	medium-high	\N	\N	213
Zoom Roulette	basic	https://gis-static.com/games/Nucleus/e0be22d154764b018b85d1317bb7c815.png	t	t	e0be22d154764b018b85d1317bb7c815	e0be22d154764b018b85d1317bb7c815	0	1534	t	96	Nucleus	Nucleus	{}	high	\N	\N	214
Carnaval Scratchcard	basic	https://gis-static.com/games/c5a88c2f4fc5fbfd4a6a3a155f26a8d56229f481.png	t	t	c5a88c2f4fc5fbfd4a6a3a155f26a8d56229f481	c5a88c2f4fc5fbfd4a6a3a155f26a8d56229f481	0	734	t	96	Caleta	Caleta	{}	low	\N	\N	215
Andar Nights	basic	https://gis-static.com/games/273811f3dc6ce6ed0c929c19d543336c6215d3e0.png	t	t	273811f3dc6ce6ed0c929c19d543336c6215d3e0	273811f3dc6ce6ed0c929c19d543336c6215d3e0	0	734	t	96	Evoplay	Evoplay	{}	high	\N	\N	216
Ultimate Blackjack II	basic	https://gis-static.com/games/ConceptGaming/fa93dde12ca54881bfe06c81089c7af8.png	t	t	fa93dde12ca54881bfe06c81089c7af8	fa93dde12ca54881bfe06c81089c7af8	0	10036	t	96	ConceptGaming	ConceptGaming	{}	very-high	\N	\N	217
Ultimate Blackjack	basic	https://gis-static.com/games/ConceptGaming/6677946dd5a44d70bc0ddeadadb97477.png	t	t	6677946dd5a44d70bc0ddeadadb97477	6677946dd5a44d70bc0ddeadadb97477	0	2185	t	96	ConceptGaming	ConceptGaming	{}	high	\N	\N	218
Craps	basic	https://gis-static.com/games/ConceptGaming/a021a48a168747d8927a1d52e1e1cdd5.png	t	t	a021a48a168747d8927a1d52e1e1cdd5	a021a48a168747d8927a1d52e1e1cdd5	0	1285	t	96	ConceptGaming	ConceptGaming	{}	medium	\N	\N	219
Jackpot Blackjack	basic	https://gis-static.com/games/ConceptGaming/59bce598eebf465b95f27b6b2e4c48fb.png	f	f	59bce598eebf465b95f27b6b2e4c48fb	59bce598eebf465b95f27b6b2e4c48fb	0	1035	t	96	ConceptGaming	ConceptGaming	{}	low	\N	\N	220
Jacks or Better	basic	https://gis-static.com/games/ConceptGaming/2f59b8e63db64a5c90a688c8ac5f73c3.png	t	t	2f59b8e63db64a5c90a688c8ac5f73c3	2f59b8e63db64a5c90a688c8ac5f73c3	0	2535	t	96	ConceptGaming	ConceptGaming	{}	medium-high	\N	\N	221
Classic Multi-Hand Blackjack (Black)	basic	https://gis-static.com/games/ConceptGaming/16a81a508c3b44a9a3f4ce1ebf47680d.png	t	t	16a81a508c3b44a9a3f4ce1ebf47680d	16a81a508c3b44a9a3f4ce1ebf47680d	0	1535	t	96	ConceptGaming	ConceptGaming	{}	high	\N	\N	222
Classic Multi-Hand Blackjack (Red)	basic	https://gis-static.com/games/ConceptGaming/37051c1d0e6c483da43590a7af5a139a.png	t	t	37051c1d0e6c483da43590a7af5a139a	37051c1d0e6c483da43590a7af5a139a	0	735	t	96	ConceptGaming	ConceptGaming	{}	low	\N	\N	223
American Roulette	basic	https://gis-static.com/games/ConceptGaming/35694e22c2cb4033846ea521309bbe9b.png	t	t	35694e22c2cb4033846ea521309bbe9b	35694e22c2cb4033846ea521309bbe9b	0	735	t	96	ConceptGaming	ConceptGaming	{}	high	\N	\N	224
Keno Fortunes	basic	https://gis-static.com/games/ConceptGaming/ea7fdfefddf54deb9c818a448b57a8bb.png	t	t	ea7fdfefddf54deb9c818a448b57a8bb	ea7fdfefddf54deb9c818a448b57a8bb	0	10037	t	96	ConceptGaming	ConceptGaming	{}	very-high	\N	\N	225
Keno Vegas	basic	https://gis-static.com/games/ConceptGaming/8ed3e10f544043e28b826f24ef990f81.png	t	t	8ed3e10f544043e28b826f24ef990f81	8ed3e10f544043e28b826f24ef990f81	0	2186	t	96	ConceptGaming	ConceptGaming	{}	high	\N	\N	226
Baccarat	basic	https://gis-static.com/games/ConceptGaming/5d42d220384b49ad8444348b7219037c.png	t	t	5d42d220384b49ad8444348b7219037c	5d42d220384b49ad8444348b7219037c	0	1286	t	96	ConceptGaming	ConceptGaming	{}	medium	\N	\N	227
Roulette	basic	https://gis-static.com/games/ConceptGaming/93c2ef957b3b4948bf37cece000b560f.png	f	f	93c2ef957b3b4948bf37cece000b560f	93c2ef957b3b4948bf37cece000b560f	0	1036	t	96	ConceptGaming	ConceptGaming	{}	low	\N	\N	228
Multi-Hand Blackjack V2	basic	https://gis-static.com/games/ConceptGaming/f7e49ce160fe449d9fbda555f6b2f51f.png	t	t	f7e49ce160fe449d9fbda555f6b2f51f	f7e49ce160fe449d9fbda555f6b2f51f	0	2536	t	96	ConceptGaming	ConceptGaming	{}	medium-high	\N	\N	229
Multi-Hand Blackjack	basic	https://gis-static.com/games/ConceptGaming/ba5bbbde506c46df886056345100e052.png	t	t	ba5bbbde506c46df886056345100e052	ba5bbbde506c46df886056345100e052	0	1536	t	96	ConceptGaming	ConceptGaming	{}	high	\N	\N	230
Five Hand Vegas Blackjack	basic	https://gis-static.com/games/ConceptGaming/96f6c1cc41924f52b0f502a8f950a223.png	t	t	96f6c1cc41924f52b0f502a8f950a223	96f6c1cc41924f52b0f502a8f950a223	0	736	t	96	ConceptGaming	ConceptGaming	{}	low	\N	\N	231
Five Hand Vegas Blackjack V2	basic	https://gis-static.com/games/ConceptGaming/f0cbebf07d37499da9817c0dc2d964ea.png	t	t	f0cbebf07d37499da9817c0dc2d964ea	f0cbebf07d37499da9817c0dc2d964ea	0	736	t	96	ConceptGaming	ConceptGaming	{}	high	\N	\N	232
Single Hand Blackjack	basic	https://gis-static.com/games/ConceptGaming/e0ff765dc1f44effa2a96a8043b55567.png	t	t	e0ff765dc1f44effa2a96a8043b55567	e0ff765dc1f44effa2a96a8043b55567	0	10038	t	96	ConceptGaming	ConceptGaming	{}	very-high	\N	\N	233
Keno Jackpot	basic	https://gis-static.com/games/ConceptGaming/851756e7f27c4156ae63d3b4b661123a.png	t	t	851756e7f27c4156ae63d3b4b661123a	851756e7f27c4156ae63d3b4b661123a	0	2187	t	96	ConceptGaming	ConceptGaming	{}	high	\N	\N	234
Andar Bahar	basic	https://gis-static.com/games/ConceptGaming/bfe5a475ff584ab7881b4094a19b1046.png	t	t	bfe5a475ff584ab7881b4094a19b1046	bfe5a475ff584ab7881b4094a19b1046	0	1287	t	96	ConceptGaming	ConceptGaming	{}	medium	\N	\N	235
Super Bola	basic	https://gis-static.com/games/VibraGaming/5d99a53b51a34a45927dfe43b2e6a635.png	f	f	5d99a53b51a34a45927dfe43b2e6a635	5d99a53b51a34a45927dfe43b2e6a635	0	1037	t	96	VibraGaming	VibraGaming	{}	low	\N	\N	236
Champions 2	basic	https://gis-static.com/games/VibraGaming/0bd55b4c386242ca80b308d4761649f8.png	t	t	0bd55b4c386242ca80b308d4761649f8	0bd55b4c386242ca80b308d4761649f8	0	2537	t	96	VibraGaming	VibraGaming	{}	medium-high	\N	\N	237
Showball 3	basic	https://gis-static.com/games/VibraGaming/987e088a5b2d4fb69c7195a64175afa6.png	t	t	987e088a5b2d4fb69c7195a64175afa6	987e088a5b2d4fb69c7195a64175afa6	0	1537	t	96	VibraGaming	VibraGaming	{}	high	\N	\N	238
Turbo 90	basic	https://gis-static.com/games/VibraGaming/f4262e9203fa4fc6a414a7a3c73d6b4c.png	t	t	f4262e9203fa4fc6a414a7a3c73d6b4c	f4262e9203fa4fc6a414a7a3c73d6b4c	0	1493	t	96	VibraGaming	VibraGaming	{}	medium	\N	\N	239
Pachinko 2	basic	https://gis-static.com/games/VibraGaming/c6a8fc01334942508e1c2ef1b2471bac.png	t	t	c6a8fc01334942508e1c2ef1b2471bac	c6a8fc01334942508e1c2ef1b2471bac	0	737	t	96	VibraGaming	VibraGaming	{}	low	\N	\N	240
Pachinko 3	basic	https://gis-static.com/games/VibraGaming/46cd69148fda4916834334e560a354fd.png	t	t	46cd69148fda4916834334e560a354fd	46cd69148fda4916834334e560a354fd	0	737	t	96	VibraGaming	VibraGaming	{}	high	\N	\N	241
Bingo 3	basic	https://gis-static.com/games/VibraGaming/02e1ecc74610418988d4b4d91cb9d73b.png	t	t	02e1ecc74610418988d4b4d91cb9d73b	02e1ecc74610418988d4b4d91cb9d73b	0	10039	t	96	VibraGaming	VibraGaming	{}	very-high	\N	\N	242
Freeway Poker	basic	https://gis-static.com/games/VibraGaming/3570d272ddff462e86923c9dbeef388e.png	t	t	3570d272ddff462e86923c9dbeef388e	3570d272ddff462e86923c9dbeef388e	0	2188	t	96	VibraGaming	VibraGaming	{}	high	\N	\N	243
Goleada Millonaria	basic	https://gis-static.com/games/VibraGaming/81000e34766141e3a28ac4b8e8aa70f7.png	t	t	81000e34766141e3a28ac4b8e8aa70f7	81000e34766141e3a28ac4b8e8aa70f7	0	1288	t	96	VibraGaming	VibraGaming	{}	medium	\N	\N	244
Tesoro del Mono	basic	https://gis-static.com/games/VibraGaming/a6102f1b5a5a45d4a7cf05e0046f9fbb.png	f	f	a6102f1b5a5a45d4a7cf05e0046f9fbb	a6102f1b5a5a45d4a7cf05e0046f9fbb	0	1038	t	96	VibraGaming	VibraGaming	{}	low	\N	\N	245
Baccarat	basic	https://gis-static.com/games/Espressogames/7339a6dbe71f449d9c6070b742056bc4.png	t	t	7339a6dbe71f449d9c6070b742056bc4	7339a6dbe71f449d9c6070b742056bc4	0	2538	t	96	Espressogames	Espressogames	{}	medium-high	\N	\N	246
12 Number Roulette	basic	https://gis-static.com/games/Espressogames/fbe3bb44f00f406ba034ced6808656fc.png	t	t	fbe3bb44f00f406ba034ced6808656fc	fbe3bb44f00f406ba034ced6808656fc	0	1538	t	96	Espressogames	Espressogames	{}	high	\N	\N	247
American Roulette	basic	https://gis-static.com/games/Espressogames/1b79cdc96c034ea8ae5c5d3b261c43ce.png	t	t	1b79cdc96c034ea8ae5c5d3b261c43ce	1b79cdc96c034ea8ae5c5d3b261c43ce	0	738	t	96	Espressogames	Espressogames	{}	low	\N	\N	248
Euro Roulette	basic	https://gis-static.com/games/Espressogames/4e4d6cf0df52478aafd3d7d4493303b7.png	f	f	4e4d6cf0df52478aafd3d7d4493303b7	4e4d6cf0df52478aafd3d7d4493303b7	0	1043	t	96	Espressogames	Espressogames	{}	low	\N	\N	249
Global 12 Numbers	basic	https://gis-static.com/games/Espressogames/c61e1c398a6041f1817714b10641b9f8.png	t	t	c61e1c398a6041f1817714b10641b9f8	c61e1c398a6041f1817714b10641b9f8	0	738	t	96	Espressogames	Espressogames	{}	high	\N	\N	250
Global American Roulette	basic	https://gis-static.com/games/Espressogames/6cdd60a21a0a47e3a7e1c4f73aff86d5.png	t	t	6cdd60a21a0a47e3a7e1c4f73aff86d5	6cdd60a21a0a47e3a7e1c4f73aff86d5	0	10040	t	96	Espressogames	Espressogames	{}	very-high	\N	\N	251
Global Euro Roulette	basic	https://gis-static.com/games/Espressogames/c17a64a8feda4cc2870f8653e0e4f4a0.png	t	t	c17a64a8feda4cc2870f8653e0e4f4a0	c17a64a8feda4cc2870f8653e0e4f4a0	0	2189	t	96	Espressogames	Espressogames	{}	high	\N	\N	252
Global Poker Roulette	basic	https://gis-static.com/games/Espressogames/5db301660c554d51b8e66609b4ce0184.png	t	t	5db301660c554d51b8e66609b4ce0184	5db301660c554d51b8e66609b4ce0184	0	1289	t	96	Espressogames	Espressogames	{}	medium	\N	\N	253
Poker Roulette	basic	https://gis-static.com/games/Espressogames/d9f71d5200e14ff68c6020dbcf69bc2c.png	f	f	d9f71d5200e14ff68c6020dbcf69bc2c	d9f71d5200e14ff68c6020dbcf69bc2c	0	1039	t	96	Espressogames	Espressogames	{}	low	\N	\N	254
Magic Rush Deluxe	basic	https://gis-static.com/games/Espressogames/e97bf6e2b74c4fa1aea245d99d0db2de.png	t	t	e97bf6e2b74c4fa1aea245d99d0db2de	e97bf6e2b74c4fa1aea245d99d0db2de	0	2539	t	96	Espressogames	Espressogames	{}	medium-high	\N	\N	255
Magic Rush Win	basic	https://gis-static.com/games/Espressogames/290b4914f24b4ad8afe8a053f7697218.png	t	t	290b4914f24b4ad8afe8a053f7697218	290b4914f24b4ad8afe8a053f7697218	0	1539	t	96	Espressogames	Espressogames	{}	high	\N	\N	256
Power Balls	basic	https://gis-static.com/games/Espressogames/a5afa3098f6c4c08bad80a32c53d2bf0.png	t	t	a5afa3098f6c4c08bad80a32c53d2bf0	a5afa3098f6c4c08bad80a32c53d2bf0	0	739	t	96	Espressogames	Espressogames	{}	low	\N	\N	257
Power Balls Light	basic	https://gis-static.com/games/Espressogames/096035d4863643f8af04665246a6ee68.png	t	t	096035d4863643f8af04665246a6ee68	096035d4863643f8af04665246a6ee68	0	739	t	96	Espressogames	Espressogames	{}	high	\N	\N	258
4H All American	basic	https://gis-static.com/games/Espressogames/9a5c5f695cbe4c5aa699cfed8b4e63e0.png	t	t	9a5c5f695cbe4c5aa699cfed8b4e63e0	9a5c5f695cbe4c5aa699cfed8b4e63e0	0	10041	t	96	Espressogames	Espressogames	{}	very-high	\N	\N	259
4H Deuces Wild	basic	https://gis-static.com/games/Espressogames/63a435fc377d4f9c81bc5e8257d6855f.png	t	t	63a435fc377d4f9c81bc5e8257d6855f	63a435fc377d4f9c81bc5e8257d6855f	0	2190	t	96	Espressogames	Espressogames	{}	high	\N	\N	260
4H Jacks or Better	basic	https://gis-static.com/games/Espressogames/a2786734227940ee9815f65fd0e2eebe.png	t	t	a2786734227940ee9815f65fd0e2eebe	a2786734227940ee9815f65fd0e2eebe	0	1290	t	96	Espressogames	Espressogames	{}	medium	\N	\N	261
4H Joker Poker	basic	https://gis-static.com/games/Espressogames/eb4d71954e1f4f92bf74bfd48ea0807f.png	f	f	eb4d71954e1f4f92bf74bfd48ea0807f	eb4d71954e1f4f92bf74bfd48ea0807f	0	1040	t	96	Espressogames	Espressogames	{}	low	\N	\N	262
4H Steam Joker Poker	basic	https://gis-static.com/games/Espressogames/de8f71c150b14261a670f290d38e4cf8.png	t	t	de8f71c150b14261a670f290d38e4cf8	de8f71c150b14261a670f290d38e4cf8	0	2540	t	96	Espressogames	Espressogames	{}	medium-high	\N	\N	263
All American	basic	https://gis-static.com/games/Espressogames/19023dcb7de943d9bf4f0be1d012a026.png	t	t	19023dcb7de943d9bf4f0be1d012a026	19023dcb7de943d9bf4f0be1d012a026	0	1540	t	96	Espressogames	Espressogames	{}	high	\N	\N	264
Color Champion	basic	https://gis-static.com/games/Espressogames/7d9d5fbc365b4b2cb9128f16e83a3add.png	t	t	7d9d5fbc365b4b2cb9128f16e83a3add	7d9d5fbc365b4b2cb9128f16e83a3add	0	740	t	96	Espressogames	Espressogames	{}	low	\N	\N	265
Deuces Wild	basic	https://gis-static.com/games/Espressogames/4f4c2d2638784562a42d0133590576cf.png	t	t	4f4c2d2638784562a42d0133590576cf	4f4c2d2638784562a42d0133590576cf	0	740	t	96	Espressogames	Espressogames	{}	high	\N	\N	266
Jacks or Better	basic	https://gis-static.com/games/Espressogames/44bf1e21480c47ef8090f1d13cc7ff7e.png	t	t	44bf1e21480c47ef8090f1d13cc7ff7e	44bf1e21480c47ef8090f1d13cc7ff7e	0	10042	t	96	Espressogames	Espressogames	{}	very-high	\N	\N	267
Joker Poker	basic	https://gis-static.com/games/Espressogames/8b1bdd7202a54ee2b7af5f800039b35f.png	t	t	8b1bdd7202a54ee2b7af5f800039b35f	8b1bdd7202a54ee2b7af5f800039b35f	0	2191	t	96	Espressogames	Espressogames	{}	high	\N	\N	268
Steam Joker Poker	basic	https://gis-static.com/games/Espressogames/08c240c55cfc4e6da57618956d1cae1c.png	t	t	08c240c55cfc4e6da57618956d1cae1c	08c240c55cfc4e6da57618956d1cae1c	0	1291	t	96	Espressogames	Espressogames	{}	medium	\N	\N	269
European Blackjack	basic	https://gis-static.com/games/dd30fa8dc83842c9826d471a58e8962a.png	f	f	dd30fa8dc83842c9826d471a58e8962a	dd30fa8dc83842c9826d471a58e8962a	0	1041	t	96	Espressogames	Espressogames	{}	low	\N	\N	270
Lucky 7 Blackjack	basic	https://gis-static.com/games/03239dfc81f6403399fe41cd88b1b2c0.png	t	t	03239dfc81f6403399fe41cd88b1b2c0	03239dfc81f6403399fe41cd88b1b2c0	0	2541	t	96	Espressogames	Espressogames	{}	medium-high	\N	\N	271
Classic Blackjack	basic	https://gis-static.com/games/4197d45cf903493daaa7a5861634a0a8.png	t	t	4197d45cf903493daaa7a5861634a0a8	4197d45cf903493daaa7a5861634a0a8	0	1541	t	96	Espressogames	Espressogames	{}	high	\N	\N	272
Single Deck BJ	basic	https://gis-static.com/games/c944f0852ab443aeb41e8338ea83c8ab.png	t	t	c944f0852ab443aeb41e8338ea83c8ab	c944f0852ab443aeb41e8338ea83c8ab	0	741	t	96	Espressogames	Espressogames	{}	low	\N	\N	273
Six Card Charlie Blackjack	basic	https://gis-static.com/games/1c99a4f954654d7c8d510f1bf0aad05a.png	t	t	1c99a4f954654d7c8d510f1bf0aad05a	1c99a4f954654d7c8d510f1bf0aad05a	0	741	t	96	Espressogames	Espressogames	{}	high	\N	\N	274
Jackpot Stud Poker	basic	https://gis-static.com/games/651a1e6323fe4802bde1937dec84788b.png	t	t	651a1e6323fe4802bde1937dec84788b	651a1e6323fe4802bde1937dec84788b	0	10043	t	96	Espressogames	Espressogames	{}	very-high	\N	\N	275
Texas Hold'em Poker	basic	https://gis-static.com/games/e67bee1ca09d4b5da01b0b5f4a909165.png	t	t	e67bee1ca09d4b5da01b0b5f4a909165	e67bee1ca09d4b5da01b0b5f4a909165	0	2192	t	96	Espressogames	Espressogames	{}	high	\N	\N	276
Speed Baccarat 2	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/13f7f8f4ed053ee72ff9fc6e517bb20606685d8c.png	t	t	13f7f8f4ed053ee72ff9fc6e517bb20606685d8c	13f7f8f4ed053ee72ff9fc6e517bb20606685d8c	0	2326	t	96	Evolution	Evolution	{}	high	\N	\N	1282
Speed Baccarat 3	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/b72425143cf8b674337148f96a92c46513deb4a5.png	t	t	b72425143cf8b674337148f96a92c46513deb4a5	b72425143cf8b674337148f96a92c46513deb4a5	0	1426	t	96	Evolution	Evolution	{}	medium	\N	\N	1283
Russian Keno	basic	https://gis-static.com/games/SmartSoft/f13d51bc76534ac5930daa719d7a3c4a.png	t	t	f13d51bc76534ac5930daa719d7a3c4a	f13d51bc76534ac5930daa719d7a3c4a	0	1292	t	96	SmartSoft	SmartSoft	{}	medium	\N	\N	277
Virtual Classic Roulette	basic	https://gis-static.com/games/SmartSoft/781c061be33a46919803c89e6cf3b042.png	f	f	781c061be33a46919803c89e6cf3b042	781c061be33a46919803c89e6cf3b042	0	1042	t	96	SmartSoft	SmartSoft	{}	low	\N	\N	278
JetX3	basic	https://gis-static.com/games/SmartSoft/269a1ce0b5d04486a63139b9dd6dfe39.png	t	t	269a1ce0b5d04486a63139b9dd6dfe39	269a1ce0b5d04486a63139b9dd6dfe39	0	2542	t	96	SmartSoft	SmartSoft	{}	medium-high	\N	\N	279
Cappadocia	basic	https://gis-static.com/games/SmartSoft/40f1aaa03a5c403ea3148b17e1894ece.png	t	t	40f1aaa03a5c403ea3148b17e1894ece	40f1aaa03a5c403ea3148b17e1894ece	0	1542	t	96	SmartSoft	SmartSoft	{}	high	\N	\N	280
SpinX	basic	https://gis-static.com/games/SmartSoft/26fd466aee444a8c90ca7ee36041caa4.png	t	t	26fd466aee444a8c90ca7ee36041caa4	26fd466aee444a8c90ca7ee36041caa4	0	742	t	96	SmartSoft	SmartSoft	{}	low	\N	\N	281
Virtual Burning Roulette	basic	https://gis-static.com/games/SmartSoft/bed59aa1290a49828e3f13ca10e9951c.png	t	t	bed59aa1290a49828e3f13ca10e9951c	bed59aa1290a49828e3f13ca10e9951c	0	742	t	96	SmartSoft	SmartSoft	{}	high	\N	\N	282
Virtual Roulette	basic	https://gis-static.com/games/SmartSoft/a795f930b3b9424daa0d0ebe38f91192.png	t	t	a795f930b3b9424daa0d0ebe38f91192	a795f930b3b9424daa0d0ebe38f91192	0	10044	t	96	SmartSoft	SmartSoft	{}	very-high	\N	\N	283
Balloon	basic	https://gis-static.com/games/SmartSoft/9d102c4944c742acbb3ac49dad3bda1e.png	t	t	9d102c4944c742acbb3ac49dad3bda1e	9d102c4944c742acbb3ac49dad3bda1e	0	2193	t	96	SmartSoft	SmartSoft	{}	high	\N	\N	284
JetX	basic	https://gis-static.com/games/SmartSoft/bc048935acfd4956950bf0b2a29c6aff.png	t	t	bc048935acfd4956950bf0b2a29c6aff	bc048935acfd4956950bf0b2a29c6aff	0	1293	t	96	SmartSoft	SmartSoft	{}	medium	\N	\N	285
Amaterasu Keno	basic	https://gis-static.com/games/8c30002d6536f4ecb42dd3dfd7df5b016c7eb133.png	t	t	8c30002d6536f4ecb42dd3dfd7df5b016c7eb133	8c30002d6536f4ecb42dd3dfd7df5b016c7eb133	0	2543	t	96	Mascot	Mascot	{}	medium-high	\N	\N	286
Patrick's Magic Field	basic	https://gis-static.com/games/ba4e0aba6580189adcef4589a6752761922b8edd.png	t	t	ba4e0aba6580189adcef4589a6752761922b8edd	ba4e0aba6580189adcef4589a6752761922b8edd	0	1543	t	96	Evoplay	Evoplay	{}	high	\N	\N	287
Lucky Card	basic	https://gis-static.com/games/5198f8ccfdf9f120eba385814fb4b4a04bd28105.png	t	t	5198f8ccfdf9f120eba385814fb4b4a04bd28105	5198f8ccfdf9f120eba385814fb4b4a04bd28105	0	743	t	96	Evoplay	Evoplay	{}	low	\N	\N	288
Heads and Tails XY	basic	https://gis-static.com/games/8a9799c0cdfec1834ef0023b38fc21b07aa71bc6.png	t	t	8a9799c0cdfec1834ef0023b38fc21b07aa71bc6	8a9799c0cdfec1834ef0023b38fc21b07aa71bc6	0	743	t	96	BGaming	BGaming	{}	high	\N	\N	289
Rocket Dice XY	basic	https://gis-static.com/games/bae542065f1bc52a41f9362e0eb161c4814c7c5d.png	t	t	bae542065f1bc52a41f9362e0eb161c4814c7c5d	bae542065f1bc52a41f9362e0eb161c4814c7c5d	0	10045	t	96	BGaming	BGaming	{}	very-high	\N	\N	290
Minesweeper XY	basic	https://gis-static.com/games/b8d010004f84d5de112ee2ef9bf9badf6e4d31d9.png	t	t	b8d010004f84d5de112ee2ef9bf9badf6e4d31d9	b8d010004f84d5de112ee2ef9bf9badf6e4d31d9	0	2194	t	96	BGaming	BGaming	{}	high	\N	\N	291
Plinko XY	basic	https://gis-static.com/games/2dba096b6001e9230e46a4bfa13577f17ebcaf43.png	t	t	2dba096b6001e9230e46a4bfa13577f17ebcaf43	2dba096b6001e9230e46a4bfa13577f17ebcaf43	0	1294	t	96	BGaming	BGaming	{}	medium	\N	\N	292
Atlantis Bingo	basic	https://gis-static.com/games/5bfce53de914d5216eb019430f2525e24522a035.png	f	f	5bfce53de914d5216eb019430f2525e24522a035	5bfce53de914d5216eb019430f2525e24522a035	0	1044	t	96	Caleta	Caleta	{}	low	\N	\N	293
Goblin Run	basic	https://gis-static.com/games/de78efb63a1cebf83fe3975ba740ad4879d282a7.png	t	t	de78efb63a1cebf83fe3975ba740ad4879d282a7	de78efb63a1cebf83fe3975ba740ad4879d282a7	0	2544	t	96	Evoplay	Evoplay	{}	medium-high	\N	\N	294
Roulette Euro Pro	basic	https://gis-static.com/games/2b080933106c6a89bb377523bdc5f2163bc6e176.png	t	t	2b080933106c6a89bb377523bdc5f2163bc6e176	2b080933106c6a89bb377523bdc5f2163bc6e176	0	1544	t	96	Espressogames	Espressogames	{}	high	\N	\N	295
Crash X	basic	https://gis-static.com/games/Turbogames/28b9d6467c934b728066ca0af0738c39.png	t	t	28b9d6467c934b728066ca0af0738c39	28b9d6467c934b728066ca0af0738c39	0	744	t	96	Turbogames	Turbogames	{}	high	\N	\N	297
Dice Twice	basic	https://gis-static.com/games/Turbogames/400dee13a1a2457f9588aed8b156b67a.png	t	t	400dee13a1a2457f9588aed8b156b67a	400dee13a1a2457f9588aed8b156b67a	0	10046	t	96	Turbogames	Turbogames	{}	very-high	\N	\N	298
Hamsta	basic	https://gis-static.com/games/Turbogames/f74c230b916945d190ec4f54d6a08da7.png	t	t	f74c230b916945d190ec4f54d6a08da7	f74c230b916945d190ec4f54d6a08da7	0	2195	t	96	Turbogames	Turbogames	{}	high	\N	\N	299
Mines	basic	https://gis-static.com/games/Turbogames/264f6bd9d93e4c98aa669ca8275cc89a.png	t	t	264f6bd9d93e4c98aa669ca8275cc89a	264f6bd9d93e4c98aa669ca8275cc89a	0	1295	t	96	Turbogames	Turbogames	{}	medium	\N	\N	300
Neko	basic	https://gis-static.com/games/Turbogames/785260eeca2d4c60a22fc9003eb0a006.png	f	f	785260eeca2d4c60a22fc9003eb0a006	785260eeca2d4c60a22fc9003eb0a006	0	1045	t	96	Turbogames	Turbogames	{}	low	\N	\N	301
Towers	basic	https://gis-static.com/games/Turbogames/5ec8feec03d44efda9d8d0558bf65b40.png	t	t	5ec8feec03d44efda9d8d0558bf65b40	5ec8feec03d44efda9d8d0558bf65b40	0	2545	t	96	Turbogames	Turbogames	{}	medium-high	\N	\N	302
First Person XXXtreme Lightning Baccarat	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/e471b768809c54fffdf24cc730e954e2990b36c5.png	t	t	e471b768809c54fffdf24cc730e954e2990b36c5	e471b768809c54fffdf24cc730e954e2990b36c5	0	1679	t	96	Evolution	Evolution	{}	high	\N	\N	1310
XXXtreme Lightning Baccarat	basic	https://gis-static.com/games/2ba977d934f57f1a9ee4e829d4dba646/Evolution/53531f6d9fc7337004b6760a9ad5e232f5d2f7e4.png	t	t	53531f6d9fc7337004b6760a9ad5e232f5d2f7e4	53531f6d9fc7337004b6760a9ad5e232f5d2f7e4	0	879	t	96	Evolution	Evolution	{}	low	\N	\N	1311
1Tap Mines	basic	https://gis-static.com/games/Turbogames/b07bd46cf3ee4dcab4c1fba2e9889c62.png	t	t	b07bd46cf3ee4dcab4c1fba2e9889c62	b07bd46cf3ee4dcab4c1fba2e9889c62	0	879	t	96	Turbogames	Turbogames	{}	high	\N	\N	1312
Sweet Lotto	basic	https://gis-static.com/games/fdc4364a3eae2f06260e2f95ce9571ed/Belatra Games/67af0e142b834e9fa0aeb2309d708475.png	t	t	67af0e142b834e9fa0aeb2309d708475	67af0e142b834e9fa0aeb2309d708475	0	10181	t	96	Belatra Games	Belatra Games	{}	very-high	\N	\N	1313
Teen Patty	basic	https://gis-static.com/games/RivalGames/3fc27f37dcf649bd8e4148c053a997c3.png	t	t	3fc27f37dcf649bd8e4148c053a997c3	3fc27f37dcf649bd8e4148c053a997c3	0	2330	t	96	RivalGames	RivalGames	{}	high	\N	\N	1314
Crash, Hamster, Crash!	basic	https://gis-static.com/games/Mascot/dbface85d689490ea0b4f1eb7f8fdbdd.png	f	f	dbface85d689490ea0b4f1eb7f8fdbdd	dbface85d689490ea0b4f1eb7f8fdbdd	0	1180	t	96	Mascot	Mascot	{}	low	\N	\N	1316
Fury Stairs	basic	https://gis-static.com/games/Turbogames/2d5cbf3324ce48f5a5df720c16a4e8e0.png	t	t	2d5cbf3324ce48f5a5df720c16a4e8e0	2d5cbf3324ce48f5a5df720c16a4e8e0	0	745	t	96	Turbogames	Turbogames	{}	high	\N	\N	303
Ball & Ball	basic	https://gis-static.com/games/Turbogames/c7a64ae4763b4fd59b4747c5a0bd43f4.png	t	t	c7a64ae4763b4fd59b4747c5a0bd43f4	c7a64ae4763b4fd59b4747c5a0bd43f4	0	10047	t	96	Turbogames	Turbogames	{}	very-high	\N	\N	304
Limbo Rider	basic	https://gis-static.com/games/Turbogames/556d8ef93573468692ab5c9e935ab1ef.png	t	t	556d8ef93573468692ab5c9e935ab1ef	556d8ef93573468692ab5c9e935ab1ef	0	2196	t	96	Turbogames	Turbogames	{}	high	\N	\N	305
Bayraktar	basic	https://gis-static.com/games/Turbogames/b672e0cc04ed48de810e2e18a9a47dc8.png	t	t	b672e0cc04ed48de810e2e18a9a47dc8	b672e0cc04ed48de810e2e18a9a47dc8	0	1296	t	96	Turbogames	Turbogames	{}	medium	\N	\N	306
Double Up	basic	https://gis-static.com/games/MPlay/67d821867da548e5b2888a62da3c95d3.png	f	f	67d821867da548e5b2888a62da3c95d3	67d821867da548e5b2888a62da3c95d3	0	1046	t	96	MPlay	MPlay	{}	low	\N	\N	307
Andar Bahar	basic	https://gis-static.com/games/MPlay/ddda30159e51481e8ce8f5c844b0606a.png	t	t	ddda30159e51481e8ce8f5c844b0606a	ddda30159e51481e8ce8f5c844b0606a	0	2546	t	96	MPlay	MPlay	{}	medium-high	\N	\N	308
Ludo Express	basic	https://gis-static.com/games/MPlay/6425fc82f7834fb3a0cb896d2d208df4.png	t	t	6425fc82f7834fb3a0cb896d2d208df4	6425fc82f7834fb3a0cb896d2d208df4	0	1546	t	96	MPlay	MPlay	{}	high	\N	\N	309
Teen Patti Express	basic	https://gis-static.com/games/MPlay/d3571c9140804b23816e3c9816303d3e.png	t	t	d3571c9140804b23816e3c9816303d3e	d3571c9140804b23816e3c9816303d3e	0	746	t	96	MPlay	MPlay	{}	low	\N	\N	310
Teen Patti Champion	basic	https://gis-static.com/games/MPlay/c3669029c45c4ea7b95e685009a50ac8.png	t	t	c3669029c45c4ea7b95e685009a50ac8	c3669029c45c4ea7b95e685009a50ac8	0	746	t	96	MPlay	MPlay	{}	high	\N	\N	311
Jhandi Munda	basic	https://gis-static.com/games/MPlay/65257ce131af4fdda9950be3efbdce65.png	t	t	65257ce131af4fdda9950be3efbdce65	65257ce131af4fdda9950be3efbdce65	0	10048	t	96	MPlay	MPlay	{}	very-high	\N	\N	312
Snakes n Ladders	basic	https://gis-static.com/games/MPlay/205a484b1a6f473a937d13dbdab4b069.png	t	t	205a484b1a6f473a937d13dbdab4b069	205a484b1a6f473a937d13dbdab4b069	0	2197	t	96	MPlay	MPlay	{}	high	\N	\N	313
Dragon Tiger	basic	https://gis-static.com/games/MPlay/5e9752a874a34665a68051454f0e08a8.png	t	t	5e9752a874a34665a68051454f0e08a8	5e9752a874a34665a68051454f0e08a8	0	1297	t	96	MPlay	MPlay	{}	medium	\N	\N	314
Satta Matka Express	basic	https://gis-static.com/games/MPlay/c4fa77a3e0814eed960a26690b6d3abf.png	f	f	c4fa77a3e0814eed960a26690b6d3abf	c4fa77a3e0814eed960a26690b6d3abf	0	1047	t	96	MPlay	MPlay	{}	low	\N	\N	315
Sicbo	basic	https://gis-static.com/games/MPlay/dfd2d4ca15104a8cb46981b079941ca5.png	t	t	dfd2d4ca15104a8cb46981b079941ca5	dfd2d4ca15104a8cb46981b079941ca5	0	2547	t	96	MPlay	MPlay	{}	medium-high	\N	\N	316
Legend Of Erlang	basic	https://gis-static.com/games/d0f458effab8e6898556b6a864a8faf20c8c33b3.png	t	t	d0f458effab8e6898556b6a864a8faf20c8c33b3	d0f458effab8e6898556b6a864a8faf20c8c33b3	0	1547	t	96	KAGaming	KAGaming	{}	high	\N	\N	317
Pride Fight	basic	https://gis-static.com/games/a0500369ff3ddf6d3f60afb73ae72bfcc4b203a2.png	t	t	a0500369ff3ddf6d3f60afb73ae72bfcc4b203a2	a0500369ff3ddf6d3f60afb73ae72bfcc4b203a2	0	747	t	96	Evoplay	Evoplay	{}	high	\N	\N	319
Go Go Magic Dog	basic	https://gis-static.com/games/8362d0d9ca6b04454a1c46560e85e62fe0fab7ec.png	t	t	8362d0d9ca6b04454a1c46560e85e62fe0fab7ec	8362d0d9ca6b04454a1c46560e85e62fe0fab7ec	0	10049	t	96	KAGaming	KAGaming	{}	very-high	\N	\N	320
The Thimbles	basic	https://gis-static.com/games/OnlyPlay/8a4d6c0698624f058c356e663af454a1.png	t	t	8a4d6c0698624f058c356e663af454a1	8a4d6c0698624f058c356e663af454a1	0	762	t	96	OnlyPlay	OnlyPlay	{}	low	\N	\N	321
Lucky Coin	basic	https://gis-static.com/games/OnlyPlay/44d7478450804b46912ebb7510294a37.png	t	t	44d7478450804b46912ebb7510294a37	44d7478450804b46912ebb7510294a37	0	2198	t	96	OnlyPlay	OnlyPlay	{}	high	\N	\N	322
Golden Clover	basic	https://gis-static.com/games/OnlyPlay/2184f4d9b3124e3cb4fafd07732fe026.png	t	t	2184f4d9b3124e3cb4fafd07732fe026	2184f4d9b3124e3cb4fafd07732fe026	0	1298	t	96	OnlyPlay	OnlyPlay	{}	medium	\N	\N	323
Lucky Ocean	basic	https://gis-static.com/games/OnlyPlay/e13ac58a8e6141ecacee61e392a3646a.png	f	f	e13ac58a8e6141ecacee61e392a3646a	e13ac58a8e6141ecacee61e392a3646a	0	1048	t	96	OnlyPlay	OnlyPlay	{}	low	\N	\N	324
Lucky Clover	basic	https://gis-static.com/games/OnlyPlay/95f6865f60674b77899d6f4e6c958608.png	t	t	95f6865f60674b77899d6f4e6c958608	95f6865f60674b77899d6f4e6c958608	0	2548	t	96	OnlyPlay	OnlyPlay	{}	medium-high	\N	\N	325
Troll Dice	basic	https://gis-static.com/games/OnlyPlay/67606815bb2347d2ac0c56094c403b75.png	t	t	67606815bb2347d2ac0c56094c403b75	67606815bb2347d2ac0c56094c403b75	0	1548	t	96	OnlyPlay	OnlyPlay	{}	high	\N	\N	326
Limbo Cat	basic	https://gis-static.com/games/OnlyPlay/b82fea280d7a4ec8b06baaf6158c5ae0.png	t	t	b82fea280d7a4ec8b06baaf6158c5ae0	b82fea280d7a4ec8b06baaf6158c5ae0	0	748	t	96	OnlyPlay	OnlyPlay	{}	low	\N	\N	327
Lucky Tanks	basic	https://gis-static.com/games/OnlyPlay/e1ac71ab0d664f14a9fa0eb5c5ae9d68.png	t	t	e1ac71ab0d664f14a9fa0eb5c5ae9d68	e1ac71ab0d664f14a9fa0eb5c5ae9d68	0	748	t	96	OnlyPlay	OnlyPlay	{}	high	\N	\N	328
F777 Fighter	basic	https://gis-static.com/games/OnlyPlay/93adad6f64824ea3a2fee45cdd087379.png	t	t	93adad6f64824ea3a2fee45cdd087379	93adad6f64824ea3a2fee45cdd087379	0	10050	t	96	OnlyPlay	OnlyPlay	{}	very-high	\N	\N	329
Paradise Trippies Bingo	basic	https://gis-static.com/games/57fd346f70cda4dc34f74eebbac84c9f02f18287.png	t	t	57fd346f70cda4dc34f74eebbac84c9f02f18287	57fd346f70cda4dc34f74eebbac84c9f02f18287	0	2199	t	96	Caleta	Caleta	{}	high	\N	\N	330
Aquarium	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/51dfd00c4d1c409a98a4e40056f4d790.png	t	t	51dfd00c4d1c409a98a4e40056f4d790	51dfd00c4d1c409a98a4e40056f4d790	0	1299	t	96	SuperlottoFast	SuperlottoFast	{}	medium	\N	\N	331
Arabeska	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/37defe4b8f0d40d4a70f4810224b52a9.png	f	f	37defe4b8f0d40d4a70f4810224b52a9	37defe4b8f0d40d4a70f4810224b52a9	0	1049	t	96	SuperlottoFast	SuperlottoFast	{}	low	\N	\N	332
Saloon	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/20cad226d42b48ab962a4ab925d47d28.png	t	t	20cad226d42b48ab962a4ab925d47d28	20cad226d42b48ab962a4ab925d47d28	0	2549	t	96	SuperlottoFast	SuperlottoFast	{}	medium-high	\N	\N	333
Battleships	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/cdc63048ea12410195c8d1f457d19ccd.png	t	t	cdc63048ea12410195c8d1f457d19ccd	cdc63048ea12410195c8d1f457d19ccd	0	1549	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	334
Gangsters	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/0ea460e38f17448c8936990965f094b5.png	t	t	0ea460e38f17448c8936990965f094b5	0ea460e38f17448c8936990965f094b5	0	749	t	96	SuperlottoFast	SuperlottoFast	{}	low	\N	\N	335
Super 7	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/22e2ac4cb9484a47b054eca83628bb52.png	t	t	22e2ac4cb9484a47b054eca83628bb52	22e2ac4cb9484a47b054eca83628bb52	0	749	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	336
Pyramid	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/c38e120ce40140fba13f6f8ef16f112d.png	t	t	c38e120ce40140fba13f6f8ef16f112d	c38e120ce40140fba13f6f8ef16f112d	0	10051	t	96	SuperlottoFast	SuperlottoFast	{}	very-high	\N	\N	337
N1 Blackjack	basic	https://gis-static.com/games/HoGaming/b322b0c7f1df4298a00cbc5e2dfaf4be.png	t	t	b322b0c7f1df4298a00cbc5e2dfaf4be	b322b0c7f1df4298a00cbc5e2dfaf4be	0	1556	t	96	HoGaming	HoGaming	{}	high	\N	\N	390
Christmas	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/90a204cf420243e3ae5354d61bf43ba7.png	t	t	90a204cf420243e3ae5354d61bf43ba7	90a204cf420243e3ae5354d61bf43ba7	0	2200	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	338
Basketball	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/7cb72fbb5713492d897091560488c6fa.png	t	t	7cb72fbb5713492d897091560488c6fa	7cb72fbb5713492d897091560488c6fa	0	1300	t	96	SuperlottoFast	SuperlottoFast	{}	medium	\N	\N	339
Lucky 7	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/f41d53918d254eacba075e1dbe4cd614.png	f	f	f41d53918d254eacba075e1dbe4cd614	f41d53918d254eacba075e1dbe4cd614	0	1050	t	96	SuperlottoFast	SuperlottoFast	{}	low	\N	\N	340
Golden Bank	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/2ce4a765663f47d0ac3e0a3844c58bd6.png	t	t	2ce4a765663f47d0ac3e0a3844c58bd6	2ce4a765663f47d0ac3e0a3844c58bd6	0	2550	t	96	SuperlottoFast	SuperlottoFast	{}	medium-high	\N	\N	341
Vegas	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/36c23a4338c0427b97ce25d83487401e.png	t	t	36c23a4338c0427b97ce25d83487401e	36c23a4338c0427b97ce25d83487401e	0	1550	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	342
Football	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/cd27ad16605e438dae923ace86349040.png	t	t	cd27ad16605e438dae923ace86349040	cd27ad16605e438dae923ace86349040	0	750	t	96	SuperlottoFast	SuperlottoFast	{}	low	\N	\N	343
Royal Riches Fast	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/dd3057a9e99c42a28c7250f52cacb79b.png	t	t	dd3057a9e99c42a28c7250f52cacb79b	dd3057a9e99c42a28c7250f52cacb79b	0	750	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	344
Fortune	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/78432d0b6abc44b4b18ac53b0e9c0ad6.png	t	t	78432d0b6abc44b4b18ac53b0e9c0ad6	78432d0b6abc44b4b18ac53b0e9c0ad6	0	10052	t	96	SuperlottoFast	SuperlottoFast	{}	very-high	\N	\N	345
Hockey	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/66448b55cfd249219b87ad1537eb4039.png	t	t	66448b55cfd249219b87ad1537eb4039	66448b55cfd249219b87ad1537eb4039	0	2201	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	346
Awesome Money Fast	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/044615a7ae1242939fc2c628765341ee.png	t	t	044615a7ae1242939fc2c628765341ee	044615a7ae1242939fc2c628765341ee	0	1301	t	96	SuperlottoFast	SuperlottoFast	{}	medium	\N	\N	347
Andar Bahar	basic	https://gis-static.com/games/fde78e89cbe69f90bbfea7f26f67b579477cf46b.png	t	t	fde78e89cbe69f90bbfea7f26f67b579477cf46b	fde78e89cbe69f90bbfea7f26f67b579477cf46b	0	1512	t	96	Ezugi	Ezugi	{}	high	\N	\N	74
Bet on Teen Patti	basic	https://gis-static.com/games/fe2133e298051c6474c34cc8754ecf9174df229b.png	t	t	fe2133e298051c6474c34cc8754ecf9174df229b	fe2133e298051c6474c34cc8754ecf9174df229b	0	712	t	96	Ezugi	Ezugi	{}	low	\N	\N	75
Blackjack	basic	https://gis-static.com/games/0e9e90471848524af0a2eb4ae1f7ca794655b452.png	t	t	0e9e90471848524af0a2eb4ae1f7ca794655b452	0e9e90471848524af0a2eb4ae1f7ca794655b452	0	712	t	96	Ezugi	Ezugi	{}	high	\N	\N	76
Baccarat	basic	https://gis-static.com/games/f2da0e82e4b75724d2fffb51aca14434ddd6864b.png	t	t	f2da0e82e4b75724d2fffb51aca14434ddd6864b	f2da0e82e4b75724d2fffb51aca14434ddd6864b	0	10014	t	96	Ezugi	Ezugi	{}	very-high	\N	\N	77
Casino Hold'em	basic	https://gis-static.com/games/5ffe9c022755838add76ff18161fbb83a8dade46.png	t	t	5ffe9c022755838add76ff18161fbb83a8dade46	5ffe9c022755838add76ff18161fbb83a8dade46	0	2163	t	96	Ezugi	Ezugi	{}	high	\N	\N	78
Roulette	basic	https://gis-static.com/games/3a120c12e78edbf77a954ec8a1d5d97be6b09fe8.png	f	f	3a120c12e78edbf77a954ec8a1d5d97be6b09fe8	3a120c12e78edbf77a954ec8a1d5d97be6b09fe8	0	1014	t	96	Ezugi	Ezugi	{}	low	\N	\N	79
Automatic Roulette	basic	https://gis-static.com/games/7d608830b031b43cded3abbbb3719448adff3668.png	t	t	7d608830b031b43cded3abbbb3719448adff3668	7d608830b031b43cded3abbbb3719448adff3668	0	2514	t	96	Ezugi	Ezugi	{}	medium-high	\N	\N	80
Unlimited Blackjack	basic	https://gis-static.com/games/802e0279619f46a9250a134e40e795606f493329.png	t	t	802e0279619f46a9250a134e40e795606f493329	802e0279619f46a9250a134e40e795606f493329	0	1514	t	96	Ezugi	Ezugi	{}	high	\N	\N	81
Teen Patti	basic	https://gis-static.com/games/cac88d6f80950224007a2d90ad58d5f8c991b72d.png	t	t	cac88d6f80950224007a2d90ad58d5f8c991b72d	cac88d6f80950224007a2d90ad58d5f8c991b72d	0	714	t	96	Ezugi	Ezugi	{}	low	\N	\N	82
Baccarat Super 6	basic	https://gis-static.com/games/ab2982dcbec79bb5731084e0cfb6220de2e504e6.png	t	t	ab2982dcbec79bb5731084e0cfb6220de2e504e6	ab2982dcbec79bb5731084e0cfb6220de2e504e6	0	10016	t	96	Ezugi	Ezugi	{}	very-high	\N	\N	83
Las Vegas	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/2afad306853c4b4ea15162ab3d1ac421.png	f	f	2afad306853c4b4ea15162ab3d1ac421	2afad306853c4b4ea15162ab3d1ac421	0	1051	t	96	SuperlottoFast	SuperlottoFast	{}	low	\N	\N	348
Rocky Mocky	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/b7f9a341f2fe427b9da66b9d990632e7.png	t	t	b7f9a341f2fe427b9da66b9d990632e7	b7f9a341f2fe427b9da66b9d990632e7	0	2551	t	96	SuperlottoFast	SuperlottoFast	{}	medium-high	\N	\N	349
Cards	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/3808671851ba4da6b9d5f02168a953e3.png	t	t	3808671851ba4da6b9d5f02168a953e3	3808671851ba4da6b9d5f02168a953e3	0	1551	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	350
Wheel of Fortune	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/5fdc18a77b7442028c0f9887bec76cb3.png	t	t	5fdc18a77b7442028c0f9887bec76cb3	5fdc18a77b7442028c0f9887bec76cb3	0	751	t	96	SuperlottoFast	SuperlottoFast	{}	low	\N	\N	351
Chef Menu	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/abf27990f0e64183a7e73b6c4b4f05fb.png	t	t	abf27990f0e64183a7e73b6c4b4f05fb	abf27990f0e64183a7e73b6c4b4f05fb	0	751	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	352
Lucky Coins	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/1e3f3620ca5f469eabdae03d72643f53.png	t	t	1e3f3620ca5f469eabdae03d72643f53	1e3f3620ca5f469eabdae03d72643f53	0	10053	t	96	SuperlottoFast	SuperlottoFast	{}	very-high	\N	\N	353
Diamonds Valley	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/1e58c0e8710545c78dc42f22d36b9008.png	t	t	1e58c0e8710545c78dc42f22d36b9008	1e58c0e8710545c78dc42f22d36b9008	0	2202	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	354
Cowboy	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/2a17299cebce4c83a090b74dc26699ec.png	t	t	2a17299cebce4c83a090b74dc26699ec	2a17299cebce4c83a090b74dc26699ec	0	1302	t	96	SuperlottoFast	SuperlottoFast	{}	medium	\N	\N	355
Pyramid Treasures	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/4e9428f3c61745618ef310b125a19200.png	f	f	4e9428f3c61745618ef310b125a19200	4e9428f3c61745618ef310b125a19200	0	1052	t	96	SuperlottoFast	SuperlottoFast	{}	low	\N	\N	356
Ocean	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/269f381542fd42b0afe1ecb963a5cf41.png	t	t	269f381542fd42b0afe1ecb963a5cf41	269f381542fd42b0afe1ecb963a5cf41	0	2552	t	96	SuperlottoFast	SuperlottoFast	{}	medium-high	\N	\N	357
Bankman	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/2b5f903efae4460d91d03d4471e751a8.png	t	t	2b5f903efae4460d91d03d4471e751a8	2b5f903efae4460d91d03d4471e751a8	0	1552	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	358
Spaceships	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/ef31f04b6532468daa7e23d99702a9f6.png	t	t	ef31f04b6532468daa7e23d99702a9f6	ef31f04b6532468daa7e23d99702a9f6	0	752	t	96	SuperlottoFast	SuperlottoFast	{}	low	\N	\N	359
Pirate	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/e3b78d4504da412795b5494b0664534e.png	t	t	e3b78d4504da412795b5494b0664534e	e3b78d4504da412795b5494b0664534e	0	752	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	360
Magic Pearl	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/f6b58987dc924f3ebe6df5736e28d154.png	t	t	f6b58987dc924f3ebe6df5736e28d154	f6b58987dc924f3ebe6df5736e28d154	0	10054	t	96	SuperlottoFast	SuperlottoFast	{}	very-high	\N	\N	361
Double lucky	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/81b7bd9c999945cf8c48c91012744f74.png	t	t	81b7bd9c999945cf8c48c91012744f74	81b7bd9c999945cf8c48c91012744f74	0	2203	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	362
5x	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/5dfdde7c56ab4973ba6ae7a139101b28.png	t	t	5dfdde7c56ab4973ba6ae7a139101b28	5dfdde7c56ab4973ba6ae7a139101b28	0	1303	t	96	SuperlottoFast	SuperlottoFast	{}	medium	\N	\N	363
Quarter Million	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/13ed3a56d846439da52282d3c2ce9477.png	f	f	13ed3a56d846439da52282d3c2ce9477	13ed3a56d846439da52282d3c2ce9477	0	1053	t	96	SuperlottoFast	SuperlottoFast	{}	low	\N	\N	364
Planets	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/9711ede1874b48c79ea8efa1bfedf6b8.png	t	t	9711ede1874b48c79ea8efa1bfedf6b8	9711ede1874b48c79ea8efa1bfedf6b8	0	2553	t	96	SuperlottoFast	SuperlottoFast	{}	medium-high	\N	\N	365
Golden Nugget	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/ef8c3f8d6372400da41ba8447fe8f027.png	t	t	ef8c3f8d6372400da41ba8447fe8f027	ef8c3f8d6372400da41ba8447fe8f027	0	1553	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	366
Mega	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/3cdb56d63b974b03b3099e5ddc856ec4.png	t	t	3cdb56d63b974b03b3099e5ddc856ec4	3cdb56d63b974b03b3099e5ddc856ec4	0	753	t	96	SuperlottoFast	SuperlottoFast	{}	low	\N	\N	367
Diamonds	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/fe5196bc6844433b8f23aed6d84cfe04.png	t	t	fe5196bc6844433b8f23aed6d84cfe04	fe5196bc6844433b8f23aed6d84cfe04	0	753	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	368
Dragon's Tomb	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/9f6fd8cd65504699898a88587a69b394.png	t	t	9f6fd8cd65504699898a88587a69b394	9f6fd8cd65504699898a88587a69b394	0	10055	t	96	SuperlottoFast	SuperlottoFast	{}	very-high	\N	\N	369
Winning Calendar	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/a83b1723cbfc4e22ba53d954face125c.png	t	t	a83b1723cbfc4e22ba53d954face125c	a83b1723cbfc4e22ba53d954face125c	0	2204	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	370
Flash Wins	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/bb5aef4a53444ba0ad4aaed2367c25f2.png	t	t	bb5aef4a53444ba0ad4aaed2367c25f2	bb5aef4a53444ba0ad4aaed2367c25f2	0	1304	t	96	SuperlottoFast	SuperlottoFast	{}	medium	\N	\N	371
Money Wheel	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/2cd644c98e964fb19428d49ff2eed73d.png	f	f	2cd644c98e964fb19428d49ff2eed73d	2cd644c98e964fb19428d49ff2eed73d	0	1054	t	96	SuperlottoFast	SuperlottoFast	{}	low	\N	\N	372
Vegas_2	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/354092e643cd4b758dd1c53e00d5dee2.png	t	t	354092e643cd4b758dd1c53e00d5dee2	354092e643cd4b758dd1c53e00d5dee2	0	2554	t	96	SuperlottoFast	SuperlottoFast	{}	medium-high	\N	\N	373
Treasure Island	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/01e0d3ce5efd4edeafdee55bbb706201.png	t	t	01e0d3ce5efd4edeafdee55bbb706201	01e0d3ce5efd4edeafdee55bbb706201	0	1554	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	374
Anubis	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/41e2d7beb3284613a3fa564b23d560a5.png	t	t	41e2d7beb3284613a3fa564b23d560a5	41e2d7beb3284613a3fa564b23d560a5	0	754	t	96	SuperlottoFast	SuperlottoFast	{}	low	\N	\N	375
Magical Elixir	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/b1475d7546f348ccb63efb93c05842b8.png	t	t	b1475d7546f348ccb63efb93c05842b8	b1475d7546f348ccb63efb93c05842b8	0	754	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	376
Happy Daisies	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/53eb8ec5c9994fa6bab47b2befdd478f.png	t	t	53eb8ec5c9994fa6bab47b2befdd478f	53eb8ec5c9994fa6bab47b2befdd478f	0	10056	t	96	SuperlottoFast	SuperlottoFast	{}	very-high	\N	\N	377
The Charm of Cleopatra	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/64e3e677e5724548a3220257da8559ea.png	t	t	64e3e677e5724548a3220257da8559ea	64e3e677e5724548a3220257da8559ea	0	2205	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	378
Winter Night	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/29e4354d8b164e789432235a11e074ba.png	t	t	29e4354d8b164e789432235a11e074ba	29e4354d8b164e789432235a11e074ba	0	1305	t	96	SuperlottoFast	SuperlottoFast	{}	medium	\N	\N	379
El Porko Mafioso	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/265465180c144fe9b81687925d06167e.png	f	f	265465180c144fe9b81687925d06167e	265465180c144fe9b81687925d06167e	0	1055	t	96	SuperlottoFast	SuperlottoFast	{}	low	\N	\N	380
Superlotto	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/16b8dee37a534a88a84f805dc790903d.png	t	t	16b8dee37a534a88a84f805dc790903d	16b8dee37a534a88a84f805dc790903d	0	2555	t	96	SuperlottoFast	SuperlottoFast	{}	medium-high	\N	\N	381
Dice Vegas	basic	https://gis-static.com/games/Mascot/ff0b702d7e544bd8af4a3b77c793d07e.png	t	t	ff0b702d7e544bd8af4a3b77c793d07e	ff0b702d7e544bd8af4a3b77c793d07e	0	1595	t	96	Mascot	Mascot	{}	high	\N	\N	634
The Shield of Zeus	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/c099411ddcaf4191a92528d9568a0719.png	t	t	c099411ddcaf4191a92528d9568a0719	c099411ddcaf4191a92528d9568a0719	0	1555	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	382
5 from 36	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoTV/5c0c6bc6033a4e299f453b1713cb6fab.png	t	t	5c0c6bc6033a4e299f453b1713cb6fab	5c0c6bc6033a4e299f453b1713cb6fab	0	755	t	96	SuperlottoTV	SuperlottoTV	{}	low	\N	\N	383
7 from 42	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoTV/c1a419d8b9b444c78a633c1f5736d332.png	t	t	c1a419d8b9b444c78a633c1f5736d332	c1a419d8b9b444c78a633c1f5736d332	0	755	t	96	SuperlottoTV	SuperlottoTV	{}	high	\N	\N	384
Dice	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoTV/b6cd411a71ac487cb209c3107c17f6d3.png	t	t	b6cd411a71ac487cb209c3107c17f6d3	b6cd411a71ac487cb209c3107c17f6d3	0	10057	t	96	SuperlottoTV	SuperlottoTV	{}	very-high	\N	\N	385
Football Bet	basic	https://gis-static.com/games/c27bf82e131175c75fd1021a107169b4d4de9e1b.png	t	t	c27bf82e131175c75fd1021a107169b4d4de9e1b	c27bf82e131175c75fd1021a107169b4d4de9e1b	0	2206	t	96	Evoplay	Evoplay	{}	high	\N	\N	386
One More Poker	basic	https://gis-static.com/games/af6918b2cb7f4030c16c603df9879fd22fd04aa4.png	t	t	af6918b2cb7f4030c16c603df9879fd22fd04aa4	af6918b2cb7f4030c16c603df9879fd22fd04aa4	0	1306	t	96	Espressogames	Espressogames	{}	medium	\N	\N	387
Euro Twins Roulette	basic	https://gis-static.com/games/47c67ed8edc80d5c6b9fa262c6d3fc8ca8ac6dcd.png	f	f	47c67ed8edc80d5c6b9fa262c6d3fc8ca8ac6dcd	47c67ed8edc80d5c6b9fa262c6d3fc8ca8ac6dcd	0	1056	t	96	Espressogames	Espressogames	{}	low	\N	\N	388
Roulette S1	basic	https://gis-static.com/games/HoGaming/24eaad8f641248ba95375d3459523290.png	t	t	24eaad8f641248ba95375d3459523290	24eaad8f641248ba95375d3459523290	0	2556	t	96	HoGaming	HoGaming	{}	medium-high	\N	\N	389
Baccarat CA4	basic	https://gis-static.com/games/HoGaming/c2ffed0b5fac43bd8b75bfc0cca93b7c.png	t	t	c2ffed0b5fac43bd8b75bfc0cca93b7c	c2ffed0b5fac43bd8b75bfc0cca93b7c	0	756	t	96	HoGaming	HoGaming	{}	low	\N	\N	391
3-Hand Casino Hold'em	basic	https://gis-static.com/games/PlayngoAsia/20d25dbd05e847c19b167522c0bf2988.png	t	t	20d25dbd05e847c19b167522c0bf2988	20d25dbd05e847c19b167522c0bf2988	0	756	t	96	PlayngoAsia	PlayngoAsia	{}	high	\N	\N	392
BlackJack MH	basic	https://gis-static.com/games/PlayngoAsia/9e43568f9b9449a38aa918295bf8c3ea.png	t	t	9e43568f9b9449a38aa918295bf8c3ea	9e43568f9b9449a38aa918295bf8c3ea	0	10058	t	96	PlayngoAsia	PlayngoAsia	{}	very-high	\N	\N	393
Casino Stud Poker	basic	https://gis-static.com/games/PlayngoAsia/3e738de63aa14a26b59e1b145d63a37e.png	t	t	3e738de63aa14a26b59e1b145d63a37e	3e738de63aa14a26b59e1b145d63a37e	0	2207	t	96	PlayngoAsia	PlayngoAsia	{}	high	\N	\N	394
Deuces Wild MH	basic	https://gis-static.com/games/PlayngoAsia/55bd238b62884e128a9c8639932072db.png	t	t	55bd238b62884e128a9c8639932072db	55bd238b62884e128a9c8639932072db	0	1307	t	96	PlayngoAsia	PlayngoAsia	{}	medium	\N	\N	395
Double Exposure BlackJack MH	basic	https://gis-static.com/games/PlayngoAsia/d4b8ef16d8414305933d743cb92a4987.png	f	f	d4b8ef16d8414305933d743cb92a4987	d4b8ef16d8414305933d743cb92a4987	0	1057	t	96	PlayngoAsia	PlayngoAsia	{}	low	\N	\N	396
European BlackJack MH	basic	https://gis-static.com/games/PlayngoAsia/bfb3ff3c85f5463cb9f5ebc85576cd45.png	t	t	bfb3ff3c85f5463cb9f5ebc85576cd45	bfb3ff3c85f5463cb9f5ebc85576cd45	0	2557	t	96	PlayngoAsia	PlayngoAsia	{}	medium-high	\N	\N	397
European Roulette Pro	basic	https://gis-static.com/games/PlayngoAsia/963a6fc8e6934282b20880fd022231fd.png	t	t	963a6fc8e6934282b20880fd022231fd	963a6fc8e6934282b20880fd022231fd	0	1557	t	96	PlayngoAsia	PlayngoAsia	{}	high	\N	\N	398
Jackpot Poker	basic	https://gis-static.com/games/PlayngoAsia/1f8834c0ff174277bbc8d0a7fd5acd91.png	t	t	1f8834c0ff174277bbc8d0a7fd5acd91	1f8834c0ff174277bbc8d0a7fd5acd91	0	757	t	96	PlayngoAsia	PlayngoAsia	{}	low	\N	\N	399
Jacks or Better MH	basic	https://gis-static.com/games/PlayngoAsia/4a73ea5d3469456cbeabdc0cbbe66b1c.png	t	t	4a73ea5d3469456cbeabdc0cbbe66b1c	4a73ea5d3469456cbeabdc0cbbe66b1c	0	757	t	96	PlayngoAsia	PlayngoAsia	{}	high	\N	\N	400
Joker Poker MH	basic	https://gis-static.com/games/PlayngoAsia/5108ecccb9a344f89c48547c4c5aa2db.png	t	t	5108ecccb9a344f89c48547c4c5aa2db	5108ecccb9a344f89c48547c4c5aa2db	0	10059	t	96	PlayngoAsia	PlayngoAsia	{}	very-high	\N	\N	401
Mini Baccarat	basic	https://gis-static.com/games/PlayngoAsia/32b2d4d7e0b242b288f0279a1915fa5e.png	t	t	32b2d4d7e0b242b288f0279a1915fa5e	32b2d4d7e0b242b288f0279a1915fa5e	0	2208	t	96	PlayngoAsia	PlayngoAsia	{}	high	\N	\N	402
Money Wheel	basic	https://gis-static.com/games/PlayngoAsia/480b5a24a1c04448af3e46962d99563a.png	t	t	480b5a24a1c04448af3e46962d99563a	480b5a24a1c04448af3e46962d99563a	0	1308	t	96	PlayngoAsia	PlayngoAsia	{}	medium	\N	\N	403
Rainforest Magic Bingo	basic	https://gis-static.com/games/PlayngoAsia/765cce4791e442faa0a0ecef530d04c2.png	f	f	765cce4791e442faa0a0ecef530d04c2	765cce4791e442faa0a0ecef530d04c2	0	1058	t	96	PlayngoAsia	PlayngoAsia	{}	low	\N	\N	404
Single Deck BlackJack MH	basic	https://gis-static.com/games/PlayngoAsia/68c66c7d4cb541c99b89731d83d37e0e.png	t	t	68c66c7d4cb541c99b89731d83d37e0e	68c66c7d4cb541c99b89731d83d37e0e	0	2558	t	96	PlayngoAsia	PlayngoAsia	{}	medium-high	\N	\N	405
Super Wheel	basic	https://gis-static.com/games/PlayngoAsia/dbf56e972b384b70b994f1ad81aabe2e.png	t	t	dbf56e972b384b70b994f1ad81aabe2e	dbf56e972b384b70b994f1ad81aabe2e	0	1558	t	96	PlayngoAsia	PlayngoAsia	{}	high	\N	\N	406
Sweet Alchemy Bingo	basic	https://gis-static.com/games/PlayngoAsia/36db8dec6d6143bea1f28e946f36117b.png	f	f	36db8dec6d6143bea1f28e946f36117b	36db8dec6d6143bea1f28e946f36117b	0	1243	t	96	PlayngoAsia	PlayngoAsia	{}	low	\N	\N	407
Twin Dice of Olympus	basic	https://gis-static.com/games/Mascot/5d0f18f7e16146e89a4fed7127a30ac2.png	t	t	5d0f18f7e16146e89a4fed7127a30ac2	5d0f18f7e16146e89a4fed7127a30ac2	0	795	t	96	Mascot	Mascot	{}	high	\N	\N	636
Viking Runecraft Bingo	basic	https://gis-static.com/games/PlayngoAsia/e705330ea10b46e58f52b20375001a78.png	t	t	e705330ea10b46e58f52b20375001a78	e705330ea10b46e58f52b20375001a78	0	758	t	96	PlayngoAsia	PlayngoAsia	{}	low	\N	\N	408
Giant Fish Hunter	basic	https://gis-static.com/games/4fd1495b4985a8c91485563935b9fb146ad3777b.png	t	t	4fd1495b4985a8c91485563935b9fb146ad3777b	4fd1495b4985a8c91485563935b9fb146ad3777b	0	758	t	96	KAGaming	KAGaming	{}	high	\N	\N	409
Iron Chicken Hunter	basic	https://gis-static.com/games/ba6296d92ccbc3c2a79601825d13f63abb96b41c.png	t	t	ba6296d92ccbc3c2a79601825d13f63abb96b41c	ba6296d92ccbc3c2a79601825d13f63abb96b41c	0	10060	t	96	KAGaming	KAGaming	{}	very-high	\N	\N	410
Bingo Royale	basic	https://gis-static.com/games/25cfe6aabd146c4b0b86dfcd04d731fff7711814.png	t	t	25cfe6aabd146c4b0b86dfcd04d731fff7711814	25cfe6aabd146c4b0b86dfcd04d731fff7711814	0	2209	t	96	Caleta	Caleta	{}	high	\N	\N	411
Plinko X	basic	https://gis-static.com/games/f6573dfe5225f0d3eb56fc99a4e0eca894268f1e.png	t	t	f6573dfe5225f0d3eb56fc99a4e0eca894268f1e	f6573dfe5225f0d3eb56fc99a4e0eca894268f1e	0	1309	t	96	SmartSoft	SmartSoft	{}	medium	\N	\N	412
Zombie Chicken	basic	https://gis-static.com/games/f258517976ca9aa4d4ef11a9e7179194f44be49a.png	f	f	f258517976ca9aa4d4ef11a9e7179194f44be49a	f258517976ca9aa4d4ef11a9e7179194f44be49a	0	1059	t	96	KAGaming	KAGaming	{}	low	\N	\N	413
Monster Island	basic	https://gis-static.com/games/175c49f66cfabe9307fa1001af73578fa6733a54.png	t	t	175c49f66cfabe9307fa1001af73578fa6733a54	175c49f66cfabe9307fa1001af73578fa6733a54	0	2559	t	96	KAGaming	KAGaming	{}	medium-high	\N	\N	414
Crash X Football Edition	basic	https://gis-static.com/games/Turbogames/85c9146205eed9cd708173e46d9668e71cd3576e.png	t	t	85c9146205eed9cd708173e46d9668e71cd3576e	85c9146205eed9cd708173e46d9668e71cd3576e	0	1559	t	96	Turbogames	Turbogames	{}	high	\N	\N	415
Cricket X	basic	https://gis-static.com/games/9117a28ecefe54ebb9f812e1cbafdf0de9ace433.png	t	t	9117a28ecefe54ebb9f812e1cbafdf0de9ace433	9117a28ecefe54ebb9f812e1cbafdf0de9ace433	0	1311	t	96	SmartSoft	SmartSoft	{}	medium	\N	\N	416
Mriya	basic	https://gis-static.com/games/a054edc2ec93ab0000ba3a4f2e07c7a5846a0c07.png	f	f	a054edc2ec93ab0000ba3a4f2e07c7a5846a0c07	a054edc2ec93ab0000ba3a4f2e07c7a5846a0c07	0	1061	t	96	NetGame	NetGame	{}	low	\N	\N	417
Roulette European	basic	https://gis-static.com/games/e6259ecb958c606a553e6ba252ff347b6280b666.png	t	t	e6259ecb958c606a553e6ba252ff347b6280b666	e6259ecb958c606a553e6ba252ff347b6280b666	0	2561	t	96	VibraGaming	VibraGaming	{}	medium-high	\N	\N	418
Forest of Spirits	basic	https://gis-static.com/games/a8d612003245085568f55e311f746ced6f880a29.png	t	t	a8d612003245085568f55e311f746ced6f880a29	a8d612003245085568f55e311f746ced6f880a29	0	1561	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	419
Midsummer Night	basic	https://gis-static.com/games/b181a828209a06d4f8682a2bcb402059b5323e48.png	t	t	b181a828209a06d4f8682a2bcb402059b5323e48	b181a828209a06d4f8682a2bcb402059b5323e48	0	761	t	96	SuperlottoFast	SuperlottoFast	{}	low	\N	\N	420
Mermaid World	basic	https://gis-static.com/games/307ca25d94c72e5c172924a9334fec1bc2e2c758.png	t	t	307ca25d94c72e5c172924a9334fec1bc2e2c758	307ca25d94c72e5c172924a9334fec1bc2e2c758	0	761	t	96	KAGaming	KAGaming	{}	high	\N	\N	421
Magnify Man	basic	https://gis-static.com/games/Fugaso/d4c520af428e48799aa7a2c2ab2687bb.png	t	t	d4c520af428e48799aa7a2c2ab2687bb	d4c520af428e48799aa7a2c2ab2687bb	0	10063	t	96	Fugaso	Fugaso	{}	very-high	\N	\N	422
Pilot	basic	https://gis-static.com/games/Gamzix/10ff3929a5484f5dc24dfcad71d7c21d6756b83a.jpg	t	t	10ff3929a5484f5dc24dfcad71d7c21d6756b83a	10ff3929a5484f5dc24dfcad71d7c21d6756b83a	0	2212	t	96	Gamzix	Gamzix	{}	high	\N	\N	423
Cash Galaxy	basic	https://gis-static.com/games/0a7b214a1cc81b4d5b494bfe71376f94030f3e80.png	t	t	0a7b214a1cc81b4d5b494bfe71376f94030f3e80	0a7b214a1cc81b4d5b494bfe71376f94030f3e80	0	1312	t	96	OneTouch	OneTouch	{}	medium	\N	\N	424
Tower Poker	basic	https://gis-static.com/games/fbf6e313ca78809664c9891e6a1fb598ea138aa4.png	f	f	fbf6e313ca78809664c9891e6a1fb598ea138aa4	fbf6e313ca78809664c9891e6a1fb598ea138aa4	0	1062	t	96	Igrosoft	Igrosoft	{}	low	\N	\N	425
Turbo Plinko	basic	https://gis-static.com/games/e2d3b1e6bf61857a9f14104b5769275033381637.png	t	t	e2d3b1e6bf61857a9f14104b5769275033381637	e2d3b1e6bf61857a9f14104b5769275033381637	0	2562	t	96	Turbogames	Turbogames	{}	medium-high	\N	\N	426
Turbo Mines	basic	https://gis-static.com/games/267242f074513afe257c7b5fb9908e9cd63c7ccf.png	t	t	267242f074513afe257c7b5fb9908e9cd63c7ccf	267242f074513afe257c7b5fb9908e9cd63c7ccf	0	1562	t	96	Turbogames	Turbogames	{}	high	\N	\N	427
Ocean Princess	basic	https://gis-static.com/games/f613b25f8605e1a9d184d87c1e40a60618679665.png	t	t	f613b25f8605e1a9d184d87c1e40a60618679665	f613b25f8605e1a9d184d87c1e40a60618679665	0	762	t	96	KAGaming	KAGaming	{}	high	\N	\N	428
Happy Food Hunter	basic	https://gis-static.com/games/d81b37c6a2557ba4c4eeb0112eb1d718ed17a101.png	t	t	d81b37c6a2557ba4c4eeb0112eb1d718ed17a101	d81b37c6a2557ba4c4eeb0112eb1d718ed17a101	0	1444	t	96	KAGaming	KAGaming	{}	high	\N	\N	429
CA1 Roulette	basic	https://gis-static.com/games/0a1ba6dcb218bedb8794f9092b9aa18a0c8c9f0a.png	t	t	0a1ba6dcb218bedb8794f9092b9aa18a0c8c9f0a	0a1ba6dcb218bedb8794f9092b9aa18a0c8c9f0a	0	10064	t	96	HoGaming	HoGaming	{}	very-high	\N	\N	430
J2 Blackjack	basic	https://gis-static.com/games/a5d1b369edc82381f536b4f77a435858e8ae4046.png	t	t	a5d1b369edc82381f536b4f77a435858e8ae4046	a5d1b369edc82381f536b4f77a435858e8ae4046	0	2213	t	96	HoGaming	HoGaming	{}	high	\N	\N	431
C1 Speed Baccarat	basic	https://gis-static.com/games/7581867adce539b241063bb86258adb865154f0a.png	t	t	7581867adce539b241063bb86258adb865154f0a	7581867adce539b241063bb86258adb865154f0a	0	1313	t	96	HoGaming	HoGaming	{}	medium	\N	\N	432
C2 Speed Baccarat	basic	https://gis-static.com/games/a27fc52631c8a1479bceaf3fa6694b3707c628e1.png	f	f	a27fc52631c8a1479bceaf3fa6694b3707c628e1	a27fc52631c8a1479bceaf3fa6694b3707c628e1	0	1063	t	96	HoGaming	HoGaming	{}	low	\N	\N	433
C3 Speed Baccarat	basic	https://gis-static.com/games/7e11482f89bd1117cbfeb6b4fe86cd291375f16c.png	t	t	7e11482f89bd1117cbfeb6b4fe86cd291375f16c	7e11482f89bd1117cbfeb6b4fe86cd291375f16c	0	2563	t	96	HoGaming	HoGaming	{}	medium-high	\N	\N	434
C4 Baccarat	basic	https://gis-static.com/games/3f7f7221223ef095679e017c60d90d416705efeb.png	t	t	3f7f7221223ef095679e017c60d90d416705efeb	3f7f7221223ef095679e017c60d90d416705efeb	0	1563	t	96	HoGaming	HoGaming	{}	high	\N	\N	435
CA1 Speed Baccarat	basic	https://gis-static.com/games/849d4b97d90ef3ee1c79b235c933271bc7e0bc66.png	t	t	849d4b97d90ef3ee1c79b235c933271bc7e0bc66	849d4b97d90ef3ee1c79b235c933271bc7e0bc66	0	763	t	96	HoGaming	HoGaming	{}	low	\N	\N	436
CA3 Speed Baccarat	basic	https://gis-static.com/games/92f92810c660566b3d707b7d6589ea30499d3481.png	t	t	92f92810c660566b3d707b7d6589ea30499d3481	92f92810c660566b3d707b7d6589ea30499d3481	0	763	t	96	HoGaming	HoGaming	{}	high	\N	\N	437
CA5 Baccarat	basic	https://gis-static.com/games/2a7c9c1447ec3381a54d3b40a7756b4751eac05a.png	t	t	2a7c9c1447ec3381a54d3b40a7756b4751eac05a	2a7c9c1447ec3381a54d3b40a7756b4751eac05a	0	10065	t	96	HoGaming	HoGaming	{}	very-high	\N	\N	438
Blackjack	basic	https://gis-static.com/games/0f15077f186614ec9646cd9b534a46afe30e8280.png	t	t	0f15077f186614ec9646cd9b534a46afe30e8280	0f15077f186614ec9646cd9b534a46afe30e8280	0	2214	t	96	VibraGaming	VibraGaming	{}	high	\N	\N	439
Fruitverse	basic	https://gis-static.com/games/Caleta/99166c085feeb3d9b6321bb8ff0d7a4b98a29bbe.png	t	t	99166c085feeb3d9b6321bb8ff0d7a4b98a29bbe	99166c085feeb3d9b6321bb8ff0d7a4b98a29bbe	0	1314	t	96	Caleta	Caleta	{}	medium	\N	\N	440
Robot Wars	basic	https://gis-static.com/games/KAGaming/b21524a25ec72f41ca83124c31685c6af7041430.png	f	f	b21524a25ec72f41ca83124c31685c6af7041430	b21524a25ec72f41ca83124c31685c6af7041430	0	1064	t	96	KAGaming	KAGaming	{}	low	\N	\N	441
Lucky Video Poker	basic	https://gis-static.com/games/KAGaming/4d46a841ddbc0531452f334b49af2488f43ab577.png	t	t	4d46a841ddbc0531452f334b49af2488f43ab577	4d46a841ddbc0531452f334b49af2488f43ab577	0	2564	t	96	KAGaming	KAGaming	{}	medium-high	\N	\N	442
Baccarat Punto Banco	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Red Tiger/016bf05143194ff6a6dcf95c0233f51f.png	t	t	016bf05143194ff6a6dcf95c0233f51f	016bf05143194ff6a6dcf95c0233f51f	0	1564	t	96	Red Tiger	Red Tiger	{}	high	\N	\N	443
Classic Blackjack	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Red Tiger/b820cce9e0b54d4c881f2598e512b389.png	t	t	b820cce9e0b54d4c881f2598e512b389	b820cce9e0b54d4c881f2598e512b389	0	764	t	96	Red Tiger	Red Tiger	{}	low	\N	\N	444
European Roulette	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Red Tiger/88689e559d604c22a1f97910b06c3c2f.png	t	t	88689e559d604c22a1f97910b06c3c2f	88689e559d604c22a1f97910b06c3c2f	0	764	t	96	Red Tiger	Red Tiger	{}	high	\N	\N	445
Old West	basic	https://gis-static.com/games/Evoplay/a5adf8a7c62911577dfff086a7b9716be8d95189.png	t	t	a5adf8a7c62911577dfff086a7b9716be8d95189	a5adf8a7c62911577dfff086a7b9716be8d95189	0	10066	t	96	Evoplay	Evoplay	{}	very-high	\N	\N	446
Wheel of Magic	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/714af394f74045239a67ab822ab3e2e6.png	t	t	714af394f74045239a67ab822ab3e2e6	714af394f74045239a67ab822ab3e2e6	0	2215	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	447
Mythical Beast	basic	https://gis-static.com/games/KAGaming/6868365d7bcd43fd82da75b845e007c5.png	t	t	6868365d7bcd43fd82da75b845e007c5	6868365d7bcd43fd82da75b845e007c5	0	1315	t	96	KAGaming	KAGaming	{}	medium	\N	\N	448
Special OPS	basic	https://gis-static.com/games/KAGaming/aa05ea81ba5f475197a9c38655feae24.png	f	f	aa05ea81ba5f475197a9c38655feae24	aa05ea81ba5f475197a9c38655feae24	0	1065	t	96	KAGaming	KAGaming	{}	low	\N	\N	449
Euro MultiX Roulette	basic	https://gis-static.com/games/Espressogames/af343e9dc575f7836185e7db6c0db21777466cca.png	t	t	af343e9dc575f7836185e7db6c0db21777466cca	af343e9dc575f7836185e7db6c0db21777466cca	0	2565	t	96	Espressogames	Espressogames	{}	medium-high	\N	\N	450
Jacks or Better	basic	https://gis-static.com/games/Platipus/26c605db2c072a51cc5bee9d4daef37c83103821.png	t	t	26c605db2c072a51cc5bee9d4daef37c83103821	26c605db2c072a51cc5bee9d4daef37c83103821	0	1565	t	96	Platipus	Platipus	{}	high	\N	\N	451
Hungry Shark	basic	https://gis-static.com/games/KAGaming/ba92e1e5f2ab2d9dfe97fbce8e55c80cb3080aae.png	t	t	ba92e1e5f2ab2d9dfe97fbce8e55c80cb3080aae	ba92e1e5f2ab2d9dfe97fbce8e55c80cb3080aae	0	765	t	96	KAGaming	KAGaming	{}	low	\N	\N	452
Pilot Cup	basic	https://gis-static.com/games/Gamzix/afa0c35aaf3f85e2296e6930f507e49e3fbae71a.jpg	t	t	afa0c35aaf3f85e2296e6930f507e49e3fbae71a	afa0c35aaf3f85e2296e6930f507e49e3fbae71a	0	765	t	96	Gamzix	Gamzix	{}	high	\N	\N	453
Spooky Witchcraft	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/4a6ab315f7a3a1fcdcdc466f8e5d2ab4a4ea81b2.png	t	t	4a6ab315f7a3a1fcdcdc466f8e5d2ab4a4ea81b2	4a6ab315f7a3a1fcdcdc466f8e5d2ab4a4ea81b2	0	766	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	454
Fortuna Mortal	basic	https://gis-static.com/games/VibraGaming/bac0f16ef0224bdc0f53f9761c83ad1062b851ee.png	t	t	bac0f16ef0224bdc0f53f9761c83ad1062b851ee	bac0f16ef0224bdc0f53f9761c83ad1062b851ee	0	10068	t	96	VibraGaming	VibraGaming	{}	very-high	\N	\N	455
Magic Witches	basic	https://gis-static.com/games/KAGaming/47a2cbd726c56c4522a15f3db41c37a5b00c90af.png	t	t	47a2cbd726c56c4522a15f3db41c37a5b00c90af	47a2cbd726c56c4522a15f3db41c37a5b00c90af	0	2217	t	96	KAGaming	KAGaming	{}	high	\N	\N	456
Goal Crash	basic	https://gis-static.com/games/TripleCherry/b45dce212e0cd95a57f344672e08c8ae943d8ab4.png	t	t	b45dce212e0cd95a57f344672e08c8ae943d8ab4	b45dce212e0cd95a57f344672e08c8ae943d8ab4	0	1317	t	96	TripleCherry	TripleCherry	{}	medium	\N	\N	457
El Mariachi	basic	https://gis-static.com/games/VibraGaming/5ffae883f3ba4243ea7abd76163fa6aa692eec49.png	f	f	5ffae883f3ba4243ea7abd76163fa6aa692eec49	5ffae883f3ba4243ea7abd76163fa6aa692eec49	0	1067	t	96	VibraGaming	VibraGaming	{}	low	\N	\N	458
Football Scratch	basic	https://gis-static.com/games/Evoplay/c45a78947193eaa8ab17c7e6a6b02e3f0809c08d.png	t	t	c45a78947193eaa8ab17c7e6a6b02e3f0809c08d	c45a78947193eaa8ab17c7e6a6b02e3f0809c08d	0	2567	t	96	Evoplay	Evoplay	{}	medium-high	\N	\N	459
Sheng Xiao Bingo	basic	https://gis-static.com/games/f624ed082b9280306e3f8daaaf4bc5f1/EurasianGamingBingo/5e254a8abbb4cf478e1f7997254744602f364865.jpg	t	t	5e254a8abbb4cf478e1f7997254744602f364865	5e254a8abbb4cf478e1f7997254744602f364865	0	2218	t	96	EurasianGamingBingo	EurasianGamingBingo	{}	high	\N	\N	460
Magic Keno	basic	https://gis-static.com/games/Turbogames/e0711aa575a8a3c4ac9cd49c48c797b5cab296a1.jpg	t	t	e0711aa575a8a3c4ac9cd49c48c797b5cab296a1	e0711aa575a8a3c4ac9cd49c48c797b5cab296a1	0	1318	t	96	Turbogames	Turbogames	{}	medium	\N	\N	461
Pilot Coin	basic	https://gis-static.com/games/Gamzix/0abac1a672976c3b4065c25634dac198f21fc836.jpg	f	f	0abac1a672976c3b4065c25634dac198f21fc836	0abac1a672976c3b4065c25634dac198f21fc836	0	1068	t	96	Gamzix	Gamzix	{}	low	\N	\N	462
Bonus Poker	basic	https://gis-static.com/games/KAGaming/7c1b4168d08465dbef567a559297de81184bdc76.png	t	t	7c1b4168d08465dbef567a559297de81184bdc76	7c1b4168d08465dbef567a559297de81184bdc76	0	2568	t	96	KAGaming	KAGaming	{}	medium-high	\N	\N	463
Food Coma	basic	https://gis-static.com/games/KAGaming/c014125929928f1dea16d63a62fe8d0e1719f1b7.png	t	t	c014125929928f1dea16d63a62fe8d0e1719f1b7	c014125929928f1dea16d63a62fe8d0e1719f1b7	0	1568	t	96	KAGaming	KAGaming	{}	high	\N	\N	464
FootbalX	basic	https://gis-static.com/games/SmartSoft/eb2fbec7b7095e687125e86536e22bf661867bec.png	t	t	eb2fbec7b7095e687125e86536e22bf661867bec	eb2fbec7b7095e687125e86536e22bf661867bec	0	768	t	96	SmartSoft	SmartSoft	{}	low	\N	\N	465
European Roulette	basic	https://gis-static.com/games/2b2de74b5a4ee5058d93c4109b56077e/Truelab/031f50028ba44543918d5393894de701.png	t	t	031f50028ba44543918d5393894de701	031f50028ba44543918d5393894de701	0	768	t	96	Truelab	Truelab	{}	high	\N	\N	466
American Roulette	basic	https://gis-static.com/games/2b2de74b5a4ee5058d93c4109b56077e/Truelab/7b0101ff563f4202b783f9fbd18bb0b3.png	t	t	7b0101ff563f4202b783f9fbd18bb0b3	7b0101ff563f4202b783f9fbd18bb0b3	0	1570	t	96	Truelab	Truelab	{}	high	\N	\N	467
Ethan Grand: Mayan Diaries	basic	https://gis-static.com/games/Evoplay/e988cded668f4d6db054c76b81dcac17.png	t	t	e988cded668f4d6db054c76b81dcac17	e988cded668f4d6db054c76b81dcac17	0	770	t	96	Evoplay	Evoplay	{}	low	\N	\N	468
Roulette	basic	https://gis-static.com/games/Boldplay/f3578cb5383246a8a7b20e99a89adda2.png	t	t	f3578cb5383246a8a7b20e99a89adda2	f3578cb5383246a8a7b20e99a89adda2	0	770	t	96	Boldplay	Boldplay	{}	high	\N	\N	469
Baccarat	basic	https://gis-static.com/games/Boldplay/e79c77b5f6384406abb7f87b71394247.png	t	t	e79c77b5f6384406abb7f87b71394247	e79c77b5f6384406abb7f87b71394247	0	10072	t	96	Boldplay	Boldplay	{}	very-high	\N	\N	470
Blackjack	basic	https://gis-static.com/games/Boldplay/52d12614989e45cf9ee6beb0b7639364.png	t	t	52d12614989e45cf9ee6beb0b7639364	52d12614989e45cf9ee6beb0b7639364	0	2221	t	96	Boldplay	Boldplay	{}	high	\N	\N	471
Book of Amduat Scratch	basic	https://gis-static.com/games/Boldplay/207eb8f3865349fb970409499eb7894f.png	t	t	207eb8f3865349fb970409499eb7894f	207eb8f3865349fb970409499eb7894f	0	1321	t	96	Boldplay	Boldplay	{}	medium	\N	\N	472
Swan House Scratch	basic	https://gis-static.com/games/Boldplay/34da091b5f2b451a9d306ddf206a68a9.png	t	t	34da091b5f2b451a9d306ddf206a68a9	34da091b5f2b451a9d306ddf206a68a9	0	767	t	96	Boldplay	Boldplay	{}	high	\N	\N	473
9 Planet Shockers Scratch	basic	https://gis-static.com/games/Boldplay/bdb62f1e9d524028ab6f79e9c96367d4.png	t	t	bdb62f1e9d524028ab6f79e9c96367d4	bdb62f1e9d524028ab6f79e9c96367d4	0	10070	t	96	Boldplay	Boldplay	{}	very-high	\N	\N	474
Aapo's Quest Scratch	basic	https://gis-static.com/games/Boldplay/128b62ff1daf4616a2a70a3ea40db787.png	f	f	128b62ff1daf4616a2a70a3ea40db787	128b62ff1daf4616a2a70a3ea40db787	0	1071	t	96	Boldplay	Boldplay	{}	low	\N	\N	475
Fabulous Fairies Scratch	basic	https://gis-static.com/games/Boldplay/d3854195264e45869126f21c6f5d9269.png	t	t	d3854195264e45869126f21c6f5d9269	d3854195264e45869126f21c6f5d9269	0	2571	t	96	Boldplay	Boldplay	{}	medium-high	\N	\N	476
Gold Creek Superpays Scratch	basic	https://gis-static.com/games/Boldplay/cce337a930f54110a8558c4b4cc9e8fc.png	t	t	cce337a930f54110a8558c4b4cc9e8fc	cce337a930f54110a8558c4b4cc9e8fc	0	1571	t	96	Boldplay	Boldplay	{}	high	\N	\N	477
Eirik the Viking Scratch	basic	https://gis-static.com/games/Boldplay/decbb81bba2f4c16b5ab96edaafc5b7a.png	t	t	decbb81bba2f4c16b5ab96edaafc5b7a	decbb81bba2f4c16b5ab96edaafc5b7a	0	771	t	96	Boldplay	Boldplay	{}	low	\N	\N	478
Fruit Bar Scratch	basic	https://gis-static.com/games/Boldplay/c8b73e042f4d4583b5e2f5b44fb93a03.png	t	t	c8b73e042f4d4583b5e2f5b44fb93a03	c8b73e042f4d4583b5e2f5b44fb93a03	0	771	t	96	Boldplay	Boldplay	{}	high	\N	\N	479
1000 Rainbows Superpot Scratch	basic	https://gis-static.com/games/Boldplay/e97a157b3e044eca9e63475a4718e75f.png	t	t	e97a157b3e044eca9e63475a4718e75f	e97a157b3e044eca9e63475a4718e75f	0	10073	t	96	Boldplay	Boldplay	{}	very-high	\N	\N	480
Christmas Fairies Scratch	basic	https://gis-static.com/games/Boldplay/7f7291ec8188422da00cdfe345a3b0da.png	t	t	7f7291ec8188422da00cdfe345a3b0da	7f7291ec8188422da00cdfe345a3b0da	0	2222	t	96	Boldplay	Boldplay	{}	high	\N	\N	481
Arriba Scratch	basic	https://gis-static.com/games/Boldplay/81e4fa1262e74be7923dfdeb8cef85bc.png	t	t	81e4fa1262e74be7923dfdeb8cef85bc	81e4fa1262e74be7923dfdeb8cef85bc	0	1322	t	96	Boldplay	Boldplay	{}	medium	\N	\N	482
500 BC Sparta Supersweep Scratch	basic	https://gis-static.com/games/Boldplay/a1e63f2c194e428dacf2243d9a4cf090.png	f	f	a1e63f2c194e428dacf2243d9a4cf090	a1e63f2c194e428dacf2243d9a4cf090	0	1072	t	96	Boldplay	Boldplay	{}	low	\N	\N	483
Shinobi Supersweep Scratch	basic	https://gis-static.com/games/Boldplay/4ac6611687c744d3aca474f8420a7d1a.png	t	t	4ac6611687c744d3aca474f8420a7d1a	4ac6611687c744d3aca474f8420a7d1a	0	2572	t	96	Boldplay	Boldplay	{}	medium-high	\N	\N	484
Gold Metal Ox Scratch	basic	https://gis-static.com/games/Boldplay/dcddbe2c73d64018bc33f4f30f919cd7.png	t	t	dcddbe2c73d64018bc33f4f30f919cd7	dcddbe2c73d64018bc33f4f30f919cd7	0	1572	t	96	Boldplay	Boldplay	{}	high	\N	\N	485
Keno	basic	https://gis-static.com/games/Boldplay/a25c471688bb4cb1b7d1d506d83fb84c.png	t	t	a25c471688bb4cb1b7d1d506d83fb84c	a25c471688bb4cb1b7d1d506d83fb84c	0	772	t	96	Boldplay	Boldplay	{}	low	\N	\N	486
Gold Saloon Superpot Scratch	basic	https://gis-static.com/games/Boldplay/fe641e40ac4b43d49848620660bdaba2.png	t	t	fe641e40ac4b43d49848620660bdaba2	fe641e40ac4b43d49848620660bdaba2	0	772	t	96	Boldplay	Boldplay	{}	high	\N	\N	487
Toro Bravo Scratch	basic	https://gis-static.com/games/Boldplay/0d1090d8e55f468ab7dc04de8c985f3a.png	t	t	0d1090d8e55f468ab7dc04de8c985f3a	0d1090d8e55f468ab7dc04de8c985f3a	0	10074	t	96	Boldplay	Boldplay	{}	very-high	\N	\N	488
1 Don House Supersweep Scratch	basic	https://gis-static.com/games/Boldplay/815459d5e75149cca67b2d6337aee83d.png	t	t	815459d5e75149cca67b2d6337aee83d	815459d5e75149cca67b2d6337aee83d	0	2223	t	96	Boldplay	Boldplay	{}	high	\N	\N	489
Knights of Alturia Scratch	basic	https://gis-static.com/games/Boldplay/9a9d7600950849aaaac6cef8c139032c.png	t	t	9a9d7600950849aaaac6cef8c139032c	9a9d7600950849aaaac6cef8c139032c	0	1323	t	96	Boldplay	Boldplay	{}	medium	\N	\N	490
Swift Blades Scratch	basic	https://gis-static.com/games/Boldplay/cf4e4b11f9ab4fd58e69d1c38a0493d2.png	f	f	cf4e4b11f9ab4fd58e69d1c38a0493d2	cf4e4b11f9ab4fd58e69d1c38a0493d2	0	1073	t	96	Boldplay	Boldplay	{}	low	\N	\N	491
Creatures of Atlantis Scratch	basic	https://gis-static.com/games/Boldplay/09b34f0f60f84c97b71e5bf2987a6a26.png	t	t	09b34f0f60f84c97b71e5bf2987a6a26	09b34f0f60f84c97b71e5bf2987a6a26	0	2573	t	96	Boldplay	Boldplay	{}	medium-high	\N	\N	492
Mummified Mysteries Scratch	basic	https://gis-static.com/games/Boldplay/6573788ec17e420096e724e9e8503373.png	t	t	6573788ec17e420096e724e9e8503373	6573788ec17e420096e724e9e8503373	0	1573	t	96	Boldplay	Boldplay	{}	high	\N	\N	493
Pretty Diamonds Scratch	basic	https://gis-static.com/games/Boldplay/fc579454deba4a0e8a329d74235cf7fe.png	t	t	fc579454deba4a0e8a329d74235cf7fe	fc579454deba4a0e8a329d74235cf7fe	0	773	t	96	Boldplay	Boldplay	{}	low	\N	\N	494
Bow Wow Scratch	basic	https://gis-static.com/games/Boldplay/d7990cf87b774696be72af9f5637e55f.png	t	t	d7990cf87b774696be72af9f5637e55f	d7990cf87b774696be72af9f5637e55f	0	10075	t	96	Boldplay	Boldplay	{}	very-high	\N	\N	496
Dark Potions Scratch	basic	https://gis-static.com/games/Boldplay/671f62e913e9447fa83d3f22d8751cd4.png	t	t	671f62e913e9447fa83d3f22d8751cd4	671f62e913e9447fa83d3f22d8751cd4	0	1324	t	96	Boldplay	Boldplay	{}	medium	\N	\N	498
Tiger Fortune Scratch	basic	https://gis-static.com/games/Boldplay/c3fbf7d47a934e14b1fe39e3385abcf1.png	f	f	c3fbf7d47a934e14b1fe39e3385abcf1	c3fbf7d47a934e14b1fe39e3385abcf1	0	1074	t	96	Boldplay	Boldplay	{}	low	\N	\N	499
Queen Hera Scratch	basic	https://gis-static.com/games/Boldplay/1b4ded84c0c14526a020a802c9b9f4fc.png	t	t	1b4ded84c0c14526a020a802c9b9f4fc	1b4ded84c0c14526a020a802c9b9f4fc	0	2574	t	96	Boldplay	Boldplay	{}	medium-high	\N	\N	500
Carnaval do Rio Scratch	basic	https://gis-static.com/games/Boldplay/1ee4a61e9200430e850f2c7ea6243fca.png	t	t	1ee4a61e9200430e850f2c7ea6243fca	1ee4a61e9200430e850f2c7ea6243fca	0	1574	t	96	Boldplay	Boldplay	{}	high	\N	\N	501
Mad Scientist Scratch	basic	https://gis-static.com/games/Boldplay/a1c2bf00299e41419d7cf44f6cf5cf26.png	t	t	a1c2bf00299e41419d7cf44f6cf5cf26	a1c2bf00299e41419d7cf44f6cf5cf26	0	774	t	96	Boldplay	Boldplay	{}	low	\N	\N	502
White Buffalo Miracles Scratch	basic	https://gis-static.com/games/Boldplay/47c27c8397dd41bca853a9c59b3c906f.png	t	t	47c27c8397dd41bca853a9c59b3c906f	47c27c8397dd41bca853a9c59b3c906f	0	774	t	96	Boldplay	Boldplay	{}	high	\N	\N	503
Reef Adventures Scratch	basic	https://gis-static.com/games/Boldplay/c7b828119ed0485a9a77829719725e5e.png	t	t	c7b828119ed0485a9a77829719725e5e	c7b828119ed0485a9a77829719725e5e	0	10076	t	96	Boldplay	Boldplay	{}	very-high	\N	\N	504
Silver Hook Scratch	basic	https://gis-static.com/games/Boldplay/6b29db6723904f00aa66e0d393ae7d63.png	t	t	6b29db6723904f00aa66e0d393ae7d63	6b29db6723904f00aa66e0d393ae7d63	0	2225	t	96	Boldplay	Boldplay	{}	high	\N	\N	505
Star Dragon Scratch	basic	https://gis-static.com/games/Boldplay/3579f219701d439da4fe073cd76dff5a.png	t	t	3579f219701d439da4fe073cd76dff5a	3579f219701d439da4fe073cd76dff5a	0	1325	t	96	Boldplay	Boldplay	{}	medium	\N	\N	506
Roulette Touch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/NetEnt/281088de0e524d64bcfbd49d8d69bcc3.png	f	f	281088de0e524d64bcfbd49d8d69bcc3	281088de0e524d64bcfbd49d8d69bcc3	0	1075	t	96	NetEnt	NetEnt	{}	low	\N	\N	507
Roulette Advanced	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/NetEnt/56e207a65d094c8bab56ae48fb7d3b9b.png	t	t	56e207a65d094c8bab56ae48fb7d3b9b	56e207a65d094c8bab56ae48fb7d3b9b	0	10089	t	96	NetEnt	NetEnt	{}	very-high	\N	\N	508
Jacks or Better Double Up	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/NetEnt/9a9286f440074aaf8c7843c9d285afb4.png	t	t	9a9286f440074aaf8c7843c9d285afb4	9a9286f440074aaf8c7843c9d285afb4	0	2575	t	96	NetEnt	NetEnt	{}	medium-high	\N	\N	509
French Roulette	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/NetEnt/28db8d41953b49c096243c7445c1539c.png	t	t	28db8d41953b49c096243c7445c1539c	28db8d41953b49c096243c7445c1539c	0	1575	t	96	NetEnt	NetEnt	{}	high	\N	\N	510
European Roulette	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/NetEnt/9b375b770e364751b331fe670f56a87d.png	t	t	9b375b770e364751b331fe670f56a87d	9b375b770e364751b331fe670f56a87d	0	775	t	96	NetEnt	NetEnt	{}	low	\N	\N	511
Casino Hold'em	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/NetEnt/6043ac76f4de4b008d233b3e8d1203af.png	t	t	6043ac76f4de4b008d233b3e8d1203af	6043ac76f4de4b008d233b3e8d1203af	0	775	t	96	NetEnt	NetEnt	{}	high	\N	\N	512
Baccarat	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/NetEnt/4553774a417c47e3b94aa212a1edd95d.png	t	t	4553774a417c47e3b94aa212a1edd95d	4553774a417c47e3b94aa212a1edd95d	0	10077	t	96	NetEnt	NetEnt	{}	very-high	\N	\N	513
American Roulette	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/NetEnt/b9919858658b4a72929fb2938293daf3.png	t	t	b9919858658b4a72929fb2938293daf3	b9919858658b4a72929fb2938293daf3	0	1326	t	96	NetEnt	NetEnt	{}	medium	\N	\N	514
Blackjack Classic	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/NetEnt/964f74d89fb447e2bab08d65bd8f82bf.png	f	f	964f74d89fb447e2bab08d65bd8f82bf	964f74d89fb447e2bab08d65bd8f82bf	0	1076	t	96	NetEnt	NetEnt	{}	low	\N	\N	515
Muertitos: Video Bingo	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Spearhead Studios/e39c6a2958444206a7d2e9e65af46cb2.png	t	t	e39c6a2958444206a7d2e9e65af46cb2	e39c6a2958444206a7d2e9e65af46cb2	0	2576	t	96	Spearhead Studios	Spearhead Studios	{}	medium-high	\N	\N	516
Jacks or Better	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Spearhead Studios/65dbf972e4d040f2856f736987f72bdd.png	t	t	65dbf972e4d040f2856f736987f72bdd	65dbf972e4d040f2856f736987f72bdd	0	1576	t	96	Spearhead Studios	Spearhead Studios	{}	high	\N	\N	517
Undersea Treasure	basic	https://gis-static.com/games/KAGaming/a758d654c23e48b186d1cb9e169f3ec6.png	t	t	a758d654c23e48b186d1cb9e169f3ec6	a758d654c23e48b186d1cb9e169f3ec6	0	776	t	96	KAGaming	KAGaming	{}	high	\N	\N	519
Penalty Kick	basic	https://gis-static.com/games/KAGaming/0724aa6806404510951eb176fe21d44c.png	t	t	0724aa6806404510951eb176fe21d44c	0724aa6806404510951eb176fe21d44c	0	10078	t	96	KAGaming	KAGaming	{}	very-high	\N	\N	520
Classic Spins Scratch	basic	https://gis-static.com/games/Boldplay/5c4b84a46508fd8e903d2ca46107d9d2b9d04099.png	t	t	5c4b84a46508fd8e903d2ca46107d9d2b9d04099	5c4b84a46508fd8e903d2ca46107d9d2b9d04099	0	10079	t	96	Boldplay	Boldplay	{}	very-high	\N	\N	521
Surfing Beauties Scratch	basic	https://gis-static.com/games/Boldplay/24a08a51b2e5264cd41f23232ef5d6486ba454c9.png	t	t	24a08a51b2e5264cd41f23232ef5d6486ba454c9	24a08a51b2e5264cd41f23232ef5d6486ba454c9	0	2228	t	96	Boldplay	Boldplay	{}	high	\N	\N	522
Cam Carter and the Cursed Caves Scratch	basic	https://gis-static.com/games/Boldplay/ea47f8d99815fc8f8ac8b101a7212a2ad2c03ab5.png	f	f	ea47f8d99815fc8f8ac8b101a7212a2ad2c03ab5	ea47f8d99815fc8f8ac8b101a7212a2ad2c03ab5	0	1078	t	96	Boldplay	Boldplay	{}	low	\N	\N	524
Holmes and Moriarty Scratch	basic	https://gis-static.com/games/Boldplay/49c047fa1957c2539728de4d2da6bb2b246e5beb.png	t	t	49c047fa1957c2539728de4d2da6bb2b246e5beb	49c047fa1957c2539728de4d2da6bb2b246e5beb	0	2578	t	96	Boldplay	Boldplay	{}	medium-high	\N	\N	525
Wildscapes Scratch	basic	https://gis-static.com/games/Boldplay/245df34df1a5d7528c81223c9d4e110059191a28.png	t	t	245df34df1a5d7528c81223c9d4e110059191a28	245df34df1a5d7528c81223c9d4e110059191a28	0	1578	t	96	Boldplay	Boldplay	{}	high	\N	\N	526
Biker Santa: Bells Angels Scratch	basic	https://gis-static.com/games/Boldplay/2838f10f9be5d8ceb4a304b4a5d3437b9735a742.png	t	t	2838f10f9be5d8ceb4a304b4a5d3437b9735a742	2838f10f9be5d8ceb4a304b4a5d3437b9735a742	0	778	t	96	Boldplay	Boldplay	{}	low	\N	\N	527
Ocean Star Hunting	basic	https://gis-static.com/games/KAGaming/a79ef4bfc13c4b528a1d4b931a7533cf.png	t	t	a79ef4bfc13c4b528a1d4b931a7533cf	a79ef4bfc13c4b528a1d4b931a7533cf	0	778	t	96	KAGaming	KAGaming	{}	high	\N	\N	528
Rainbow Keno	basic	https://gis-static.com/games/Caleta/d5d8bac546554141bd58fc7f70746ba9.png	t	t	d5d8bac546554141bd58fc7f70746ba9	d5d8bac546554141bd58fc7f70746ba9	0	10080	t	96	Caleta	Caleta	{}	very-high	\N	\N	529
Lucky Santa	basic	https://gis-static.com/games/be9ccd37c82dbd3e31e2aed7f8dfce53/SuperlottoFast/0307bff7be247ad0e2a2a1440f2d43de2fffcef5.png	t	t	0307bff7be247ad0e2a2a1440f2d43de2fffcef5	0307bff7be247ad0e2a2a1440f2d43de2fffcef5	0	2229	t	96	SuperlottoFast	SuperlottoFast	{}	high	\N	\N	530
Andar Bahar	basic	https://gis-static.com/games/TripleProfitsGames/f745bbb4e6b6d9b2a7a0c2f5f33749903f3eb4ef.png	t	t	f745bbb4e6b6d9b2a7a0c2f5f33749903f3eb4ef	f745bbb4e6b6d9b2a7a0c2f5f33749903f3eb4ef	0	1329	t	96	TripleProfitsGames	TripleProfitsGames	{}	medium	\N	\N	531
Aces and Faces	basic	https://gis-static.com/games/Platipus/40f294b86a8d4293b7a712cd818051ad.png	f	f	40f294b86a8d4293b7a712cd818051ad	40f294b86a8d4293b7a712cd818051ad	0	1079	t	96	Platipus	Platipus	{}	low	\N	\N	532
Quantum X	basic	https://gis-static.com/games/OnlyPlay/6b53d0ffca713bf5389af574d2fb2c5c172aeaae.png	t	t	6b53d0ffca713bf5389af574d2fb2c5c172aeaae	6b53d0ffca713bf5389af574d2fb2c5c172aeaae	0	2698	t	96	OnlyPlay	OnlyPlay	{}	medium-high	\N	\N	533
Keno Goal	basic	https://gis-static.com/games/Caleta/7c16968cf079437abbeaefef7911f8be.png	t	t	7c16968cf079437abbeaefef7911f8be	7c16968cf079437abbeaefef7911f8be	0	2579	t	96	Caleta	Caleta	{}	medium-high	\N	\N	534
Football Lotto	basic	https://gis-static.com/games/Caleta/32d46bd830e04b26be7234aa3166a8c9.png	t	t	32d46bd830e04b26be7234aa3166a8c9	32d46bd830e04b26be7234aa3166a8c9	0	1579	t	96	Caleta	Caleta	{}	high	\N	\N	535
Naughty Witches	basic	https://gis-static.com/games/KAGaming/63993035ead74e2abdae3d8e7203b275.png	t	t	63993035ead74e2abdae3d8e7203b275	63993035ead74e2abdae3d8e7203b275	0	779	t	96	KAGaming	KAGaming	{}	high	\N	\N	537
El Dorado	basic	https://gis-static.com/games/VibraGaming/e2531ca2966f97c1e0a8e2c34f79090a3464871d.png	t	t	e2531ca2966f97c1e0a8e2c34f79090a3464871d	e2531ca2966f97c1e0a8e2c34f79090a3464871d	0	10081	t	96	VibraGaming	VibraGaming	{}	very-high	\N	\N	538
Elite of Evil: The First Quest	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/0d0ec1f6a51b4cbba8d7890dd95428c9.png	t	t	0d0ec1f6a51b4cbba8d7890dd95428c9	0d0ec1f6a51b4cbba8d7890dd95428c9	0	2230	t	96	G.Games	G.Games	{}	high	\N	\N	539
The Link Scratch	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/ad4a4f5298a94016b7ab87f676684721.png	t	t	ad4a4f5298a94016b7ab87f676684721	ad4a4f5298a94016b7ab87f676684721	0	1330	t	96	G.Games	G.Games	{}	medium	\N	\N	540
Tennis Scratch	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/bc4c8671f8014521998d054f3e9784d2.png	f	f	bc4c8671f8014521998d054f3e9784d2	bc4c8671f8014521998d054f3e9784d2	0	1080	t	96	G.Games	G.Games	{}	low	\N	\N	541
Super Shamrock	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/a8e71aa005fb49f4ad44ac02a7d1f344.png	t	t	a8e71aa005fb49f4ad44ac02a7d1f344	a8e71aa005fb49f4ad44ac02a7d1f344	0	2580	t	96	G.Games	G.Games	{}	medium-high	\N	\N	542
Stuffed with £100s	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/4ab9ffdb1ffe47ce9a6300255785efa2.png	t	t	4ab9ffdb1ffe47ce9a6300255785efa2	4ab9ffdb1ffe47ce9a6300255785efa2	0	1580	t	96	G.Games	G.Games	{}	high	\N	\N	543
Spinlotto Scratch	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/2d991f6599dc4a23a95815e23d4eebaa.png	t	t	2d991f6599dc4a23a95815e23d4eebaa	2d991f6599dc4a23a95815e23d4eebaa	0	780	t	96	G.Games	G.Games	{}	low	\N	\N	544
Raid the Piggy Bank	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/5482fda9388f418d81d72f6069b9ff52.png	t	t	5482fda9388f418d81d72f6069b9ff52	5482fda9388f418d81d72f6069b9ff52	0	780	t	96	G.Games	G.Games	{}	high	\N	\N	545
Magic Scratch	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/89eabcb1d4a94272b7477d9becd947cc.png	t	t	89eabcb1d4a94272b7477d9becd947cc	89eabcb1d4a94272b7477d9becd947cc	0	10082	t	96	G.Games	G.Games	{}	very-high	\N	\N	546
Lucky Day: Summer Spike	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/6a82675752c64b7c85b1607c44ff8456.png	t	t	6a82675752c64b7c85b1607c44ff8456	6a82675752c64b7c85b1607c44ff8456	0	2231	t	96	G.Games	G.Games	{}	high	\N	\N	547
Lucky Day: Mega Hallowin	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/6d227191093d4de1b0830995b269b769.png	t	t	6d227191093d4de1b0830995b269b769	6d227191093d4de1b0830995b269b769	0	1331	t	96	G.Games	G.Games	{}	medium	\N	\N	548
Lucky Day: Football Gold	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/54ff5522f00e4fd7a44deb82de13c1f4.png	f	f	54ff5522f00e4fd7a44deb82de13c1f4	54ff5522f00e4fd7a44deb82de13c1f4	0	1081	t	96	G.Games	G.Games	{}	low	\N	\N	549
European Roulette	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/77a8a1a2042d42c689f586222b5a9757.png	t	t	77a8a1a2042d42c689f586222b5a9757	77a8a1a2042d42c689f586222b5a9757	0	1587	t	96	G.Games	G.Games	{}	high	\N	\N	578
Lucky Day: Christmas Cashcade	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/4500901c1e3546deb6130a486f71e2c8.png	t	t	4500901c1e3546deb6130a486f71e2c8	4500901c1e3546deb6130a486f71e2c8	0	2581	t	96	G.Games	G.Games	{}	medium-high	\N	\N	550
Kitty Puzzle	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/9670943e9b2b4f1080e3d3110e819c7c.png	t	t	9670943e9b2b4f1080e3d3110e819c7c	9670943e9b2b4f1080e3d3110e819c7c	0	1581	t	96	G.Games	G.Games	{}	high	\N	\N	551
Horseshoe	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/b6aecb35ad4645bf9c1c52958d248d70.png	t	t	b6aecb35ad4645bf9c1c52958d248d70	b6aecb35ad4645bf9c1c52958d248d70	0	781	t	96	G.Games	G.Games	{}	low	\N	\N	552
Fruity Flurry	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/1271c5d84ae14946ac654e0e6e0fd033.png	t	t	1271c5d84ae14946ac654e0e6e0fd033	1271c5d84ae14946ac654e0e6e0fd033	0	781	t	96	G.Games	G.Games	{}	high	\N	\N	553
Fortune Scratch	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/bdc27ce16303454c82031d0237bc21b9.png	t	t	bdc27ce16303454c82031d0237bc21b9	bdc27ce16303454c82031d0237bc21b9	0	10083	t	96	G.Games	G.Games	{}	very-high	\N	\N	554
Football	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/9c8ef3e8ee1347469cfc17d05a8e0150.png	t	t	9c8ef3e8ee1347469cfc17d05a8e0150	9c8ef3e8ee1347469cfc17d05a8e0150	0	2232	t	96	G.Games	G.Games	{}	high	\N	\N	555
Elephant	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/ed73c2354bf740179f7c0f30ad239b08.png	t	t	ed73c2354bf740179f7c0f30ad239b08	ed73c2354bf740179f7c0f30ad239b08	0	1332	t	96	G.Games	G.Games	{}	medium	\N	\N	556
Diamonds Scratch	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/ef545baad5d547f4ae5d72940b44494a.png	f	f	ef545baad5d547f4ae5d72940b44494a	ef545baad5d547f4ae5d72940b44494a	0	1082	t	96	G.Games	G.Games	{}	low	\N	\N	557
Casino Scratch	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/e5b384c470dd4637ad0d64abf5a3282e.png	t	t	e5b384c470dd4637ad0d64abf5a3282e	e5b384c470dd4637ad0d64abf5a3282e	0	1333	t	96	G.Games	G.Games	{}	medium	\N	\N	558
777	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/1224788bc9c64fa99f9815f6e8c673c2.png	t	t	1224788bc9c64fa99f9815f6e8c673c2	1224788bc9c64fa99f9815f6e8c673c2	0	1334	t	96	G.Games	G.Games	{}	medium	\N	\N	559
7 11 21	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/46211c51c26c45e29b36d708364db28f.png	f	f	46211c51c26c45e29b36d708364db28f	46211c51c26c45e29b36d708364db28f	0	1084	t	96	G.Games	G.Games	{}	low	\N	\N	560
7UP!	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/67cd50ff84d14a8691e2ee6543a7f7e0.png	t	t	67cd50ff84d14a8691e2ee6543a7f7e0	67cd50ff84d14a8691e2ee6543a7f7e0	0	2584	t	96	G.Games	G.Games	{}	medium-high	\N	\N	561
Boss The Lotto	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/858ffe9028d7499c9b997d35962341eb.png	t	t	858ffe9028d7499c9b997d35962341eb	858ffe9028d7499c9b997d35962341eb	0	1584	t	96	G.Games	G.Games	{}	high	\N	\N	562
Casino Solitaire	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/7018dda747b94303b02c088c3c12aeee.png	t	t	7018dda747b94303b02c088c3c12aeee	7018dda747b94303b02c088c3c12aeee	0	784	t	96	G.Games	G.Games	{}	low	\N	\N	563
Casino Solitaire DE	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/bc4cf6b1986c4a4aa58cf770b1234ce4.png	t	t	bc4cf6b1986c4a4aa58cf770b1234ce4	bc4cf6b1986c4a4aa58cf770b1234ce4	0	785	t	96	G.Games	G.Games	{}	high	\N	\N	564
Christmas Deal	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/fcb6553a6c89479fb42756e851b66fcd.png	t	t	fcb6553a6c89479fb42756e851b66fcd	fcb6553a6c89479fb42756e851b66fcd	0	10087	t	96	G.Games	G.Games	{}	very-high	\N	\N	565
Coin Conqueror	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/0732982e55034198a70ad9dca15ad19c.png	t	t	0732982e55034198a70ad9dca15ad19c	0732982e55034198a70ad9dca15ad19c	0	2236	t	96	G.Games	G.Games	{}	high	\N	\N	566
Diamond Deal	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/292fcb0a499a4ec5bd664cfe6ecfcfd0.png	t	t	292fcb0a499a4ec5bd664cfe6ecfcfd0	292fcb0a499a4ec5bd664cfe6ecfcfd0	0	1336	t	96	G.Games	G.Games	{}	medium	\N	\N	567
Epic Gems	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/d9f4bafbafc041fc805401f67fa8c9d6.png	f	f	d9f4bafbafc041fc805401f67fa8c9d6	d9f4bafbafc041fc805401f67fa8c9d6	0	1086	t	96	G.Games	G.Games	{}	low	\N	\N	568
Fruit Punch Up	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/0d30744168534ea6b08adcfe2f464c99.png	t	t	0d30744168534ea6b08adcfe2f464c99	0d30744168534ea6b08adcfe2f464c99	0	2586	t	96	G.Games	G.Games	{}	medium-high	\N	\N	569
Jingle Up	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/17d8fa8dc32d4b51a5806416245f49e0.png	t	t	17d8fa8dc32d4b51a5806416245f49e0	17d8fa8dc32d4b51a5806416245f49e0	0	1586	t	96	G.Games	G.Games	{}	high	\N	\N	570
Nerves of Steal	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/a8d3c157a28e466f89fa32714be0b491.png	t	t	a8d3c157a28e466f89fa32714be0b491	a8d3c157a28e466f89fa32714be0b491	0	786	t	96	G.Games	G.Games	{}	low	\N	\N	571
Red Card	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/eaaa4b8d91314e6585aa7d43de84ca3d.png	t	t	eaaa4b8d91314e6585aa7d43de84ca3d	eaaa4b8d91314e6585aa7d43de84ca3d	0	786	t	96	G.Games	G.Games	{}	high	\N	\N	572
Retro Solitaire	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/1b096f92c2e9486ba104ee4963136d8b.png	t	t	1b096f92c2e9486ba104ee4963136d8b	1b096f92c2e9486ba104ee4963136d8b	0	10088	t	96	G.Games	G.Games	{}	very-high	\N	\N	573
Space Force	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/1403afd68ebd4a89b1c4cd0a6222d896.png	t	t	1403afd68ebd4a89b1c4cd0a6222d896	1403afd68ebd4a89b1c4cd0a6222d896	0	2237	t	96	G.Games	G.Games	{}	high	\N	\N	574
10p Roulette	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/d8d2cc259a1c4aadadff5bde9793afe4.png	t	t	d8d2cc259a1c4aadadff5bde9793afe4	d8d2cc259a1c4aadadff5bde9793afe4	0	1337	t	96	G.Games	G.Games	{}	medium	\N	\N	575
American Roulette	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/69a6d7c727894425a1f257cc2f0a54d5.png	f	f	69a6d7c727894425a1f257cc2f0a54d5	69a6d7c727894425a1f257cc2f0a54d5	0	1087	t	96	G.Games	G.Games	{}	low	\N	\N	576
Blackjack	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/7d1a8c97d6374dad93661d8b398a89d5.png	t	t	7d1a8c97d6374dad93661d8b398a89d5	7d1a8c97d6374dad93661d8b398a89d5	0	2587	t	96	G.Games	G.Games	{}	medium-high	\N	\N	577
European Roulette - Dark Mode	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/ec0f8733c7cb42e9aac9c364e6db7d73.png	t	t	ec0f8733c7cb42e9aac9c364e6db7d73	ec0f8733c7cb42e9aac9c364e6db7d73	0	787	t	96	G.Games	G.Games	{}	low	\N	\N	579
Turbo Roulette	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/6d3246c242624ff395f86bd923eeb093.png	t	t	6d3246c242624ff395f86bd923eeb093	6d3246c242624ff395f86bd923eeb093	0	787	t	96	G.Games	G.Games	{}	high	\N	\N	580
Calavera Bingo	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/1dd9c795c6ce4851bf9e9ea481c09066.png	t	t	1dd9c795c6ce4851bf9e9ea481c09066	1dd9c795c6ce4851bf9e9ea481c09066	0	784	t	96	G.Games	G.Games	{}	high	\N	\N	581
Instant Bingo	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/f74f8c674db24d9aab9961e46b70051b.png	t	t	f74f8c674db24d9aab9961e46b70051b	f74f8c674db24d9aab9961e46b70051b	0	10086	t	96	G.Games	G.Games	{}	very-high	\N	\N	582
Tomatina Bingo	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/07bbc7391c6a41198215d2529dda5dbe.png	t	t	07bbc7391c6a41198215d2529dda5dbe	07bbc7391c6a41198215d2529dda5dbe	0	2235	t	96	G.Games	G.Games	{}	high	\N	\N	583
Bingo 90	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/4de71314e23449b386094bee4cd4cd44.png	t	t	4de71314e23449b386094bee4cd4cd44	4de71314e23449b386094bee4cd4cd44	0	1335	t	96	G.Games	G.Games	{}	medium	\N	\N	584
Bingo 75	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/017548c5606e420e94c62a1d5619eb9e.png	f	f	017548c5606e420e94c62a1d5619eb9e	017548c5606e420e94c62a1d5619eb9e	0	1085	t	96	G.Games	G.Games	{}	low	\N	\N	585
Platinum Roulette	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/a1719691d842425799b1b15479674d60.png	t	t	a1719691d842425799b1b15479674d60	a1719691d842425799b1b15479674d60	0	2585	t	96	G.Games	G.Games	{}	medium-high	\N	\N	586
World Cup Roulette Platinum	basic	https://gis-static.com/games/3cd7afea7f51b3ba4b97e05c9bb32bf9/G.Games/20fc00b7e79a44f490ad9f22fa2da261.png	t	t	20fc00b7e79a44f490ad9f22fa2da261	20fc00b7e79a44f490ad9f22fa2da261	0	2238	t	96	G.Games	G.Games	{}	high	\N	\N	587
Tap Heroes	basic	https://gis-static.com/games/KAGaming/a1215df090264f41b37b0278090e945c.jpg	f	f	a1215df090264f41b37b0278090e945c	a1215df090264f41b37b0278090e945c	0	1124	t	96	KAGaming	KAGaming	{}	low	\N	\N	862
The Candy Keno	basic	https://gis-static.com/games/Mascot/52352d00161c1f78e109b2d07020c691fd1609b9.png	t	t	52352d00161c1f78e109b2d07020c691fd1609b9	52352d00161c1f78e109b2d07020c691fd1609b9	0	1338	t	96	Mascot	Mascot	{}	medium	\N	\N	588
N1 Baccarat	basic	https://gis-static.com/games/HoGaming/f63334d0c008bee6fa7b4afb90e0945fb59a973c.png	f	f	f63334d0c008bee6fa7b4afb90e0945fb59a973c	f63334d0c008bee6fa7b4afb90e0945fb59a973c	0	1088	t	96	HoGaming	HoGaming	{}	low	\N	\N	589
N2 Speed Baccarat	basic	https://gis-static.com/games/HoGaming/8af15478e9adef9c4fc681e8c8117f31d7f44406.png	t	t	8af15478e9adef9c4fc681e8c8117f31d7f44406	8af15478e9adef9c4fc681e8c8117f31d7f44406	0	2588	t	96	HoGaming	HoGaming	{}	medium-high	\N	\N	590
N3 Speed Baccarat	basic	https://gis-static.com/games/HoGaming/fe8ae880134c71a7f0f65a7003220bdcf6bfb515.png	t	t	fe8ae880134c71a7f0f65a7003220bdcf6bfb515	fe8ae880134c71a7f0f65a7003220bdcf6bfb515	0	1588	t	96	HoGaming	HoGaming	{}	high	\N	\N	591
20 Dice Roosters	basic	https://gis-static.com/games/CTInteractive/144693f03d074799810699bd5ce7ac05.png	t	t	144693f03d074799810699bd5ce7ac05	144693f03d074799810699bd5ce7ac05	0	788	t	96	CTInteractive	CTInteractive	{}	low	\N	\N	592
40 Dice Treasures	basic	https://gis-static.com/games/CTInteractive/2ed0470e28a442a4897929b6a3655610.png	t	t	2ed0470e28a442a4897929b6a3655610	2ed0470e28a442a4897929b6a3655610	0	788	t	96	CTInteractive	CTInteractive	{}	high	\N	\N	593
50 Dice Treasures	basic	https://gis-static.com/games/CTInteractive/6c759a0fede642ea944fe215d2078699.png	t	t	6c759a0fede642ea944fe215d2078699	6c759a0fede642ea944fe215d2078699	0	10090	t	96	CTInteractive	CTInteractive	{}	very-high	\N	\N	594
Banana Dice Party	basic	https://gis-static.com/games/CTInteractive/e8846bdc08784e92877df05d1cf0b2d3.png	t	t	e8846bdc08784e92877df05d1cf0b2d3	e8846bdc08784e92877df05d1cf0b2d3	0	2239	t	96	CTInteractive	CTInteractive	{}	high	\N	\N	595
Big Joker Dice	basic	https://gis-static.com/games/CTInteractive/03d340d5749c4f0cbd76486a10c7dc1e.png	t	t	03d340d5749c4f0cbd76486a10c7dc1e	03d340d5749c4f0cbd76486a10c7dc1e	0	1339	t	96	CTInteractive	CTInteractive	{}	medium	\N	\N	596
More Dragons Dice	basic	https://gis-static.com/games/CTInteractive/765132e1d2864d5597211e014ef6320e.png	f	f	765132e1d2864d5597211e014ef6320e	765132e1d2864d5597211e014ef6320e	0	1089	t	96	CTInteractive	CTInteractive	{}	low	\N	\N	597
Satyr And Nymph Dice	basic	https://gis-static.com/games/CTInteractive/0867241577284f4bb36b12a51f428f06.png	t	t	0867241577284f4bb36b12a51f428f06	0867241577284f4bb36b12a51f428f06	0	2589	t	96	CTInteractive	CTInteractive	{}	medium-high	\N	\N	598
Bombay Roulette	basic	https://gis-static.com/games/OneTouch/74776b6e0efd8049490ae5c6314d806efe73202e.png	t	t	74776b6e0efd8049490ae5c6314d806efe73202e	74776b6e0efd8049490ae5c6314d806efe73202e	0	1589	t	96	OneTouch	OneTouch	{}	high	\N	\N	599
Candy Dreams: Bingo	basic	https://gis-static.com/games/Evoplay/a7d94d6b34794482a7638e3d3898d7c3.png	t	t	a7d94d6b34794482a7638e3d3898d7c3	a7d94d6b34794482a7638e3d3898d7c3	0	789	t	96	Evoplay	Evoplay	{}	low	\N	\N	600
Football Grid	basic	https://gis-static.com/games/Betgames/0127c39e234aa5c7335c6bc13ed41eacad3f0bfe.png	t	t	0127c39e234aa5c7335c6bc13ed41eacad3f0bfe	0127c39e234aa5c7335c6bc13ed41eacad3f0bfe	0	789	t	96	Betgames	Betgames	{}	high	\N	\N	601
Cleopatra's Gems Bingo	basic	https://gis-static.com/games/Mascot/3bfd6b7811306a955a1174fabd303a8e8ca0fc48.png	t	t	3bfd6b7811306a955a1174fabd303a8e8ca0fc48	3bfd6b7811306a955a1174fabd303a8e8ca0fc48	0	10091	t	96	Mascot	Mascot	{}	very-high	\N	\N	602
Need for X	basic	https://gis-static.com/games/OnlyPlay/9286dd40e249bd61dd3ac3ea358c6801fcfcc7f9.png	t	t	9286dd40e249bd61dd3ac3ea358c6801fcfcc7f9	9286dd40e249bd61dd3ac3ea358c6801fcfcc7f9	0	2240	t	96	OnlyPlay	OnlyPlay	{}	high	\N	\N	603
Warriors & Warlocks	basic	https://gis-static.com/games/Boldplay/763c650a6b68c2728b0fb5443e6511fdfd3d1263.png	t	t	763c650a6b68c2728b0fb5443e6511fdfd3d1263	763c650a6b68c2728b0fb5443e6511fdfd3d1263	0	1340	t	96	Boldplay	Boldplay	{}	medium	\N	\N	604
Hungry Shark Cthulhu	basic	https://gis-static.com/games/KAGaming/fa62800c964145f3ba41108bc26159eb.png	f	f	fa62800c964145f3ba41108bc26159eb	fa62800c964145f3ba41108bc26159eb	0	1090	t	96	KAGaming	KAGaming	{}	low	\N	\N	605
Mermaid Legend	basic	https://gis-static.com/games/KAGaming/f9e21c11faf64cd0b9fc2f2a641514fa.png	t	t	f9e21c11faf64cd0b9fc2f2a641514fa	f9e21c11faf64cd0b9fc2f2a641514fa	0	2242	t	96	KAGaming	KAGaming	{}	high	\N	\N	606
Bonus Deuces Wild	basic	https://gis-static.com/games/Platipus/5d076eb3f7e765f5fbd2cae36347244dd259bc2c.png	t	t	5d076eb3f7e765f5fbd2cae36347244dd259bc2c	5d076eb3f7e765f5fbd2cae36347244dd259bc2c	0	2592	t	96	Platipus	Platipus	{}	medium-high	\N	\N	609
Golden Fish Hunter	basic	https://gis-static.com/games/KAGaming/45cca38cbba54054af9b2ecc7c9debda.png	t	t	45cca38cbba54054af9b2ecc7c9debda	45cca38cbba54054af9b2ecc7c9debda	0	1592	t	96	KAGaming	KAGaming	{}	high	\N	\N	610
Cricket Crash	basic	https://gis-static.com/games/OnlyPlay/6a8608bae0301c7d2b7b16295dcf2318e713a17c.png	t	t	6a8608bae0301c7d2b7b16295dcf2318e713a17c	6a8608bae0301c7d2b7b16295dcf2318e713a17c	0	792	t	96	OnlyPlay	OnlyPlay	{}	low	\N	\N	611
HiLo	basic	https://gis-static.com/games/Turbogames/b2011c4fb6bb4d6bb8b202b705edfd2d328d25e1.png	t	t	b2011c4fb6bb4d6bb8b202b705edfd2d328d25e1	b2011c4fb6bb4d6bb8b202b705edfd2d328d25e1	0	792	t	96	Turbogames	Turbogames	{}	high	\N	\N	612
Surfing Beauties Video Bingo	basic	https://gis-static.com/games/Boldplay/743c8a5e00916ae6543231856d2fa27d97a5e2dd.png	t	t	743c8a5e00916ae6543231856d2fa27d97a5e2dd	743c8a5e00916ae6543231856d2fa27d97a5e2dd	0	10094	t	96	Boldplay	Boldplay	{}	very-high	\N	\N	613
Sic Bo	basic	https://gis-static.com/games/VibraGaming/e446ddaf95c45055b7f4cc8dd9177a0afda0ba1b.png	t	t	e446ddaf95c45055b7f4cc8dd9177a0afda0ba1b	e446ddaf95c45055b7f4cc8dd9177a0afda0ba1b	0	2243	t	96	VibraGaming	VibraGaming	{}	high	\N	\N	614
Treasure of the Gods	basic	https://gis-static.com/games/Evoplay/3318bfbb234a4647a66839ca05c013ea.png	t	t	3318bfbb234a4647a66839ca05c013ea	3318bfbb234a4647a66839ca05c013ea	0	1343	t	96	Evoplay	Evoplay	{}	medium	\N	\N	615
Craps	basic	https://gis-static.com/games/PlayngoAsia/9249c5b955c74b84b23e665798c9350f.png	f	f	9249c5b955c74b84b23e665798c9350f	9249c5b955c74b84b23e665798c9350f	0	1093	t	96	PlayngoAsia	PlayngoAsia	{}	low	\N	\N	616
2 Ways Royal	basic	https://gis-static.com/games/Platipus/c163ae780953304ea04adcbb5c50685a4f7c3cf7.png	t	t	c163ae780953304ea04adcbb5c50685a4f7c3cf7	c163ae780953304ea04adcbb5c50685a4f7c3cf7	0	2593	t	96	Platipus	Platipus	{}	medium-high	\N	\N	617
Coliseu Bingo	basic	https://gis-static.com/games/Caleta/d459a06e49a27ccfc3ec37da9f19bcccd3a12bcc.png	t	t	d459a06e49a27ccfc3ec37da9f19bcccd3a12bcc	d459a06e49a27ccfc3ec37da9f19bcccd3a12bcc	0	1593	t	96	Caleta	Caleta	{}	high	\N	\N	618
Spin Strike	basic	https://gis-static.com/games/Turbogames/e1ce5c0813df9d5090211559fba2e015c7d5d542.png	t	t	e1ce5c0813df9d5090211559fba2e015c7d5d542	e1ce5c0813df9d5090211559fba2e015c7d5d542	0	793	t	96	Turbogames	Turbogames	{}	low	\N	\N	619
World Of Lord Witch King	basic	https://gis-static.com/games/KAGaming/634f70af44ee42bcb9ab840f9f75c829.png	t	t	634f70af44ee42bcb9ab840f9f75c829	634f70af44ee42bcb9ab840f9f75c829	0	793	t	96	KAGaming	KAGaming	{}	high	\N	\N	620
Bear Run	basic	https://gis-static.com/games/KAGaming/5057b8fc27014845bb980c624ba3e1d2.png	t	t	5057b8fc27014845bb980c624ba3e1d2	5057b8fc27014845bb980c624ba3e1d2	0	10095	t	96	KAGaming	KAGaming	{}	very-high	\N	\N	621
Baccarat Deluxe	basic	https://gis-static.com/games/PGSoft/a7220c337fe44fe197a68a1bd63a0c44.png	t	t	a7220c337fe44fe197a68a1bd63a0c44	a7220c337fe44fe197a68a1bd63a0c44	0	2244	t	96	PGSoft	PGSoft	{}	high	\N	\N	622
Aviatrix	basic	https://gis-static.com/games/Aviatrix/9d9b5b34389337d4e43568b4ba2d56be97de447a.png	t	t	9d9b5b34389337d4e43568b4ba2d56be97de447a	9d9b5b34389337d4e43568b4ba2d56be97de447a	0	1344	t	96	Aviatrix	Aviatrix	{}	medium	\N	\N	623
American Roulette	basic	https://gis-static.com/games/Boldplay/0e582d93143017cfc22050b2c30e8188185d9b9d.png	f	f	0e582d93143017cfc22050b2c30e8188185d9b9d	0e582d93143017cfc22050b2c30e8188185d9b9d	0	1094	t	96	Boldplay	Boldplay	{}	low	\N	\N	624
Chocolate Planet	basic	https://gis-static.com/games/VibraGaming/f34d3c4d88b362ce8bbed3abbfe6657410a62352.png	t	t	f34d3c4d88b362ce8bbed3abbfe6657410a62352	f34d3c4d88b362ce8bbed3abbfe6657410a62352	0	2594	t	96	VibraGaming	VibraGaming	{}	medium-high	\N	\N	625
Wicket Blast	basic	https://gis-static.com/games/Turbogames/7fdd8af9b64890abee7debbd851a514e94282963.png	t	t	7fdd8af9b64890abee7debbd851a514e94282963	7fdd8af9b64890abee7debbd851a514e94282963	0	1594	t	96	Turbogames	Turbogames	{}	high	\N	\N	626
Long Ball	basic	https://gis-static.com/games/Evoplay/4319261742314da887dc4184fe651325.png	t	t	4319261742314da887dc4184fe651325	4319261742314da887dc4184fe651325	0	10096	t	96	Evoplay	Evoplay	{}	very-high	\N	\N	629
No Fly Zone	basic	https://gis-static.com/games/KAGaming/a2684d45ac1746e58c2c6e5e46ca764e.png	t	t	a2684d45ac1746e58c2c6e5e46ca764e	a2684d45ac1746e58c2c6e5e46ca764e	0	2245	t	96	KAGaming	KAGaming	{}	high	\N	\N	630
Red Baron	basic	https://gis-static.com/games/KAGaming/e9d07ca5b5aa45a887ea7f7cea1d4873.png	t	t	e9d07ca5b5aa45a887ea7f7cea1d4873	e9d07ca5b5aa45a887ea7f7cea1d4873	0	1345	t	96	KAGaming	KAGaming	{}	medium	\N	\N	631
Aces And Eights	basic	https://gis-static.com/games/KAGaming/90156c1c002f4ec4a91e6cdade16ac22.png	f	f	90156c1c002f4ec4a91e6cdade16ac22	90156c1c002f4ec4a91e6cdade16ac22	0	1095	t	96	KAGaming	KAGaming	{}	low	\N	\N	632
Dama da Fortuna Bingo	basic	https://gis-static.com/games/Caleta/7c053cdf8d904d148341dd4a984a90e8.png	t	t	7c053cdf8d904d148341dd4a984a90e8	7c053cdf8d904d148341dd4a984a90e8	0	2595	t	96	Caleta	Caleta	{}	medium-high	\N	\N	633
Dice of Luxor	basic	https://gis-static.com/games/Mascot/2433b75bafb94bfba55665816442d626.png	t	t	2433b75bafb94bfba55665816442d626	2433b75bafb94bfba55665816442d626	0	795	t	96	Mascot	Mascot	{}	low	\N	\N	635
Impossible X	basic	https://gis-static.com/games/KAGaming/17d97717f87d49f8a990f576a457ceb9.png	f	f	17d97717f87d49f8a990f576a457ceb9	17d97717f87d49f8a990f576a457ceb9	0	1096	t	96	KAGaming	KAGaming	{}	low	\N	\N	641
Slap It	basic	https://gis-static.com/games/KAGaming/52888e0c25564c17b45c60e48cb93ceb.png	t	t	52888e0c25564c17b45c60e48cb93ceb	52888e0c25564c17b45c60e48cb93ceb	0	2596	t	96	KAGaming	KAGaming	{}	medium-high	\N	\N	642
Thunder Land	basic	https://gis-static.com/games/KAGaming/c218c063dd9f4cd2a453baed0fda2650.png	t	t	c218c063dd9f4cd2a453baed0fda2650	c218c063dd9f4cd2a453baed0fda2650	0	1596	t	96	KAGaming	KAGaming	{}	high	\N	\N	643
N1 Roulette	basic	https://gis-static.com/games/HoGaming/2fdfa0b91267f2e0be2f32a1d582d4b8df5070b2.png	t	t	2fdfa0b91267f2e0be2f32a1d582d4b8df5070b2	2fdfa0b91267f2e0be2f32a1d582d4b8df5070b2	0	796	t	96	HoGaming	HoGaming	{}	low	\N	\N	644
Soccer Solo Striker	basic	https://gis-static.com/games/Evoplay/33621fc553754763880a2d420701b083.png	t	t	33621fc553754763880a2d420701b083	33621fc553754763880a2d420701b083	0	796	t	96	Evoplay	Evoplay	{}	high	\N	\N	645
Leprechaun	basic	https://gis-static.com/games/f624ed082b9280306e3f8daaaf4bc5f1/EurasianGamingSlots/2100d65b84a3a211b052ae92bc5ca034a811ccce.png	t	t	2100d65b84a3a211b052ae92bc5ca034a811ccce	2100d65b84a3a211b052ae92bc5ca034a811ccce	0	10098	t	96	EurasianGamingSlots	EurasianGamingSlots	{}	very-high	\N	\N	646
Limbo XY	basic	https://gis-static.com/games/772c50b6e70a91f89f0266e2ebfb9992/BGaming/3faff623986242c4a54dd8ac68e013e2.png	t	t	3faff623986242c4a54dd8ac68e013e2	3faff623986242c4a54dd8ac68e013e2	0	2247	t	96	BGaming	BGaming	{}	high	\N	\N	647
Caipirinha Keno	basic	https://gis-static.com/games/Caleta/0022b534413c4c3c8ac112b9befc68b8.png	t	t	0022b534413c4c3c8ac112b9befc68b8	0022b534413c4c3c8ac112b9befc68b8	0	1347	t	96	Caleta	Caleta	{}	medium	\N	\N	648
Happy Animal Farm	basic	https://gis-static.com/games/KAGaming/0832256e214e4938a886d1dcce3bfec0.png	f	f	0832256e214e4938a886d1dcce3bfec0	0832256e214e4938a886d1dcce3bfec0	0	1097	t	96	KAGaming	KAGaming	{}	low	\N	\N	649
Hypersonic X	basic	https://gis-static.com/games/KAGaming/b038aa6aab7640d684b64a8f3593802a.png	t	t	b038aa6aab7640d684b64a8f3593802a	b038aa6aab7640d684b64a8f3593802a	0	2597	t	96	KAGaming	KAGaming	{}	medium-high	\N	\N	650
Mary's Mining Mania	basic	https://gis-static.com/games/Evoplay/9e656acdcae042d7a210af93155e2e0e.png	t	t	9e656acdcae042d7a210af93155e2e0e	9e656acdcae042d7a210af93155e2e0e	0	797	t	96	Evoplay	Evoplay	{}	low	\N	\N	652
Underwater	basic	https://gis-static.com/games/VibraGaming/5a02c0b9f36450704fad62164c6c2dcc04ef1554.png	t	t	5a02c0b9f36450704fad62164c6c2dcc04ef1554	5a02c0b9f36450704fad62164c6c2dcc04ef1554	0	797	t	96	VibraGaming	VibraGaming	{}	high	\N	\N	653
Hook Up! Fishing Wars	basic	https://gis-static.com/games/Mascot/460f7ee57f4eb016fdea6a77737d26925e6aa9f0.png	t	t	460f7ee57f4eb016fdea6a77737d26925e6aa9f0	460f7ee57f4eb016fdea6a77737d26925e6aa9f0	0	10099	t	96	Mascot	Mascot	{}	very-high	\N	\N	654
Blackjack BB	basic	https://gis-static.com/games/BarbaraBang/f6c540d171c145088c6da4e6ef1ea6d3.png	t	t	f6c540d171c145088c6da4e6ef1ea6d3	f6c540d171c145088c6da4e6ef1ea6d3	0	2248	t	96	BarbaraBang	BarbaraBang	{}	high	\N	\N	655
Texas Hold'em	basic	https://gis-static.com/games/Platipus/6202d4b2e44117c0695b7bc82a2fa7fdfb58cb91.png	t	t	6202d4b2e44117c0695b7bc82a2fa7fdfb58cb91	6202d4b2e44117c0695b7bc82a2fa7fdfb58cb91	0	1598	t	96	Platipus	Platipus	{}	high	\N	\N	659
Take My Plinko	basic	https://gis-static.com/games/Turbogames/6c2a42ea006388718232896f6ad1fa4084ce9a88.png	t	t	6c2a42ea006388718232896f6ad1fa4084ce9a88	6c2a42ea006388718232896f6ad1fa4084ce9a88	0	798	t	96	Turbogames	Turbogames	{}	low	\N	\N	660
Crazy Hunt X	basic	https://gis-static.com/games/SmartSoft/81e452bc420b4abe97ee46e0857d6003.png	t	t	81e452bc420b4abe97ee46e0857d6003	81e452bc420b4abe97ee46e0857d6003	0	798	t	96	SmartSoft	SmartSoft	{}	high	\N	\N	661
Pìggy Show Bingo	basic	https://gis-static.com/games/Caleta/cd62f8506864443488fa17e091a4e10a.png	t	t	cd62f8506864443488fa17e091a4e10a	cd62f8506864443488fa17e091a4e10a	0	10100	t	96	Caleta	Caleta	{}	very-high	\N	\N	662
Fast Fielder	basic	https://gis-static.com/games/Turbogames/bec51570fd1f1c4e632c3ee833bc412453e49447.png	t	t	bec51570fd1f1c4e632c3ee833bc412453e49447	bec51570fd1f1c4e632c3ee833bc412453e49447	0	2249	t	96	Turbogames	Turbogames	{}	high	\N	\N	663
Diamond's Fortune	basic	https://gis-static.com/games/ZeusPlay/f479da383d2e450b81306079c089f835.png	t	t	f479da383d2e450b81306079c089f835	f479da383d2e450b81306079c089f835	0	1349	t	96	ZeusPlay	ZeusPlay	{}	medium	\N	\N	664
Instant Lucky 7	basic	https://gis-static.com/games/Betgames/b4c33f2efe8bd46c27ec71ee25158329018f2b60.png	f	f	b4c33f2efe8bd46c27ec71ee25158329018f2b60	b4c33f2efe8bd46c27ec71ee25158329018f2b60	0	1099	t	96	Betgames	Betgames	{}	low	\N	\N	665
Penalty Shoot-Out Street	basic	https://gis-static.com/games/Evoplay/cd39d62b6f12418f8bcf00a41b6d6e39.png	t	t	cd39d62b6f12418f8bcf00a41b6d6e39	cd39d62b6f12418f8bcf00a41b6d6e39	0	2599	t	96	Evoplay	Evoplay	{}	medium-high	\N	\N	666
Wizard Of Wild	basic	https://gis-static.com/games/KAGaming/eadf999b2e2b4bfb9d4485f769750ee1.png	t	t	eadf999b2e2b4bfb9d4485f769750ee1	eadf999b2e2b4bfb9d4485f769750ee1	0	1599	t	96	KAGaming	KAGaming	{}	high	\N	\N	667
Infinity X	basic	https://gis-static.com/games/KAGaming/0bcfad1a1912497d85445f54b5c65aab.png	t	t	0bcfad1a1912497d85445f54b5c65aab	0bcfad1a1912497d85445f54b5c65aab	0	799	t	96	KAGaming	KAGaming	{}	low	\N	\N	668
Plinko Cash	basic	https://gis-static.com/games/PangaGames/5ec9209fa3a96beac261687be594eecd2e46f99c.png	t	t	5ec9209fa3a96beac261687be594eecd2e46f99c	5ec9209fa3a96beac261687be594eecd2e46f99c	0	799	t	96	PangaGames	PangaGames	{}	high	\N	\N	669
Bingo Pescaria	basic	https://gis-static.com/games/Caleta/90106b6bf7177a619fcef7ae22d81094f30df6cb.png	t	t	90106b6bf7177a619fcef7ae22d81094f30df6cb	90106b6bf7177a619fcef7ae22d81094f30df6cb	0	10101	t	96	Caleta	Caleta	{}	very-high	\N	\N	670
Bingo Power	basic	https://gis-static.com/games/fdc4364a3eae2f06260e2f95ce9571ed/Belatra Games/a9c04237f35ddc51db40893e6a7ccd8e18de730d.png	t	t	a9c04237f35ddc51db40893e6a7ccd8e18de730d	a9c04237f35ddc51db40893e6a7ccd8e18de730d	0	2250	t	96	Belatra Games	Belatra Games	{}	high	\N	\N	671
Carnival	basic	https://gis-static.com/games/VibraGaming/8488f717725de03ac0c595ed8acd7506e0be7fe6.png	t	t	8488f717725de03ac0c595ed8acd7506e0be7fe6	8488f717725de03ac0c595ed8acd7506e0be7fe6	0	1350	t	96	VibraGaming	VibraGaming	{}	medium	\N	\N	672
5 Handed American Blackjack	basic	https://gis-static.com/games/ConceptGaming/e035199a344b4fbf832680ecffe55c01.png	f	f	e035199a344b4fbf832680ecffe55c01	e035199a344b4fbf832680ecffe55c01	0	1100	t	96	ConceptGaming	ConceptGaming	{}	low	\N	\N	673
7 Handed Blackjack (American)	basic	https://gis-static.com/games/ConceptGaming/7b4fad6dc8624f0885c41255e4499c18.png	t	t	7b4fad6dc8624f0885c41255e4499c18	7b4fad6dc8624f0885c41255e4499c18	0	2600	t	96	ConceptGaming	ConceptGaming	{}	medium-high	\N	\N	674
7 Handed Blackjack (European)	basic	https://gis-static.com/games/ConceptGaming/beb15076a0e34ed7ba90e35244536039.png	f	f	beb15076a0e34ed7ba90e35244536039	beb15076a0e34ed7ba90e35244536039	0	1101	t	96	ConceptGaming	ConceptGaming	{}	low	\N	\N	675
Deuces Wild Gamble	basic	https://gis-static.com/games/ConceptGaming/7d317d105d594ef1851fe6a98ab64e5a.png	t	t	7d317d105d594ef1851fe6a98ab64e5a	7d317d105d594ef1851fe6a98ab64e5a	0	2601	t	96	ConceptGaming	ConceptGaming	{}	medium-high	\N	\N	676
Roulette II	basic	https://gis-static.com/games/ConceptGaming/1f6501d74eec4f419fe5613041114972.png	t	t	1f6501d74eec4f419fe5613041114972	1f6501d74eec4f419fe5613041114972	0	1601	t	96	ConceptGaming	ConceptGaming	{}	high	\N	\N	677
Texas Holdem	basic	https://gis-static.com/games/ConceptGaming/ca1feabceee948e7b7070f51539bb375.png	t	t	ca1feabceee948e7b7070f51539bb375	ca1feabceee948e7b7070f51539bb375	0	801	t	96	ConceptGaming	ConceptGaming	{}	low	\N	\N	678
Ultimate Baccarat	basic	https://gis-static.com/games/ConceptGaming/7922dbd4be8a45a4a82815c186a3f9b2.png	f	f	7922dbd4be8a45a4a82815c186a3f9b2	7922dbd4be8a45a4a82815c186a3f9b2	0	1102	t	96	ConceptGaming	ConceptGaming	{}	low	\N	\N	679
Ultra One Hand Blackjack	basic	https://gis-static.com/games/ConceptGaming/381f3811a9204903a6d43ccc47133339.png	t	t	381f3811a9204903a6d43ccc47133339	381f3811a9204903a6d43ccc47133339	0	2602	t	96	ConceptGaming	ConceptGaming	{}	medium-high	\N	\N	680
Vegas Roulette	basic	https://gis-static.com/games/ConceptGaming/4181777a4e6445cc888868b873cfc4ee.png	t	t	4181777a4e6445cc888868b873cfc4ee	4181777a4e6445cc888868b873cfc4ee	0	1602	t	96	ConceptGaming	ConceptGaming	{}	high	\N	\N	681
E-Keno	basic	https://gis-static.com/games/ExcellentReel/1b3c12cb0bce1c5d61a7e1ae86454371f02340e7.png	t	t	1b3c12cb0bce1c5d61a7e1ae86454371f02340e7	1b3c12cb0bce1c5d61a7e1ae86454371f02340e7	0	802	t	96	ExcellentReel	ExcellentReel	{}	low	\N	\N	682
Greek Keno	basic	https://gis-static.com/games/ExcellentReel/f753acfb1338675908885a9d6893069d072f1b26.png	t	t	f753acfb1338675908885a9d6893069d072f1b26	f753acfb1338675908885a9d6893069d072f1b26	0	802	t	96	ExcellentReel	ExcellentReel	{}	high	\N	\N	683
Lucky 6	basic	https://gis-static.com/games/ExcellentReel/a9b5c9d280c00ff831afd105e735d01af7257e25.png	t	t	a9b5c9d280c00ff831afd105e735d01af7257e25	a9b5c9d280c00ff831afd105e735d01af7257e25	0	10104	t	96	ExcellentReel	ExcellentReel	{}	very-high	\N	\N	684
Cakeshop Cascade	basic	https://gis-static.com/games/Boldplay/4176444be8d089c9b43c33fae447396fe4eb39e7.png	t	t	4176444be8d089c9b43c33fae447396fe4eb39e7	4176444be8d089c9b43c33fae447396fe4eb39e7	0	2253	t	96	Boldplay	Boldplay	{}	high	\N	\N	685
Doodle Crash	basic	https://gis-static.com/games/BarbaraBang/871456fa0d7549fbbc514f029a99cdff.png	t	t	871456fa0d7549fbbc514f029a99cdff	871456fa0d7549fbbc514f029a99cdff	0	1353	t	96	BarbaraBang	BarbaraBang	{}	medium	\N	\N	686
Penalty Roulette	basic	https://gis-static.com/games/Evoplay/f431ccbdbbcd43749460d560436ecffa.png	f	f	f431ccbdbbcd43749460d560436ecffa	f431ccbdbbcd43749460d560436ecffa	0	1103	t	96	Evoplay	Evoplay	{}	low	\N	\N	687
Golden Time Roulette	basic	https://gis-static.com/games/Espressogames/68790c3667714fa1932f2e21fead7a96.png	t	t	68790c3667714fa1932f2e21fead7a96	68790c3667714fa1932f2e21fead7a96	0	2603	t	96	Espressogames	Espressogames	{}	medium-high	\N	\N	688
Calorie Killer	basic	https://gis-static.com/games/KAGaming/06ec85218b554f53a5f838aa10f1023b.png	t	t	06ec85218b554f53a5f838aa10f1023b	06ec85218b554f53a5f838aa10f1023b	0	1603	t	96	KAGaming	KAGaming	{}	high	\N	\N	689
Endorser Of Thor	basic	https://gis-static.com/games/KAGaming/10dd71a39e844d15af6523252c5b4f95.png	t	t	10dd71a39e844d15af6523252c5b4f95	10dd71a39e844d15af6523252c5b4f95	0	803	t	96	KAGaming	KAGaming	{}	low	\N	\N	690
Poseidon Battle	basic	https://gis-static.com/games/KAGaming/0b1e4d2c7a324d8786987591245a51c2.png	t	t	0b1e4d2c7a324d8786987591245a51c2	0b1e4d2c7a324d8786987591245a51c2	0	803	t	96	KAGaming	KAGaming	{}	high	\N	\N	691
Home Run X	basic	https://gis-static.com/games/KAGaming/9fa155ae250544f98697004d6983367f.png	t	t	9fa155ae250544f98697004d6983367f	9fa155ae250544f98697004d6983367f	0	10105	t	96	KAGaming	KAGaming	{}	very-high	\N	\N	692
Plinko S	basic	https://gis-static.com/games/KAGaming/dc7e693323fc4ed99e3c0b2ab5f6bf0e.png	t	t	dc7e693323fc4ed99e3c0b2ab5f6bf0e	dc7e693323fc4ed99e3c0b2ab5f6bf0e	0	2254	t	96	KAGaming	KAGaming	{}	high	\N	\N	693
Bubbles	basic	https://gis-static.com/games/Turbogames/0f9ba6277de545427dd64656115148eac595ab28.png	t	t	0f9ba6277de545427dd64656115148eac595ab28	0f9ba6277de545427dd64656115148eac595ab28	0	1354	t	96	Turbogames	Turbogames	{}	medium	\N	\N	694
Tower X	basic	https://gis-static.com/games/SmartSoft/0e746d99157948eba4240ef4dc0ea1ee.png	f	f	0e746d99157948eba4240ef4dc0ea1ee	0e746d99157948eba4240ef4dc0ea1ee	0	1104	t	96	SmartSoft	SmartSoft	{}	low	\N	\N	695
Slicer X	basic	https://gis-static.com/games/SmartSoft/30d7238b3ce64a01ae36bf4612364974.png	t	t	30d7238b3ce64a01ae36bf4612364974	30d7238b3ce64a01ae36bf4612364974	0	2604	t	96	SmartSoft	SmartSoft	{}	medium-high	\N	\N	696
Joker’s 4 Bonuses	basic	https://gis-static.com/games/SmartSoft/4f64db83cb45413c939d20d0650d801c.png	t	t	4f64db83cb45413c939d20d0650d801c	4f64db83cb45413c939d20d0650d801c	0	1604	t	96	SmartSoft	SmartSoft	{}	high	\N	\N	697
Tesoro Maya	basic	https://gis-static.com/games/Caleta/f12d5b1d4efe4896b3988dc58046cc0a.png	t	t	f12d5b1d4efe4896b3988dc58046cc0a	f12d5b1d4efe4896b3988dc58046cc0a	0	804	t	96	Caleta	Caleta	{}	low	\N	\N	698
Kick Pumpkin	basic	https://gis-static.com/games/KAGaming/c00030827c67494b8711f3e37f71e770.jpg	t	t	c00030827c67494b8711f3e37f71e770	c00030827c67494b8711f3e37f71e770	0	804	t	96	KAGaming	KAGaming	{}	high	\N	\N	699
Ace Race	basic	https://gis-static.com/games/JadeRabbitStudio/6938288648298257a06934ead3ad2b2f6874c178.png	t	t	6938288648298257a06934ead3ad2b2f6874c178	6938288648298257a06934ead3ad2b2f6874c178	0	10106	t	96	JadeRabbitStudio	JadeRabbitStudio	{}	very-high	\N	\N	700
Aero	basic	https://gis-static.com/games/Turbogames/a0613ce4d9c2aee3db4f8321741e187cb35f599c.png	t	t	a0613ce4d9c2aee3db4f8321741e187cb35f599c	a0613ce4d9c2aee3db4f8321741e187cb35f599c	0	801	t	96	Turbogames	Turbogames	{}	high	\N	\N	701
Blackjack	basic	https://gis-static.com/games/RivalGames/20662a8f21c24b83a284cfdd845eb40c.png	t	t	20662a8f21c24b83a284cfdd845eb40c	20662a8f21c24b83a284cfdd845eb40c	0	10103	t	96	RivalGames	RivalGames	{}	very-high	\N	\N	702
Card Clash	basic	https://gis-static.com/games/RivalGames/b42c18f3768247b29fcee472fa0df426.png	t	t	b42c18f3768247b29fcee472fa0df426	b42c18f3768247b29fcee472fa0df426	0	2252	t	96	RivalGames	RivalGames	{}	high	\N	\N	703
Baccarat	basic	https://gis-static.com/games/RivalGames/ac966715a50e43e3bcb4515e679a823c.png	t	t	ac966715a50e43e3bcb4515e679a823c	ac966715a50e43e3bcb4515e679a823c	0	2255	t	96	RivalGames	RivalGames	{}	high	\N	\N	704
Ride 'em Poker	basic	https://gis-static.com/games/RivalGames/bf1c69693c634bb7997e85387d324584.png	t	t	bf1c69693c634bb7997e85387d324584	bf1c69693c634bb7997e85387d324584	0	1355	t	96	RivalGames	RivalGames	{}	medium	\N	\N	705
Jacks or Better	basic	https://gis-static.com/games/RivalGames/8dd59957f6074350a9aef3351f3dbb63.png	f	f	8dd59957f6074350a9aef3351f3dbb63	8dd59957f6074350a9aef3351f3dbb63	0	1105	t	96	RivalGames	RivalGames	{}	low	\N	\N	706
Tens or Better	basic	https://gis-static.com/games/RivalGames/ceaef8eaff10445ba5f5693d411ba7cf.png	t	t	ceaef8eaff10445ba5f5693d411ba7cf	ceaef8eaff10445ba5f5693d411ba7cf	0	2605	t	96	RivalGames	RivalGames	{}	medium-high	\N	\N	707
Deuces and Joker	basic	https://gis-static.com/games/RivalGames/1591a1ffd5e94ec3ab473f25bc233100.png	t	t	1591a1ffd5e94ec3ab473f25bc233100	1591a1ffd5e94ec3ab473f25bc233100	0	1605	t	96	RivalGames	RivalGames	{}	high	\N	\N	708
Joker Poker	basic	https://gis-static.com/games/RivalGames/4c2b03cd70d54fbb8881a4dd3c8a801a.png	t	t	4c2b03cd70d54fbb8881a4dd3c8a801a	4c2b03cd70d54fbb8881a4dd3c8a801a	0	805	t	96	RivalGames	RivalGames	{}	low	\N	\N	709
Double Joker	basic	https://gis-static.com/games/RivalGames/6573514bfb394c2384f3fb200c034583.png	t	t	6573514bfb394c2384f3fb200c034583	6573514bfb394c2384f3fb200c034583	0	805	t	96	RivalGames	RivalGames	{}	high	\N	\N	710
Deuces Wild	basic	https://gis-static.com/games/RivalGames/dc1ac29315f941ff8ec05fe54353e216.png	t	t	dc1ac29315f941ff8ec05fe54353e216	dc1ac29315f941ff8ec05fe54353e216	0	10107	t	96	RivalGames	RivalGames	{}	very-high	\N	\N	711
Keno	basic	https://gis-static.com/games/RivalGames/c5bb37eddd7a4515b77282aec9718950.png	t	t	c5bb37eddd7a4515b77282aec9718950	c5bb37eddd7a4515b77282aec9718950	0	933	t	96	RivalGames	RivalGames	{}	low	\N	\N	712
Vegas Jackpot Keno	basic	https://gis-static.com/games/RivalGames/bcb6ecab0e41489c8f4045e6900d7c05.png	t	t	bcb6ecab0e41489c8f4045e6900d7c05	bcb6ecab0e41489c8f4045e6900d7c05	0	2256	t	96	RivalGames	RivalGames	{}	high	\N	\N	713
Tiki Treasure	basic	https://gis-static.com/games/RivalGames/849d95b14b2e4978abfa4d020ff5fa22.png	t	t	849d95b14b2e4978abfa4d020ff5fa22	849d95b14b2e4978abfa4d020ff5fa22	0	1356	t	96	RivalGames	RivalGames	{}	medium	\N	\N	714
Penguin Payday	basic	https://gis-static.com/games/RivalGames/8dfd35a337954fe49d36f29530c96678.png	f	f	8dfd35a337954fe49d36f29530c96678	8dfd35a337954fe49d36f29530c96678	0	1106	t	96	RivalGames	RivalGames	{}	low	\N	\N	715
Gunslinger’s Gold	basic	https://gis-static.com/games/RivalGames/563b508e679944fea8b7a7f680da5f2d.png	t	t	563b508e679944fea8b7a7f680da5f2d	563b508e679944fea8b7a7f680da5f2d	0	2606	t	96	RivalGames	RivalGames	{}	medium-high	\N	\N	716
Pirate’s Pillage	basic	https://gis-static.com/games/RivalGames/49823f38a8b94d73b086916d8a669d7e.png	t	t	49823f38a8b94d73b086916d8a669d7e	49823f38a8b94d73b086916d8a669d7e	0	1606	t	96	RivalGames	RivalGames	{}	high	\N	\N	717
Cash for Cash	basic	https://gis-static.com/games/RivalGames/f0f5c6883a1c46fa9dfff3e7909d2780.png	t	t	f0f5c6883a1c46fa9dfff3e7909d2780	f0f5c6883a1c46fa9dfff3e7909d2780	0	806	t	96	RivalGames	RivalGames	{}	low	\N	\N	718
Beach Bums	basic	https://gis-static.com/games/RivalGames/56b9def5bf614535865b4d6d46c91f31.png	t	t	56b9def5bf614535865b4d6d46c91f31	56b9def5bf614535865b4d6d46c91f31	0	806	t	96	RivalGames	RivalGames	{}	high	\N	\N	719
Aces and Faces	basic	https://gis-static.com/games/RivalGames/bed273c6fba148d0ace8212679362064.png	t	t	bed273c6fba148d0ace8212679362064	bed273c6fba148d0ace8212679362064	0	10108	t	96	RivalGames	RivalGames	{}	very-high	\N	\N	720
Deuces Wild (Multi-Hand)	basic	https://gis-static.com/games/RivalGames/7a478496f446424986778653caac12aa.png	t	t	7a478496f446424986778653caac12aa	7a478496f446424986778653caac12aa	0	2257	t	96	RivalGames	RivalGames	{}	high	\N	\N	721
American Roulette	basic	https://gis-static.com/games/RivalGames/eb75f95a42e6417e8fcd623fc432b3ea.png	t	t	eb75f95a42e6417e8fcd623fc432b3ea	eb75f95a42e6417e8fcd623fc432b3ea	0	1357	t	96	RivalGames	RivalGames	{}	medium	\N	\N	722
Jacks or Better (Multi-Hand)	basic	https://gis-static.com/games/RivalGames/a7e3999a149b40d48888267befdf390a.png	f	f	a7e3999a149b40d48888267befdf390a	a7e3999a149b40d48888267befdf390a	0	1107	t	96	RivalGames	RivalGames	{}	low	\N	\N	723
Aces and Faces (Multi-Hand)	basic	https://gis-static.com/games/RivalGames/6273a7495adc4d578310fc29876c7763.png	t	t	6273a7495adc4d578310fc29876c7763	6273a7495adc4d578310fc29876c7763	0	2607	t	96	RivalGames	RivalGames	{}	medium-high	\N	\N	724
Tens or Better (Multi-Hand)	basic	https://gis-static.com/games/RivalGames/88debfc947ab42319ca2df1f0650dc15.png	t	t	88debfc947ab42319ca2df1f0650dc15	88debfc947ab42319ca2df1f0650dc15	0	1607	t	96	RivalGames	RivalGames	{}	high	\N	\N	725
Deuces and Joker (Multi-Hand)	basic	https://gis-static.com/games/RivalGames/7c7db8a16b754d2eb92d964e813214b2.png	t	t	7c7db8a16b754d2eb92d964e813214b2	7c7db8a16b754d2eb92d964e813214b2	0	807	t	96	RivalGames	RivalGames	{}	low	\N	\N	726
Joker Poker (Multi-Hand)	basic	https://gis-static.com/games/RivalGames/d368fb68a34b4c4794773faa25e5fd37.png	t	t	d368fb68a34b4c4794773faa25e5fd37	d368fb68a34b4c4794773faa25e5fd37	0	807	t	96	RivalGames	RivalGames	{}	high	\N	\N	727
Double Joker (Multi-Hand)	basic	https://gis-static.com/games/RivalGames/a6b1c53e850a49e0970f34f4bface4b6.png	t	t	a6b1c53e850a49e0970f34f4bface4b6	a6b1c53e850a49e0970f34f4bface4b6	0	10109	t	96	RivalGames	RivalGames	{}	very-high	\N	\N	728
Blackjack (Multi-Hand)	basic	https://gis-static.com/games/RivalGames/7cfd65d406414471843cad48c2ec915c.png	t	t	7cfd65d406414471843cad48c2ec915c	7cfd65d406414471843cad48c2ec915c	0	2258	t	96	RivalGames	RivalGames	{}	high	\N	\N	729
European Roulette	basic	https://gis-static.com/games/RivalGames/73ccab9fb046476e8e1e9682b34a196a.png	t	t	73ccab9fb046476e8e1e9682b34a196a	73ccab9fb046476e8e1e9682b34a196a	0	1358	t	96	RivalGames	RivalGames	{}	medium	\N	\N	730
Rolling Stack Blackjack	basic	https://gis-static.com/games/RivalGames/781821dab804420885b3a95fb6182f79.png	f	f	781821dab804420885b3a95fb6182f79	781821dab804420885b3a95fb6182f79	0	1108	t	96	RivalGames	RivalGames	{}	low	\N	\N	731
Kaboom	basic	https://gis-static.com/games/RivalGames/3415228d0bcf48b7b66eac8c1ff02b7d.png	t	t	3415228d0bcf48b7b66eac8c1ff02b7d	3415228d0bcf48b7b66eac8c1ff02b7d	0	2608	t	96	RivalGames	RivalGames	{}	medium-high	\N	\N	732
Elven Princesses: Crown Quest	basic	https://gis-static.com/games/Evoplay/b249d4b4f8534f7da1a0c06c5a575f82.png	t	t	b249d4b4f8534f7da1a0c06c5a575f82	b249d4b4f8534f7da1a0c06c5a575f82	0	1608	t	96	Evoplay	Evoplay	{}	high	\N	\N	733
Puffer Swimming	basic	https://gis-static.com/games/KAGaming/420f2c020edc4492bd7aed3664fb0012.jpg	t	t	420f2c020edc4492bd7aed3664fb0012	420f2c020edc4492bd7aed3664fb0012	0	808	t	96	KAGaming	KAGaming	{}	low	\N	\N	734
Pick ‘Em Poker	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/RTG SLOTS/ba8d07a40fa14bec92d013f24fefec47.png	t	t	ba8d07a40fa14bec92d013f24fefec47	ba8d07a40fa14bec92d013f24fefec47	0	808	t	96	RTG SLOTS	RTG SLOTS	{}	high	\N	\N	735
Baccarat	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/RTG SLOTS/ecad8a5d73404dd08ef11667a44811da.png	t	t	ecad8a5d73404dd08ef11667a44811da	ecad8a5d73404dd08ef11667a44811da	0	10110	t	96	RTG SLOTS	RTG SLOTS	{}	very-high	\N	\N	736
Vegas Hold'em	basic	https://gis-static.com/games/Platipus/604b7a5892585675727719ac854e4291557969b6.png	t	t	604b7a5892585675727719ac854e4291557969b6	604b7a5892585675727719ac854e4291557969b6	0	2259	t	96	Platipus	Platipus	{}	high	\N	\N	737
Whale Bingo	basic	https://gis-static.com/games/Caleta/18e64bb0a3272b9b792697c2fbd45ccb8a484d34.png	t	t	18e64bb0a3272b9b792697c2fbd45ccb8a484d34	18e64bb0a3272b9b792697c2fbd45ccb8a484d34	0	1359	t	96	Caleta	Caleta	{}	medium	\N	\N	738
Blocks	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/b5c5bba2373a44e8a982beb6b80bbe3d.png	f	f	b5c5bba2373a44e8a982beb6b80bbe3d	b5c5bba2373a44e8a982beb6b80bbe3d	0	1109	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	739
Boxes	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/ae5470f5f0f24fc78b599adc61ceb8f1.png	t	t	ae5470f5f0f24fc78b599adc61ceb8f1	ae5470f5f0f24fc78b599adc61ceb8f1	0	2609	t	96	Hacksaw	Hacksaw	{}	medium-high	\N	\N	740
Coins	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/4286df1e9d3544109f5d367023767b5b.png	t	t	4286df1e9d3544109f5d367023767b5b	4286df1e9d3544109f5d367023767b5b	0	1609	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	741
Hi-Lo	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/df74cdb88c6f4dfa9c80c5e155617ad1.png	t	t	df74cdb88c6f4dfa9c80c5e155617ad1	df74cdb88c6f4dfa9c80c5e155617ad1	0	809	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	742
Lines	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/7d9995b8acd44365bb34d289ff2eac26.png	t	t	7d9995b8acd44365bb34d289ff2eac26	7d9995b8acd44365bb34d289ff2eac26	0	809	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	743
Mines	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/9356a04e8bd94d528f9f826d7d1e2113.png	t	t	9356a04e8bd94d528f9f826d7d1e2113	9356a04e8bd94d528f9f826d7d1e2113	0	10111	t	96	Hacksaw	Hacksaw	{}	very-high	\N	\N	744
Plinko	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/b35f278eefeb4fde98efde1164fa53f3.png	t	t	b35f278eefeb4fde98efde1164fa53f3	b35f278eefeb4fde98efde1164fa53f3	0	2260	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	745
Wheel	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/eb55d2ffaa1d424d8ab3f730717b6833.png	t	t	eb55d2ffaa1d424d8ab3f730717b6833	eb55d2ffaa1d424d8ab3f730717b6833	0	1360	t	96	Hacksaw	Hacksaw	{}	medium	\N	\N	746
Break the Ice	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/d233ba91dfdd4b2e8b680b7b4e61fb20.png	t	t	d233ba91dfdd4b2e8b680b7b4e61fb20	d233ba91dfdd4b2e8b680b7b4e61fb20	0	933	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	747
Cash Pool	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/0235afd3a0504db99559b6c3f1aa9143.png	f	f	0235afd3a0504db99559b6c3f1aa9143	0235afd3a0504db99559b6c3f1aa9143	0	1274	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	748
Cash Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/15f5a0945dda4599ae5858baf7f06bfe.png	f	f	15f5a0945dda4599ae5858baf7f06bfe	15f5a0945dda4599ae5858baf7f06bfe	0	1110	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	749
Cash Vault I	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/0cab07cfe60e499fa8160c6dd602c3c4.png	t	t	0cab07cfe60e499fa8160c6dd602c3c4	0cab07cfe60e499fa8160c6dd602c3c4	0	2610	t	96	Hacksaw	Hacksaw	{}	medium-high	\N	\N	750
Cash Vault II	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/5b633e3579e3462d9cc7f5062dca6f6b.png	t	t	5b633e3579e3462d9cc7f5062dca6f6b	5b633e3579e3462d9cc7f5062dca6f6b	0	1610	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	751
Chaos Crew Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/aa82986db0b7476986c5c578407bf933.png	t	t	aa82986db0b7476986c5c578407bf933	aa82986db0b7476986c5c578407bf933	0	810	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	752
Crazy Donuts	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/75b04def65634b4aa959fdc24c10c398.png	t	t	75b04def65634b4aa959fdc24c10c398	75b04def65634b4aa959fdc24c10c398	0	810	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	753
Cut the Grass	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/3eaf9c23f34c4d3fa4591e8963d06269.png	t	t	3eaf9c23f34c4d3fa4591e8963d06269	3eaf9c23f34c4d3fa4591e8963d06269	0	10112	t	96	Hacksaw	Hacksaw	{}	very-high	\N	\N	754
Diamond Rush	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/78af9993bdda4bc5a9347e3d32e87444.png	t	t	78af9993bdda4bc5a9347e3d32e87444	78af9993bdda4bc5a9347e3d32e87444	0	2261	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	755
Double Salary - 1 Year	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/0a52104330664869a27170a76983f20c.png	t	t	0a52104330664869a27170a76983f20c	0a52104330664869a27170a76983f20c	0	1361	t	96	Hacksaw	Hacksaw	{}	medium	\N	\N	756
Dream Car Speed	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/bd1918752cb64d2b8f238729e27c4054.png	f	f	bd1918752cb64d2b8f238729e27c4054	bd1918752cb64d2b8f238729e27c4054	0	1111	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	757
Dream Car SUV	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/379a8d18c24447aabbc2cc82a3fc720a.png	t	t	379a8d18c24447aabbc2cc82a3fc720a	379a8d18c24447aabbc2cc82a3fc720a	0	2611	t	96	Hacksaw	Hacksaw	{}	medium-high	\N	\N	758
Dream Car Urban	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/ed3d2220c8d6476ab9e7ac61abe4b199.png	t	t	ed3d2220c8d6476ab9e7ac61abe4b199	ed3d2220c8d6476ab9e7ac61abe4b199	0	1611	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	759
Eggstra Cash	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/6695cdab09f14b18a80cfdb5f5031d97.png	t	t	6695cdab09f14b18a80cfdb5f5031d97	6695cdab09f14b18a80cfdb5f5031d97	0	811	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	760
Express 200 Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/8080062047f64f80b44c003a43cdfeea.png	t	t	8080062047f64f80b44c003a43cdfeea	8080062047f64f80b44c003a43cdfeea	0	811	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	761
Football Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/f415cb7386a44ea2bea3d6fcf61352f2.png	t	t	f415cb7386a44ea2bea3d6fcf61352f2	f415cb7386a44ea2bea3d6fcf61352f2	0	10113	t	96	Hacksaw	Hacksaw	{}	very-high	\N	\N	762
Frogs Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/ec86ea9552bf4419b941fcd178bfc716.png	t	t	ec86ea9552bf4419b941fcd178bfc716	ec86ea9552bf4419b941fcd178bfc716	0	2262	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	763
Go Panda	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/b74cb86604ce49c085f02d55e6d42ecf.png	t	t	b74cb86604ce49c085f02d55e6d42ecf	b74cb86604ce49c085f02d55e6d42ecf	0	1362	t	96	Hacksaw	Hacksaw	{}	medium	\N	\N	764
Gold Coins	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/2afacc81312943959e4747c482a631c1.png	f	f	2afacc81312943959e4747c482a631c1	2afacc81312943959e4747c482a631c1	0	1112	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	765
Gold Rush	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/e522d769dd4c4541b24d6d8e50aecf4b.png	t	t	e522d769dd4c4541b24d6d8e50aecf4b	e522d769dd4c4541b24d6d8e50aecf4b	0	2612	t	96	Hacksaw	Hacksaw	{}	medium-high	\N	\N	766
Happy Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/9d0fb1718702404398367ff7b18b8df2.png	t	t	9d0fb1718702404398367ff7b18b8df2	9d0fb1718702404398367ff7b18b8df2	0	1612	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	767
It's bananas!	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/b3063b114b8b41829400e23de38e0383.png	t	t	b3063b114b8b41829400e23de38e0383	b3063b114b8b41829400e23de38e0383	0	812	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	768
King Treasure	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/e208d863c8d9496e95f3a6958d46b458.png	t	t	e208d863c8d9496e95f3a6958d46b458	e208d863c8d9496e95f3a6958d46b458	0	812	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	769
Koi Cash	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/b009b1ec8bd54171a1cc6a00b8ec8b17.png	t	t	b009b1ec8bd54171a1cc6a00b8ec8b17	b009b1ec8bd54171a1cc6a00b8ec8b17	0	10114	t	96	Hacksaw	Hacksaw	{}	very-high	\N	\N	770
LOVE is all you need	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/726385c846a640f7ae20537f17cc3993.png	t	t	726385c846a640f7ae20537f17cc3993	726385c846a640f7ae20537f17cc3993	0	2263	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	771
Lucky Numbers x12	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/04a6fef4ee494233be0e6a4038d3e44c.png	t	t	04a6fef4ee494233be0e6a4038d3e44c	04a6fef4ee494233be0e6a4038d3e44c	0	1363	t	96	Hacksaw	Hacksaw	{}	medium	\N	\N	772
Lucky Numbers x16	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/804bfd60d0dd47e0bd0024e5f06ccf38.png	f	f	804bfd60d0dd47e0bd0024e5f06ccf38	804bfd60d0dd47e0bd0024e5f06ccf38	0	1184	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	773
Lucky Numbers x20	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/9f4db6ced9864863ba4acbf6eab37800.png	f	f	9f4db6ced9864863ba4acbf6eab37800	9f4db6ced9864863ba4acbf6eab37800	0	1113	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	774
Lucky Numbers x8	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/e2049191ebbd4ee2a59146d75c696147.png	t	t	e2049191ebbd4ee2a59146d75c696147	e2049191ebbd4ee2a59146d75c696147	0	2613	t	96	Hacksaw	Hacksaw	{}	medium-high	\N	\N	775
Fly To Universe	basic	https://gis-static.com/games/KAGaming/96e7427a66d744b6926f9234e81128b6.jpg	t	t	96e7427a66d744b6926f9234e81128b6	96e7427a66d744b6926f9234e81128b6	0	2333	t	96	KAGaming	KAGaming	{}	high	\N	\N	1338
Lucky Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/cd18ab9fa3694378b872d6319dbd0d66.png	t	t	cd18ab9fa3694378b872d6319dbd0d66	cd18ab9fa3694378b872d6319dbd0d66	0	1613	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	776
Lucky Shot	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/b3c925e535c6487bb0e49da3a6bfc08a.png	t	t	b3c925e535c6487bb0e49da3a6bfc08a	b3c925e535c6487bb0e49da3a6bfc08a	0	813	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	777
Prince Treasure	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/4b6117a669c5444e96c08f8ecd8e5912.png	t	t	4b6117a669c5444e96c08f8ecd8e5912	4b6117a669c5444e96c08f8ecd8e5912	0	813	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	778
Queen Treasure	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/204711db2f4d4051a34aa2a7c5a06156.png	t	t	204711db2f4d4051a34aa2a7c5a06156	204711db2f4d4051a34aa2a7c5a06156	0	10115	t	96	Hacksaw	Hacksaw	{}	very-high	\N	\N	779
Darts Champion	basic	https://gis-static.com/games/KAGaming/1b77e533ee6c4426b7fcfd6d816a2fbd.jpg	t	t	1b77e533ee6c4426b7fcfd6d816a2fbd	1b77e533ee6c4426b7fcfd6d816a2fbd	0	1374	t	96	KAGaming	KAGaming	{}	medium	\N	\N	861
Rat Riches	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/ad0702cbdd86462fb6cd614638eb9cbc.png	t	t	ad0702cbdd86462fb6cd614638eb9cbc	ad0702cbdd86462fb6cd614638eb9cbc	0	2264	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	780
Ruby Rush	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/700ee0ca12094e3b9baf8893b63d9573.png	t	t	700ee0ca12094e3b9baf8893b63d9573	700ee0ca12094e3b9baf8893b63d9573	0	1364	t	96	Hacksaw	Hacksaw	{}	medium	\N	\N	781
SCRATCH! Bronze	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/2c61d52345ab40a1833fc4a4f60d9817.png	f	f	2c61d52345ab40a1833fc4a4f60d9817	2c61d52345ab40a1833fc4a4f60d9817	0	1114	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	782
SCRATCH! Gold	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/b085f4a2e9ce4cb69735220007e501d8.png	t	t	b085f4a2e9ce4cb69735220007e501d8	b085f4a2e9ce4cb69735220007e501d8	0	2614	t	96	Hacksaw	Hacksaw	{}	medium-high	\N	\N	783
SCRATCH! Platinum	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/c332ec35a73b42f6bf9cd92d12fccf27.png	t	t	c332ec35a73b42f6bf9cd92d12fccf27	c332ec35a73b42f6bf9cd92d12fccf27	0	1614	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	784
SCRATCH! Silver	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/1d2646044290490fb5907e3f12afb67d.png	t	t	1d2646044290490fb5907e3f12afb67d	1d2646044290490fb5907e3f12afb67d	0	814	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	785
Scratch’em	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/c6a6baa7dcdb453a8927165246b6c3aa.png	t	t	c6a6baa7dcdb453a8927165246b6c3aa	c6a6baa7dcdb453a8927165246b6c3aa	0	814	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	786
Scratchy	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/862d9c9afa6b4db29036e0b7d2c3567d.png	t	t	862d9c9afa6b4db29036e0b7d2c3567d	862d9c9afa6b4db29036e0b7d2c3567d	0	10116	t	96	Hacksaw	Hacksaw	{}	very-high	\N	\N	787
Scratchy Big	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/d640327851cf4cf3943fe3b61d185d89.png	t	t	d640327851cf4cf3943fe3b61d185d89	d640327851cf4cf3943fe3b61d185d89	0	2265	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	788
Scratchy Mini	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/317bc3a0b6c84b8594d749244af8ed4c.png	t	t	317bc3a0b6c84b8594d749244af8ed4c	317bc3a0b6c84b8594d749244af8ed4c	0	1365	t	96	Hacksaw	Hacksaw	{}	medium	\N	\N	789
Shave the Beard	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/99d405abe5f94399b92b4d3ff7a8c8ae.png	f	f	99d405abe5f94399b92b4d3ff7a8c8ae	99d405abe5f94399b92b4d3ff7a8c8ae	0	1115	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	790
Shave the Sheep	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/750fb25d822b4b238e7cba9a6e337beb.png	t	t	750fb25d822b4b238e7cba9a6e337beb	750fb25d822b4b238e7cba9a6e337beb	0	2615	t	96	Hacksaw	Hacksaw	{}	medium-high	\N	\N	791
Snow Scratcher	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/67b6c9215e0f495fb1122114639712e3.png	t	t	67b6c9215e0f495fb1122114639712e3	67b6c9215e0f495fb1122114639712e3	0	1615	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	792
Spooky Scary Scratchy	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/b7218ffb9d1e4a49aed3682ccfb6127e.png	t	t	b7218ffb9d1e4a49aed3682ccfb6127e	b7218ffb9d1e4a49aed3682ccfb6127e	0	815	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	793
Stack'Em Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/7b3d11e895f14441bd676a4ea81097eb.png	t	t	7b3d11e895f14441bd676a4ea81097eb	7b3d11e895f14441bd676a4ea81097eb	0	815	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	794
Summer Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/fab5a42915874d70bdb13f50949669e7.png	t	t	fab5a42915874d70bdb13f50949669e7	fab5a42915874d70bdb13f50949669e7	0	10117	t	96	Hacksaw	Hacksaw	{}	very-high	\N	\N	795
The perfect Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/d1d39874b1f449abaf1ea163f4a4e18f.png	t	t	d1d39874b1f449abaf1ea163f4a4e18f	d1d39874b1f449abaf1ea163f4a4e18f	0	2266	t	96	Hacksaw	Hacksaw	{}	high	\N	\N	796
Tiger Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/6a222d78d8014f8da0722daaf37f30a3.png	t	t	6a222d78d8014f8da0722daaf37f30a3	6a222d78d8014f8da0722daaf37f30a3	0	1366	t	96	Hacksaw	Hacksaw	{}	medium	\N	\N	797
Paper Lanterns	basic	https://gis-static.com/games/Mascot/ce4c36bbdf943aa4aa0432d19450cbe9a65afe37.png	f	f	ce4c36bbdf943aa4aa0432d19450cbe9a65afe37	ce4c36bbdf943aa4aa0432d19450cbe9a65afe37	0	1116	t	96	Mascot	Mascot	{}	low	\N	\N	798
3D Baccarat	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/e2d7755fef914ca3b37b084daf303a9e.png	t	t	e2d7755fef914ca3b37b084daf303a9e	e2d7755fef914ca3b37b084daf303a9e	0	2616	t	96	Iron Dog Studio	Iron Dog Studio	{}	medium-high	\N	\N	799
3D Blackjack	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/45a7006f9eec4bd194e656b80ff8139e.png	t	t	45a7006f9eec4bd194e656b80ff8139e	45a7006f9eec4bd194e656b80ff8139e	0	1616	t	96	Iron Dog Studio	Iron Dog Studio	{}	high	\N	\N	800
3D Roulette	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/329a94126e254c20b446b9b8ed261f86.png	t	t	329a94126e254c20b446b9b8ed261f86	329a94126e254c20b446b9b8ed261f86	0	816	t	96	Iron Dog Studio	Iron Dog Studio	{}	low	\N	\N	801
Blackjack Classic	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/c2513df61bb5493abbf824fdc6f36539.png	t	t	c2513df61bb5493abbf824fdc6f36539	c2513df61bb5493abbf824fdc6f36539	0	816	t	96	Iron Dog Studio	Iron Dog Studio	{}	high	\N	\N	802
Blood Queen Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/9961de69a9fd4eeda82bd98a3cbc7701.png	t	t	9961de69a9fd4eeda82bd98a3cbc7701	9961de69a9fd4eeda82bd98a3cbc7701	0	10118	t	96	Iron Dog Studio	Iron Dog Studio	{}	very-high	\N	\N	803
Cherry Blast Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/fd67090501c74c928df85bba9f755ab3.png	t	t	fd67090501c74c928df85bba9f755ab3	fd67090501c74c928df85bba9f755ab3	0	2267	t	96	Iron Dog Studio	Iron Dog Studio	{}	high	\N	\N	804
Cosmic Crystals Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/709a403d003a43e7bfaf2bea960c35e8.png	t	t	709a403d003a43e7bfaf2bea960c35e8	709a403d003a43e7bfaf2bea960c35e8	0	1367	t	96	Iron Dog Studio	Iron Dog Studio	{}	medium	\N	\N	805
Gifts of Ostara Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/8fcc5d0b2e3f4002bd6d00d2011a86d7.png	f	f	8fcc5d0b2e3f4002bd6d00d2011a86d7	8fcc5d0b2e3f4002bd6d00d2011a86d7	0	1117	t	96	Iron Dog Studio	Iron Dog Studio	{}	low	\N	\N	806
Moirai Blaze Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/9f167aa9174e432aad1bc51e7adbd253.png	t	t	9f167aa9174e432aad1bc51e7adbd253	9f167aa9174e432aad1bc51e7adbd253	0	2617	t	96	Iron Dog Studio	Iron Dog Studio	{}	medium-high	\N	\N	807
Neon Jungle Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/7089b09739ab45eca4762f0f2c58ca01.png	t	t	7089b09739ab45eca4762f0f2c58ca01	7089b09739ab45eca4762f0f2c58ca01	0	1617	t	96	Iron Dog Studio	Iron Dog Studio	{}	high	\N	\N	808
Paint Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/74f5938edda8422c95468b6343660f21.png	t	t	74f5938edda8422c95468b6343660f21	74f5938edda8422c95468b6343660f21	0	817	t	96	Iron Dog Studio	Iron Dog Studio	{}	low	\N	\N	809
Rainbow Wilds Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/2d16dbfec22a4a798893aa70c926e0dc.png	t	t	2d16dbfec22a4a798893aa70c926e0dc	2d16dbfec22a4a798893aa70c926e0dc	0	817	t	96	Iron Dog Studio	Iron Dog Studio	{}	high	\N	\N	810
Si Xiang Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/3b3771ee4ef146ce8f29bce0b64bc03d.png	t	t	3b3771ee4ef146ce8f29bce0b64bc03d	3b3771ee4ef146ce8f29bce0b64bc03d	0	10119	t	96	Iron Dog Studio	Iron Dog Studio	{}	very-high	\N	\N	811
Siren's Kingdom Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/4fc9726d17cc4d1d958cc11b094e48f3.png	t	t	4fc9726d17cc4d1d958cc11b094e48f3	4fc9726d17cc4d1d958cc11b094e48f3	0	2268	t	96	Iron Dog Studio	Iron Dog Studio	{}	high	\N	\N	812
The Curious Cabinet Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/6d7de59b84564863a6055bf62acef843.png	t	t	6d7de59b84564863a6055bf62acef843	6d7de59b84564863a6055bf62acef843	0	1368	t	96	Iron Dog Studio	Iron Dog Studio	{}	medium	\N	\N	813
Treasure of Horus Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/19407a1d4a6c443f85599d9d0de33063.png	f	f	19407a1d4a6c443f85599d9d0de33063	19407a1d4a6c443f85599d9d0de33063	0	1118	t	96	Iron Dog Studio	Iron Dog Studio	{}	low	\N	\N	814
Viking Wilds Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/12484e6d8a684a92a89db29ceed2693b.png	t	t	12484e6d8a684a92a89db29ceed2693b	12484e6d8a684a92a89db29ceed2693b	0	2618	t	96	Iron Dog Studio	Iron Dog Studio	{}	medium-high	\N	\N	815
Wai-Kiki Scratch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/1bf04f15068e472b975901049bcabc6a.png	t	t	1bf04f15068e472b975901049bcabc6a	1bf04f15068e472b975901049bcabc6a	0	1618	t	96	Iron Dog Studio	Iron Dog Studio	{}	high	\N	\N	816
3 Gods Fishing	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/50f517a50f8347bd8131821cc4a11445.png	t	t	50f517a50f8347bd8131821cc4a11445	50f517a50f8347bd8131821cc4a11445	0	818	t	96	Dragoon Soft	Dragoon Soft	{}	low	\N	\N	817
Acey Deucey	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/3b46218b152f48b09eba9104c8c4c6c8.png	t	t	3b46218b152f48b09eba9104c8c4c6c8	3b46218b152f48b09eba9104c8c4c6c8	0	818	t	96	Dragoon Soft	Dragoon Soft	{}	high	\N	\N	818
Big Hammer	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/b31e2f855dce41f0b63d76c567dd775e.png	t	t	b31e2f855dce41f0b63d76c567dd775e	b31e2f855dce41f0b63d76c567dd775e	0	10120	t	96	Dragoon Soft	Dragoon Soft	{}	very-high	\N	\N	819
Bingo Fishing	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/4f8c52f278fc4212be4068a5a7daaa4a.png	t	t	4f8c52f278fc4212be4068a5a7daaa4a	4f8c52f278fc4212be4068a5a7daaa4a	0	2269	t	96	Dragoon Soft	Dragoon Soft	{}	high	\N	\N	820
Cat Fishing	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/116b5fef4e7044409e7f5dcc792c1fcd.png	t	t	116b5fef4e7044409e7f5dcc792c1fcd	116b5fef4e7044409e7f5dcc792c1fcd	0	1369	t	96	Dragoon Soft	Dragoon Soft	{}	medium	\N	\N	821
Crazy Orb	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/0ffc76dabb6a443d8e2558a8834cc9fa.png	f	f	0ffc76dabb6a443d8e2558a8834cc9fa	0ffc76dabb6a443d8e2558a8834cc9fa	0	1119	t	96	Dragoon Soft	Dragoon Soft	{}	low	\N	\N	822
Demon Conquered	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/83f921ebba784d6e94bd2c0d677c10ab.png	t	t	83f921ebba784d6e94bd2c0d677c10ab	83f921ebba784d6e94bd2c0d677c10ab	0	2619	t	96	Dragoon Soft	Dragoon Soft	{}	medium-high	\N	\N	823
Dino Hunter	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/3da56bec845d44d9b79bcc2ad4463330.png	t	t	3da56bec845d44d9b79bcc2ad4463330	3da56bec845d44d9b79bcc2ad4463330	0	1619	t	96	Dragoon Soft	Dragoon Soft	{}	high	\N	\N	824
Dragon or Crash	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/8fb99c262a6d4656819683ddd3bf83d5.png	t	t	8fb99c262a6d4656819683ddd3bf83d5	8fb99c262a6d4656819683ddd3bf83d5	0	819	t	96	Dragoon Soft	Dragoon Soft	{}	low	\N	\N	825
Flying Phoenix	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/74b5a237842b41db99354f7fae991eec.png	t	t	74b5a237842b41db99354f7fae991eec	74b5a237842b41db99354f7fae991eec	0	819	t	96	Dragoon Soft	Dragoon Soft	{}	high	\N	\N	826
Gods Slash Fish	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/9ee4254973f8492691e8e0dcd1e4b2af.png	t	t	9ee4254973f8492691e8e0dcd1e4b2af	9ee4254973f8492691e8e0dcd1e4b2af	0	10121	t	96	Dragoon Soft	Dragoon Soft	{}	very-high	\N	\N	827
Golden Zuma	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/17ccc4a2a8b34ed3bd8e69a81ee52ae0.png	t	t	17ccc4a2a8b34ed3bd8e69a81ee52ae0	17ccc4a2a8b34ed3bd8e69a81ee52ae0	0	2270	t	96	Dragoon Soft	Dragoon Soft	{}	high	\N	\N	828
Jump & Jump	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/49cc344283784d7bbd7fb0012777d03f.png	t	t	49cc344283784d7bbd7fb0012777d03f	49cc344283784d7bbd7fb0012777d03f	0	1370	t	96	Dragoon Soft	Dragoon Soft	{}	medium	\N	\N	829
Ladder Game	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/be53f5394eed48aeba02b471a7de0002.png	f	f	be53f5394eed48aeba02b471a7de0002	be53f5394eed48aeba02b471a7de0002	0	1120	t	96	Dragoon Soft	Dragoon Soft	{}	low	\N	\N	830
Let’s Enhance	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/4b7c8184cebb40b5a40a94683ba27022.png	t	t	4b7c8184cebb40b5a40a94683ba27022	4b7c8184cebb40b5a40a94683ba27022	0	2620	t	96	Dragoon Soft	Dragoon Soft	{}	medium-high	\N	\N	831
Let's Shoot	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/1cb55a50b5c9451c91dd625c304bf639.png	t	t	1cb55a50b5c9451c91dd625c304bf639	1cb55a50b5c9451c91dd625c304bf639	0	1620	t	96	Dragoon Soft	Dragoon Soft	{}	high	\N	\N	832
Lion's Orb	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/241546f494704346ac986e0e4deb5980.png	t	t	241546f494704346ac986e0e4deb5980	241546f494704346ac986e0e4deb5980	0	820	t	96	Dragoon Soft	Dragoon Soft	{}	low	\N	\N	833
Ocean Lord	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/cb82924872d44c008f6a8daa610dbfaa.png	t	t	cb82924872d44c008f6a8daa610dbfaa	cb82924872d44c008f6a8daa610dbfaa	0	820	t	96	Dragoon Soft	Dragoon Soft	{}	high	\N	\N	834
Plants vs. Dinos	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragonsoft/94bce13ae5644e8c9aea2af65b837cf5.png	t	t	94bce13ae5644e8c9aea2af65b837cf5	94bce13ae5644e8c9aea2af65b837cf5	0	10122	t	96	Dragoon Soft	Dragoon Soft	{}	very-high	\N	\N	835
American Poker Gold	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Wazdan/420971a784bd46499fd753ef2a528be4.png	t	t	420971a784bd46499fd753ef2a528be4	420971a784bd46499fd753ef2a528be4	0	2271	t	96	Wazdan	Wazdan	{}	high	\N	\N	836
American Poker V	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Wazdan/85bfa8ae9d3f4ce9bb7fea78fdf0d9f2.png	t	t	85bfa8ae9d3f4ce9bb7fea78fdf0d9f2	85bfa8ae9d3f4ce9bb7fea78fdf0d9f2	0	1371	t	96	Wazdan	Wazdan	{}	medium	\N	\N	837
Black Jack	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Wazdan/0383d21aa9da49dbaf7b6ad3fe4082e1.png	f	f	0383d21aa9da49dbaf7b6ad3fe4082e1	0383d21aa9da49dbaf7b6ad3fe4082e1	0	1121	t	96	Wazdan	Wazdan	{}	low	\N	\N	838
Caribbean Beach Poker	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Wazdan/a46bbdac78a145529179a78b0fd88d3f.png	t	t	a46bbdac78a145529179a78b0fd88d3f	a46bbdac78a145529179a78b0fd88d3f	0	2621	t	96	Wazdan	Wazdan	{}	medium-high	\N	\N	839
Casino Roulette	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Wazdan/ae50475d8f884bb591ea296d862e03f3.png	t	t	ae50475d8f884bb591ea296d862e03f3	ae50475d8f884bb591ea296d862e03f3	0	1621	t	96	Wazdan	Wazdan	{}	high	\N	\N	840
Extra Bingo	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Wazdan/570972ff01e44f9b88e9464af8ffb3b3.png	t	t	570972ff01e44f9b88e9464af8ffb3b3	570972ff01e44f9b88e9464af8ffb3b3	0	821	t	96	Wazdan	Wazdan	{}	low	\N	\N	841
Gold Roulette	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Wazdan/80f1f74c2ff34d668d6ab07bfafedbfe.png	t	t	80f1f74c2ff34d668d6ab07bfafedbfe	80f1f74c2ff34d668d6ab07bfafedbfe	0	821	t	96	Wazdan	Wazdan	{}	high	\N	\N	842
Joker Poker	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Wazdan/1a1d81b1a12b4ff99c208a557063f3c6.png	t	t	1a1d81b1a12b4ff99c208a557063f3c6	1a1d81b1a12b4ff99c208a557063f3c6	0	10123	t	96	Wazdan	Wazdan	{}	very-high	\N	\N	843
Magic Poker	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Wazdan/1a7d5eaaf7d9413d844d2e677d638a33.png	t	t	1a7d5eaaf7d9413d844d2e677d638a33	1a7d5eaaf7d9413d844d2e677d638a33	0	2272	t	96	Wazdan	Wazdan	{}	high	\N	\N	844
Sic Bo Dragons	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Wazdan/c8266646997e40f29074e08b2e232df7.png	t	t	c8266646997e40f29074e08b2e232df7	c8266646997e40f29074e08b2e232df7	0	1372	t	96	Wazdan	Wazdan	{}	medium	\N	\N	845
Three Cards	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Wazdan/7e891c3a60b7429ca7cb062b48c6d0f6.png	f	f	7e891c3a60b7429ca7cb062b48c6d0f6	7e891c3a60b7429ca7cb062b48c6d0f6	0	1122	t	96	Wazdan	Wazdan	{}	low	\N	\N	846
Turbo Poker	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Wazdan/5b21adfa54134ef0b8057e0747b03f4e.png	t	t	5b21adfa54134ef0b8057e0747b03f4e	5b21adfa54134ef0b8057e0747b03f4e	0	2622	t	96	Wazdan	Wazdan	{}	medium-high	\N	\N	847
October Pub	basic	https://gis-static.com/games/Evoplay/7e4527f3f43701045c13b0033e15af54095fe372.jpg	t	t	7e4527f3f43701045c13b0033e15af54095fe372	7e4527f3f43701045c13b0033e15af54095fe372	0	823	t	96	Evoplay	Evoplay	{}	low	\N	\N	857
Halloween Bingo	basic	https://gis-static.com/games/fdc4364a3eae2f06260e2f95ce9571ed/Belatra Games/35daedc87a9ad8b26a3d3ba59138fceb2171503f.png	t	t	35daedc87a9ad8b26a3d3ba59138fceb2171503f	35daedc87a9ad8b26a3d3ba59138fceb2171503f	0	823	t	96	Belatra Games	Belatra Games	{}	high	\N	\N	858
GOAL Crash America	basic	https://gis-static.com/games/TripleCherry/7b46b1e9f09e26b2a0c15b655c5781b07bab8bf9.png	t	t	7b46b1e9f09e26b2a0c15b655c5781b07bab8bf9	7b46b1e9f09e26b2a0c15b655c5781b07bab8bf9	0	10125	t	96	TripleCherry	TripleCherry	{}	very-high	\N	\N	859
Zodiac Hunting	basic	https://gis-static.com/games/KAGaming/d8048e73d77b4378a6ce30249ad477fe.jpg	t	t	d8048e73d77b4378a6ce30249ad477fe	d8048e73d77b4378a6ce30249ad477fe	0	2274	t	96	KAGaming	KAGaming	{}	high	\N	\N	860
Triple Card Gamble	basic	https://gis-static.com/games/ConceptGaming/35376dd773e0f999eb6ff809d63f0062ddadac96.png	t	t	35376dd773e0f999eb6ff809d63f0062ddadac96	35376dd773e0f999eb6ff809d63f0062ddadac96	0	2624	t	96	ConceptGaming	ConceptGaming	{}	medium-high	\N	\N	863
Mega Bingo	basic	https://gis-static.com/games/Caleta/853ddf86dfe5499bbeb87cfe74ca44f5.png	t	t	853ddf86dfe5499bbeb87cfe74ca44f5	853ddf86dfe5499bbeb87cfe74ca44f5	0	1624	t	96	Caleta	Caleta	{}	high	\N	\N	864
Pumpkin Master	basic	https://gis-static.com/games/Evoplay/c96d875406d54f60ad1200c229d46544.png	t	t	c96d875406d54f60ad1200c229d46544	c96d875406d54f60ad1200c229d46544	0	824	t	96	Evoplay	Evoplay	{}	low	\N	\N	865
Video Poker	basic	https://gis-static.com/games/Evoplay/391a2a2c99824871b072d3ee422b27c2.png	t	t	391a2a2c99824871b072d3ee422b27c2	391a2a2c99824871b072d3ee422b27c2	0	824	t	96	Evoplay	Evoplay	{}	high	\N	\N	866
Blast Man	basic	https://gis-static.com/games/KAGaming/5b7d6b99456d439aa63b09eb8d769efd.jpg	t	t	5b7d6b99456d439aa63b09eb8d769efd	5b7d6b99456d439aa63b09eb8d769efd	0	10126	t	96	KAGaming	KAGaming	{}	very-high	\N	\N	867
Garoto de Ipanema Bingo	basic	https://gis-static.com/games/Caleta/96e2ac53f820456bbaa4a93514f4e9ba.png	t	t	96e2ac53f820456bbaa4a93514f4e9ba	96e2ac53f820456bbaa4a93514f4e9ba	0	2275	t	96	Caleta	Caleta	{}	high	\N	\N	868
Bombing Kraken	basic	https://gis-static.com/games/KAGaming/01a0fe3e1dad4512a10fc8dd2f2d7810.jpg	t	t	01a0fe3e1dad4512a10fc8dd2f2d7810	01a0fe3e1dad4512a10fc8dd2f2d7810	0	1375	t	96	KAGaming	KAGaming	{}	medium	\N	\N	869
Jhana Of God:Scratch	basic	https://gis-static.com/games/Evoplay/5143ea4e1741460da7d9a05ae2a4d67b.png	f	f	5143ea4e1741460da7d9a05ae2a4d67b	5143ea4e1741460da7d9a05ae2a4d67b	0	1125	t	96	Evoplay	Evoplay	{}	low	\N	\N	870
Brute Force Scratch	basic	https://gis-static.com/games/Boldplay/b681fb4e1c1043e89efb1311f376b3be.png	t	t	b681fb4e1c1043e89efb1311f376b3be	b681fb4e1c1043e89efb1311f376b3be	0	2625	t	96	Boldplay	Boldplay	{}	medium-high	\N	\N	871
Crush Pirate Ship	basic	https://gis-static.com/games/KAGaming/de5ad4fccff24443950e03b0d99d57c0.jpg	t	t	de5ad4fccff24443950e03b0d99d57c0	de5ad4fccff24443950e03b0d99d57c0	0	1625	t	96	KAGaming	KAGaming	{}	high	\N	\N	872
Twenty-One	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/17a91be9c3eca13c7a6fb1f626b113d0d6c9735e.png	t	t	17a91be9c3eca13c7a6fb1f626b113d0d6c9735e	17a91be9c3eca13c7a6fb1f626b113d0d6c9735e	0	825	t	96	Hacksaw	Hacksaw	{}	low	\N	\N	873
Dragon City	basic	https://gis-static.com/games/KAGaming/0f95c820c04f45a5924a6d814c70c1d5.jpg	t	t	0f95c820c04f45a5924a6d814c70c1d5	0f95c820c04f45a5924a6d814c70c1d5	0	888	t	96	KAGaming	KAGaming	{}	high	\N	\N	874
Mania Lotto	basic	https://gis-static.com/games/KAGaming/af38817ad86148b194ae68fcf7d410f6.jpg	t	t	af38817ad86148b194ae68fcf7d410f6	af38817ad86148b194ae68fcf7d410f6	0	825	t	96	KAGaming	KAGaming	{}	high	\N	\N	875
Jingle Bell Bingo	basic	https://gis-static.com/games/Caleta/49d20a2b3157dd7115356390b4fe2ccff6e87e6d.png	t	t	49d20a2b3157dd7115356390b4fe2ccff6e87e6d	49d20a2b3157dd7115356390b4fe2ccff6e87e6d	0	10127	t	96	Caleta	Caleta	{}	very-high	\N	\N	876
Ice Scratch Gold	basic	https://gis-static.com/games/772c50b6e70a91f89f0266e2ebfb9992/BGaming/c0948062a87e46b0826ec981da4ac04e.png	t	t	c0948062a87e46b0826ec981da4ac04e	c0948062a87e46b0826ec981da4ac04e	0	2276	t	96	BGaming	BGaming	{}	high	\N	\N	877
Ice Scratch Silver	basic	https://gis-static.com/games/772c50b6e70a91f89f0266e2ebfb9992/BGaming/c8d0a7eea6c0405bafbc8cdec97bc69c.png	t	t	c8d0a7eea6c0405bafbc8cdec97bc69c	c8d0a7eea6c0405bafbc8cdec97bc69c	0	1376	t	96	BGaming	BGaming	{}	medium	\N	\N	878
Ice Scratch Bronze	basic	https://gis-static.com/games/772c50b6e70a91f89f0266e2ebfb9992/BGaming/8b75faa75d124c709dfc781e53778d23.png	f	f	8b75faa75d124c709dfc781e53778d23	8b75faa75d124c709dfc781e53778d23	0	1126	t	96	BGaming	BGaming	{}	low	\N	\N	879
Far West	basic	https://gis-static.com/games/TripleCherry/88fdf8407561a84de7240c972e7ad7798f057e15.png	t	t	88fdf8407561a84de7240c972e7ad7798f057e15	88fdf8407561a84de7240c972e7ad7798f057e15	0	2626	t	96	TripleCherry	TripleCherry	{}	medium-high	\N	\N	880
B3 Roulette	basic	https://gis-static.com/games/BarbaraBang/5ac020600b1e81c37632c8b482ea64cefeb7690c.png	t	t	5ac020600b1e81c37632c8b482ea64cefeb7690c	5ac020600b1e81c37632c8b482ea64cefeb7690c	0	1626	t	96	BarbaraBang	BarbaraBang	{}	high	\N	\N	881
Wonder Christmas Scratch BB	basic	https://gis-static.com/games/BarbaraBang/1194c8f20490614462565ccf1d9c4862e839bfe2.png	t	t	1194c8f20490614462565ccf1d9c4862e839bfe2	1194c8f20490614462565ccf1d9c4862e839bfe2	0	826	t	96	BarbaraBang	BarbaraBang	{}	low	\N	\N	882
American Roulette	basic	https://gis-static.com/games/Platipus/e76b121657dcf30874af7a3508daea8c03ffad9c.png	t	t	e76b121657dcf30874af7a3508daea8c03ffad9c	e76b121657dcf30874af7a3508daea8c03ffad9c	0	826	t	96	Platipus	Platipus	{}	high	\N	\N	883
Christmas Crash	basic	https://gis-static.com/games/Evoplay/138a12efc590491380c8496bb7ba0762.png	t	t	138a12efc590491380c8496bb7ba0762	138a12efc590491380c8496bb7ba0762	0	10128	t	96	Evoplay	Evoplay	{}	very-high	\N	\N	884
Iron Hero	basic	https://gis-static.com/games/KAGaming/0c82e9b448aa4621b6fb1227cb601712.jpg	t	t	0c82e9b448aa4621b6fb1227cb601712	0c82e9b448aa4621b6fb1227cb601712	0	2277	t	96	KAGaming	KAGaming	{}	high	\N	\N	885
Trading Dice	basic	https://gis-static.com/games/Turbogames/f248d480ac5692f1fb17811d0fa11458a3427230.png	t	t	f248d480ac5692f1fb17811d0fa11458a3427230	f248d480ac5692f1fb17811d0fa11458a3427230	0	1377	t	96	Turbogames	Turbogames	{}	medium	\N	\N	886
Pai Gow	basic	https://gis-static.com/games/RivalGames/175b4c3f4a73434f807d6de8b4784bcd.png	f	f	175b4c3f4a73434f807d6de8b4784bcd	175b4c3f4a73434f807d6de8b4784bcd	0	1127	t	96	RivalGames	RivalGames	{}	low	\N	\N	887
Octopus Legend	basic	https://gis-static.com/games/KAGaming/36821700e05a4f36a65f32e9d9733d41.png	t	t	36821700e05a4f36a65f32e9d9733d41	36821700e05a4f36a65f32e9d9733d41	0	1429	t	96	KAGaming	KAGaming	{}	medium	\N	\N	1307
Wood Dragon Scratch	basic	https://gis-static.com/games/Boldplay/079b39d358564e34afce22982a3b93d7.png	f	f	079b39d358564e34afce22982a3b93d7	079b39d358564e34afce22982a3b93d7	0	1179	t	96	Boldplay	Boldplay	{}	low	\N	\N	1308
Monster Go Shopping	basic	https://gis-static.com/games/KAGaming/d5c201318da5a3e7f3466b570f0cec25b7a771bc.jpg	t	t	d5c201318da5a3e7f3466b570f0cec25b7a771bc	d5c201318da5a3e7f3466b570f0cec25b7a771bc	0	1430	t	96	KAGaming	KAGaming	{}	medium	\N	\N	1315
Win Poker	basic	https://gis-static.com/games/Igrosoft/bf216a68667333386b4429033cc2c45fdb633aa0.png	t	t	bf216a68667333386b4429033cc2c45fdb633aa0	bf216a68667333386b4429033cc2c45fdb633aa0	0	2679	t	96	Igrosoft	Igrosoft	{}	medium-high	\N	\N	1309
Millionaire (Scratch)	basic	https://gis-static.com/games/TripleCherry/54099499960a4977ba7f7cceeae6c048.png	t	t	54099499960a4977ba7f7cceeae6c048	54099499960a4977ba7f7cceeae6c048	0	877	t	96	TripleCherry	TripleCherry	{}	low	\N	\N	1295
Dragon Boom	basic	https://gis-static.com/games/KAGaming/868112cd76e04c00a1d933e5513be38f.jpg	t	t	868112cd76e04c00a1d933e5513be38f	868112cd76e04c00a1d933e5513be38f	0	877	t	96	KAGaming	KAGaming	{}	high	\N	\N	1296
Mine Island	basic	https://gis-static.com/games/SmartSoft/86c789fd089096a66dfabbf32a2209b5947b8424.png	t	t	86c789fd089096a66dfabbf32a2209b5947b8424	86c789fd089096a66dfabbf32a2209b5947b8424	0	10179	t	96	SmartSoft	SmartSoft	{}	very-high	\N	\N	1297
Juicy Fruits Scratch BB	basic	https://gis-static.com/games/BarbaraBang/6bb17e6f74f04cfbbedb12cbaee895a9.png	t	t	6bb17e6f74f04cfbbedb12cbaee895a9	6bb17e6f74f04cfbbedb12cbaee895a9	0	2328	t	96	BarbaraBang	BarbaraBang	{}	high	\N	\N	1298
Bubble Shooter	basic	https://gis-static.com/games/KAGaming/25db1b1c5a874927bcdda8c3ba25ffcc.jpg	t	t	25db1b1c5a874927bcdda8c3ba25ffcc	25db1b1c5a874927bcdda8c3ba25ffcc	0	1428	t	96	KAGaming	KAGaming	{}	medium	\N	\N	1299
Philosopher Roulette	basic	https://gis-static.com/games/KAGaming/c38afd7ad1af431fbc32b2bda055b091.jpg	f	f	c38afd7ad1af431fbc32b2bda055b091	c38afd7ad1af431fbc32b2bda055b091	0	1178	t	96	KAGaming	KAGaming	{}	low	\N	\N	1300
Rocket Race	basic	https://gis-static.com/games/KAGaming/31075b9bcce4413cb7c3c38f3f6fb86a.jpg	t	t	31075b9bcce4413cb7c3c38f3f6fb86a	31075b9bcce4413cb7c3c38f3f6fb86a	0	2678	t	96	KAGaming	KAGaming	{}	medium-high	\N	\N	1301
Smash X	basic	https://gis-static.com/games/SmartSoft/3091dca1ec706d9605fb5ee2b6ea5a993beb6987.png	t	t	3091dca1ec706d9605fb5ee2b6ea5a993beb6987	3091dca1ec706d9605fb5ee2b6ea5a993beb6987	0	878	t	96	SmartSoft	SmartSoft	{}	high	\N	\N	1304
Three Card Poker	basic	https://gis-static.com/games/Boldplay/b5797d886059430c9ec7c1e204dab65c.png	t	t	b5797d886059430c9ec7c1e204dab65c	b5797d886059430c9ec7c1e204dab65c	0	2680	t	96	Boldplay	Boldplay	{}	medium-high	\N	\N	1317
Baccarat Triple Treat	basic	https://gis-static.com/games/OneTouch/bdb12fda3fbe49c835008dba9e94b2ffe47d1fa7.png	t	t	bdb12fda3fbe49c835008dba9e94b2ffe47d1fa7	bdb12fda3fbe49c835008dba9e94b2ffe47d1fa7	0	1680	t	96	OneTouch	OneTouch	{}	high	\N	\N	1318
Dessert Party	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragoon Soft/7241cb9105e2431eadbc5a03638d6b9c.png	t	t	7241cb9105e2431eadbc5a03638d6b9c	7241cb9105e2431eadbc5a03638d6b9c	0	880	t	96	Dragoon Soft	Dragoon Soft	{}	high	\N	\N	1320
Ninja Fishing	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Dragoon Soft/3c37da08f7dc455d8211c6375b7489c5.png	t	t	3c37da08f7dc455d8211c6375b7489c5	3c37da08f7dc455d8211c6375b7489c5	0	10182	t	96	Dragoon Soft	Dragoon Soft	{}	very-high	\N	\N	1321
Fish Catch	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/RTG SLOTS/3eaf6a8b0bf9479ebc885ed24ff2c54a.png	t	t	3eaf6a8b0bf9479ebc885ed24ff2c54a	3eaf6a8b0bf9479ebc885ed24ff2c54a	0	2331	t	96	RTG SLOTS	RTG SLOTS	{}	high	\N	\N	1322
Luxury (Scratch)	basic	https://gis-static.com/games/TripleCherry/62842f320127422e91de1785be0ed5ff.png	t	t	62842f320127422e91de1785be0ed5ff	62842f320127422e91de1785be0ed5ff	0	1431	t	96	TripleCherry	TripleCherry	{}	medium	\N	\N	1323
Hockey Shootout	basic	https://gis-static.com/games/Evoplay/1bb7c006301c45549e81a796aa06bb2d.jpg	f	f	1bb7c006301c45549e81a796aa06bb2d	1bb7c006301c45549e81a796aa06bb2d	0	1181	t	96	Evoplay	Evoplay	{}	low	\N	\N	1324
Dice BB	basic	https://gis-static.com/games/BarbaraBang/e2f6e73e659c49e9993af17299b8f8c9.png	t	t	e2f6e73e659c49e9993af17299b8f8c9	e2f6e73e659c49e9993af17299b8f8c9	0	881	t	96	BarbaraBang	BarbaraBang	{}	high	\N	\N	1328
Thunder Roulette	basic	https://gis-static.com/games/XProgaming/0136694b50afbf6b1a8ac65781284a489a179448.png	t	t	0136694b50afbf6b1a8ac65781284a489a179448	0136694b50afbf6b1a8ac65781284a489a179448	0	10183	t	96	XProgaming	XProgaming	{}	very-high	\N	\N	1329
Wheel of Fortune	basic	https://gis-static.com/games/HoGaming/2556adda419a6c6c3eb124039d0a8a95933a0ac6.png	t	t	2556adda419a6c6c3eb124039d0a8a95933a0ac6	2556adda419a6c6c3eb124039d0a8a95933a0ac6	0	2332	t	96	HoGaming	HoGaming	{}	high	\N	\N	1330
DRAGON'S CRASH	basic	https://gis-static.com/games/772c50b6e70a91f89f0266e2ebfb9992/BGaming/2b77f20b9003476e9939daa6d2792cce.png	t	t	2b77f20b9003476e9939daa6d2792cce	2b77f20b9003476e9939daa6d2792cce	0	1432	t	96	BGaming	BGaming	{}	medium	\N	\N	1331
Deep Beast	basic	https://gis-static.com/games/KAGaming/909c321b053f47769204653d1712f1fb.png	t	t	909c321b053f47769204653d1712f1fb	909c321b053f47769204653d1712f1fb	0	10184	t	96	KAGaming	KAGaming	{}	very-high	\N	\N	1337
Jackpot Mines	basic	https://gis-static.com/games/fdc4364a3eae2f06260e2f95ce9571ed/Belatra Games/1cf5635bd6474cc2b82aa76edac6eb9b.png	t	t	1cf5635bd6474cc2b82aa76edac6eb9b	1cf5635bd6474cc2b82aa76edac6eb9b	0	1433	t	96	Belatra Games	Belatra Games	{}	medium	\N	\N	1339
Multihand BlackJack	basic	https://gis-static.com/games/Platipus/525deaba51fdd0700562a98b7101082c9cde66f4.png	f	f	525deaba51fdd0700562a98b7101082c9cde66f4	525deaba51fdd0700562a98b7101082c9cde66f4	0	1183	t	96	Platipus	Platipus	{}	low	\N	\N	1340
Extra luck	basic	https://gis-static.com/games/TripleCherry/844213dd209d45ef93053eb0f2c99b6f.png	t	t	844213dd209d45ef93053eb0f2c99b6f	844213dd209d45ef93053eb0f2c99b6f	0	2683	t	96	TripleCherry	TripleCherry	{}	medium-high	\N	\N	1341
Lucky 7	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/RTG SLOTS/8f03fea2875b60da1ee520778ed33c3e02963bda.png	t	t	8f03fea2875b60da1ee520778ed33c3e02963bda	8f03fea2875b60da1ee520778ed33c3e02963bda	0	1683	t	96	RTG SLOTS	RTG SLOTS	{}	high	\N	\N	1342
Deep Overlord	basic	https://gis-static.com/games/KAGaming/300ee284a1bd0c6eb0ad79378b90a3a187ab3210.jpg	t	t	300ee284a1bd0c6eb0ad79378b90a3a187ab3210	300ee284a1bd0c6eb0ad79378b90a3a187ab3210	0	883	t	96	KAGaming	KAGaming	{}	low	\N	\N	1343
3 Kings Scratch	basic	https://gis-static.com/games/772c50b6e70a91f89f0266e2ebfb9992/BGaming/d1fb13f8e2624fe1beb61110da194dc9.png	t	t	d1fb13f8e2624fe1beb61110da194dc9	d1fb13f8e2624fe1beb61110da194dc9	0	883	t	96	BGaming	BGaming	{}	high	\N	\N	1344
Golden Crab	basic	https://gis-static.com/games/KAGaming/b2c1cb145bbe8480aadee76f9ca2ea163783fe65.jpg	t	t	b2c1cb145bbe8480aadee76f9ca2ea163783fe65	b2c1cb145bbe8480aadee76f9ca2ea163783fe65	0	10185	t	96	KAGaming	KAGaming	{}	very-high	\N	\N	1345
Million Lucky Wheel	basic	https://gis-static.com/games/KAGaming/ffef46a4375fed73752b40082c60e11b62a94ea6.jpg	t	t	ffef46a4375fed73752b40082c60e11b62a94ea6	ffef46a4375fed73752b40082c60e11b62a94ea6	0	2334	t	96	KAGaming	KAGaming	{}	high	\N	\N	1346
Roulette Classic	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Iron Dog Studio/5c9b756d81e4402fbdb15b1567bcdbc2.png	t	t	5c9b756d81e4402fbdb15b1567bcdbc2	5c9b756d81e4402fbdb15b1567bcdbc2	0	1434	t	96	Iron Dog Studio	Iron Dog Studio	{}	medium	\N	\N	1347
Baccarat	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Hacksaw/d89f99f8c07b4e73bfbe2a2bb52916d8.png	t	t	d89f99f8c07b4e73bfbe2a2bb52916d8	d89f99f8c07b4e73bfbe2a2bb52916d8	0	2684	t	96	Hacksaw	Hacksaw	{}	medium-high	\N	\N	1348
5x Dice Party	basic	https://gis-static.com/games/CTInteractive/6bf66970d0e44d1d57a87c8991e7e5df89126d7b.png	f	f	6bf66970d0e44d1d57a87c8991e7e5df89126d7b	6bf66970d0e44d1d57a87c8991e7e5df89126d7b	0	1186	t	96	CTInteractive	CTInteractive	{}	low	\N	\N	1363
Fire Egg Dice	basic	https://gis-static.com/games/CTInteractive/33edf7700744bb82b56183dac891724cbb666ada.png	t	t	33edf7700744bb82b56183dac891724cbb666ada	33edf7700744bb82b56183dac891724cbb666ada	0	2686	t	96	CTInteractive	CTInteractive	{}	medium-high	\N	\N	1364
Pick The Pig Dice	basic	https://gis-static.com/games/CTInteractive/e3bef6bef8af6a853c9366aa0bf9e93bf62875cc.png	t	t	e3bef6bef8af6a853c9366aa0bf9e93bf62875cc	e3bef6bef8af6a853c9366aa0bf9e93bf62875cc	0	1686	t	96	CTInteractive	CTInteractive	{}	high	\N	\N	1365
Win Storm Dice	basic	https://gis-static.com/games/CTInteractive/e042a9c11b8320325f3438a4428ede1997026bb5.png	t	t	e042a9c11b8320325f3438a4428ede1997026bb5	e042a9c11b8320325f3438a4428ede1997026bb5	0	886	t	96	CTInteractive	CTInteractive	{}	low	\N	\N	1366
Deep Fishing	basic	https://gis-static.com/games/KAGaming/e28e688b203848e4a44582d76ca8758f.jpg	t	t	e28e688b203848e4a44582d76ca8758f	e28e688b203848e4a44582d76ca8758f	0	886	t	96	KAGaming	KAGaming	{}	high	\N	\N	1367
32 Cards	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/RTG SLOTS/793646d889eae7abe8d243d7908df58d16a0d013.png	t	t	793646d889eae7abe8d243d7908df58d16a0d013	793646d889eae7abe8d243d7908df58d16a0d013	0	10188	t	96	RTG SLOTS	RTG SLOTS	{}	very-high	\N	\N	1368
Swindler	basic	https://gis-static.com/games/FBastards/11b98582505044b182895b5cef035eda.png	t	t	11b98582505044b182895b5cef035eda	11b98582505044b182895b5cef035eda	0	2337	t	96	FBastards	FBastards	{}	high	\N	\N	1369
SkaterBoy	basic	https://gis-static.com/games/FBastards/1160901f31554d95a26c9a08a54843c0.png	t	t	1160901f31554d95a26c9a08a54843c0	1160901f31554d95a26c9a08a54843c0	0	1437	t	96	FBastards	FBastards	{}	medium	\N	\N	1370
Thimbles	basic	https://gis-static.com/games/FBastards/5b0dd18d267448fea338eb1cde1d0835.png	f	f	5b0dd18d267448fea338eb1cde1d0835	5b0dd18d267448fea338eb1cde1d0835	0	1187	t	96	FBastards	FBastards	{}	low	\N	\N	1371
Air Boss	basic	https://gis-static.com/games/Platipus/692d6f3d188ffbcc3f1e25e8078ed8b0b6a48a7f.png	t	t	692d6f3d188ffbcc3f1e25e8078ed8b0b6a48a7f	692d6f3d188ffbcc3f1e25e8078ed8b0b6a48a7f	0	2687	t	96	Platipus	Platipus	{}	medium-high	\N	\N	1372
B-Ball Blitz	basic	https://gis-static.com/games/Evoplay/5fdb9f17d8754d39bc2697ca9d8159e4.jpg	t	t	5fdb9f17d8754d39bc2697ca9d8159e4	5fdb9f17d8754d39bc2697ca9d8159e4	0	1687	t	96	Evoplay	Evoplay	{}	high	\N	\N	1373
LUCK & MAGIC SCRATCH	basic	https://gis-static.com/games/772c50b6e70a91f89f0266e2ebfb9992/BGaming/ea4f95993c504b56abf0ea46cca0ea69.png	t	t	ea4f95993c504b56abf0ea46cca0ea69	ea4f95993c504b56abf0ea46cca0ea69	0	887	t	96	BGaming	BGaming	{}	low	\N	\N	1374
Attack on Crabs	basic	https://gis-static.com/games/KAGaming/9ce1f63ee26f484d85d8c87ddb245344.jpg	t	t	9ce1f63ee26f484d85d8c87ddb245344	9ce1f63ee26f484d85d8c87ddb245344	0	887	t	96	KAGaming	KAGaming	{}	high	\N	\N	1375
King Kong Cash Full House	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/Blueprint/69f5a5a24260f43817d3825281f77c6fd993b9db.png	t	t	69f5a5a24260f43817d3825281f77c6fd993b9db	69f5a5a24260f43817d3825281f77c6fd993b9db	0	10189	t	96	Blueprint	Blueprint	{}	very-high	\N	\N	1376
Blackjack	basic	https://gis-static.com/games/SmartBet/e0a689879dce1f153021314cafc03957b6966c42.png	t	t	e0a689879dce1f153021314cafc03957b6966c42	e0a689879dce1f153021314cafc03957b6966c42	0	2338	t	96	SmartBet	SmartBet	{}	high	\N	\N	1377
Bet on Poker	basic	https://gis-static.com/games/SmartBet/378601115ceab604bf15025afa725023da320f9d.png	t	t	378601115ceab604bf15025afa725023da320f9d	378601115ceab604bf15025afa725023da320f9d	0	1438	t	96	SmartBet	SmartBet	{}	medium	\N	\N	1378
Roulette	basic	https://gis-static.com/games/SmartBet/3f5c89dd2f1fb82558d4713b0b5090d49c2708d3.png	f	f	3f5c89dd2f1fb82558d4713b0b5090d49c2708d3	3f5c89dd2f1fb82558d4713b0b5090d49c2708d3	0	1188	t	96	SmartBet	SmartBet	{}	low	\N	\N	1379
Go Go Fishing	basic	https://gis-static.com/games/KAGaming/3d233d892ecd4414a5da8150efcaede9.jpg	t	t	3d233d892ecd4414a5da8150efcaede9	3d233d892ecd4414a5da8150efcaede9	0	2688	t	96	KAGaming	KAGaming	{}	medium-high	\N	\N	1380
Fortune Wheel	basic	https://gis-static.com/games/KAGaming/aead4b1e0b9244cea902fe28e56bee9c.jpg	t	t	aead4b1e0b9244cea902fe28e56bee9c	aead4b1e0b9244cea902fe28e56bee9c	0	1688	t	96	KAGaming	KAGaming	{}	high	\N	\N	1381
5000 x Rush	basic	https://gis-static.com/games/Platipus/42de8d037e0e91d7c1901f2c99a026a57112be5e.png	t	t	42de8d037e0e91d7c1901f2c99a026a57112be5e	42de8d037e0e91d7c1901f2c99a026a57112be5e	0	888	t	96	Platipus	Platipus	{}	low	\N	\N	1382
DICE	basic	https://gis-static.com/games/VibraGaming/5880f11b6a394c9784bf504d10a7d82e.png	t	t	5880f11b6a394c9784bf504d10a7d82e	5880f11b6a394c9784bf504d10a7d82e	0	2339	t	96	VibraGaming	VibraGaming	{}	high	\N	\N	1383
Andar Bahar	basic	https://gis-static.com/games/3962be5e18b1e84fdd95613e87dfda1a/RTG SLOTS/c357a6c0757d6ebd3fa2f9970b83f63f1dbc4e85.png	t	t	c357a6c0757d6ebd3fa2f9970b83f63f1dbc4e85	c357a6c0757d6ebd3fa2f9970b83f63f1dbc4e85	0	1439	t	96	RTG SLOTS	RTG SLOTS	{}	medium	\N	\N	1384
\.


--
-- Data for Name: casinotransactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.casinotransactions (id, game_id, user_id, game_code, transaction_id, reference_id, provider_code, provider_transaction_id, amount, remark, game_type, created_at, updated_at, username, path) FROM stdin;
4330	84	576	Dragon Tiger	dff44dd99cd841ea83592497f83808a5	6659b8c5ca41974006aa284e	Casinoland	dff44dd99cd841ea83592497f83808a5	200.00	bet on Dragon Tiger	Ezugi	2024-05-31 11:47:17.865+00	2024-05-31 11:47:17.865+00	DemoUser	0.576
4331	84	576	Dragon Tiger	17c4435ab12b47c8b2c85d725b8c3c24	6659b8ccca41974006aa2859	Casinoland	17c4435ab12b47c8b2c85d725b8c3c24	0.00	win on Dragon Tiger	Ezugi	2024-05-31 11:47:24.5+00	2024-05-31 11:47:24.5+00	DemoUser	0.576
4332	84	576	Dragon Tiger	65672c982fc7431ca1ff4e4b4f1ad233	6659b8e0ca41974006aa287a	Casinoland	65672c982fc7431ca1ff4e4b4f1ad233	200.00	bet on Dragon Tiger	Ezugi	2024-05-31 11:47:44.669+00	2024-05-31 11:47:44.669+00	DemoUser	0.576
4333	84	576	Dragon Tiger	dba35b4974274ee29ce5e5d21819af99	6659b8e7ca41974006aa2890	Casinoland	dba35b4974274ee29ce5e5d21819af99	400.00	win on Dragon Tiger	Ezugi	2024-05-31 11:47:51.732+00	2024-05-31 11:47:51.732+00	DemoUser	0.576
4334	1358	589	Book of Mines	2144b359707a4659b51c5c49f163212e	665aaeedca41974006aadbde	Casinoland	2144b359707a4659b51c5c49f163212e	100.00	bet on Book of Mines	Turbogames	2024-06-01 05:17:33.22+00	2024-06-01 05:17:33.22+00	user12	0.575.582.589
4335	1358	589	Book of Mines	287550b0eca94ad2ac71d7241f86c932	665aaf07ca41974006aadbe9	Casinoland	287550b0eca94ad2ac71d7241f86c932	123.00	win on Book of Mines	Turbogames	2024-06-01 05:17:59.217+00	2024-06-01 05:17:59.217+00	user12	0.575.582.589
4336	1358	589	Book of Mines	69c67e08603049e58dc527c629542694	665aaf12ca41974006aadbf4	Casinoland	69c67e08603049e58dc527c629542694	100.00	bet on Book of Mines	Turbogames	2024-06-01 05:18:10.685+00	2024-06-01 05:18:10.685+00	user12	0.575.582.589
4337	1358	589	Book of Mines	fd6ace867b03497b96a7cf8af5a38fd2	665aaf1bca41974006aadbff	Casinoland	fd6ace867b03497b96a7cf8af5a38fd2	108.00	win on Book of Mines	Turbogames	2024-06-01 05:18:19.628+00	2024-06-01 05:18:19.628+00	user12	0.575.582.589
4338	1358	589	Book of Mines	ab66498cdf0a459e8d90afb00b123e26	665aaf2aca41974006aadc0a	Casinoland	ab66498cdf0a459e8d90afb00b123e26	100.00	bet on Book of Mines	Turbogames	2024-06-01 05:18:35.039+00	2024-06-01 05:18:35.039+00	user12	0.575.582.589
4339	1358	589	Book of Mines	2351e1fe595d4ba6800d3a69244b2c23	665aaf34ca41974006aadc15	Casinoland	2351e1fe595d4ba6800d3a69244b2c23	108.00	win on Book of Mines	Turbogames	2024-06-01 05:18:44.834+00	2024-06-01 05:18:44.834+00	user12	0.575.582.589
4340	1358	589	Book of Mines	edfc02cd73cf404ab5fbd02039307a5e	665aaf3bca41974006aadc23	Casinoland	edfc02cd73cf404ab5fbd02039307a5e	100.00	bet on Book of Mines	Turbogames	2024-06-01 05:18:51.6+00	2024-06-01 05:18:51.6+00	user12	0.575.582.589
4341	1358	589	Book of Mines	1e1121fc5aad413aa26f19f250fdc2bf	665aaf3bca41974006aadc2e	Casinoland	1e1121fc5aad413aa26f19f250fdc2bf	0.00	win on Book of Mines	Turbogames	2024-06-01 05:18:52.008+00	2024-06-01 05:18:52.008+00	user12	0.575.582.589
4342	1358	589	Book of Mines	cbadb9685d0a429f821aa3c1f7ac7bff	665aaf44ca41974006aadc3d	Casinoland	cbadb9685d0a429f821aa3c1f7ac7bff	100.00	bet on Book of Mines	Turbogames	2024-06-01 05:19:00.517+00	2024-06-01 05:19:00.517+00	user12	0.575.582.589
4343	1358	589	Book of Mines	c9a560d89f1741f4af48dab85a7a4985	665aaf44ca41974006aadc48	Casinoland	c9a560d89f1741f4af48dab85a7a4985	0.00	win on Book of Mines	Turbogames	2024-06-01 05:19:00.905+00	2024-06-01 05:19:00.905+00	user12	0.575.582.589
4344	1358	589	Book of Mines	92a0aca3a67e46819ff96f3456478410	665aaf4dca41974006aadc53	Casinoland	92a0aca3a67e46819ff96f3456478410	100.00	bet on Book of Mines	Turbogames	2024-06-01 05:19:09.773+00	2024-06-01 05:19:09.773+00	user12	0.575.582.589
4345	1358	589	Book of Mines	4fa7f8f8f4594008be5d05af05018583	665aaf52ca41974006aadc5e	Casinoland	4fa7f8f8f4594008be5d05af05018583	108.00	win on Book of Mines	Turbogames	2024-06-01 05:19:14.375+00	2024-06-01 05:19:14.375+00	user12	0.575.582.589
4346	1358	589	Book of Mines	d9bc4ca7fef94bf885e2fa0f6e02d817	665aaf57ca41974006aadc69	Casinoland	d9bc4ca7fef94bf885e2fa0f6e02d817	100.00	bet on Book of Mines	Turbogames	2024-06-01 05:19:19.166+00	2024-06-01 05:19:19.166+00	user12	0.575.582.589
4347	1358	589	Book of Mines	e8e28ad82b4d476099fcb60c922179da	665aaf5bca41974006aadc79	Casinoland	e8e28ad82b4d476099fcb60c922179da	108.00	win on Book of Mines	Turbogames	2024-06-01 05:19:24.033+00	2024-06-01 05:19:24.033+00	user12	0.575.582.589
4348	1358	589	Book of Mines	c0f13cd0736d4653b0ae2ee981132f5e	665aaf63ca41974006aadc84	Casinoland	c0f13cd0736d4653b0ae2ee981132f5e	100.00	bet on Book of Mines	Turbogames	2024-06-01 05:19:32.034+00	2024-06-01 05:19:32.034+00	user12	0.575.582.589
4349	1358	589	Book of Mines	349f7b3dc3a54476aa2edaf7e6a3f592	665aaf68ca41974006aadc8f	Casinoland	349f7b3dc3a54476aa2edaf7e6a3f592	108.00	win on Book of Mines	Turbogames	2024-06-01 05:19:36.187+00	2024-06-01 05:19:36.187+00	user12	0.575.582.589
4350	1358	589	Book of Mines	c1f80b5b363a4dca992ffd8018c9db5b	665aaf79ca41974006aadcb0	Casinoland	c1f80b5b363a4dca992ffd8018c9db5b	200.00	bet on Book of Mines	Turbogames	2024-06-01 05:19:53.347+00	2024-06-01 05:19:53.347+00	user12	0.575.582.589
4351	1358	589	Book of Mines	dd254ca7c68e4e11af858bc307c26109	665aaf7dca41974006aadcbb	Casinoland	dd254ca7c68e4e11af858bc307c26109	216.00	win on Book of Mines	Turbogames	2024-06-01 05:19:57.28+00	2024-06-01 05:19:57.28+00	user12	0.575.582.589
\.


--
-- Data for Name: depositrequests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.depositrequests (id, "paymentMethod", utr, img, amount, "userId", status, "createdAt", "updatedAt", username, userpath) FROM stdin;
187	bankaccount	q11w1w	https://staging-api.jamesbondcasinoroyale.com/\n/api/user/f9f74be189d3e7a6507f5b596acd9d0e.png	101	576	Approved	2024-05-31 11:02:01.074+00	2024-05-31 11:03:50.412+00	DemoUser	0.576
188	bankaccount	6285467534	https://staging-api.jamesbondcasinoroyale.com/\n/api/user/4f60728ffcee9f1a75ac7183f01efe1f.png	101	576	Approved	2024-05-31 11:11:13.096+00	2024-05-31 11:32:33.535+00	DemoUser	0.576
189	bankaccount	210de0e1	https://staging-api.jamesbondcasinoroyale.com/\n/api/user/729b430d438def4179c2acf98a710f82.png	150	576	Approved	2024-05-31 11:34:54.662+00	2024-05-31 11:35:26.695+00	DemoUser	0.576
192	bankaccount	125521e1e	https://staging-api.jamesbondcasinoroyale.com/\n/api/user/90ef8740b50f67d5e5abffdc904d2cce.png	300	576	Approved	2024-05-31 11:46:31.622+00	2024-05-31 11:54:08.905+00	DemoUser	0.576
191	bankaccount	628546753412	https://staging-api.jamesbondcasinoroyale.com/\n/api/user/774c0e04e07b5e222bf51ca038cceaae.png	250	576	Approved	2024-05-31 11:46:11.849+00	2024-05-31 12:04:07.84+00	DemoUser	0.576
190	bankaccount	111w6w56w6	https://staging-api.jamesbondcasinoroyale.com/\n/api/user/832ace241f8c4d74157f50c9ee67e8dd.png	150	576	Approved	2024-05-31 11:45:33.17+00	2024-05-31 12:07:31.817+00	DemoUser	0.576
193	bankaccount	2233441234	https://staging-api.jamesbondcasinoroyale.com/\n/api/user/ccb67a95eae86166b395e7d8f3064956.jpeg	100	576	Approved	2024-05-31 12:13:31.296+00	2024-05-31 12:13:55.61+00	DemoUser	0.576
194	bankaccount	5635252315346	https://staging-api.jamesbondcasinoroyale.com/\n/api/user/dd757a7c5a8aead8dc9339be27acfcda.jpeg	554	576	pending	2024-05-31 12:17:44.245+00	2024-05-31 12:17:44.245+00	DemoUser	0.576
195	bankaccount	3850386854054564	https://staging-api.jamesbondcasinoroyale.com/\n/api/user/ccace636a6c1b8d3069e9f172916c573.png	75	576	Approved	2024-05-31 12:18:09.725+00	2024-05-31 13:00:53.044+00	DemoUser	0.576
\.


--
-- Data for Name: otps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.otps (id, code, attempt, lastsentat, retries, target, lastcodeverified, blocked, createdat, updatedat) FROM stdin;
\.


--
-- Data for Name: password_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_history (id, userid, remarks, createdat, updatedat, path) FROM stdin;
238	575	Password Changed By Self	2024-05-31 09:29:52.796+00	2024-05-31 09:29:52.797+00	0.575
239	577	Password Changed By Self	2024-05-31 09:51:53.261+00	2024-05-31 09:51:53.262+00	0.577
240	582	Password Changed By Self	2024-05-31 09:59:16.495+00	2024-05-31 09:59:16.495+00	0.575.582
241	584	Password Changed By Self	2024-05-31 10:18:17.244+00	2024-05-31 10:18:17.245+00	0.575.584
242	586	Password Changed By Self	2024-05-31 10:22:59.94+00	2024-05-31 10:22:59.94+00	0.575.586
243	587	Password Changed By Self	2024-05-31 10:31:07.181+00	2024-05-31 10:31:07.181+00	0.575.587
\.


--
-- Data for Name: settlement-transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."settlement-transactions" (id, "from", "to", amount, receiver_balance, betid, remark, ap, created_at, updated_at) FROM stdin;
11020	-1	593	100.00	500.00	4678	Soccer / N/A / Daejeon Korail FC v Ulsan Citizen FC / MATCH_ODDS	100	2024-05-31 11:55:33.035+00	2024-05-31 11:55:33.035+00
11021	-1	584	-10.00	1390.00	4678	Soccer / N/A / Daejeon Korail FC v Ulsan Citizen FC / MATCH_ODDS	10	2024-05-31 11:55:33.117+00	2024-05-31 11:55:33.117+00
11022	-1	575	-20.00	38980.00	4678	Soccer / N/A / Daejeon Korail FC v Ulsan Citizen FC / MATCH_ODDS	30	2024-05-31 11:55:33.146+00	2024-05-31 11:55:33.146+00
11023	-1	1	-70.00	9917478.00	4678	Soccer / N/A / Daejeon Korail FC v Ulsan Citizen FC / MATCH_ODDS	100	2024-05-31 11:55:33.16+00	2024-05-31 11:55:33.16+00
11024	-1	576	-100.00	12352.00	4662	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	100	2024-05-31 12:05:41.632+00	2024-05-31 12:05:41.632+00
11025	-1	1	100.00	9917578.00	4662	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	100	2024-05-31 12:05:41.738+00	2024-05-31 12:05:41.738+00
11026	-1	595	23.00	423.00	4684	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	100	2024-05-31 12:05:41.807+00	2024-05-31 12:05:41.807+00
11027	-1	584	-2.30	1387.70	4684	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	10	2024-05-31 12:05:41.815+00	2024-05-31 12:05:41.815+00
11028	-1	575	-4.60	38975.40	4684	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	30	2024-05-31 12:05:41.821+00	2024-05-31 12:05:41.821+00
11029	-1	1	-16.10	9917561.90	4684	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	100	2024-05-31 12:05:41.828+00	2024-05-31 12:05:41.828+00
11030	-1	576	100.00	12452.00	4663	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	100	2024-05-31 12:05:41.847+00	2024-05-31 12:05:41.847+00
11031	-1	1	-100.00	9917461.90	4663	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	100	2024-05-31 12:05:41.857+00	2024-05-31 12:05:41.857+00
11032	-1	578	-100.00	400.00	4689	Tennis / N/A / Linette/Pera v Moratelli/Rosatello / MATCH_ODDS	100	2024-05-31 12:18:13.512+00	2024-05-31 12:18:13.512+00
11033	-1	575	30.00	39005.40	4689	Tennis / N/A / Linette/Pera v Moratelli/Rosatello / MATCH_ODDS	30	2024-05-31 12:18:13.559+00	2024-05-31 12:18:13.559+00
11034	-1	1	70.00	9917584.90	4689	Tennis / N/A / Linette/Pera v Moratelli/Rosatello / MATCH_ODDS	100	2024-05-31 12:18:13.629+00	2024-05-31 12:18:13.629+00
11035	-1	592	-100.00	200.00	4676	Tennis / N/A / Goransson/Pel v Purcell/Thompson / MATCH_ODDS	100	2024-05-31 12:23:13.384+00	2024-05-31 12:23:13.384+00
11036	-1	584	10.00	1397.70	4676	Tennis / N/A / Goransson/Pel v Purcell/Thompson / MATCH_ODDS	10	2024-05-31 12:23:13.416+00	2024-05-31 12:23:13.416+00
11037	-1	575	20.00	39025.40	4676	Tennis / N/A / Goransson/Pel v Purcell/Thompson / MATCH_ODDS	30	2024-05-31 12:23:13.486+00	2024-05-31 12:23:13.486+00
11038	-1	1	70.00	9917654.90	4676	Tennis / N/A / Goransson/Pel v Purcell/Thompson / MATCH_ODDS	100	2024-05-31 12:23:13.52+00	2024-05-31 12:23:13.52+00
11039	-1	576	22.00	12971.00	4660	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	100	2024-05-31 12:35:13.395+00	2024-05-31 12:35:13.395+00
11040	-1	1	-22.00	9917082.90	4660	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	100	2024-05-31 12:35:13.402+00	2024-05-31 12:35:13.402+00
11041	-1	576	-27.00	12944.00	4661	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	100	2024-05-31 12:35:13.408+00	2024-05-31 12:35:13.408+00
11042	-1	1	27.00	9917109.90	4661	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	100	2024-05-31 12:35:13.413+00	2024-05-31 12:35:13.413+00
11043	-1	595	-50.00	373.00	4686	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	100	2024-05-31 12:35:13.425+00	2024-05-31 12:35:13.425+00
11044	-1	584	5.00	1402.70	4686	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	10	2024-05-31 12:35:13.43+00	2024-05-31 12:35:13.43+00
11045	-1	575	10.00	39035.40	4686	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	30	2024-05-31 12:35:13.436+00	2024-05-31 12:35:13.436+00
11046	-1	1	35.00	9917144.90	4686	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	100	2024-05-31 12:35:13.441+00	2024-05-31 12:35:13.441+00
11047	-1	576	-100.00	12844.00	4695	Soccer / N/A / Binh Duong v Ho Chi Minh City / MATCH_ODDS	100	2024-05-31 12:58:11.108+00	2024-05-31 12:58:11.108+00
11048	-1	1	100.00	9916044.90	4695	Soccer / N/A / Binh Duong v Ho Chi Minh City / MATCH_ODDS	100	2024-05-31 12:58:11.149+00	2024-05-31 12:58:11.149+00
11049	-1	594	100.00	600.00	4682	Soccer / N/A / Binh Duong v Ho Chi Minh City / MATCH_ODDS	100	2024-05-31 12:58:11.24+00	2024-05-31 12:58:11.24+00
11050	-1	584	-10.00	1392.70	4682	Soccer / N/A / Binh Duong v Ho Chi Minh City / MATCH_ODDS	10	2024-05-31 12:58:11.247+00	2024-05-31 12:58:11.247+00
11051	-1	575	-20.00	37515.40	4682	Soccer / N/A / Binh Duong v Ho Chi Minh City / MATCH_ODDS	30	2024-05-31 12:58:11.259+00	2024-05-31 12:58:11.259+00
11052	-1	1	-70.00	9915974.90	4682	Soccer / N/A / Binh Duong v Ho Chi Minh City / MATCH_ODDS	100	2024-05-31 12:58:11.266+00	2024-05-31 12:58:11.266+00
11053	-1	592	-100.00	100.00	4675	Soccer / N/A / Roma v AC Milan / MATCH_ODDS	100	2024-05-31 13:05:01.654+00	2024-05-31 13:05:01.654+00
11054	-1	584	10.00	11402.70	4675	Soccer / N/A / Roma v AC Milan / MATCH_ODDS	10	2024-05-31 13:05:01.694+00	2024-05-31 13:05:01.694+00
11055	-1	575	20.00	4535.40	4675	Soccer / N/A / Roma v AC Milan / MATCH_ODDS	30	2024-05-31 13:05:01.708+00	2024-05-31 13:05:01.708+00
11056	-1	1	70.00	9916044.90	4675	Soccer / N/A / Roma v AC Milan / MATCH_ODDS	100	2024-05-31 13:05:01.735+00	2024-05-31 13:05:01.735+00
11057	-1	578	100.00	2000.00	4688	Soccer / N/A / Roma v AC Milan / MATCH_ODDS	100	2024-05-31 13:05:01.789+00	2024-05-31 13:05:01.789+00
11058	-1	575	-30.00	4505.40	4688	Soccer / N/A / Roma v AC Milan / MATCH_ODDS	30	2024-05-31 13:05:01.797+00	2024-05-31 13:05:01.797+00
11059	-1	1	-70.00	9915974.90	4688	Soccer / N/A / Roma v AC Milan / MATCH_ODDS	100	2024-05-31 13:05:01.817+00	2024-05-31 13:05:01.817+00
11060	-1	595	-1.00	2372.00	4685	Tennis / N/A / Murkel Dellien v Stefano Travaglia / MATCH_ODDS	100	2024-05-31 13:30:53.296+00	2024-05-31 13:30:53.296+00
11061	-1	584	0.10	1902.80	4685	Tennis / N/A / Murkel Dellien v Stefano Travaglia / MATCH_ODDS	10	2024-05-31 13:30:53.352+00	2024-05-31 13:30:53.352+00
11062	-1	575	0.20	4505.60	4685	Tennis / N/A / Murkel Dellien v Stefano Travaglia / MATCH_ODDS	30	2024-05-31 13:30:53.414+00	2024-05-31 13:30:53.414+00
11063	-1	1	0.70	9915975.60	4685	Tennis / N/A / Murkel Dellien v Stefano Travaglia / MATCH_ODDS	100	2024-05-31 13:30:53.453+00	2024-05-31 13:30:53.453+00
11064	-1	581	430.00	1430.00	4711	Tennis / N/A / Doumbia/Reboul v Added/Arribage / MATCH_ODDS	100	2024-05-31 14:50:10.626+00	2024-05-31 14:50:10.626+00
11065	-1	575	-129.00	4376.60	4711	Tennis / N/A / Doumbia/Reboul v Added/Arribage / MATCH_ODDS	30	2024-05-31 14:50:10.67+00	2024-05-31 14:50:10.67+00
11066	-1	1	-301.00	9915674.60	4711	Tennis / N/A / Doumbia/Reboul v Added/Arribage / MATCH_ODDS	100	2024-05-31 14:50:10.747+00	2024-05-31 14:50:10.747+00
11067	-1	595	1220.00	3592.00	4697	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	100	2024-05-31 14:53:34.926+00	2024-05-31 14:53:34.926+00
11068	-1	584	-122.00	1780.80	4697	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	10	2024-05-31 14:53:35.075+00	2024-05-31 14:53:35.075+00
11069	-1	575	-244.00	4132.60	4697	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	30	2024-05-31 14:53:35.081+00	2024-05-31 14:53:35.081+00
11070	-1	1	-854.00	9914820.60	4697	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	100	2024-05-31 14:53:35.086+00	2024-05-31 14:53:35.086+00
11071	-1	578	-500.00	1500.00	4704	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	100	2024-05-31 14:53:35.102+00	2024-05-31 14:53:35.102+00
11072	-1	575	150.00	4282.60	4704	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	30	2024-05-31 14:53:35.107+00	2024-05-31 14:53:35.107+00
11073	-1	1	350.00	9915170.60	4704	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	100	2024-05-31 14:53:35.111+00	2024-05-31 14:53:35.111+00
11074	-1	579	-200.00	300.00	4706	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	100	2024-05-31 14:53:35.123+00	2024-05-31 14:53:35.123+00
11075	-1	575	60.00	4342.60	4706	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	30	2024-05-31 14:53:35.128+00	2024-05-31 14:53:35.128+00
11076	-1	1	140.00	9915310.60	4706	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	100	2024-05-31 14:53:35.134+00	2024-05-31 14:53:35.134+00
11077	-1	593	-500.00	3000.00	4699	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	100	2024-05-31 14:53:35.147+00	2024-05-31 14:53:35.147+00
11078	-1	584	50.00	1830.80	4699	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	10	2024-05-31 14:53:35.164+00	2024-05-31 14:53:35.164+00
11079	-1	575	100.00	4442.60	4699	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	30	2024-05-31 14:53:35.173+00	2024-05-31 14:53:35.173+00
11080	-1	1	350.00	9915660.60	4699	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	100	2024-05-31 14:53:35.178+00	2024-05-31 14:53:35.178+00
11081	-1	579	-160.00	140.00	4707	Tennis / N/A / Peers/Safiullin v Bhambri/Olivetti / MATCH_ODDS	100	2024-05-31 15:00:45.843+00	2024-05-31 15:00:45.843+00
11082	-1	575	48.00	4490.60	4707	Tennis / N/A / Peers/Safiullin v Bhambri/Olivetti / MATCH_ODDS	30	2024-05-31 15:00:45.932+00	2024-05-31 15:00:45.932+00
11083	-1	1	112.00	9915772.60	4707	Tennis / N/A / Peers/Safiullin v Bhambri/Olivetti / MATCH_ODDS	100	2024-05-31 15:00:45.939+00	2024-05-31 15:00:45.939+00
11084	-1	580	-200.00	600.00	4709	Tennis / N/A / Cornea/Darderi v Nys/Zielinski / MATCH_ODDS	100	2024-05-31 15:46:50.693+00	2024-05-31 15:46:50.693+00
11085	-1	575	60.00	4550.60	4709	Tennis / N/A / Cornea/Darderi v Nys/Zielinski / MATCH_ODDS	30	2024-05-31 15:46:50.728+00	2024-05-31 15:46:50.728+00
11086	-1	1	140.00	9915912.60	4709	Tennis / N/A / Cornea/Darderi v Nys/Zielinski / MATCH_ODDS	100	2024-05-31 15:46:50.854+00	2024-05-31 15:46:50.854+00
11087	-1	593	1000.00	4000.00	4700	Tennis / N/A / Cornea/Darderi v Nys/Zielinski / MATCH_ODDS	100	2024-05-31 15:46:50.878+00	2024-05-31 15:46:50.878+00
11088	-1	584	-100.00	1730.80	4700	Tennis / N/A / Cornea/Darderi v Nys/Zielinski / MATCH_ODDS	10	2024-05-31 15:46:50.888+00	2024-05-31 15:46:50.888+00
11089	-1	575	-200.00	4350.60	4700	Tennis / N/A / Cornea/Darderi v Nys/Zielinski / MATCH_ODDS	30	2024-05-31 15:46:50.894+00	2024-05-31 15:46:50.894+00
11090	-1	1	-700.00	9915212.60	4700	Tennis / N/A / Cornea/Darderi v Nys/Zielinski / MATCH_ODDS	100	2024-05-31 15:46:50.899+00	2024-05-31 15:46:50.899+00
11091	-1	594	-1740.00	1360.00	4702	Tennis / N/A / Anastasia Potapova v Xinyu Wang / MATCH_ODDS	100	2024-05-31 16:43:38.51+00	2024-05-31 16:43:38.51+00
11092	-1	584	174.00	1904.80	4702	Tennis / N/A / Anastasia Potapova v Xinyu Wang / MATCH_ODDS	10	2024-05-31 16:43:38.662+00	2024-05-31 16:43:38.662+00
11093	-1	575	348.00	4698.60	4702	Tennis / N/A / Anastasia Potapova v Xinyu Wang / MATCH_ODDS	30	2024-05-31 16:43:38.744+00	2024-05-31 16:43:38.744+00
11094	-1	1	1218.00	9916430.60	4702	Tennis / N/A / Anastasia Potapova v Xinyu Wang / MATCH_ODDS	100	2024-05-31 16:43:38.753+00	2024-05-31 16:43:38.753+00
11095	-1	594	-500.00	860.00	4701	Soccer / N/A / FK Dainava Alytus v Hegelmann Litauen / MATCH_ODDS	100	2024-05-31 17:53:11.068+00	2024-05-31 17:53:11.068+00
11096	-1	584	50.00	1954.80	4701	Soccer / N/A / FK Dainava Alytus v Hegelmann Litauen / MATCH_ODDS	10	2024-05-31 17:53:11.127+00	2024-05-31 17:53:11.127+00
11097	-1	575	100.00	4798.60	4701	Soccer / N/A / FK Dainava Alytus v Hegelmann Litauen / MATCH_ODDS	30	2024-05-31 17:53:11.167+00	2024-05-31 17:53:11.167+00
11098	-1	1	350.00	9916780.60	4701	Soccer / N/A / FK Dainava Alytus v Hegelmann Litauen / MATCH_ODDS	100	2024-05-31 17:53:11.172+00	2024-05-31 17:53:11.172+00
11099	-1	576	-100.00	12744.00	4696	Soccer / N/A / Norway (W) v Italy (W) / MATCH_ODDS	100	2024-05-31 17:56:52.02+00	2024-05-31 17:56:52.02+00
11100	-1	1	100.00	9916880.60	4696	Soccer / N/A / Norway (W) v Italy (W) / MATCH_ODDS	100	2024-05-31 17:56:52.082+00	2024-05-31 17:56:52.082+00
11101	-1	581	-500.00	930.00	4710	Cricket / N/A / Durham v Warwickshire / Match Odds	100	2024-05-31 20:04:57.665+00	2024-05-31 20:04:57.665+00
11102	-1	575	150.00	4948.60	4710	Cricket / N/A / Durham v Warwickshire / Match Odds	30	2024-05-31 20:04:57.889+00	2024-05-31 20:04:57.889+00
11103	-1	1	350.00	9917230.60	4710	Cricket / N/A / Durham v Warwickshire / Match Odds	100	2024-05-31 20:04:57.978+00	2024-05-31 20:04:57.978+00
11104	-1	592	72.00	2172.00	4674	Cricket / N/A / Durham v Warwickshire / Match Odds	100	2024-05-31 20:04:59.09+00	2024-05-31 20:04:59.09+00
11105	-1	584	-7.20	1947.60	4674	Cricket / N/A / Durham v Warwickshire / Match Odds	10	2024-05-31 20:04:59.119+00	2024-05-31 20:04:59.119+00
11106	-1	575	-14.40	4934.20	4674	Cricket / N/A / Durham v Warwickshire / Match Odds	30	2024-05-31 20:04:59.127+00	2024-05-31 20:04:59.127+00
11107	-1	1	-50.40	9917180.20	4674	Cricket / N/A / Durham v Warwickshire / Match Odds	100	2024-05-31 20:04:59.137+00	2024-05-31 20:04:59.137+00
11108	-1	576	-100.00	12644.00	4690	Cricket / N/A / Middlesex v Kent / Match Odds	100	2024-05-31 20:37:21.945+00	2024-05-31 20:37:21.945+00
11109	-1	1	100.00	9917280.20	4690	Cricket / N/A / Middlesex v Kent / Match Odds	100	2024-05-31 20:37:21.997+00	2024-05-31 20:37:21.997+00
11110	-1	593	-100.00	3900.00	4677	Cricket / N/A / Middlesex v Kent / Match Odds	100	2024-05-31 20:37:22.089+00	2024-05-31 20:37:22.089+00
11111	-1	584	10.00	1957.60	4677	Cricket / N/A / Middlesex v Kent / Match Odds	10	2024-05-31 20:37:22.098+00	2024-05-31 20:37:22.098+00
11112	-1	575	20.00	4954.20	4677	Cricket / N/A / Middlesex v Kent / Match Odds	30	2024-05-31 20:37:22.105+00	2024-05-31 20:37:22.105+00
11113	-1	1	70.00	9917350.20	4677	Cricket / N/A / Middlesex v Kent / Match Odds	100	2024-05-31 20:37:22.114+00	2024-05-31 20:37:22.114+00
11114	-1	603	100.00	500.00	4668	Cricket / N/A / Middlesex v Kent / Match Odds	100	2024-05-31 20:37:22.132+00	2024-05-31 20:37:22.132+00
11115	-1	587	-10.00	7090.00	4668	Cricket / N/A / Middlesex v Kent / Match Odds	10	2024-05-31 20:37:22.137+00	2024-05-31 20:37:22.137+00
11116	-1	575	-20.00	4934.20	4668	Cricket / N/A / Middlesex v Kent / Match Odds	30	2024-05-31 20:37:22.141+00	2024-05-31 20:37:22.141+00
11117	-1	1	-70.00	9917280.20	4668	Cricket / N/A / Middlesex v Kent / Match Odds	100	2024-05-31 20:37:22.146+00	2024-05-31 20:37:22.146+00
11118	-1	602	-80.00	220.00	4673	Cricket / N/A / Middlesex v Kent / Match Odds	100	2024-05-31 20:37:22.177+00	2024-05-31 20:37:22.177+00
11119	-1	587	8.00	7098.00	4673	Cricket / N/A / Middlesex v Kent / Match Odds	10	2024-05-31 20:37:22.183+00	2024-05-31 20:37:22.183+00
11120	-1	575	16.00	4950.20	4673	Cricket / N/A / Middlesex v Kent / Match Odds	30	2024-05-31 20:37:22.191+00	2024-05-31 20:37:22.191+00
11121	-1	1	56.00	9917336.20	4673	Cricket / N/A / Middlesex v Kent / Match Odds	100	2024-05-31 20:37:22.205+00	2024-05-31 20:37:22.205+00
11122	-1	603	42.00	542.00	4670	Soccer / N/A / Bolivia v Mexico / MATCH_ODDS	100	2024-06-01 03:28:57.076+00	2024-06-01 03:28:57.076+00
11123	-1	587	-4.20	7093.80	4670	Soccer / N/A / Bolivia v Mexico / MATCH_ODDS	10	2024-06-01 03:28:57.202+00	2024-06-01 03:28:57.202+00
11124	-1	575	-8.40	4941.80	4670	Soccer / N/A / Bolivia v Mexico / MATCH_ODDS	30	2024-06-01 03:28:57.218+00	2024-06-01 03:28:57.218+00
11125	-1	1	-29.40	9917306.80	4670	Soccer / N/A / Bolivia v Mexico / MATCH_ODDS	100	2024-06-01 03:28:57.258+00	2024-06-01 03:28:57.258+00
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (id, "from", "to", amount, remark, status, created_at, updated_at, sender_balance, receiver_balance, type) FROM stdin;
11758	1	575	20000.00	opening balance	1	2024-05-31 09:08:40.309+00	2024-05-31 09:08:40.309+00	9980000.00	20000.00	CREDIT
11759	1	576	1000.00	opening balance	1	2024-05-31 09:15:03.504+00	2024-05-31 09:15:03.504+00	9979000.00	1000.00	CREDIT
11760	1	577	20000.00	opening balance	1	2024-05-31 09:31:28.61+00	2024-05-31 09:31:28.61+00	9959000.00	20000.00	CREDIT
11761	575	578	500.00	opening balance	1	2024-05-31 09:49:34.195+00	2024-05-31 09:49:34.195+00	19500.00	500.00	CREDIT
11762	575	579	500.00	opening balance	1	2024-05-31 09:50:21.562+00	2024-05-31 09:50:21.562+00	19000.00	500.00	CREDIT
11763	575	580	800.00	opening balance	1	2024-05-31 09:50:53.855+00	2024-05-31 09:50:53.855+00	18200.00	800.00	CREDIT
11764	575	581	1000.00	opening balance	1	2024-05-31 09:51:13.317+00	2024-05-31 09:51:13.317+00	17200.00	1000.00	CREDIT
11765	575	582	2000.00	opening balance	1	2024-05-31 09:52:58.318+00	2024-05-31 09:52:58.318+00	15200.00	2000.00	CREDIT
11766	577	583	1000.00	opening balance	1	2024-05-31 09:53:42.93+00	2024-05-31 09:53:42.93+00	19000.00	1000.00	CREDIT
11767	575	584	3000.00	opening balance	1	2024-05-31 09:53:44.384+00	2024-05-31 09:53:44.384+00	12200.00	3000.00	CREDIT
11768	577	585	10000.00	opening balance	1	2024-05-31 09:54:20.685+00	2024-05-31 09:54:20.685+00	9000.00	10000.00	CREDIT
11769	575	586	2000.00	opening balance	1	2024-05-31 09:54:45.309+00	2024-05-31 09:54:45.309+00	10200.00	2000.00	CREDIT
11770	575	587	1200.00	opening balance	1	2024-05-31 09:55:18.458+00	2024-05-31 09:55:18.458+00	9000.00	1200.00	CREDIT
11771	583	577	3.00		1	2024-05-31 10:00:48.888+00	2024-05-31 10:00:48.888+00	997.00	9003.00	WITHDRAW
11772	577	583	2.00		1	2024-05-31 10:01:07.422+00	2024-05-31 10:01:07.422+00	9001.00	999.00	CREDIT
11773	582	588	300.00	opening balance	1	2024-05-31 10:01:30.55+00	2024-05-31 10:01:30.55+00	1700.00	300.00	CREDIT
11774	577	585	1.00		1	2024-05-31 10:02:05.264+00	2024-05-31 10:02:05.264+00	9000.00	10001.00	CREDIT
11775	585	577	1.50		1	2024-05-31 10:02:15.29+00	2024-05-31 10:02:15.29+00	9999.50	9001.50	WITHDRAW
11776	582	589	400.00	opening balance	1	2024-05-31 10:03:14.608+00	2024-05-31 10:03:14.608+00	1300.00	400.00	CREDIT
11777	582	590	200.00	opening balance	1	2024-05-31 10:03:40.993+00	2024-05-31 10:03:40.993+00	1100.00	200.00	CREDIT
11778	582	591	500.00	opening balance	1	2024-05-31 10:04:23.639+00	2024-05-31 10:04:23.639+00	600.00	500.00	CREDIT
11779	584	592	300.00	opening balance	1	2024-05-31 10:20:03.844+00	2024-05-31 10:20:03.844+00	2700.00	300.00	CREDIT
11780	584	593	400.00	opening balance	1	2024-05-31 10:20:25.794+00	2024-05-31 10:20:25.794+00	2300.00	400.00	CREDIT
11781	584	594	500.00	opening balance	1	2024-05-31 10:21:03.634+00	2024-05-31 10:21:03.634+00	1800.00	500.00	CREDIT
11782	584	595	400.00	opening balance	1	2024-05-31 10:21:37.206+00	2024-05-31 10:21:37.206+00	1400.00	400.00	CREDIT
11783	586	596	200.00	opening balance	1	2024-05-31 10:28:31.215+00	2024-05-31 10:28:31.215+00	1800.00	200.00	CREDIT
11784	586	597	300.00	opening balance	1	2024-05-31 10:28:58.987+00	2024-05-31 10:28:58.987+00	1500.00	300.00	CREDIT
11785	586	598	400.00	opening balance	1	2024-05-31 10:29:20.422+00	2024-05-31 10:29:20.422+00	1100.00	400.00	CREDIT
11786	586	599	400.00	opening balance	1	2024-05-31 10:29:47.618+00	2024-05-31 10:29:47.618+00	700.00	400.00	CREDIT
11787	587	600	100.00	opening balance	1	2024-05-31 10:32:45.164+00	2024-05-31 10:32:45.164+00	1100.00	100.00	CREDIT
11788	587	601	200.00	opening balance	1	2024-05-31 10:33:07.945+00	2024-05-31 10:33:07.945+00	900.00	200.00	CREDIT
11789	587	602	300.00	opening balance	1	2024-05-31 10:33:25.528+00	2024-05-31 10:33:25.528+00	600.00	300.00	CREDIT
11790	587	603	400.00	opening balance	1	2024-05-31 10:33:44.242+00	2024-05-31 10:33:44.242+00	200.00	400.00	CREDIT
11791	587	604	100.00	opening balance	1	2024-05-31 10:48:24.167+00	2024-05-31 10:48:24.167+00	100.00	100.00	CREDIT
11792	1	576	10000.00		1	2024-05-31 10:55:52.394+00	2024-05-31 10:55:52.394+00	9949000.00	11000.00	CREDIT
11793	1	576	101.00		1	2024-05-31 11:03:50.067+00	2024-05-31 11:03:50.067+00	9948899.00	11101.00	CREDIT
11794	576	1	101.00		1	2024-05-31 11:04:37.654+00	2024-05-31 11:04:37.654+00	11000.00	9949000.00	WITHDRAW
11795	576	1	102.00		1	2024-05-31 11:09:02.924+00	2024-05-31 11:09:02.924+00	10898.00	9949102.00	WITHDRAW
11796	576	1	102.00		1	2024-05-31 11:09:24.667+00	2024-05-31 11:09:24.667+00	10796.00	9949204.00	WITHDRAW
11797	576	1	102.00		1	2024-05-31 11:09:27.364+00	2024-05-31 11:09:27.364+00	10694.00	9949306.00	WITHDRAW
11798	576	1	102.00		1	2024-05-31 11:09:41.228+00	2024-05-31 11:09:41.228+00	10592.00	9949408.00	WITHDRAW
11799	576	1	102.00		1	2024-05-31 11:09:44.76+00	2024-05-31 11:09:44.76+00	10490.00	9949510.00	WITHDRAW
11800	576	1	102.00		1	2024-05-31 11:10:03.544+00	2024-05-31 11:10:03.544+00	10388.00	9949612.00	WITHDRAW
11801	576	1	102.00		1	2024-05-31 11:10:03.58+00	2024-05-31 11:10:03.58+00	10286.00	9949714.00	WITHDRAW
11802	576	1	102.00		1	2024-05-31 11:10:03.792+00	2024-05-31 11:10:03.792+00	10184.00	9949816.00	WITHDRAW
11803	576	1	102.00		1	2024-05-31 11:10:03.92+00	2024-05-31 11:10:03.92+00	10082.00	9949918.00	WITHDRAW
11804	1	575	30000.00		1	2024-05-31 11:19:54.113+00	2024-05-31 11:19:54.113+00	9919918.00	39000.00	CREDIT
11805	1	576	101.00		1	2024-05-31 11:32:33.204+00	2024-05-31 11:32:33.204+00	9919817.00	10183.00	CREDIT
11806	1	576	101.00		1	2024-05-31 11:32:33.287+00	2024-05-31 11:32:33.287+00	9919716.00	10284.00	CREDIT
11807	1	576	101.00		1	2024-05-31 11:32:33.423+00	2024-05-31 11:32:33.423+00	9919615.00	10385.00	CREDIT
11808	1	576	101.00		1	2024-05-31 11:32:35.606+00	2024-05-31 11:32:35.606+00	9919514.00	10486.00	CREDIT
11809	1	576	101.00		1	2024-05-31 11:32:35.624+00	2024-05-31 11:32:35.624+00	9919514.00	10486.00	CREDIT
11810	1	576	101.00		1	2024-05-31 11:32:35.665+00	2024-05-31 11:32:35.665+00	9919312.00	10688.00	CREDIT
11811	1	576	101.00		1	2024-05-31 11:32:37.589+00	2024-05-31 11:32:37.589+00	9919211.00	10789.00	CREDIT
11812	1	576	101.00		1	2024-05-31 11:32:50.986+00	2024-05-31 11:32:50.986+00	9919110.00	10890.00	CREDIT
11813	1	576	101.00		1	2024-05-31 11:32:51.007+00	2024-05-31 11:32:51.007+00	9919009.00	10991.00	CREDIT
11814	1	576	101.00		1	2024-05-31 11:32:51.189+00	2024-05-31 11:32:51.189+00	9918908.00	11092.00	CREDIT
11815	1	576	101.00		1	2024-05-31 11:33:05.504+00	2024-05-31 11:33:05.504+00	9918807.00	11193.00	CREDIT
11816	1	576	101.00		1	2024-05-31 11:33:05.64+00	2024-05-31 11:33:05.64+00	9918706.00	11294.00	CREDIT
11817	1	576	101.00		1	2024-05-31 11:33:05.705+00	2024-05-31 11:33:05.705+00	9918605.00	11395.00	CREDIT
11818	1	576	101.00		1	2024-05-31 11:33:05.853+00	2024-05-31 11:33:05.853+00	9918504.00	11496.00	CREDIT
11819	1	576	101.00		1	2024-05-31 11:33:06.182+00	2024-05-31 11:33:06.182+00	9918403.00	11597.00	CREDIT
11820	1	576	101.00		1	2024-05-31 11:33:06.332+00	2024-05-31 11:33:06.332+00	9918302.00	11698.00	CREDIT
11821	1	576	101.00		1	2024-05-31 11:33:06.888+00	2024-05-31 11:33:06.888+00	9918201.00	11799.00	CREDIT
11822	1	576	101.00		1	2024-05-31 11:33:07.06+00	2024-05-31 11:33:07.06+00	9918100.00	11900.00	CREDIT
11823	1	576	101.00		1	2024-05-31 11:33:13.277+00	2024-05-31 11:33:13.277+00	9917999.00	12001.00	CREDIT
11824	1	576	101.00		1	2024-05-31 11:33:13.42+00	2024-05-31 11:33:13.42+00	9917898.00	12102.00	CREDIT
11825	1	576	150.00		1	2024-05-31 11:35:26.369+00	2024-05-31 11:35:26.369+00	9917748.00	12252.00	CREDIT
11826	1	576	150.00		1	2024-05-31 11:35:28.887+00	2024-05-31 11:35:28.887+00	9917598.00	12402.00	CREDIT
11827	1	576	150.00		1	2024-05-31 11:35:32.313+00	2024-05-31 11:35:32.313+00	9917448.00	12552.00	CREDIT
11828	1	576	150.00		1	2024-05-31 11:35:32.967+00	2024-05-31 11:35:32.967+00	9917298.00	12702.00	CREDIT
11829	1	576	150.00		1	2024-05-31 11:35:33.585+00	2024-05-31 11:35:33.585+00	9917148.00	12852.00	CREDIT
11830	1	576	150.00		1	2024-05-31 11:35:36.616+00	2024-05-31 11:35:36.616+00	9916998.00	13002.00	CREDIT
11831	1	576	150.00		1	2024-05-31 11:35:37.157+00	2024-05-31 11:35:37.157+00	9916848.00	13152.00	CREDIT
11832	1	576	150.00		1	2024-05-31 11:35:37.65+00	2024-05-31 11:35:37.65+00	9916698.00	13302.00	CREDIT
11833	1	576	150.00		1	2024-05-31 11:35:37.73+00	2024-05-31 11:35:37.73+00	9916548.00	13452.00	CREDIT
11834	576	1	250.00		1	2024-05-31 11:39:48.579+00	2024-05-31 11:39:48.579+00	13202.00	9916798.00	WITHDRAW
11835	576	1	250.00		1	2024-05-31 11:39:48.603+00	2024-05-31 11:39:48.603+00	12952.00	9917048.00	WITHDRAW
11836	576	1	250.00		1	2024-05-31 11:39:53.06+00	2024-05-31 11:39:53.06+00	12702.00	9917298.00	WITHDRAW
11837	576	1	250.00		1	2024-05-31 11:39:56.169+00	2024-05-31 11:39:56.169+00	12452.00	9917548.00	WITHDRAW
11838	-1	593	100.00	Soccer / N/A / Daejeon Korail FC v Ulsan Citizen FC / MATCH_ODDS	1	2024-05-31 11:55:33.036+00	2024-05-31 11:55:33.036+00	0.00	500.00	BALANCE
11839	-1	584	-10.00	Soccer / N/A / Daejeon Korail FC v Ulsan Citizen FC / MATCH_ODDS	1	2024-05-31 11:55:33.117+00	2024-05-31 11:55:33.117+00	0.00	1390.00	BALANCE
11840	-1	575	-20.00	Soccer / N/A / Daejeon Korail FC v Ulsan Citizen FC / MATCH_ODDS	1	2024-05-31 11:55:33.146+00	2024-05-31 11:55:33.146+00	0.00	38980.00	BALANCE
11841	-1	1	-70.00	Soccer / N/A / Daejeon Korail FC v Ulsan Citizen FC / MATCH_ODDS	1	2024-05-31 11:55:33.16+00	2024-05-31 11:55:33.16+00	0.00	9917478.00	BALANCE
11842	-1	576	-100.00	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	1	2024-05-31 12:05:41.632+00	2024-05-31 12:05:41.632+00	0.00	12352.00	BALANCE
11843	-1	1	100.00	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	1	2024-05-31 12:05:41.738+00	2024-05-31 12:05:41.738+00	0.00	9917578.00	BALANCE
11844	-1	595	23.00	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	1	2024-05-31 12:05:41.807+00	2024-05-31 12:05:41.807+00	0.00	423.00	BALANCE
11845	-1	584	-2.30	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	1	2024-05-31 12:05:41.815+00	2024-05-31 12:05:41.815+00	0.00	1387.70	BALANCE
11846	-1	575	-4.60	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	1	2024-05-31 12:05:41.821+00	2024-05-31 12:05:41.821+00	0.00	38975.40	BALANCE
11847	-1	1	-16.10	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	1	2024-05-31 12:05:41.828+00	2024-05-31 12:05:41.828+00	0.00	9917561.90	BALANCE
11848	-1	576	100.00	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	1	2024-05-31 12:05:41.847+00	2024-05-31 12:05:41.847+00	0.00	12452.00	BALANCE
11849	-1	1	-100.00	Soccer / N/A / Tosu v FC Tokyo / MATCH_ODDS	1	2024-05-31 12:05:41.857+00	2024-05-31 12:05:41.857+00	0.00	9917461.90	BALANCE
11850	1	576	150.00		1	2024-05-31 12:07:31.804+00	2024-05-31 12:07:31.804+00	9917311.90	12602.00	CREDIT
11851	576	1	102.00		1	2024-05-31 12:08:49.485+00	2024-05-31 12:08:49.485+00	12500.00	9917413.90	WITHDRAW
11852	576	1	101.00		1	2024-05-31 12:11:45.247+00	2024-05-31 12:11:45.247+00	12399.00	9917514.90	WITHDRAW
11853	-1	578	-100.00	Tennis / N/A / Linette/Pera v Moratelli/Rosatello / MATCH_ODDS	1	2024-05-31 12:18:13.512+00	2024-05-31 12:18:13.512+00	0.00	400.00	BALANCE
11854	-1	575	30.00	Tennis / N/A / Linette/Pera v Moratelli/Rosatello / MATCH_ODDS	1	2024-05-31 12:18:13.56+00	2024-05-31 12:18:13.56+00	0.00	39005.40	BALANCE
11855	-1	1	70.00	Tennis / N/A / Linette/Pera v Moratelli/Rosatello / MATCH_ODDS	1	2024-05-31 12:18:13.63+00	2024-05-31 12:18:13.63+00	0.00	9917584.90	BALANCE
11856	-1	592	-100.00	Tennis / N/A / Goransson/Pel v Purcell/Thompson / MATCH_ODDS	1	2024-05-31 12:23:13.384+00	2024-05-31 12:23:13.384+00	0.00	200.00	BALANCE
11857	-1	584	10.00	Tennis / N/A / Goransson/Pel v Purcell/Thompson / MATCH_ODDS	1	2024-05-31 12:23:13.417+00	2024-05-31 12:23:13.417+00	0.00	1397.70	BALANCE
11858	-1	575	20.00	Tennis / N/A / Goransson/Pel v Purcell/Thompson / MATCH_ODDS	1	2024-05-31 12:23:13.486+00	2024-05-31 12:23:13.486+00	0.00	39025.40	BALANCE
11859	-1	1	70.00	Tennis / N/A / Goransson/Pel v Purcell/Thompson / MATCH_ODDS	1	2024-05-31 12:23:13.521+00	2024-05-31 12:23:13.521+00	0.00	9917654.90	BALANCE
11860	1	576	100.00	Add on	1	2024-05-31 12:26:11.402+00	2024-05-31 12:26:11.402+00	9917554.90	12499.00	CREDIT
11861	576	1	100.00	Deb	1	2024-05-31 12:26:24.368+00	2024-05-31 12:26:24.368+00	12399.00	9917654.90	WITHDRAW
11862	1	576	100.00	Deb	1	2024-05-31 12:26:42.337+00	2024-05-31 12:26:42.337+00	9917554.90	12499.00	CREDIT
11863	1	576	100.00	Deb	1	2024-05-31 12:26:42.381+00	2024-05-31 12:26:42.381+00	9917454.90	12599.00	CREDIT
11864	1	576	150.00	Deb	1	2024-05-31 12:27:28.064+00	2024-05-31 12:27:28.064+00	9917304.90	12749.00	CREDIT
11865	1	576	100.00	Add on	1	2024-05-31 12:27:56.522+00	2024-05-31 12:27:56.522+00	9917204.90	12849.00	CREDIT
11866	1	576	100.00	Add on	1	2024-05-31 12:27:56.593+00	2024-05-31 12:27:56.593+00	9917104.90	12949.00	CREDIT
11867	-1	576	22.00	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	1	2024-05-31 12:35:13.395+00	2024-05-31 12:35:13.395+00	0.00	12971.00	BALANCE
11868	-1	1	-22.00	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	1	2024-05-31 12:35:13.402+00	2024-05-31 12:35:13.402+00	0.00	9917082.90	BALANCE
11869	-1	576	-27.00	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	1	2024-05-31 12:35:13.408+00	2024-05-31 12:35:13.408+00	0.00	12944.00	BALANCE
11870	-1	1	27.00	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	1	2024-05-31 12:35:13.413+00	2024-05-31 12:35:13.413+00	0.00	9917109.90	BALANCE
11871	-1	595	-50.00	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	1	2024-05-31 12:35:13.425+00	2024-05-31 12:35:13.425+00	0.00	373.00	BALANCE
11872	-1	584	5.00	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	1	2024-05-31 12:35:13.43+00	2024-05-31 12:35:13.43+00	0.00	1402.70	BALANCE
11873	-1	575	10.00	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	1	2024-05-31 12:35:13.436+00	2024-05-31 12:35:13.436+00	0.00	39035.40	BALANCE
11874	-1	1	35.00	Tennis / N/A / Matos/Melo v Frantzen/Jebens / MATCH_ODDS	1	2024-05-31 12:35:13.442+00	2024-05-31 12:35:13.442+00	0.00	9917144.90	BALANCE
11875	1	605	1000.00	opening balance	1	2024-05-31 12:35:34.268+00	2024-05-31 12:35:34.268+00	9916144.90	1000.00	CREDIT
11876	1	605	100.00	Bond007	1	2024-05-31 12:36:05.032+00	2024-05-31 12:36:05.032+00	9916044.90	1100.00	CREDIT
11877	1	605	100.00	Bond007	1	2024-05-31 12:36:05.187+00	2024-05-31 12:36:05.187+00	9915944.90	1200.00	CREDIT
11878	575	578	2000.00		1	2024-05-31 12:43:55.74+00	2024-05-31 12:43:55.74+00	37035.40	2400.00	CREDIT
11879	578	575	500.00		1	2024-05-31 12:44:46.359+00	2024-05-31 12:44:46.359+00	1900.00	37535.40	WITHDRAW
11880	-1	576	-100.00	Soccer / N/A / Binh Duong v Ho Chi Minh City / MATCH_ODDS	1	2024-05-31 12:58:11.108+00	2024-05-31 12:58:11.108+00	0.00	12844.00	BALANCE
11881	-1	1	100.00	Soccer / N/A / Binh Duong v Ho Chi Minh City / MATCH_ODDS	1	2024-05-31 12:58:11.149+00	2024-05-31 12:58:11.149+00	0.00	9916044.90	BALANCE
11882	-1	594	100.00	Soccer / N/A / Binh Duong v Ho Chi Minh City / MATCH_ODDS	1	2024-05-31 12:58:11.24+00	2024-05-31 12:58:11.24+00	0.00	600.00	BALANCE
11883	-1	584	-10.00	Soccer / N/A / Binh Duong v Ho Chi Minh City / MATCH_ODDS	1	2024-05-31 12:58:11.247+00	2024-05-31 12:58:11.247+00	0.00	1392.70	BALANCE
11884	-1	575	-20.00	Soccer / N/A / Binh Duong v Ho Chi Minh City / MATCH_ODDS	1	2024-05-31 12:58:11.259+00	2024-05-31 12:58:11.259+00	0.00	37515.40	BALANCE
11885	-1	1	-70.00	Soccer / N/A / Binh Duong v Ho Chi Minh City / MATCH_ODDS	1	2024-05-31 12:58:11.266+00	2024-05-31 12:58:11.266+00	0.00	9915974.90	BALANCE
11886	575	582	6000.00	Bet	1	2024-05-31 12:58:32.547+00	2024-05-31 12:58:32.547+00	31515.40	6600.00	CREDIT
11887	575	584	10000.00	Bet	1	2024-05-31 12:59:06.13+00	2024-05-31 12:59:06.13+00	21515.40	11392.70	CREDIT
11888	575	586	10000.00	Bet	1	2024-05-31 12:59:28.625+00	2024-05-31 12:59:28.625+00	11515.40	10700.00	CREDIT
11889	575	587	7000.00	Bet	1	2024-05-31 13:00:06.666+00	2024-05-31 13:00:06.666+00	4515.40	7100.00	CREDIT
11890	-1	592	-100.00	Soccer / N/A / Roma v AC Milan / MATCH_ODDS	1	2024-05-31 13:05:01.655+00	2024-05-31 13:05:01.655+00	0.00	100.00	BALANCE
11891	-1	584	10.00	Soccer / N/A / Roma v AC Milan / MATCH_ODDS	1	2024-05-31 13:05:01.694+00	2024-05-31 13:05:01.694+00	0.00	11402.70	BALANCE
11892	-1	575	20.00	Soccer / N/A / Roma v AC Milan / MATCH_ODDS	1	2024-05-31 13:05:01.708+00	2024-05-31 13:05:01.708+00	0.00	4535.40	BALANCE
11893	-1	1	70.00	Soccer / N/A / Roma v AC Milan / MATCH_ODDS	1	2024-05-31 13:05:01.736+00	2024-05-31 13:05:01.736+00	0.00	9916044.90	BALANCE
11894	-1	578	100.00	Soccer / N/A / Roma v AC Milan / MATCH_ODDS	1	2024-05-31 13:05:01.79+00	2024-05-31 13:05:01.79+00	0.00	2000.00	BALANCE
11895	-1	575	-30.00	Soccer / N/A / Roma v AC Milan / MATCH_ODDS	1	2024-05-31 13:05:01.797+00	2024-05-31 13:05:01.797+00	0.00	4505.40	BALANCE
11896	-1	1	-70.00	Soccer / N/A / Roma v AC Milan / MATCH_ODDS	1	2024-05-31 13:05:01.817+00	2024-05-31 13:05:01.817+00	0.00	9915974.90	BALANCE
11897	584	592	2000.00	Bet	1	2024-05-31 13:12:30.559+00	2024-05-31 13:12:30.559+00	9402.70	2100.00	CREDIT
11898	584	593	3000.00	Bet	1	2024-05-31 13:12:59.514+00	2024-05-31 13:12:59.514+00	6402.70	3500.00	CREDIT
11899	584	594	2500.00	Bet	1	2024-05-31 13:13:40.098+00	2024-05-31 13:13:40.098+00	3902.70	3100.00	CREDIT
11900	584	595	2000.00	Bet	1	2024-05-31 13:14:23.988+00	2024-05-31 13:14:23.988+00	1902.70	2373.00	CREDIT
11901	-1	595	-1.00	Tennis / N/A / Murkel Dellien v Stefano Travaglia / MATCH_ODDS	1	2024-05-31 13:30:53.296+00	2024-05-31 13:30:53.296+00	0.00	2372.00	BALANCE
11902	-1	584	0.10	Tennis / N/A / Murkel Dellien v Stefano Travaglia / MATCH_ODDS	1	2024-05-31 13:30:53.352+00	2024-05-31 13:30:53.352+00	0.00	1902.80	BALANCE
11903	-1	575	0.20	Tennis / N/A / Murkel Dellien v Stefano Travaglia / MATCH_ODDS	1	2024-05-31 13:30:53.414+00	2024-05-31 13:30:53.414+00	0.00	4505.60	BALANCE
11904	-1	1	0.70	Tennis / N/A / Murkel Dellien v Stefano Travaglia / MATCH_ODDS	1	2024-05-31 13:30:53.453+00	2024-05-31 13:30:53.453+00	0.00	9915975.60	BALANCE
11905	-1	581	430.00	Tennis / N/A / Doumbia/Reboul v Added/Arribage / MATCH_ODDS	1	2024-05-31 14:50:10.626+00	2024-05-31 14:50:10.626+00	0.00	1430.00	BALANCE
11906	-1	575	-129.00	Tennis / N/A / Doumbia/Reboul v Added/Arribage / MATCH_ODDS	1	2024-05-31 14:50:10.67+00	2024-05-31 14:50:10.67+00	0.00	4376.60	BALANCE
11907	-1	1	-301.00	Tennis / N/A / Doumbia/Reboul v Added/Arribage / MATCH_ODDS	1	2024-05-31 14:50:10.747+00	2024-05-31 14:50:10.747+00	0.00	9915674.60	BALANCE
11908	-1	595	1220.00	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	1	2024-05-31 14:53:34.926+00	2024-05-31 14:53:34.926+00	0.00	3592.00	BALANCE
11909	-1	584	-122.00	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	1	2024-05-31 14:53:35.075+00	2024-05-31 14:53:35.075+00	0.00	1780.80	BALANCE
11910	-1	575	-244.00	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	1	2024-05-31 14:53:35.082+00	2024-05-31 14:53:35.082+00	0.00	4132.60	BALANCE
11911	-1	1	-854.00	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	1	2024-05-31 14:53:35.087+00	2024-05-31 14:53:35.087+00	0.00	9914820.60	BALANCE
11912	-1	578	-500.00	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	1	2024-05-31 14:53:35.102+00	2024-05-31 14:53:35.102+00	0.00	1500.00	BALANCE
11913	-1	575	150.00	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	1	2024-05-31 14:53:35.107+00	2024-05-31 14:53:35.107+00	0.00	4282.60	BALANCE
11914	-1	1	350.00	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	1	2024-05-31 14:53:35.112+00	2024-05-31 14:53:35.112+00	0.00	9915170.60	BALANCE
11915	-1	579	-200.00	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	1	2024-05-31 14:53:35.123+00	2024-05-31 14:53:35.123+00	0.00	300.00	BALANCE
11916	-1	575	60.00	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	1	2024-05-31 14:53:35.128+00	2024-05-31 14:53:35.128+00	0.00	4342.60	BALANCE
11917	-1	1	140.00	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	1	2024-05-31 14:53:35.134+00	2024-05-31 14:53:35.134+00	0.00	9915310.60	BALANCE
11918	-1	593	-500.00	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	1	2024-05-31 14:53:35.147+00	2024-05-31 14:53:35.147+00	0.00	3000.00	BALANCE
11919	-1	584	50.00	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	1	2024-05-31 14:53:35.164+00	2024-05-31 14:53:35.164+00	0.00	1830.80	BALANCE
11920	-1	575	100.00	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	1	2024-05-31 14:53:35.173+00	2024-05-31 14:53:35.173+00	0.00	4442.60	BALANCE
11921	-1	1	350.00	Soccer / N/A / Armenia (W) v Kazakhstan (W) / MATCH_ODDS	1	2024-05-31 14:53:35.179+00	2024-05-31 14:53:35.179+00	0.00	9915660.60	BALANCE
11922	-1	579	-160.00	Tennis / N/A / Peers/Safiullin v Bhambri/Olivetti / MATCH_ODDS	1	2024-05-31 15:00:45.844+00	2024-05-31 15:00:45.844+00	0.00	140.00	BALANCE
11923	-1	575	48.00	Tennis / N/A / Peers/Safiullin v Bhambri/Olivetti / MATCH_ODDS	1	2024-05-31 15:00:45.932+00	2024-05-31 15:00:45.932+00	0.00	4490.60	BALANCE
11924	-1	1	112.00	Tennis / N/A / Peers/Safiullin v Bhambri/Olivetti / MATCH_ODDS	1	2024-05-31 15:00:45.939+00	2024-05-31 15:00:45.939+00	0.00	9915772.60	BALANCE
11925	-1	580	-200.00	Tennis / N/A / Cornea/Darderi v Nys/Zielinski / MATCH_ODDS	1	2024-05-31 15:46:50.693+00	2024-05-31 15:46:50.693+00	0.00	600.00	BALANCE
11926	-1	575	60.00	Tennis / N/A / Cornea/Darderi v Nys/Zielinski / MATCH_ODDS	1	2024-05-31 15:46:50.728+00	2024-05-31 15:46:50.728+00	0.00	4550.60	BALANCE
11927	-1	1	140.00	Tennis / N/A / Cornea/Darderi v Nys/Zielinski / MATCH_ODDS	1	2024-05-31 15:46:50.855+00	2024-05-31 15:46:50.855+00	0.00	9915912.60	BALANCE
11928	-1	593	1000.00	Tennis / N/A / Cornea/Darderi v Nys/Zielinski / MATCH_ODDS	1	2024-05-31 15:46:50.878+00	2024-05-31 15:46:50.878+00	0.00	4000.00	BALANCE
11929	-1	584	-100.00	Tennis / N/A / Cornea/Darderi v Nys/Zielinski / MATCH_ODDS	1	2024-05-31 15:46:50.888+00	2024-05-31 15:46:50.888+00	0.00	1730.80	BALANCE
11930	-1	575	-200.00	Tennis / N/A / Cornea/Darderi v Nys/Zielinski / MATCH_ODDS	1	2024-05-31 15:46:50.894+00	2024-05-31 15:46:50.894+00	0.00	4350.60	BALANCE
11931	-1	1	-700.00	Tennis / N/A / Cornea/Darderi v Nys/Zielinski / MATCH_ODDS	1	2024-05-31 15:46:50.9+00	2024-05-31 15:46:50.9+00	0.00	9915212.60	BALANCE
11932	-1	594	-1740.00	Tennis / N/A / Anastasia Potapova v Xinyu Wang / MATCH_ODDS	1	2024-05-31 16:43:38.51+00	2024-05-31 16:43:38.51+00	0.00	1360.00	BALANCE
11933	-1	584	174.00	Tennis / N/A / Anastasia Potapova v Xinyu Wang / MATCH_ODDS	1	2024-05-31 16:43:38.662+00	2024-05-31 16:43:38.662+00	0.00	1904.80	BALANCE
11934	-1	575	348.00	Tennis / N/A / Anastasia Potapova v Xinyu Wang / MATCH_ODDS	1	2024-05-31 16:43:38.744+00	2024-05-31 16:43:38.744+00	0.00	4698.60	BALANCE
11935	-1	1	1218.00	Tennis / N/A / Anastasia Potapova v Xinyu Wang / MATCH_ODDS	1	2024-05-31 16:43:38.753+00	2024-05-31 16:43:38.753+00	0.00	9916430.60	BALANCE
11936	-1	594	-500.00	Soccer / N/A / FK Dainava Alytus v Hegelmann Litauen / MATCH_ODDS	1	2024-05-31 17:53:11.069+00	2024-05-31 17:53:11.069+00	0.00	860.00	BALANCE
11937	-1	584	50.00	Soccer / N/A / FK Dainava Alytus v Hegelmann Litauen / MATCH_ODDS	1	2024-05-31 17:53:11.127+00	2024-05-31 17:53:11.127+00	0.00	1954.80	BALANCE
11938	-1	575	100.00	Soccer / N/A / FK Dainava Alytus v Hegelmann Litauen / MATCH_ODDS	1	2024-05-31 17:53:11.167+00	2024-05-31 17:53:11.167+00	0.00	4798.60	BALANCE
11939	-1	1	350.00	Soccer / N/A / FK Dainava Alytus v Hegelmann Litauen / MATCH_ODDS	1	2024-05-31 17:53:11.172+00	2024-05-31 17:53:11.172+00	0.00	9916780.60	BALANCE
11940	-1	576	-100.00	Soccer / N/A / Norway (W) v Italy (W) / MATCH_ODDS	1	2024-05-31 17:56:52.02+00	2024-05-31 17:56:52.02+00	0.00	12744.00	BALANCE
11941	-1	1	100.00	Soccer / N/A / Norway (W) v Italy (W) / MATCH_ODDS	1	2024-05-31 17:56:52.082+00	2024-05-31 17:56:52.082+00	0.00	9916880.60	BALANCE
11942	-1	581	-500.00	Cricket / N/A / Durham v Warwickshire / Match Odds	1	2024-05-31 20:04:57.665+00	2024-05-31 20:04:57.665+00	0.00	930.00	BALANCE
11943	-1	575	150.00	Cricket / N/A / Durham v Warwickshire / Match Odds	1	2024-05-31 20:04:57.89+00	2024-05-31 20:04:57.89+00	0.00	4948.60	BALANCE
11944	-1	1	350.00	Cricket / N/A / Durham v Warwickshire / Match Odds	1	2024-05-31 20:04:57.978+00	2024-05-31 20:04:57.978+00	0.00	9917230.60	BALANCE
11945	-1	592	72.00	Cricket / N/A / Durham v Warwickshire / Match Odds	1	2024-05-31 20:04:59.091+00	2024-05-31 20:04:59.091+00	0.00	2172.00	BALANCE
11946	-1	584	-7.20	Cricket / N/A / Durham v Warwickshire / Match Odds	1	2024-05-31 20:04:59.119+00	2024-05-31 20:04:59.119+00	0.00	1947.60	BALANCE
11947	-1	575	-14.40	Cricket / N/A / Durham v Warwickshire / Match Odds	1	2024-05-31 20:04:59.127+00	2024-05-31 20:04:59.127+00	0.00	4934.20	BALANCE
11948	-1	1	-50.40	Cricket / N/A / Durham v Warwickshire / Match Odds	1	2024-05-31 20:04:59.138+00	2024-05-31 20:04:59.138+00	0.00	9917180.20	BALANCE
11949	-1	576	-100.00	Cricket / N/A / Middlesex v Kent / Match Odds	1	2024-05-31 20:37:21.945+00	2024-05-31 20:37:21.945+00	0.00	12644.00	BALANCE
11950	-1	1	100.00	Cricket / N/A / Middlesex v Kent / Match Odds	1	2024-05-31 20:37:21.997+00	2024-05-31 20:37:21.997+00	0.00	9917280.20	BALANCE
11951	-1	593	-100.00	Cricket / N/A / Middlesex v Kent / Match Odds	1	2024-05-31 20:37:22.089+00	2024-05-31 20:37:22.089+00	0.00	3900.00	BALANCE
11952	-1	584	10.00	Cricket / N/A / Middlesex v Kent / Match Odds	1	2024-05-31 20:37:22.098+00	2024-05-31 20:37:22.098+00	0.00	1957.60	BALANCE
11953	-1	575	20.00	Cricket / N/A / Middlesex v Kent / Match Odds	1	2024-05-31 20:37:22.105+00	2024-05-31 20:37:22.105+00	0.00	4954.20	BALANCE
11954	-1	1	70.00	Cricket / N/A / Middlesex v Kent / Match Odds	1	2024-05-31 20:37:22.115+00	2024-05-31 20:37:22.115+00	0.00	9917350.20	BALANCE
11955	-1	603	100.00	Cricket / N/A / Middlesex v Kent / Match Odds	1	2024-05-31 20:37:22.132+00	2024-05-31 20:37:22.132+00	0.00	500.00	BALANCE
11956	-1	587	-10.00	Cricket / N/A / Middlesex v Kent / Match Odds	1	2024-05-31 20:37:22.137+00	2024-05-31 20:37:22.137+00	0.00	7090.00	BALANCE
11957	-1	575	-20.00	Cricket / N/A / Middlesex v Kent / Match Odds	1	2024-05-31 20:37:22.141+00	2024-05-31 20:37:22.141+00	0.00	4934.20	BALANCE
11958	-1	1	-70.00	Cricket / N/A / Middlesex v Kent / Match Odds	1	2024-05-31 20:37:22.146+00	2024-05-31 20:37:22.146+00	0.00	9917280.20	BALANCE
11959	-1	602	-80.00	Cricket / N/A / Middlesex v Kent / Match Odds	1	2024-05-31 20:37:22.177+00	2024-05-31 20:37:22.177+00	0.00	220.00	BALANCE
11960	-1	587	8.00	Cricket / N/A / Middlesex v Kent / Match Odds	1	2024-05-31 20:37:22.183+00	2024-05-31 20:37:22.183+00	0.00	7098.00	BALANCE
11961	-1	575	16.00	Cricket / N/A / Middlesex v Kent / Match Odds	1	2024-05-31 20:37:22.191+00	2024-05-31 20:37:22.191+00	0.00	4950.20	BALANCE
11962	-1	1	56.00	Cricket / N/A / Middlesex v Kent / Match Odds	1	2024-05-31 20:37:22.205+00	2024-05-31 20:37:22.205+00	0.00	9917336.20	BALANCE
11963	-1	603	42.00	Soccer / N/A / Bolivia v Mexico / MATCH_ODDS	1	2024-06-01 03:28:57.076+00	2024-06-01 03:28:57.076+00	0.00	542.00	BALANCE
11964	-1	587	-4.20	Soccer / N/A / Bolivia v Mexico / MATCH_ODDS	1	2024-06-01 03:28:57.202+00	2024-06-01 03:28:57.202+00	0.00	7093.80	BALANCE
11965	-1	575	-8.40	Soccer / N/A / Bolivia v Mexico / MATCH_ODDS	1	2024-06-01 03:28:57.218+00	2024-06-01 03:28:57.218+00	0.00	4941.80	BALANCE
11966	-1	1	-29.40	Soccer / N/A / Bolivia v Mexico / MATCH_ODDS	1	2024-06-01 03:28:57.258+00	2024-06-01 03:28:57.258+00	0.00	9917306.80	BALANCE
\.


--
-- Data for Name: userkyc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userkyc (id, documentname, documentdetail, frontimage, backimage, userid, isapproved, createdat, updatedat, kycpercentage, reason) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, fullname, username, password, dial_code, phone_number, city, level, path, ap, parent_ap, balance, credit_amount, transaction_code, privileges, user_type, status, remark, created_at, updated_at, initial_setup, exposure_amount, lock, bet_lock, "resetToken", is_deleted, email, dob, telegramid, instagramid, whatsappnumber, "is-password-changed", new_users_access) FROM stdin;
590	prabhanshu	user13	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543203	Indore	3	0.575.582.590	100.00	0.00	200.00	200.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:03:40.986+00	2024-05-31 10:03:41.089+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
591	prabhanshu	user14	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543204	Indore	3	0.575.582.591	100.00	0.00	500.00	500.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:04:23.629+00	2024-05-31 10:04:23.699+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
596	prabhanshu	user31	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543270	Indore	3	0.575.586.596	100.00	0.00	200.00	200.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:28:31.127+00	2024-05-31 10:28:31.222+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
589	prabhanshu	user12	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543202	Indore	3	0.575.582.589	100.00	0.00	279.00	400.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:03:14.597+00	2024-06-01 05:19:57.276+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
597	prabhanshu	user32	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543271	Indore	3	0.575.586.597	100.00	0.00	300.00	300.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:28:58.977+00	2024-05-31 10:28:59.043+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
12	demo	demo	ddf15c043ef928315f4f73bc210685fb	+91	0000000000	indore	0	\N	100.00	0.00	0.00	0.00	\N	\N	DEMO	1		2024-04-24 11:50:50.61105+00	2024-04-24 11:50:50.61105+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
585	CFTMaster	CFTmaster	1455494c9f58563769b601366047c030	+91	9893851254	Indore	2	0.577.585	20.00	30.00	9999.50	9999.50	1455494c9f58563769b601366047c030	\N	MASTER	1		2024-05-31 09:54:20.679+00	2024-05-31 10:02:15.293+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
605	test	Test001	1de52961c3a824453fd18895eba7a9b0	+91	3829846990	Ujjain	1	0.605	100.00	0.00	1200.00	1200.00	1de52961c3a824453fd18895eba7a9b0	\N	USER	1		2024-05-31 12:35:34.257+00	2024-05-31 12:36:05.192+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
575	InternCFT	InternCFT	63eefe6b3cd05db2fed1b574b867125b	+91	9893851252	Indore	1	0.575	30.00	0.00	4941.80	50000.00	63eefe6b3cd05db2fed1b574b867125b	\N	SUPER_MASTER	1		2024-05-31 09:08:40.249+00	2024-06-01 03:28:57.216+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	t	f
603	prabhanshu	user44	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543278	Indore	3	0.575.587.603	100.00	0.00	542.00	400.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:33:44.232+00	2024-06-01 03:28:57.267+00	f	-100.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
579	prabhanshu	user2	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543281	Indore	2	0.575.579	100.00	0.00	140.00	500.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 09:50:21.545+00	2024-05-31 15:00:45.943+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
576	DemoUser	DemoUser	448ddd517d3abb70045aea6929f02367	+91	9893851255	Indore	1	0.576	100.00	0.00	12644.00	12949.00	448ddd517d3abb70045aea6929f02367	\N	USER	1		2024-05-31 09:15:03.202+00	2024-05-31 20:37:22.045+00	f	-705.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
593	prabhanshu	user22	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543289	Indore	3	0.575.584.593	100.00	0.00	3900.00	3400.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:20:25.784+00	2024-05-31 20:37:22.122+00	f	-114.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
580	prabhanshu	user3	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543282	Indore	2	0.575.580	100.00	0.00	600.00	800.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 09:50:53.837+00	2024-05-31 15:46:50.868+00	f	-500.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
598	prabhanshu	user33	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543272	Indore	3	0.575.586.598	100.00	0.00	400.00	400.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:29:20.372+00	2024-05-31 10:29:20.47+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
599	prabhanshu	user34	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543273	Indore	3	0.575.586.599	100.00	0.00	400.00	400.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:29:47.607+00	2024-05-31 10:29:47.707+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
581	prabhanshu	user4	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543283	Indore	2	0.575.581	100.00	0.00	930.00	1000.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 09:51:13.31+00	2024-05-31 20:04:59.063+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
604	prabhanshu	user45	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543265	Indore	3	0.575.587.604	100.00	0.00	100.00	100.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:48:24.141+00	2024-05-31 10:48:24.256+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
586	prabhanshu	Master3	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543292	Indore	2	0.575.586	10.00	30.00	10700.00	12000.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	MASTER	1		2024-05-31 09:54:45.297+00	2024-05-31 12:59:28.63+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	t	f
592	prabhanshu	user21	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543288	Indore	3	0.575.584.592	100.00	0.00	2172.00	2300.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:20:03.836+00	2024-05-31 20:04:59.149+00	f	-1000.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
587	prabhanshu	Master4	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543293	Indore	2	0.575.587	10.00	30.00	7093.80	8200.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	MASTER	1		2024-05-31 09:55:18.437+00	2024-06-01 03:28:57.199+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	t	f
582	prabhanshu	Master1	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543290	Indore	2	0.575.582	10.00	30.00	6600.00	8000.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	MASTER	1		2024-05-31 09:52:58.308+00	2024-05-31 12:58:32.558+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	t	f
594	prabhanshu	user23	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543299	Indore	3	0.575.584.594	100.00	0.00	860.00	3000.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:21:03.606+00	2024-05-31 17:53:11.179+00	f	-200.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
600	prabhanshu	user41	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543275	Indore	3	0.575.587.600	100.00	0.00	100.00	100.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:32:45.155+00	2024-05-31 10:32:45.218+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
577	CFTSuperMaster	CFTSuperMaster	1455494c9f58563769b601366047c030	+91	9893851256	Indore	1	0.577	30.00	0.00	9001.50	20000.00	1455494c9f58563769b601366047c030	\N	SUPER_MASTER	1		2024-05-31 09:31:28.529+00	2024-05-31 10:02:15.296+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	t	f
584	prabhanshu	Master2	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543291	Indore	2	0.575.584	10.00	30.00	1957.60	13000.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	MASTER	1		2024-05-31 09:53:44.372+00	2024-05-31 20:37:22.096+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	t	f
583	James	James	1455494c9f58563769b601366047c030	+91	0000002663	Indore	2	0.577.583	100.00	0.00	999.00	999.00	1455494c9f58563769b601366047c030	\N	USER	1		2024-05-31 09:53:42.917+00	2024-05-31 12:34:27.477+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
595	prabhanshu	user24	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543200	Indore	3	0.575.584.595	100.00	0.00	3592.00	2400.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:21:37.196+00	2024-05-31 14:53:35.092+00	f	-600.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
602	prabhanshu	user43	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543277	Indore	3	0.575.587.602	100.00	0.00	220.00	300.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:33:25.519+00	2024-05-31 20:37:22.211+00	f	-162.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
1	James Bond	Bond007	2ec9246a5c996d9a0004b47ec3dc6a81	+91	9584145270	Indore	0	0	100.00	0.00	9917306.80	10000000.00	2ec9246a5c996d9a0004b47ec3dc6a81	\N	OWNER	1		2021-12-13 14:50:36.550927+00	2024-06-01 03:28:57.253+00	t	0.00	f	f	\N	f	\N	\N	\N	\N	\N	t	f
578	prabhanshu	user1	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543280	Indore	2	0.575.578	100.00	0.00	1500.00	2000.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 09:49:34.179+00	2024-05-31 14:53:35.115+00	f	-700.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
588	prabhanshu	user11	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543201	Indore	3	0.575.582.588	100.00	0.00	300.00	300.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:01:30.528+00	2024-05-31 10:01:30.557+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
601	prabhanshu	user42	eb4f3b8c67a8f6cd078b0ba52fcfaea3	+91	9876543276	Indore	3	0.575.587.601	100.00	0.00	200.00	200.00	eb4f3b8c67a8f6cd078b0ba52fcfaea3	\N	USER	1		2024-05-31 10:33:07.927+00	2024-05-31 10:33:07.958+00	f	0.00	f	f	\N	f	\N	\N	\N	\N	\N	f	f
\.


--
-- Data for Name: withdrawaltransactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.withdrawaltransactions (id, "userName", "accountNo", "ifscCode", name, amount, status, userid, userpath, "createdAt", "updatedAt", acountholdername) FROM stdin;
106	DemoUser	50100200245	D0909		101.00	Approved	576	0.576	2024-05-31 11:03:04.118+00	2024-05-31 11:04:38.041+00	demo
107	DemoUser	50100200245	D0909		101.00	Rejected	576	0.576	2024-05-31 11:03:04.156+00	2024-05-31 11:07:50.234+00	demo
108	DemoUser	50100200245	D0909		101.00	Rejected	576	0.576	2024-05-31 11:08:32.268+00	2024-05-31 11:08:47.5+00	demo
109	DemoUser	50100200245	D0909		102.00	Approved	576	0.576	2024-05-31 11:08:39.619+00	2024-05-31 11:09:03.422+00	demo
111	DemoUser	50100200245	D0909		250.00	Rejected	576	0.576	2024-05-31 11:38:19.865+00	2024-05-31 11:38:40.572+00	demo
110	DemoUser	50100200245	D0909		101.00	Rejected	576	0.576	2024-05-31 11:11:24.904+00	2024-05-31 11:38:41.541+00	demo
112	DemoUser	50100200245	D0909		250.00	Approved	576	0.576	2024-05-31 11:39:20.863+00	2024-05-31 11:39:48.904+00	demo
116	DemoUser	50100200245	D0909		150.00	Approved	576	0.576	2024-05-31 11:44:34.922+00	2024-05-31 11:49:03.02+00	demo
115	DemoUser	50100200245	D0909		200.00	Approved	576	0.576	2024-05-31 11:44:29.04+00	2024-05-31 11:50:28.929+00	demo
114	DemoUser	50100200245	D0909		102.00	Approved	576	0.576	2024-05-31 11:44:24.83+00	2024-05-31 12:08:49.494+00	demo
113	DemoUser	50100200245	D0909		101.00	Approved	576	0.576	2024-05-31 11:44:21.063+00	2024-05-31 12:11:45.269+00	demo
117	DemoUser	50100200245	D0909		100.00	pending	576	0.576	2024-05-31 12:18:21.84+00	2024-05-31 12:18:21.84+00	demo
118	DemoUser	50100200245	D0909		101.00	pending	576	0.576	2024-05-31 12:18:31.21+00	2024-05-31 12:18:31.21+00	demo
119	DemoUser	50100200245	D0909		102.00	pending	576	0.576	2024-05-31 12:18:38.334+00	2024-05-31 12:18:38.334+00	demo
\.


--
-- Name: BankAccounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."BankAccounts_id_seq"', 36, true);


--
-- Name: activity_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activity_log_id_seq', 5354, true);


--
-- Name: adduserUpis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."adduserUpis_id_seq"', 1, false);


--
-- Name: adduseraccounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adduseraccounts_id_seq', 78, true);


--
-- Name: adduserapis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adduserapis_id_seq', 6, true);


--
-- Name: casino_games_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.casino_games_id_seq', 7017, true);


--
-- Name: casinotransactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.casinotransactions_id_seq', 4351, true);


--
-- Name: depositrequests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.depositrequests_id_seq', 195, true);


--
-- Name: otps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.otps_id_seq', 188, true);


--
-- Name: password_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.password_history_id_seq', 243, true);


--
-- Name: settlement-transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."settlement-transactions_id_seq"', 11125, true);


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_id_seq', 11966, true);


--
-- Name: userkyc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.userkyc_id_seq', 16, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 605, true);


--
-- Name: withdrawaltransactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.withdrawaltransactions_id_seq', 119, true);


--
-- Name: BankAccounts BankAccounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BankAccounts"
    ADD CONSTRAINT "BankAccounts_pkey" PRIMARY KEY (id);


--
-- Name: QrCodes QrCodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."QrCodes"
    ADD CONSTRAINT "QrCodes_pkey" PRIMARY KEY (id);


--
-- Name: QrCodes QrCodes_upi_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."QrCodes"
    ADD CONSTRAINT "QrCodes_upi_key" UNIQUE (upi);


--
-- Name: activity_logs activity_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_log_pkey PRIMARY KEY (id);


--
-- Name: addBanners addBanners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."addBanners"
    ADD CONSTRAINT "addBanners_pkey" PRIMARY KEY (id);


--
-- Name: adduserUpis adduserUpis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."adduserUpis"
    ADD CONSTRAINT "adduserUpis_pkey" PRIMARY KEY (id);


--
-- Name: adduseraccounts adduseraccounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adduseraccounts
    ADD CONSTRAINT adduseraccounts_pkey PRIMARY KEY (id);


--
-- Name: adduserapis adduserapis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adduserapis
    ADD CONSTRAINT adduserapis_pkey PRIMARY KEY (id);


--
-- Name: casino_games casino_games_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.casino_games
    ADD CONSTRAINT casino_games_pkey PRIMARY KEY (id);


--
-- Name: casinotransactions casinotransactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.casinotransactions
    ADD CONSTRAINT casinotransactions_pkey PRIMARY KEY (id);


--
-- Name: depositrequests depositrequests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depositrequests
    ADD CONSTRAINT depositrequests_pkey PRIMARY KEY (id);


--
-- Name: otps otps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otps
    ADD CONSTRAINT otps_pkey PRIMARY KEY (id);


--
-- Name: password_history password_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_history
    ADD CONSTRAINT password_history_pkey PRIMARY KEY (id);


--
-- Name: settlement-transactions settlement-transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."settlement-transactions"
    ADD CONSTRAINT "settlement-transactions_pkey" PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: userkyc userkyc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userkyc
    ADD CONSTRAINT userkyc_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: users users_username_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key1 UNIQUE (username);


--
-- Name: users users_username_key2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key2 UNIQUE (username);


--
-- Name: users users_username_key3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key3 UNIQUE (username);


--
-- Name: users users_username_key4; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key4 UNIQUE (username);


--
-- Name: users users_username_key5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key5 UNIQUE (username);


--
-- Name: withdrawaltransactions withdrawaltransactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.withdrawaltransactions
    ADD CONSTRAINT withdrawaltransactions_pkey PRIMARY KEY (id);


--
-- Name: password_history password_history_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_history
    ADD CONSTRAINT password_history_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id) ON UPDATE CASCADE;


--
-- Name: userkyc userkyc_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userkyc
    ADD CONSTRAINT userkyc_userid_fkey FOREIGN KEY (userid) REFERENCES public.users(id) ON UPDATE CASCADE;


--
-- PostgreSQL database dump complete
--

