-- QUERY 10
/*
for each italian region, show the name and the number of provinces that have the latitude greater
than all the spanish cities
*/

-- NON OPTIMIZED (1 min)
-- select s.name as region_name, count(*) as number_provinces
-- from states s join countries co on s.country_id = co.id join cities c on c.state_id = s.id
-- where co.name = 'Italy' and (s.type = 'region' or s.type = 'autonomous region') 
-- 	and c.name in (select st.name
-- 				from countries cou join states st on st.country_id = cou.id
-- 				where cou.name = 'Italy' 
-- 					and (st.type = 'province' or st.type = 'decentralized regional entity'))												
-- 	and c.latitude > all (select cit.latitude
-- 		from countries coun join cities cit on cit.country_id = coun.id
-- 		where coun.name = 'Spain')
-- group by s.name

-- OPTIMIZED (indexes)
-- UNCOMMENT THE FOLLOWING TO CREATE THE INDEXES
-- create index idx_states_country_id ON states(country_id);
-- create index idx_cities_state_id ON cities(state_id);
-- create index idx_cities_name ON cities(name);
-- create index idx_states_type ON states(type);
-- create index idx_countries_name ON countries(name);
-- create index idx_cities_latitude ON cities(latitude);

-- select s.name as region_name, count(*) as number_provinces
-- from states s join countries co on s.country_id = co.id join cities c on c.state_id = s.id
-- where co.name = 'Italy' and (s.type = 'region' or s.type = 'autonomous region') 
-- 	and c.name in (select st.name
-- 				from countries cou join states st on st.country_id = cou.id
-- 				where cou.name = 'Italy' 
-- 					and (st.type = 'province' or st.type = 'decentralized regional entity'))												
-- 	and c.latitude > all (select cit.latitude
-- 		from countries coun join cities cit on cit.country_id = coun.id
-- 		where coun.name = 'Spain')
-- group by s.name

-- UNCOMMENT THE FOLLOWING TO DELETE THE INDEXES
-- drop index idx_states_country_id;
-- drop index idx_cities_state_id;
-- drop index idx_cities_name;
-- drop index idx_states_type;
-- drop index idx_countries_name;
-- drop index idx_cities_latitude;