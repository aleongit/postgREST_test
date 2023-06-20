
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

-- create role todo_user nologin;
-- grant todo_user to authenticator;

SELECT current_database();
grant usage on schema public to todo_user;
grant all on ALL TABLES IN SCHEMA public to todo_user;
-- grant usage, select on sequence api.todos_id_seq to todo_user;
GRANT USAGE, select ON ALL SEQUENCES IN SCHEMA public to todo_user;



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

SELECT film_id, title FROM film WHERE title LIKE 'B%';

SELECT DISTINCT release_year FROM film;

SELECT film_id, title, release_year FROM film ORDER BY title asc;

SELECT * FROM film ORDER BY film_id desc;

SELECT * FROM film WHERE special_features IS NULL;



SELECT * FROM country;
SELECT * FROM city;

SELECT * FROM country WHERE country LIKE 'A%';

SELECT * FROM city INNER JOIN country ON city.country_id = country.country_id 
	WHERE country LIKE 'Austria';


SELECT * FROM film;
SELECT * FROM actor;
SELECT * FROM film_actor;

SELECT * FROM film_actor fa WHERE film_id = 2;

SELECT a.first_name, f.title FROM actor a
	INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
	INNER JOIN film f ON f.film_id = fa.film_id
WHERE f.film_id = 2; 

SELECT f.title, a.first_name FROM film f
	INNER JOIN film_actor fa ON f.film_id = fa.film_id
	INNER JOIN actor a ON a.actor_id = fa.actor_id
WHERE a.actor_id = 1
ORDER BY f.title;
