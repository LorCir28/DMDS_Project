-- QUERY 7

-- STATEMENTS: HAVING
/*
for each small country (i.e. a country with less than 20 states), find the name, ISO, currency 
and the number of states
*/

-- select c.name as country_name, c.iso3 as iso3, c.currency_name as currency, count(s.name) as states
-- from countries c
-- join states s on c.id = s.country_id
-- group by c.name, c.iso3, c.currency_name
-- having count(s.name)<=20
-- order by count(s.name)