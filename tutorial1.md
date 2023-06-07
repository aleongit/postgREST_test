## Tutorial 1 - The Golden Key

### Step 1. Add a Trusted User

- The previous tutorial created a **web_anon** role in the database with which to execute anonymous web requests. 
- Let’s make a role called **todo_user** for users who authenticate with the API. This role will have the authority to do anything to the todo list.

```
create role todo_user nologin;
grant todo_user to authenticator;

grant usage on schema api to todo_user;
grant all on api.todos to todo_user;
grant usage, select on sequence api.todos_id_seq to todo_user;
```

### Step 2. Make a Secret

- Clients authenticate with the API using JSON Web Tokens. These are JSON objects which are cryptographically signed using a password known to only us and the server. Because clients do not know the password, they cannot tamper with the contents of their tokens. PostgREST will detect counterfeit tokens and will reject them.

- Let’s create a password and provide it to PostgREST. Think of a nice long one, or use a tool to generate it. **Your password must be at least 32 characters long**.

- **linux**
```
echo "$(LC_CTYPE=C < /dev/urandom tr -dc A-Za-z0-9 | head -c32 )"
2oCYskZtdxZEXC7zpL6rbcbgkasEh9M7
```

- **windows**
```
cmd/randomalpha.cmd
2D$h0M17WpMDT@x~gbneLoHPzx%vPV7h
```

- Open the **tutorial.conf** and add a line with the password:
```
jwt-secret = "2oCYskZtdxZEXC7zpL6rbcbgkasEh9M7"
```


### Step 3. Sign a Token

- Ordinarily your own code in the database or in another server will create and sign authentication tokens, but for this tutorial we will make one “by hand.” 

- Go to **[jwt.io](https://jwt.io)** and fill in the fields like this:

![Screenshot](screenshots/token_jwt.io.png)

- https://jwt.io/#debugger-io?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIn0.3UW2DAERMO--EAUrET80WhjVgl8hLSxcJGDcnI84w3Q

- **token**
+ **eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIn0.3UW2DAERMO--EAUrET80WhjVgl8hLSxcJGDcnI84w3Q**

- While the token may look well obscured, it’s easy to reverse engineer the payload. The token is merely signed, not encrypted, so don’t put things inside that you don’t want a determined client to see.



### Step 4. Make a Request

- Back in the terminal, let’s use **curl** to add a todo. The request will include an HTTP header containing the authentication token.

- **linux**
```
export TOKEN="<paste token here>"

curl http://localhost:3000/todos -X POST \
     -H "Authorization: Bearer $TOKEN"   \
     -H "Content-Type: application/json" \
     -d '{"task": "learn how to auth"}'
```

- **windows**
```
set TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIn0.3UW2DAERMO--EAUrET80WhjVgl8hLSxcJGDcnI84w3Q"

echo %TOKEN%

curl http://localhost:3000/todos -X POST ^
-H "Authorization: Bearer %TOKEN%"   ^
-H "Content-Type: application/json" ^
-d "{\"task\": \"learn how to auth\"}"
```

- And now we have completed all three items in our todo list, so let’s set **done** to true for them all with a PATCH request.

- **linux**
```
curl http://localhost:3000/todos -X PATCH \
     -H "Authorization: Bearer $TOKEN"    \
     -H "Content-Type: application/json"  \
     -d '{"done": true}'
```

- **windows**
```
curl http://localhost:3000/todos -X PATCH ^
-H "Authorization: Bearer %TOKEN%"   ^
-H "Content-Type: application/json" ^
-d "{\"done\": true}"
```

- A request for the todos shows three of them, and all completed.
```
curl http://localhost:3000/todos
```


### Step 5. Add Expiration

- Currently our authentication token is valid for all eternity. The server, as long as it continues using the same JWT password, will honor the token.

- It’s better policy to include an **expiration timestamp** for tokens using the **exp** claim. This is one of two JWT claims that PostgREST treats specially.

| Claim     | Interpretation                                                   |
| :------   |:---------------                                                  |
| **role**  | The database role under which to execute SQL for API request     |
| **exp**   | Expiration timestamp for token, expressed in “Unix epoch time”   |

- Epoch time is defined as the number of seconds that have elapsed since 00:00:00 Coordinated Universal Time (UTC), January 1st 1970, minus the number of leap seconds that have taken place since then.

- To observe expiration in action, we’ll add an exp claim of five minutes in the future to our previous token. First find the epoch value of five minutes from now. In psql run this:
```
select extract(epoch from now() + '5 minutes'::interval) :: integer;
```

- Go back to **[jwt.io](https://jwt.io)** and change the payload to
```
{
  "role": "todo_user",
  "exp": 1686137263
}
```
- 1686137263 = dimecres 7 de juny de 2023 a les 13:27:43 GMT+02:00 DST

- https://jwt.io/#debugger-io?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIiwiZXhwIjoxNjg2MTM3MjYzfQ.0DkENV0MYuBPcnox0KTmQtmUfzDuls6ahSgz6cRfEUo

- **token**
- eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIiwiZXhwIjoxNjg2MTM3MjYzfQ.0DkENV0MYuBPcnox0KTmQtmUfzDuls6ahSgz6cRfEUo

- Copy the updated token as before, and save it as a new environment variable.
```
export NEW_TOKEN="<paste new token>"
```

- Try issuing this request in curl before and after the expiration time:
- **linux**
```
curl http://localhost:3000/todos \
     -H "Authorization: Bearer $NEW_TOKEN"
```

- **windows**
```
set NEW_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIiwiZXhwIjoxNjg2MTM3MjYzfQ.0DkENV0MYuBPcnox0KTmQtmUfzDuls6ahSgz6cRfEUo"

curl http://localhost:3000/todos ^
-H "Authorization: Bearer %NEW_TOKEN%"
```

```
curl http://localhost:3000/todos ^
-H "Authorization: Bearer %NEW_TOKEN%"
[{"id":1,"done":true,"task":"finish tutorial 0","due":null},
 {"id":2,"done":true,"task":"pat self on back","due":null},
 {"id":3,"done":true,"task":"learn how to auth","due":null},
 {"id":5,"done":true,"task":"do bad thing","due":null}]

curl http://localhost:3000/todos ^
-H "Authorization: Bearer %NEW_TOKEN%"
{"code":"PGRST301","details":null,"hint":null,"message":"JWT expired"}
```

- After expiration, the API returns HTTP 401 Unauthorized:
```
{
  "hint": null,
  "details": null,
  "code": "PGRST301",
  "message": "JWT expired"
}
``` 


### Bonus Topic: Immediate Revocation

