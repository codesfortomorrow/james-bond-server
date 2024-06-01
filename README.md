# Database Import/Export to initialize database
### Bet DB

```sh
# To export database
$ docker exec -t betdb pg_dump -d fantasy_bet_service -c -U postgres > betdb.sql

# To import database
$ cat betdb.sql | docker exec -i betdb psql -d fantasy_bet_service -U postgres
```
### User DB

```sh
# To export database
$ docker exec -t userdb pg_dump -d fantasy_user_service -c -U postgres > userdb.sql

# To import database
$ cat userdb.sql | docker exec -i userdb psql -d fantasy_user_service -U postgres
```