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

- Multiple conditions on columns are evaluated using **and** by default, but you can combine them using **or** with the or operator.
```
curl "http://localhost:3000/film?or=(length.lt.50,length.gt.180)"
```

- To negate any operator, you can prefix it with **not** 
- ?a=not.eq.2 or ?not.and=(a.gte.0,a.lte.100)

- You can also apply complex logic to the conditions:
```
curl "http://localhost:3000/people?grade=gte.90&student=is.true&or=(age.eq.14,not.and(age.gte.11,age.lte.17))"
```


#### Operator Modifiers

- You may further simplify the logic using the **any/all** modifiers of **eq,like,ilike,gt,gte,lt,lte,match,imatch**
- any (= or)
- all (= and)

```
curl "http://localhost:3000/film?title=like(any).{O*,P*}"
curl "http://localhost:3000/film?title=like(all).{O*,*n}"
```
- in **windows** escape with **\\**
```
curl "http://localhost:3000/film?title=like(any).\{O*,P*\}"
```


#### Pattern Matching

- **like, ilike, match, imatch**
- https://www.postgresql.org/docs/current/functions-matching.html


#### Full-Text Search

- https://www.postgresql.org/docs/current/datatype-textsearch.html



### Vertical Filtering (Columns)

- When certain columns are wide (such as those holding binary data), it is more efficient for the server to withhold them in a response. The client can specify which columns are required using the **sql:select** parameter.
```
curl "http://localhost:3000/film?select=film_id,title"
```

#### Renaming Columns

- You can rename the columns by prefixing them with an alias followed by the colon **:** operator.
```
curl "http://localhost:3000/film?select=id:film_id,titol:title"
```

#### Casting Columns

- Casting the columns is possible by suffixing them with the double colon **::** plus the desired type.
```
curl "http://localhost:3000/film?select=title,rental_rate,rental_rate::text"
```



### JSON Columns
...