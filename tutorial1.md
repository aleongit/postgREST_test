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

### Step 3. Sign a Token

### Step 4. Make a Request

### Step 5. Add Expiration

### Bonus Topic: Immediate Revocation

