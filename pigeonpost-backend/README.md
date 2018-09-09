# README

### Local Development

Clone the `carrier-pigeon` repo on your local machine.

Install [ruby](https://www.ruby-lang.org/en/documentation/installation/)

Install rails using `gem install rails`.

In a terminal, run `rails s` from the `pigeonpost-backend` dir. Navigate to `http://localhost:3000/` to see your local server.

If you get an error about a missing db, run `rails db:create` and then try starting the server again.

### Deployment

If the deploy has a migration, run `heroku run rake db:migrate` first.

Run `git subtree push --prefix pigeonpost-backend heroku master` from the root directory of the project.
