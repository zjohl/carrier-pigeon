# README

### Local Development


In a terminal, run `rails s` from the `pigeonpost-backend` dir. Navigate to `http://localhost:3000/` to see your local server.

If you get an error about a missing db, run `rails db:create` and then try starting the server again.

### Deployment

Run `git subtree push --prefix pigeonpost-backend heroku master` from the root directory of the project.
