# Carbon Leaderboard

This tool receives, stores and showcases user carbon data.

## Initial Setup

- Ensure Ruby (3.2.2) and Bundler are installed on your device
- Ensure SQLite is installed on your device (`sqlite3 --version`)
- Run `bundle install`
- Run `bin/rails secret` to generate a new secret key.
- Update the application's database credentials using `EDITOR=vim rails credentials:edit` (replacing `vim` with the editor of your choice) and setting `secret_key_base` to the key you generated with the previous command.
- Run `bin/rails db:migrate`

## Operation

- Run the application with `bin/rails s`
- By default it will be accessible at `http://localhost:3000/`. This can be changed by adding `-b` and `-p` when running `bin/rails s`. For example `rails s -b 0.0.0.0 -p 4567`

