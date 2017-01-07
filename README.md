<p align="center">
  <a href="https://travis-ci.org/makigas/makigas"><img src="https://travis-ci.org/makigas/makigas.svg?branch=master" alt="Build Status"></a>
  <a href="https://gemnasium.com/github.com/makigas/makigas"><img src="https://gemnasium.com/badges/github.com/makigas/makigas.svg" alt="Dependency Status" /></a>
  <a href="https://github.com/makigas/makigas/releases"><img src="https://img.shields.io/github/tag/makigas/makigas.svg" alt="Latest release"></a>
  <a href="https://github.com/makigas/makigas/blob/master/COPYING"><img src="https://img.shields.io/github/license/makigas/makigas.svg" alt="License"></a>
</p>

<p align="center">
<img src="http://i.imgur.com/GPJvkq1.png" alt="makigas">
</p>

# About

This is the public source code for makigas.es. The whole application was recently redesigned from scratch using the Ruby on Rails framework. This web site, just like previous iterations, still displays information about videos and playlists in the system.

# Setting up

## Requirements

Supported operating systems:

* Production environments: GNU/Linux.
* Development environments: GNU/Linux, MacOS X.

Requirements:

* Ruby 2.3.3 + Bundler. May suggest getting it via [rvm](https://rvm.io).
* PostgreSQL 9.4. May work on MySQL and sqlite3, although hasn't been tested.
* `libpq-dev`. If `bundle install` refuses to install pg, may be because of this.
* `imagemagick`. Required for image manipulation when creating playlists and topics.

## Getting the code

To install the web application:

    $ git clone https://github.com/makigas/makigas
    $ cd makigas
    $ bundle install

## Database

Upstream database is PostgreSQL and that is the officially supported one. Said that, this web application may work on MySQL and sqlite3 as well, although I haven't tested this.

**Note that no database.yml has been committed.** Copy the example file `config/database.yml.example` and modify it to suit your needs. **It is important not to commit sensitive information such as passwords to the repository**.

    $ cp config/database.yml.example config/database.yml
    $ vim config/database.yml
    $ rake db:setup

## secrets.yml

There is no secrets.yml file committed to the project because it is dangerous to track secret keys in public open source projects. Copy the example file `config/secrets.yml.example` and fill the commented keys with the secret keys that you want to use.

    $ cp config/secrets.yml.example config/secrets.yml
    $ vim config/secrets.yml

You can generate new secret keys using `rake secret` command.

## Creating administration users

Because the dashboard is a private system, it is not possible to create users via a web interface. Only an user can create new users. Therefore, in order to set up the first user, you will have to use the Rails console to seed the first user, like so:

    $ rails console
    ...
    > User.create(email: 'foo@example.com', password: '123456')

Passwords must be 6 characters or greater.

# Contributing

If you find a bug in this source code or an issue or visual glitch on the web site, please file a bug. If you find a security vulnerability on this source code, please disclose it in a private way to me. [My e-mail address and my PGP key is on my personal website](https://www.danirod.es/about.html#contact).

This project follows the [code of merit](https://github.com/rosarior/Code-of-Merit). At this repository, I care about code, not about personal opinions nor feelings. I expect to deal with adults.

Before sending a chunk of code or a new functionality, please discuss it with the team beforehand. This is not a general purpose project nor a framework – these are just the guts of my website. Therefore, I have my own roadmap.

# License

    makigas v5 - source code for the makigas.es application
    Copyright (C) 2016-2017 Dani Rodríguez

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

* **Why did you rewrite makigas.es again?**
  Previous versions of makigas.es used a blogging engine such as WordPress with a lot of plugins and hacks in order to work as general purpose CMS systems. This version was crafted specifically for the data structures required for the web site and therefore it is more concise, flexible and easy to develop and maintain.

* **What is the point on sharing the source code?**
  I don't have any particular interest in this source code at this moment. I just want an app that works and that allows me to manage my videos and keep my information up to date.
