## So you want to develop this mess.
Well, you're (kind of) in luck (and also insane). For I have made a Docker configuration especially made for development of this application. It sets up a mysql server, ldap server and rails server on your system to simulate the environment that this app runs in production. You (should) only need to run `docker-compose up --build` when you want to start the environment, then test out your changes on *localhost:3000*.

### LDAP mock config
We've prepared a mock config of the LDAP server used in production. Here is the naming convention of users:

```
uid=testxx
cn=%{nickname}
givenName=TestxxGivenName
homeDirectory=/home/chalmersit/testxx
mail=testxx@example.ex
nickname=Testxx
sn=TestxxSurname
userPassword=testxxpass <-- (this is hashed with SSHA)
uidNumber={a unique number}
loginShell=Bash
```

#### Want to change anything in LDAP?
Use apache directory studio (aur-package `apachedirectorystudio`) or another ldap editor, but used this so it should work.


### Got questions or "stuff no work pliz halp"s, contact digit@chalmers.it (and for a while feffe@chalmers.it might answer your questions but that aint guaranteed).

Other than that, just get to coding, silly! Add dependencies to `Gemfile`. 