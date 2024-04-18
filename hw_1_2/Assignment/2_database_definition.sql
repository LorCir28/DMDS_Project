-- TABLE DEFINITIONS
CREATE TABLE continents (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);

CREATE TABLE subcontinents (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    continent_id integer NOT NULL
);

CREATE TABLE countries (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    iso3 character(3),
    phonecode character varying(255),
    capital character varying(255),
    currency_name character varying(255),
    continent_id integer,
    subcontinent_id integer,
    nationality character varying(255),
    latitude numeric(10,8),
    longitude numeric(11,8)
);

CREATE TABLE states (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    country_id integer NOT NULL,
    type character varying(191),
    latitude numeric(10,8),
    longitude numeric(11,8)
);

CREATE TABLE cities (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    state_id integer NOT NULL,
    country_id integer NOT NULL,
    latitude numeric(10,8) NOT NULL,
    longitude numeric(11,8) NOT NULL
);

	
	
	