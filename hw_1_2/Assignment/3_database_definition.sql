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

	
	
	
	
-- Primary keys
ALTER TABLE cities
	ADD CONSTRAINT cities_pk PRIMARY KEY(id);
	
ALTER TABLE countries
	ADD CONSTRAINT countries_pk PRIMARY KEY(id);
	
ALTER TABLE continents
	ADD CONSTRAINT continents_pk PRIMARY KEY(id);
	
ALTER TABLE states
	ADD CONSTRAINT states_pk PRIMARY KEY(id);
	
ALTER TABLE subcontinents
	ADD CONSTRAINT subcontinents_pk PRIMARY KEY(id);


-- Foreign keys	
ALTER TABLE cities
	ADD CONSTRAINT cities_fk_1 FOREIGN KEY(state_id) REFERENCES states(id),
	ADD CONSTRAINT cities_fk_2 FOREIGN KEY(country_id) REFERENCES countries(id);
	
ALTER TABLE countries
	ADD CONSTRAINT countries_fk_1 FOREIGN KEY(continent_id) REFERENCES continents(id),
	ADD CONSTRAINT countries_fk_2 FOREIGN KEY(subcontinent_id) REFERENCES subcontinents(id);
	
ALTER TABLE states
	ADD CONSTRAINT states_fk FOREIGN KEY(country_id) REFERENCES countries(id);
	
ALTER TABLE subcontinents
	ADD CONSTRAINT subcontinents_fk FOREIGN KEY(continent_id) REFERENCES continents(id);



-- Table updates (only for countries table)
-- Some values of capital attribute of countries table are empty strings. 
-- For uniformity reasons, we set those capitals to NULL.
UPDATE countries
SET capital = NULL
WHERE capital = '';


	