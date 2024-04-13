-- QUERY 5

-- STATEMENTS: VIEW
/*
Show the name and the longitude of all the cities that lays around the Greenwich meridian within
a range of ±1 (ie such that have a longitude similar to the London one),ordering them by their 
proximity.
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
