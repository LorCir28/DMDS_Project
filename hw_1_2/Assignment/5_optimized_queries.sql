-- QUERY 3
/*
select the name and the latitude of the northernmost city in the database
*/
-- NON OPTIMIZED VERSION (Stefano 14 sec; Lorenzo 35 sec)
select name, latitude
from cities
where latitude >= all(
	select latitude
 	from cities
)
-- OPTIMIZED VERSION (no nested query and consequently no comparison with long table)
select name, latitude
from cities
order by latitude desc
limit 1
----------------------------------------------------------------------------------------------
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
----------------------------------------------------------------------------------------------
-- QUERY 8
/*
return the cities that have the same name but different countries, with the subcontinent
*/
-- NON OPTIMIZED
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
-- OPTIMIZED (nested query in where clause speeds up)
select distinct c1.name as city1, co1.name as country1, co2.name as country2,
	sb1.name as subcont1, sb2.name as subcont2
from cities c1 join cities c2 on c1.name = c2.name 
join countries co1 on c1.country_id = co1.id
join countries co2 on c2.country_id = co2.id
join subcontinents sb1 on sb1.id = co1.subcontinent_id
join subcontinents sb2 on sb2.id = co2.subcontinent_id
where c1.name in (
	select name
	from cities 
	group by name
	having count(*) > 1
)
and	co1.name <> co2.name
order by c1.name 
----------------------------------------------------------------------------------------------
-- QUERY 9
/*
for each continent, show the name and the number of cities that are not capital
which have the latitude greater than the latitude of all the italian cities
*/
-- NON OPTIMIZED (50 sec)
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
) nested on nested.continent_id = con.id
group by con.name									  
-- OPTIMIZED (no nested query in the from clause)
select con.name as continent_name, count(c.name) as number_cities
from cities c 
join countries co on c.country_id = co.id 
join continents con on co.continent_id = con.id
where c.name not in (
	select capital
	from countries
	where capital is not null
) 
and c.latitude > (
	select max(cit.latitude)
	from cities cit 
	join countries cou on cit.country_id = cou.id
	where cou.name = 'Italy'
)
group by con.name
----------------------------------------------------------------------------------------------
-- QUERY 10
/*
for each italian region, show the name and the number of provinces that have the latitude greater
than all the spanish cities
*/
-- NON OPTIMIZED (1 min)
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

-- OPTIMIZED (Same query but using the following indexes)
-- UNCOMMENT THE FOLLOWING TO CREATE THE INDEXES
-- create index idx_states_country_id ON states(country_id);
-- create index idx_cities_state_id ON cities(state_id);
-- create index idx_cities_name ON cities(name);
-- create index idx_states_type ON states(type);
-- create index idx_countries_name ON countries(name);
-- create index idx_cities_latitude ON cities(latitude);
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
-- UNCOMMENT THE FOLLOWING TO DELETE THE INDEXES
-- drop index idx_states_country_id;
-- drop index idx_cities_state_id;
-- drop index idx_cities_name;
-- drop index idx_states_type;
-- drop index idx_countries_name;
-- drop index idx_cities_latitude;