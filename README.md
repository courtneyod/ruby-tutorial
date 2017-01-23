# Tutorial on how to get Women Who Code's website environment up and running

This is my first time being exposed to an open source project, specifically's Women Who Code's website. The have their issues grouped by the type of problem and complexity, including beginner friendly issues.

The tutorial goes over how to their environment up and running. They have a terrific [wiki](https://github.com/WomenWhoCode/website/wiki/General-Setup-Guide) on their repo but I wanted to share how I set up it, issues I ran into and how I resolved them. I'm working off a fairly new machine that has Node installed and atom, but not much else so basically from scratch.

Their site is built with Ruby and Rails, Postgresql for their database, elasticsearch for searching and React JS for frontend. Dependencies are managed with Bundler and environment variables with Figaro. To test our code we use rspec.


# Objectives
  - Get Women Who Code's environment up and running on your local machine

# Step 1

Clone the repo in your terminal by running `https://github.com/WomenWhoCode/website/`, no forking.

Why might they have you clone versus fork? Cloning a repo reduces a layer of complexity - it's more of a workflow thing than anything else. If you forked the repo, every time you want to get code from your repository their master branch you would nned to merge your commits with your master branch and then push the changes to WWC's master branch, adding slightly more work.

You will now have a new directory called `website`.

# Install Ruby Version Manager

On the [Ruby Installation page](https://www.ruby-lang.org/en/documentation/installation/), scroll down to the 'Mangers' bullet and click RVM (Ruby Version Manager).

RVM allows you to install and manage multiple installations of Ruby on your system. RVM installs each version of Ruby in a hidden folder in your home folder so each version of Ruby you install doesn’t affect the system Ruby.

On the [RVM page](http://rvm.io/)

The instructions suggest running:
`$> gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3` in the terminal but I get the following error `zsh: command not found: gpg`. This [Stack OverFlow](http://stackoverflow.com/questions/27041885/how-to-resolve-gpg-command-not-found-error-during-rvm-installation) thread goes over the error. In short, "Mac OS X does not bring GnuPG with the operating system, so you have to install it on your own.
GnuPG is an application used for public key encryption using the OpenPGP protocol, but also verification of signatures (cryptographic signatures, that also can validate the publisher if used correctly)."

To install GnuPG run:
`$> brew install gpg2`  

Then you can run:
`$> gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3`

`\curl -sSL https://get.rvm.io | bash -s stable --ruby\curl -sSL https://get.rvm.io | bash -s stable --ruby`

I had to also run:
`$> source /Users/gschoolstudent/.rvm/scripts/rvm` (specific to my path)

You can list the versions of Ruby available to RVM with rvm list:
`$> rvm rubies`

The rvm use command selects a version of Ruby:
`$> rvm use 2.2.0`

You can check that you’re using an RVM-managed version of Ruby with:
`$> which ruby`

And confirm this by asking Ruby itself with:
`$> ruby -v`

# Install Postgresql

Macs do not come with Postgresql automatically installed. The suggested way to install Postgresql is with homebrew.

Install Homebrew on your mac. If you already have Homebrew, upgrade and update packages
`$> brew upgrade`
`$> brew update`

`$> brew install postgresql`

To launch postgresql now and restart at login:
`$>  brew services start postgresql`

Create a spot for your databases to live:
`$>  initdb /usr/local/var/postgres -E utf8`


Open the code in your editor (I'm using Atom). Update the __database.yml__ file. Change the contents of your config/database.yml as below. Also update your username.
*Note: When you install postgresql through homebrew your username would be that of your system's username and password is blank*

Create a database.yml file under your config folder and change the contents of your config/database.yml as below with an updated username.
When you install postgresql through homebrew your username would be that of your system's username and password is blank

`### PostgreSql
development:
  adapter:  postgresql
  host:     localhost
  encoding: unicode
  database: wwcode
  pool:     5
  username: <username>
  password:
  port: 5432

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.


test:
  adapter:  postgresql
  host:     localhost
  encoding: unicode
  database: wwcode_test
  pool:     5
  username: <username>
  password:
  port: 5432

production:
  adapter:  postgresql
  host:     localhost
  encoding: unicode
  database: wwcode_production
  pool:     5
  port: 5432
  username: <username>
  password:
`

You now have create a Postgres server but you do not have a WWCode database set up in Postgres. Run `$> createdb wwcode`.

In order for create a database you will need to set up your secret keys. But first, we need to complete installing the rest of the software

# Installing the rest of the software

Run `gem install bundler`

When I ran install bundler I got the following error message
`Your Ruby version is 2.3.3, but your Gemfile specified 2.2.2`

So I had to install and switch to Ruby 2.2.2
`$> rvm install 2.2.2`

then you can run       
`$> gem install bundler`
`$> bundle install`

When you receive the message, "Bundle complete!" you are ready to move on.

Elasticsearch
The searchkick gem is compatible with v2 or v5.). Run:

`$> brew install elasticsearch`

After I ran the command in the terminal I got the following message:
`Updating Homebrew...
elasticsearch: Java 1.8+ is required to install this formula.JavaRequirement unsatisfied!

You can install with Homebrew-Cask:
 brew cask install java`

So I then ran `$> brew cask install java`

Once you see " :beer:  java was successfully installed!" rerun:
`$> brew install elasticsearch`

You now can open a new tab in your terminal and run
`elasticsearch` to start the elasticsearch server

# Setting Secret Keys

Run `$> bundle exec figaro install`. This will create config/application.yml, where your secret keys will live.

Open __config/application.yml__. You'll see several commented lines that were pre-filled by Figaro. You can delete these lines and add:

`DEVISE_SECRET: 'paste-character-string-here-between-quotes'`

Run `$> rails s`. You should get a long error, which will include a line near the top that reads, `config.secret_key =` and a long string of characters. Copy the string to DEVISE_SECRET.

Add another line to __config/application.yml__:

`SECRET_KEY_BASE: 'new-character-string-here-between-quotes'`

Save the file, then run `$>rake secret`. This will produce another string of characters to copy to SECRET_KEY_BASE.

Add the following API keys for use of the file-picker and stripe:

`development:
  STRIPE_KEY: pk_test_6DscEAPHEHS28EYSuiXZ1yoy
  STRIPE_SECRET_KEY: sk_test_5NqdHORlW4XfBeCcbjNgqthF
  FILEPICKER_KEY: Af0ieUjfRTK8p3mR9iReBz
  RECAPTCHA_PUBLIC_KEY: 6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI
  RECAPTCHA_PRIVATE_KEY: 6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe
  MEETUP_KEY: any text (testing) or your personal meetup api key (to dev)
  SMTP_ADDRESS: smtp.mandrillapp.com
  SMTP_DOMAIN: localhost
  SMTP_PASSWORD: test
  SMTP_USERNAME: test
test:
  STRIPE_KEY: pk_test_6DscEAPHEHS28EYSuiXZ1yoy
  STRIPE_SECRET_KEY: sk_test_5NqdHORlW4XfBeCcbjNgqthF
  FILEPICKER_KEY: Af0ieUjfRTK8p3mR9iReBz
  RECAPTCHA_PUBLIC_KEY: 6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI
  RECAPTCHA_PRIVATE_KEY: 6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe
  MEETUP_KEY: any text (testing) or your personal meetup api key (to dev)
  SMTP_ADDRESS: smtp.mandrillapp.com
  SMTP_DOMAIN: localhost
  SMTP_PASSWORD: test
  SMTP_USERNAME: test`

# Setting up PG database

Now we have to populate the database with data! First run:
`$> rake db:seed`
`$> rake db:migrate`

To check if you database contains tables and tables have data in them run:
`$> psql wwcode`

In psql, `\dt` will list all your tables in the wwcode database. You should see a list of tables which includes a users table. To see if your user table hold any data type in:
`SELECT * FROM users;`

Check out the plans table:
`SELECT * FROM plans;`

#Loading the Sever

To get the server up, run `rails s` in your terminal. The 2nd line should say something like this: `=> Rails 4.2.6 application starting in development on http://localhost:3000`

Copy the localhost path and paste it into your browser. It may take a few seconds but you should be able to see the site!
