[![CI](https://github.com/makigas/makigas.es/actions/workflows/ci.yml/badge.svg)](https://github.com/makigas/makigas.es/actions/workflows/ci.yml)
[![CD](https://github.com/makigas/makigas.es/actions/workflows/cd.yml/badge.svg)](https://github.com/makigas/makigas.es/actions/workflows/cd.yml)

<img src="https://i.imgur.com/GPJvkq1.png" alt="makigas">

# About

This is the public source code for makigas.es. The whole application is built
as a Ruby on Rails monolithic application which allows to browse and watch the
videos.

# Setting up

## Requirements

Requirements:

* Ruby 3.1 and Bundler. Older Ruby version are not supported.
* An up to date PostgreSQL database. Other SQL engines are not supported.
* [MeiliSearch](https://www.meilisearch.com/), to build the search engine.
* Node.js + Yarn, for the front-end assets.
* `libpq-dev`. If `bundle install` refuses to install pg, check this.
* `imagemagick`. Required for image manipulation on thumbnails and such.
* A web browser with Selenium support, for running E2E tests.

## Getting the code

To install the web application:

    $ git clone https://github.com/makigas/makigas.es
    $ cd makigas
    $ bundle install

## Environment variables

Copy the .env.example file to .env.

Tweak the file as you need.  For instance, you might need to modify the
credentials to access the database if you are in GNU/Linux, because
probably your PostgreSQL won't allow unauthenticated connections.

## Running the application

Standard `rails server`, like any other Rails application out there.  Because
we are using jsbundling-rails, you are expected to be compiling the packs on
your own. You can do this running `yarn build` to build via esbuild once, or
`yarn build:watch` in a separate terminal, to keep doing this in the background
and update the packs everytime you save a JS or CSS file.

You can also run `bin/guard` to start the application via Guard, which will use
some guard plugins to keep the application running and up to date, and will
recompile the assets every time you change them. Additionally, it will run
the test suite and linters whenever you update these files.

## Database

Upstream database is PostgreSQL and that is the officially supported one. Said
that, this web application may work on MySQL and sqlite3 as well, although I
haven't tested this, and it's not officially supported. If you experience bugs
by using MySQL, they cannot be fix.

Remember to set the credentials in your .env file if needed for development.

## MeiliSearch

We are using MeiliSearch for the full text search index, which can be
used to lookup for video content using text that appears in the title,
description, transcription and text notes of the episode, with the hope
of making it easier to discover and consume.

You will need to [have MeiliSearch in your development environment
installed](https://docs.meilisearch.com/) if you plan to work in the
search system. It is not necessary anymore to keep MeiliSearch always
open because indexing has been refered to jobs.

## DelayedJob

MeiliSearch indexing has been defered to jobs.  If you want to run the
jobs, use `rake jobs` to spawn a DelayedJob server, or use `rake
jobs:work` to run the pending commands as a one-off.

## Secrets

makigas.es is using secrets, and it will do until secrets are not supported
anymore (let's hope this never happens). While there are newer secret storage
systems in Ruby on Rails nowadays, for an open source application I don't
understand how that does work, and most big Rails open source projects I've
looked for inspiration don't do either.

Production secrets are provided using environment variables, following the
Twelve Factor guidelines. In the future I hope to use a different system or
to abandon altogether secrets.yml to make this more clear.

## Seeds

You can use `rails db:seed` to initially seed some test data, such as a
dashboard user. If you do so, you will be able to log in to the dashboard
using `root@makigas.es` as username and `password` as password.

You can fetch live data from makigas.es using the JSON views deployed live,
by using `makigas:download_production`. It may take some time to do so.
Not every data structure is downloaded at the moment. Some things might not
be included.

# Contributing

Read the [CONTRIBUTING.md][1] file for more information on how to contribute to
the project. Follow the [Code of Conduct][2]. My two favourite guidelines from
the Contributing file:

* Send as many issues as you need, but please, keep one topic per issue
  in order to keep things clean and easy to track.
* Don't submit surprise PRs with new code. Always discuss your intentions
  in a tracking issue before starting to work so that we can provide you all
  the help you need, allocate your idea into the roadmap, or politely reject
  your idea if we consider it's outside the scope of the project.

If you find a bug in this source code or an issue or visual glitch on the web
site, please file a bug. If you find a security vulnerability on this source
code, please disclose it in a private way to me. [My e-mail address and my
PGP key is on my personal website][3].

# License

    makigas v6 - source code for the makigas.es application
    Copyright (C) 2016-2022 Dani Rodríguez

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


# Frequently Asked Questions

* **What is the point on sharing the source code?**
  I don't have any particular interest in this source code at this moment. I
  just want an app that works and that allows me to manage my videos and keep
  my information up to date.

[1]: https://github.com/makigas/makigas.es/blob/trunk/CONTRIBUTING.md
[2]: https://github.com/makigas/makigas.es/blob/trunk/CODE_OF_CONDUCT.md
[3]: https://www.danirod.es/contact/
