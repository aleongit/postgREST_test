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
jwt-secret = "<the password you made>"
```


### Step 3. Sign a Token

- Ordinarily your own code in the database or in another server will create and sign authentication tokens, but for this tutorial we will make one “by hand.” 

- Go to **[jwt.io](https://jwt.io)** and fill in the fields like this:

![Screenshot](screenshots/token_jwt.io.png)

https://jwt.io/#debugger-io?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIn0.3UW2DAERMO--EAUrET80WhjVgl8hLSxcJGDcnI84w3Q

- While the token may look well obscured, it’s easy to reverse engineer the payload. The token is merely signed, not encrypted, so don’t put things inside that you don’t want a determined client to see.


### Step 4. Make a Request

### Step 5. Add Expiration

### Bonus Topic: Immediate Revocation

