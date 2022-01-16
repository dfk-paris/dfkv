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

To start the backend rack app, first build the vagrant virtual machine. This
requires that you have [vagrant](https://vagrantup.com) and
[virtualbox](https://virtualbox.org) installed. Then run:

~~~bash
vagrant up
bin/dev.sh
~~~

Then the development instance is available at http://127.0.0.1:3000