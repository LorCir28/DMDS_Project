-- QUERY 5
-- STATEMENTS: outer join, negated nested query
/*
for every city that is not a capital, show the phonecode of the corresponding country,
the name of the corresponding continent (if present) and, if present, the subcontinent.
*/

-- select c.name as city_name, co.phonecode as city_phonecode, r.name as continent_name, s.name as subcontinent_name
-- from cities c 
-- join countries co on co.id = c.country_id
-- left join continents r on r.id = co.continent_id
-- left join subcontinents s on s.id = co.subcontinent_id
-- where c.name not in (select distinct capital
-- 					 from countries
-- 					 where capital is not null)

