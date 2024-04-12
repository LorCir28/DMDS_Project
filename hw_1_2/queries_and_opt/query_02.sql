-- QUERY 2
-- STATEMENTS: negated nested query, group by
/*
for each continent, find number of countries that don't belong to it
*/

-- select r.name as continent_name, count(*) as out_countries
-- from continents r, countries c
-- where c.name not in (select co.name
-- 					from countries co join continents re on re.id = co.continent_id
-- 					where re.name = r.name) and c.continent_id is not null
-- group by r.name