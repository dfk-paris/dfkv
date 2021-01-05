# Deutsch-Französische Kunstvermittlung 1871–1940 und 1945-1960 (database)

This is the database project for 
[Deutsch-Französische Kunstvermittlung 1871–1940 und 1945-1960](https://dfk-paris.org/de/page/deutsch-französische-kunstvermittlung-1871–1940-und-1945-1960-datenbank-2391.html) at the [DFK Paris](https://dfk-paris.org).

The application is implemented as a set of
[riot.js v3](https://v3.riotjs.now.sh) widgets and a backend
[rack](https://rack.github.io) application with MySQL.

# Development

The frontend development and asset compilation are implemented with nodejs. To
get started, run

 npm run dev

This starts a development server with a simple page at http://localhost:3000

To start the backend rack app, install a recent ruby version and install the
dependencies:

~~~bash
bundle install
~~~

then, to start the backend app, run

~~~bash
bundle exec bin/api
~~~
