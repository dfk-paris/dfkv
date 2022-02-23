# Deutsch-Französische Kunstvermittlung 1871–1940 und 1945-1960 (database)

This is the database project for 
[Deutsch-Französische Kunstvermittlung 1871–1940 und 1945-1960](https://dfk-paris.org/de/page/deutsch-französische-kunstvermittlung-1871–1940-und-1945-1960-datenbank-2391.html) at the [DFK Paris](https://dfk-paris.org).

The application is implemented as a set of
[riot.js v3](https://v3.riotjs.now.sh) widgets and a backend
[rack](https://rack.github.io) application with MySQL.

# Development

The application consists of a small ruby web API and a frontend to be embedded
in virtually any website (static, cms, groupware etc.). Below, we provide
basic instructions on how to get a development environment up and running.

## Requirements

More recent versions will likely also work, here is what we used during
development

* ruby 2.7.5
* elasticsearch 7.16.3
* nodejs 14.18.2

## Setup

Install required libraries

    bundle install
    npm install

Start elastichsearch so that it accepts connections at `http://127.0.0.1:9200`.
You may install (docker)[https://docker.com] and run

    npm run elastic

This will download relevant docker containers and run it (stop with `ctrl-c`).
The data will not be saved when elasticsearch is restarted.

In another terminal, run

    npm run index

which will feed the DFKV data to elasticsearch. The process will take a minute
or two.

In a third terminal, start the frontend development server

    npm run dev

so that the frontend is available at http://127.0.0.1:4000.