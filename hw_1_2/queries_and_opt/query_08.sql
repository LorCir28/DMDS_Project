-- QUERY 8
/*
return the cities that have the same name but different countries
*/

-- NON OPTIMIZED
select distinct c1.name as city1, co1.name as country1, co2.name as country2,
	sb1.name as subcont1, sb2.name as subcont2
from cities c1 join cities c2 on c1.name = c2.name join 
	countries co1 on c1.country_id = co1.id join
	countries co2 on c2.country_id = co2.id join
	subcontinents sb1 on sb1.id = co1.subcontinent_id join
	subcontinents sb2 on sb2.id = co2.subcontinent_id
where c1.id <> c2.id and co1.id <> co2.id
order by c1.name


-- OPTIMIZED
select distinct c1.name as city1, co1.name as country1, co2.name as country2,
	sb1.name as subcont1, sb2.name as subcont2
from cities c1 join cities c2 on c1.name = c2.name 
	join countries co1 on c1.country_id = co1.id
	join countries co2 on c2.country_id = co2.id
	join subcontinents sb1 on sb1.id = co1.subcontinent_id
	join subcontinents sb2 on sb2.id = co2.subcontinent_id
where c1.name in (select name
				from cities 
				group by name
				having count(*) > 1)
	and
	co1.name <> co2.name
order by c1.name 
