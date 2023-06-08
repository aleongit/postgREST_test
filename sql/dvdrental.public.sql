
--
-- veure rols
-- \du
-- create role web_anon nologin;
-- \c dvdrental
SELECT current_database();
grant usage on schema public to web_anon;
grant select on ALL TABLES IN SCHEMA public to web_anon;

-- create role authenticator noinherit login password 'mysecretpassword';
-- grant web_anon to authenticator;




-- query test ______________________________________________
SELECT * FROM film;
SELECT * FROM product;
SELECT * FROM actor;
SELECT * FROM city;
SELECT * FROM address;
SELECT * FROM customer;

SELECT * FROM film WHERE length < 50;

SELECT * FROM customer WHERE customer_id >= 598 AND activebool IS TRUE;

SELECT * FROM film WHERE length < 50 OR length > 180;





