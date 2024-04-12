-- QUERY 7

-- STATEMENTS: EXCEPT
/*
for each european country that has at least one province, return the name of the country and the 
number of corresponding provinces
*/

-- subquery: for each country that has at least one province, return the name of 
-- the country and the number of corresponding provinces
select co.name as country_name, count(*) as number_provinces
from countries co join states s on co.id = s.country_id
where s.type = 'province'
group by co.name

except

-- subquery: return for each non-european country that has at least one province, return the name
-- of the country and the number of corresponding provinces
select co.name as country_name, count(*) as number_provinces
from countries co join states s on co.id = s.country_id join continents r on co.continent_id = r.id
where s.type = 'province' and r.name != 'Europe'
group by co.name