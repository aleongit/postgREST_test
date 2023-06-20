# Resource Embedding

- PostgREST allows including related resources in a single API call. This reduces the need for many API requests.

- **Foreign Keys** determine which tables and views can be returned together.


## Many-to-one relationships

```
curl "http://localhost:3000/city?select=city_id,city,country(name:country)"
```
```
[
...
{
        "city_id": 90,
        "city": "Bratislava",
        "country": {
            "name": "Slovakia"
        }
    },
    {
        "city_id": 91,
        "city": "Brescia",
        "country": {
            "name": "Italy"
        }
    },
    {
        "city_id": 92,
        "city": "Brest",
        "country": {
            "name": "France"
        }
    },
...
]
```


## One-to-many relationships

```
curl "http://localhost:3000/country?select=country_id,country,city(city_id,city)"
```
```
[
...
{
        "country_id": 8,
        "country": "Australia",
        "city": [
            {
                "city_id": 576,
                "city": "Woodridge"
            }
        ]
    },
    {
        "country_id": 9,
        "country": "Austria",
        "city": [
            {
                "city_id": 186,
                "city": "Graz"
            },
            {
                "city_id": 307,
                "city": "Linz"
            },
            {
                "city_id": 447,
                "city": "Salzburg"
            }
        ]
    },

...
]
```

## Many-to-many relationships

- The join table determines many-to-many relationships. It must contain foreign keys to other two tables and they must be part of its composite key.
+ film (film_id)
+ actor (actor_id)
+ film_actor (film_id, actor_id)

```
curl "http://localhost:3000/actor?select=first_name,last_name,film(title)&film.order=title.asc"
```
```
[
    {
        "first_name": "Penelope",
        "last_name": "Guiness",
        "film": [
            {
                "title": "Academy Dinosaur"
            },
            {
                "title": "Anaconda Confessions"
            },
        ...
            {
                "title": "Westward Seabiscuit"
            },
            {
                "title": "Wizard Coldblooded"
            }
        ]
    },
...
]
```


## One-to-one relationships

- **One-to-one relationships are detected when:**
- The foreign key has a unique constraint.
- The foreign key is a primary key.



## Nested Embedding

- If you want to embed through join tables but need more control on the intermediate resources, you can do nested embedding.

```
curl "http://localhost:3000/actor?select=first_name,last_name,film_actor(film(title,length))"
```

```
[
    {
        "first_name": "Penelope",
        "last_name": "Guiness",
        "film_actor": [
            {
                "film": {
                    "title": "Academy Dinosaur",
                    "length": 86
                }
            },
        ...
            {
                "film": {
                    "title": "Bulworth Commandments",
                    "length": 61
                }
            }
        ]
    },
  ...
...
]
```


## Embedded Filters

- Embedded resources can be shaped similarly to their top-level counterparts. To do so, prefix the query parameters with the name of the embedded resource.

```
curl "http://localhost:3000/film?select=*,actor(*)&actor.order=last_name,first_name"
```

```
[
    {
        "film_id": 133,
        "title": "Chamber Italian",
...
        "actor": [
            {
                "actor_id": 60,
                "first_name": "Henry",
                "last_name": "Berry",
            },
        ...
            {
                "actor_id": 68,
                "first_name": "Rip",
                "last_name": "Winslet",
            }
        ]
    },
...
]
```

```
curl "http://localhost:3000/film?select=*,film_actor(*)&film_actor.actor_id=in.(1,2,3)"
```

- This restricts the **film_actor** included to certain **actor_id** but does not filter the films in any way. Films without any of those **actor_id** would be included along with empty **film_actor** lists.

```
[
    {
        "film_id": 133,
        "title": "Chamber Italian",
    ...
        "film_actor": []
    },
    {
        "film_id": 384,
        "title": "Grosse Wonderful",
    ...
        "film_actor": []
    },
...
    {
        "film_id": 1,
        "title": "Academy Dinosaur",
    ...
        "film_actor": [
            {
                "actor_id": 1,
                "film_id": 1
            }
        ]
    },
...
]
```

## Top-level Filtering

- By default, Embedded Filters don’t change the top-level resource(films) rows at all:

```
curl "http://localhost:3000/film?select=title,actor(first_name,last_name)&actor.first_name=eq.Penelope"
```
```
[
    {
        "title": "Chamber Italian",
        "actor": []
    },
  ...
    {
        "title": "Academy Dinosaur",
        "actor": [
            {
                "first_name": "Penelope",
                "last_name": "Guiness"
            }
        ]
    },
    {
        "title": "Ace Goldfinger",
        "actor": []
    },
  ...
...
]
```

- In order to filter the top level rows you need to add **!inner** to the embedded resource.

```
curl "http://localhost:3000/film?select=title,actor!inner(first_name,last_name)&actor.first_name=eq.Penelope"
```
```
[
    {
        "title": "Academy Dinosaur",
        "actor": [
            {
                "first_name": "Penelope",
                "last_name": "Guiness"
            }
        ]
    },
    {
        "title": "Amadeus Holy",
        "actor": [
            {
                "first_name": "Penelope",
                "last_name": "Cronyn"
            }
        ]
    },
...
]
```

## Top-level Ordering

- On **Many-to-One** and **One-to-One** relationships, you can use a column of the “to-one” end to sort the top-level.

```
curl "http://localhost:3000/city?select=city,country(country)&order=country(country).desc"
```
```
[
    {
        "city": "Kitwe",
        "country": {
            "country": "Zambia"
        }
    },
    {
        "city": "Kragujevac",
        "country": {
            "country": "Yugoslavia"
        }
    },
    {
        "city": "Novi Sad",
        "country": {
            "country": "Yugoslavia"
        }
    },
...
]
```