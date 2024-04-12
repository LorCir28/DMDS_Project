-- Primary keys
ALTER TABLE cities
	ADD CONSTRAINT id PRIMARY KEY(id);
	
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
UPDATE countries
SET capital = NULL
WHERE capital = '';