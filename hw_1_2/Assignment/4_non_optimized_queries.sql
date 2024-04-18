-- QUERY 1: STATEMENTS: HAVING
/*
for each small country (i.e. a country with less than 20 states), find the name, ISO, currency 
and the number of states
*/
select c.name as country_name, c.iso3 as iso3, c.currency_name as currency, count(s.name) as states
from countries c
join states s on c.id = s.country_id
group by c.name, c.iso3, c.currency_name
having count(s.name)<=20
order by count(s.name) desc
----------------------------------------------------------------------------------------------
-- QUERY 2: STATEMENTS: negated nested query, group by
/*
for each continent, find number of countries that don't belong to it
*/
select r.name as continent_name, count(*) as out_countries
from continents r, countries c
where c.name not in (
	select co.name
 	from countries co 
	join continents re on re.id = co.continent_id
 	where re.name = r.name
) 
and c.continent_id is not null
group by r.name
----------------------------------------------------------------------------------------------
-- QUERY 5: STATEMENTS: VIEW
/*
Show the name and the longitude of all the cities that lays around the Greenwich meridian within
a range of ±1 (ie such that have a longitude similar to the London one), ordering them by their proximity.
NB. London's longitude is not exactly 0, but -0.12574000
*/
create view london_longitude(longitude) as
	select c.longitude 
    from cities c
    join states s on s.id = c.state_id
    join countries co on co.id = s.country_id 
    where c.name = 'London' 
	and co.name = 'United Kingdom';
	
select name, c.longitude, abs(c.longitude - london_longitude.longitude) as distance
from cities c, london_longitude
where abs(c.longitude - london_longitude.longitude) <= 1
order by distance
----------------------------------------------------------------------------------------------
-- QUERY 6: STATEMENTS: outer join, negated nested query
/*
for every city that is not a capital, show the phonecode of the corresponding country,
the name of the corresponding continent (if present) and, if present, the subcontinent.
*/
select c.name as city_name, co.phonecode as city_phonecode, r.name as continent_name, s.name as subcontinent_name
from cities c 
join countries co on co.id = c.country_id
left join continents r on r.id = co.continent_id
left join subcontinents s on s.id = co.subcontinent_id
where c.name not in (
	select distinct capital
	from countries
	where capital is not null
)
----------------------------------------------------------------------------------------------		 
-- QUERY 7: STATEMENTS: EXCEPT
/*
for each european country that has at least one province, return the name of the country and the 
number of corresponding provinces
*/
-- subquery: for each country that has at least one province, return the name of 
-- the country and the number of corresponding provinces
select co.name as country_name, count(*) as number_provinces
from countries co 
join states s on co.id = s.country_id
where s.type = 'province'
group by co.name
except
-- subquery: return for each non-european country that has at least one province, return the name
-- of the country and the number of corresponding provinces
select co.name as country_name, count(*) as number_provinces
from countries co 
join states s on co.id = s.country_id 
join continents r on co.continent_id = r.id
where s.type = 'province' 
and r.name != 'Europe'
group by co.name