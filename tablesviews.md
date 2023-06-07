# Test Tables and Views

- All views and tables of the exposed schema and accessible by the active database role are available for querying. They are exposed in one-level deep routes.

## Read

- For instance the full contents of a table people is returned at
```
curl "http://localhost:3000/film"
```

### Horizontal Filtering (Rows)

- You can filter result rows by adding conditions on columns.

```
curl "http://localhost:3000/film?length=lt.50"
```

- You can evaluate multiple conditions on columns by adding more query string parameters.

```
curl "http://localhost:3000/customer?customer_id=gte.598&activebool=is.true"
```

#### Operators

- These operators are available:
- **eq gt gte lt lte neq like ilike match imatch in is isdistinct fts plfts phfts wfts cs cd ov sl sr nxr nxl adj not or and all any**
- https://postgrest.org/en/stable/references/api/tables_views.html#operators

- For more complicated filters you will have to create a **new view** in the database, or use a **stored procedure**. 

```
CREATE VIEW fresh_stories AS
SELECT *
  FROM stories
 WHERE pinned = true
    OR published > now() - interval '1 day'
ORDER BY pinned DESC, published DESC;
```
```
curl "http://localhost:3000/fresh_stories"
```


#### Logical operators
...

### Vertical Filtering (Columns)
### JSON Columns
...