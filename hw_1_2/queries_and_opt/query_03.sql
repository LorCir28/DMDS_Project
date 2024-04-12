-- QUERY 2
/*
select the name and the latitude of the northernmost city in the database
*/

-- NON OPTIMIZED VERSION (35 sec)
-- select name, latitude
-- from cities
-- where latitude >= all(select latitude
-- 					 from cities)

-- OPTIMIZED VERSION (no nested query and consequently no comparison with long table)
-- select name, latitude
-- from cities
-- order by latitude desc
-- limit 1