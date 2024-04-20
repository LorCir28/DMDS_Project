-- QUERY 1: STATEMENTS: HAVING
/* DESCRIPTION
for each small country (i.e. a country with less than 20 states), find the name, ISO, currency 
and the number of states
*/
/* EXPLANATION
we make an equi-join between countries and states on the id and select the tuples having less
than 20 states ordering them by descending number of states
*/
select c.name as country_name, c.iso3 as iso3, c.currency_name as currency, count(s.name) as states
from countries c
join states s on c.id = s.country_id
group by c.name, c.iso3, c.currency_name
having count(s.name)<=20
order by count(s.name) desc
----------------------------------------------------------------------------------------------
-- QUERY 2: STATEMENTS: negated nested query, group by
/* DESCRIPTION
for each continent, find number of countries that don't belong to it
*/
/* EXPLANATION
we select only the countries whose name is not in the table returned by the nested query which
returns the name of the countries that belong to the external continent
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
-- QUERY 3 (to be optimized)
/* DESCRIPTION
select the name and the latitude of the northernmost city in the database
*/
/* EXPLANATION
we select the city with the latitude greater or equal than the ones returned by the nested query
that returns the latitudes of all the cities in the database
*/
select name, latitude
from cities
where latitude >= all(
	select latitude
 	from cities
)
----------------------------------------------------------------------------------------------
-- QUERY 4 (to be optimized)
/* DESCRIPTION
return the name and the currency of the southern cities of each continent (with the name) that 
belong to states thar are not autonomous
*/
-- EXPLANATION
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
----------------------------------------------------------------------------------------------
-- QUERY 5: STATEMENTS: VIEW
/* DESCRITPTION
Show the name and the longitude of all the cities that lays around the Greenwich meridian within
a range of ±1 (ie such that have a longitude similar to the London one), ordering them by their proximity.
NB. London's longitude is not exactly 0, but -0.12574000
*/

-- this view returns a single-tuple table with the longitude of London
create view london_longitude(longitude) as
	select c.longitude 
    from cities c
    join states s on s.id = c.state_id
    join countries co on co.id = s.country_id 
    where c.name = 'London' 
	and co.name = 'United Kingdom';

/* EXPLANATION
we make a join between cities and the view by selecting only the cities with distance (i.e. the
error from the Greenwich meridian) between -1 and +1
*/
select name, c.longitude, abs(c.longitude - london_longitude.longitude) as distance
from cities c, london_longitude
where abs(c.longitude - london_longitude.longitude) <= 1
order by distance
----------------------------------------------------------------------------------------------
-- QUERY 6: STATEMENTS: outer join, negated nested query
/* DESCRIPTION
for every city that is not a capital, show the phonecode of the corresponding country,
the name of the corresponding continent (if present) and, if present, the subcontinent.
*/
/* EXPLANATION
we need two left joins to get NULL values whenever the continent and/or subcontinent are not
present. We select the cities whose name is not in the table returned by the nested query which 
outputs the cities that are capitals
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
/* DESCRIPTION
for each european country that has at least one province, return the name of the country and the 
number of corresponding provinces
*/
-- EXPLANATION
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
----------------------------------------------------------------------------------------------
-- QUERY 8 (to be optimized)
/* DESCRIPTION
return the cities that have the same name but different countries, with the subcontinent
*/
/* EXPLANATION
we join cities with itself by keeping cities with only the same name but different id
*/
select distinct c1.name as city1, co1.name as country1, co2.name as country2,
	sb1.name as subcont1, sb2.name as subcont2
from cities c1 
join cities c2 on c1.name = c2.name 
join countries co1 on c1.country_id = co1.id 
join countries co2 on c2.country_id = co2.id 
join subcontinents sb1 on sb1.id = co1.subcontinent_id 
join subcontinents sb2 on sb2.id = co2.subcontinent_id
where c1.id <> c2.id and co1.id <> co2.id
order by c1.name
----------------------------------------------------------------------------------------------
-- QUERY 9 (to be optimized)
/* DESCRIPTION
for each continent, show the name and the number of cities that are not capital
which have the latitude greater than the latitude of all the italian cities
*/
/* EXPLANATION
we make a join between continents and the table returned by the nested query (called Nested). 
The latter returns the name, latitude and continent_id of the non-capital cities that have the 
latitude of all the italian cities (to achieve that, there are two additional nested queries 
into Nested)
*/
select con.name as continent_name, count(nested.name) as number_cities
from continents con 
join (
	select c.name, c.latitude, co.continent_id
	from cities c join countries co on c.country_id = co.id
	where c.name not in (
		select capital
		from countries
		where capital is not null
	)
	and c.latitude > all (
		select (cit.latitude)
		from cities cit join countries cou on cit.country_id = cou.id
		where cou.name = 'Italy')
) Nested on Nested.continent_id = con.id
group by con.name
----------------------------------------------------------------------------------------------
-- QUERY 10 (to be optimized)
/* DESCRIPTION
for each italian region, show the name and the number of provinces that have the latitude greater
than all the spanish cities
*/
/* EXPLANATION
there are two nested queries in the where clause allowing us to get all the italian provinces
(the first one) and the latitudes of all the spanish cities (the second one).
some italian regions are save in the database as 'autonomous region' and some italian provinces
as 'decentralized regional entity'
*/
select s.name as region_name, count(*) as number_provinces
from states s 
join countries co on s.country_id = co.id 
join cities c on c.state_id = s.id
where co.name = 'Italy' 
and (s.type = 'region' or s.type = 'autonomous region') 
and c.name in (
	select st.name
	from countries cou 
	join states st on st.country_id = cou.id
	where cou.name = 'Italy' 
	and (st.type = 'province' or st.type = 'decentralized regional entity')
)												
and c.latitude > all (
	select cit.latitude
	from countries coun 
	join cities cit on cit.country_id = coun.id
	where coun.name = 'Spain'
)
group by s.name