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
### Composite / Array Columns
### Computed / Virtual Columns

### Ordering

- The reserved **word** order reorders the response rows. It uses a comma-separated list of columns and directions:
```
curl "http://localhost:3000/film?order=title.asc,length.desc"
```

- If you care where nulls are sorted, add **nullsfirst** or **nullslast**
```
curl "http://localhost:3000/people?order=age.nullsfirst"
curl "http://localhost:3000/people?order=age.desc.nullslast"
```

### Limits and Pagination

- PostgREST uses HTTP range headers to describe the size of results. Every response contains the current range and, if requested, the total number of results:
```
HTTP/1.1 200 OK
Range-Unit: items
Content-Range: 0-14/*
```

- Here items zero through fourteen are returned. This information is available in every response and can help you render pagination controls on the client. This is an RFC7233-compliant solution that keeps the response JSON cleaner.

- There are two ways to apply a limit and offset rows: through **request headers** or **query parameters**. 

- When using **headers** you specify the range of rows desired. This request gets the first twenty items.
```
curl "http://localhost:3000/film" -i \
  -H "Range-Unit: items" \
  -H "Range: 0-19"
```

- You may also request open-ended ranges for an offset with no limit, e.g. **Range: 10-**

- The other way to request a limit or offset is with **query parameters**.
```
curl "http://localhost:3000/film?limit=3&offset=10"
```


### Exact Count
### Planned Count
### Estimated Count


## Update

- To update a row or rows in a table, use the **PATCH** verb. Use Horizontal Filtering (Rows) to specify which record(s) to update
```
curl "http://localhost:3000/film?select=film_id,title&title=like(any).{B%}" \
  -X PATCH -H "Content-Type: application/json" \
  -d '{ "release_year": 2007 }'
```

## Insert

- All tables and auto-updatable views can be modified through the API, subject to permissions of the requester’s database role.

- To create a row in a database table post a JSON object whose keys are the names of the columns you would like to create. Missing properties will be set to default values when applicable.
```
curl "http://localhost:3000/film" \
  -X POST -H "Content-Type: application/json" \
  -d '{ 
    "title": "Django Unchained", 
    "release_year": 2012,
    "language_id": 1
}'
```

- If the table has a primary key, the response can contain a **Location** header describing where to find the new object by including the header **Prefer: return=headers-only** in the request. Make sure that the table is not write-only, otherwise constructing the **Location** header will cause a permissions error.

- On the other end of the spectrum you can get the full created object back in the response to your request by including the header **Prefer: return=representation**. That way you won’t have to make another HTTP call to discover properties that may have been filled in on the server side. You can also apply the standard Vertical Filtering (Columns) to these results.

- URL encoded payloads can be posted with **Content-Type: application/x-www-form-urlencoded**
```
curl "http://localhost:3000/film" \
  -X POST -H "Content-Type: application/x-www-form-urlencoded" \
  -d "title=Pulp Fiction&release_year=1994&language_id=1"
```

- When inserting a row you must post a JSON object, not quoted JSON.
```
Yes
{ "a": 1, "b": 2 }

No
"{ \"a\": 1, \"b\": 2 }"
```

- Some JavaScript libraries will post the data incorrectly if you’re not careful. For best results try one of the Client-Side Libraries built for PostgREST.

### Bulk Insert
### Bulk Insert with Default Values
### Specifying Columns

## Upsert

## Delete

- To delete rows in a table, use the **DELETE** verb plus Horizontal Filtering (Rows).
```
curl "http://localhost:3000/film?special_features=is.null" -X DELETE
```

- Deletions also support **Prefer: return=representation** plus Vertical Filtering (Columns).

- You can limit the amount of affected rows by Update or Delete with the **limit** query parameter. For this, you must add an explicit **order** on a unique column(s).