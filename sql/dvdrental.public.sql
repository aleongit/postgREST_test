
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
SELECT * FROM film ORDER BY title asc;