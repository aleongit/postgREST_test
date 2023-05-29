## Introduction

PostgREST is a standalone web server that turns your PostgreSQL database directly into a RESTful API. The structural constraints and permissions in the database determine the API endpoints and operations.


## Requeriments

- PostgreSQL 15.0


## Developing versions

- PostgreSQL 15.2, compiled by Visual C++ build 1914, 64-bit
- pgAdmin4 [6.21]
- DBeaver [23.0.3]
- Visual Studio Code [1.77.3]
- git version 2.38.0.windows.1
- Microsoft Windows [Versión 10.0.19044.2486]


## Tutorial 0 - Get it Running
### Step 1. Relax
### Step 2. Install PostgreSQL

### Step 3. Install PostgREST

- Visit the latest release for a list of downloads
- https://github.com/PostgREST/postgrest/releases/tag/v11.0.1
- Download **postgrest-v11.0.1-windows-x64.zip** file
- Extract .exe file

- Check
```
postgrest --help
Usage: postgrest [-e|--example] [--dump-config | --dump-schema] [FILENAME]

  PostgREST 11.0.1 (4197d2f) / create a REST API to an existing Postgres
  database
```

### Step 4. Create Database for API

- Connect to psql
```
psql -U postgres
```
- Create a named schema for the database objects which will be exposed in the API
```
create schema api;
```

- Our API will have one endpoint **/todos** which will come from a table.
```
create table api.todos (
  id serial primary key,
  done boolean not null default false,
  task text not null,
  due timestamptz
);

insert into api.todos (task) values
  ('finish tutorial 0'), ('pat self on back');
```

- Make a role to use for anonymous web requests. When a request comes in, PostgREST will switch into this role in the database to run queries
```
create role web_anon nologin;
grant usage on schema api to web_anon;
grant select on api.todos to web_anon;
```

- The **web_anon** role has permission to access things in the api schema, and to read rows in the todos table.

- It’s a good practice to create a dedicated role for connecting to the database, instead of using the highly privileged postgres role. So we’ll do that, name the role authenticator and also grant it the ability to switch to the web_anon role
```
create role authenticator noinherit login password 'mysecretpassword';
grant web_anon to authenticator;
```

- Now quit out of psql; it’s time to start the API!
```
\q
```

### Step 5. Run PostgREST




## Doc

- https://postgrest.org/
- https://postgrest.org/en/stable/tutorials/tut0.html

