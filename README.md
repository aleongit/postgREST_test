## Introduction

PostgREST is a standalone web server that turns your PostgreSQL database directly into a RESTful API. The structural constraints and permissions in the database determine the API endpoints and operations.


## Requeriments

- PostgreSQL 15.0
- setx /m PATH "%PATH%;C:\Program Files\PostgreSQL\15\bin" [windows]


## Environment

- PostgREST 11.0.1
- PostgreSQL 15.2, compiled by Visual C++ build 1914, 64-bit
- pgAdmin4 [6.21]
- DBeaver [23.0.3]
- Visual Studio Code [1.77.3]
- git version 2.38.0.windows.1
- Postman v10.14.6
- Microsoft Windows [Versión 10.0.19044.2486]


## Tutorial

- [Tutorial 0 - Get it Running](tutorial0.md)
- [Tutorial 1 - The Golden Key](tutorial1.md)
- [Tutorial 2 - Tables and Views](tablesviews.md)
- [Tutorial 3 - Resource Embedding](resource-embedding.md)


## Run for Tutorial 0 and 1
- in schema **api** of the database **postgres**
```
cd postgREST_test
postgrest tutorial.conf
```

## Run for Tutorial 2 and 3
- in schema **public** of the database **dvdrental**
```
cd postgREST_test
postgrest dvdrental.conf
```


## Sample Database for Tutorial 2 and 3
```
Load PostgreSQL Sample Database
https://www.postgresqltutorial.com/postgresql-getting-started/load-postgresql-sample-database/

. download sample
https://www.postgresqltutorial.com/postgresql-getting-started/postgresql-sample-database/

psql -U postgres
CREATE DATABASE dvdrental;
exit;

cd C:\Program Files\PostgreSQL\15\bin
pg_restore -U postgres -d dvdrental C:\APP\sampledb\dvdrental.tar

psql -U postgres
\connect dvdrental
```


## Doc

+ **postgrest**
- https://postgrest.org/
- https://postgrest.org/en/stable/references/configuration.html#configuration
- https://postgrest.org/en/stable/tutorials/tut0.html
- https://postgrest.org/en/stable/tutorials/tut1.html#tut1
- https://postgrest.org/en/stable/references/api/tables_views.html
- https://postgrest.org/en/stable/references/api/resource_embedding.html

+ **Password generator in cmd batch**
- https://superuser.com/questions/280802/what-command-line-tool-can-generate-passwords-on-windows
- https://stackoverflow.com/questions/34802042/password-generator-in-cmd-batch

+ **EpochConverter** Epoch & Unix Timestamp Conversion Tools
- https://www.epochconverter.com/
