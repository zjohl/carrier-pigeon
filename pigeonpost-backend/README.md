# README

### Local Development

Clone the `carrier-pigeon` repo on your local machine.

1. Install [ruby](https://www.ruby-lang.org/en/documentation/installation/)

2. Install nodejs [here](https://nodejs.org/en/download/)

3. Install postgres using `gem install pg`.

4. Install rails using `gem install rails`.

The above steps have their own dependencies that you might need to install first.

5. Try running `rails db:create`. If this fails because of a missing user, create a user called `postgres` with the password `root`. Then re-run `rails db:create` `rails db:migrate` and `rails db:seed`.

In a terminal, run `rails s` from the `pigeonpost-backend` dir. Navigate to `http://localhost:3000/` to see your local server.

If you get an error about a missing db, run `rails db:create` and then try starting the server again.

### Deployment

The backend app will be automatically deployed when we commit to master.

To manually deploy:

I believe you need to make a heroku account before I can add you as a collaborator. If you send me the email you used I can add you to the host.

If the deploy has a migration, run `heroku run rake db:migrate` first.

Run `git subtree push --prefix pigeonpost-backend heroku master` from the root directory of the project.
