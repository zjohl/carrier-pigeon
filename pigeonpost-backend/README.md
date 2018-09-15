# README

### Local Development

Clone the `carrier-pigeon` repo on your local machine.

1. Install [ruby](https://www.ruby-lang.org/en/documentation/installation/)

2. Install nodejs [here](https://nodejs.org/en/download/)

3. Install postgres using `gem install pg`.

4. Install rails using `gem install rails`.

The above steps have their own dependencies that you might need to install first.

In a terminal, run `rails s` from the `pigeonpost-backend` dir. Navigate to `http://localhost:3000/` to see your local server.

If you get an error about a missing db, run `rails db:create` and then try starting the server again.

### Deployment

If the deploy has a migration, run `heroku run rake db:migrate` first.

Run `git subtree push --prefix pigeonpost-backend heroku master` from the root directory of the project.
