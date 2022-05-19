# Deutsch-Französische Kunstvermittlung 1871–1940 und 1945-1960 (database)

This is the database project for 
[Deutsch-Französische Kunstvermittlung 1871–1940 und 1945-1960](https://dfk-paris.org/de/node/2391)
at the [DFK Paris](https://dfk-paris.org).

The application is implemented as a set of
[riot.js v6.1](https://riot.js.org/) widgets and a backend
[rack](https://rack.github.io) application with Elasticsearch 7.16.

# Development

The application consists of a small ruby web API and a frontend to be embedded
in virtually any website (static, cms, groupware etc.). Below, we provide
basic instructions on how to get a development environment up and running.

## Requirements

More recent versions will likely also work, here is what we used during
development

* ruby 3.0
* elasticsearch 7.16
* nodejs 14.19

## Setup

Install required libraries

    bundle install
    npm install

Start elastichsearch so that it accepts connections at `http://127.0.0.1:9200`.
You may install [docker](https://docker.com) and run

    npm run elastic

This will download relevant docker containers and run it (stop with `ctrl-c`).
The data will not be saved when elasticsearch is restarted.

In second terminal, run

    npm run index

which will feed the DFKV data to elasticsearch. The process will take a minute
or two. Once it is done, start the api with

    npm run api

In a third terminal, start the frontend development server

    npm run dev

so that the frontend is available at http://127.0.0.1:4000.

# Production

To run the application in production, the api application needs to be deployed.
It provides the data and javascript widgets to integrate the frontend into other
systems (e.g. drupal, wordpress etc).

Make sure to provide the requirements (see above) before installing the app.

The api is a rack application, please see
[this tutorial](https://wendig.io/2019/11/12/how-to-host-a-ruby-on-rails-app-with-apache.html)
for a step-by-step guide on how to get it up and running. There are a couple of
things to do for this app specifically:

* run `npm run build` and copy all files in `frontend/public/` to a web server
  so that they are publicly available
* edit `.env` to suit the production url and the server environment

To add the application to a website (e.g. drupal), insert this snippet:

    <div is="dfkv"></div>
    <script src="https://static.example.org/app.js"></script>

Change the url to the app.js file you uploaded to your web server earlier.
