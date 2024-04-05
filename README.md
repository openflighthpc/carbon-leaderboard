# Carbon Leaderboard

This tool receives, stores and showcases user carbon data.

## Initial Setup

- Ensure Ruby (3.2.2) and Bundler are installed on your device
- Ensure Sqlite is installed on your device (`sqlite3 --version`)
- Run `bundle install`
- Run `bin/rails db:migrate`

## Operation

- Run the application with `bin/rails s`
- By default it will be accessible at `http://localhost:3000/`. This can be changed by adding `-b` and `-p` when running `bin/rails s`. For example `rails s -b 0.0.0.0 -p 4567`

