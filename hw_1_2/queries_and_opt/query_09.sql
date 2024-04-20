-- QUERY 9
/*
for each continent, show the name and the number of cities that are not capital
which have the latitude greater than the latitude of all the italian cities
*/

-- STATEMENTS: nested query in from clause

-- NON OPTIMIZED (50 sec)
select con.name as continent_name, count(nested.name) as number_cities
from continents con join 
	(select c.name, c.latitude, co.continent_id
	from cities c join countries co on c.country_id = co.id
	where c.name not in (select capital
						from countries
						where capital is not null)
						and c.latitude > all (select (cit.latitude)
										  	from cities cit join countries cou on 
											  cit.country_id = cou.id
										  	where cou.name = 'Italy')) nested
	on nested.continent_id = con.id
group by con.name
										  
-- OPTIMIZED (no nested query in the from clause)
select con.name as continent_name, count(c.name) as number_cities
from cities c join countries co on c.country_id = co.id join continents con on
	co.continent_id = con.id
where c.name not in (select capital
					from countries
					where capital is not null)
	  and
	  c.latitude > (select max(cit.latitude)
					from cities cit join countries cou on cit.country_id = cou.id
					where cou.name = 'Italy')
group by con.name
