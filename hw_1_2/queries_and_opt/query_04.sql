-- QUERY 4
/*
return the name and the currency of the southern cities of each continent (with the name) that 
belong to states thar are not autonomous
*/

-- NON OPTIMIZED
-- SUBQUERY: this returns the name and currency of the southern cities of each continent
select distinct c.name as city_name, co.currency_name as currency, sr.name
from cities c 
join countries co on c.country_id = co.id 
join subcontinents sr on co.subcontinent_id = sr.id
where sr.name like 'South%'

intersect

-- SUBQUERY: this returns the name and currency of the cities that are not autonomous
select distinct c.name as city_name, co.currency_name as currency, sr.name
from cities c 
join states s on c.state_id = s.id 
join countries co on co.id = c.country_id
join subcontinents sr on co.subcontinent_id = sr.id
where s.type not like 'autonomous%'

-- OPTIMIZED (not intersection)
select distinct c.name as city_name, co.currency_name as currency, sr.name
from cities c 
join countries co on c.country_id = co.id 
join subcontinents sr on co.subcontinent_id = sr.id 
join states s on c.state_id = s.id
where s.type not like 'autonomous%' 
and sr.name like 'South%'
