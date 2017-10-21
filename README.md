<p align="center">
  <a href="https://travis-ci.org/makigas/makigas"><img src="https://travis-ci.org/makigas/makigas.svg?branch=master" alt="Build Status"></a>
  <a href="https://gemnasium.com/github.com/makigas/makigas"><img src="https://gemnasium.com/badges/github.com/makigas/makigas.svg" alt="Dependency Status" /></a>
  <a href="https://github.com/makigas/makigas/releases"><img src="https://img.shields.io/github/tag/makigas/makigas.svg" alt="Latest release"></a>
</p>

<p align="center">
<img src="http://i.imgur.com/GPJvkq1.png" alt="makigas">
</p>

# About

This is the public source code for makigas.es. The whole application was
recently redesigned from scratch using the Ruby on Rails framework. This web
site, just like previous iterations, still displays information about videos
and playlists in the system.

# Setting up

**To use the experimental Docker images, see below.**

## Requirements

Supported operating systems:

* Production environments: GNU/Linux.
* Development environments: GNU/Linux, MacOS X.

Requirements:

* Ruby 2.4+ and Bundler. Older Ruby versions are not supported.
* PostgreSQL 9.1+. Other SQL engines such as MySQL or sqlite3 are not supported.
* Node.js + Yarn, for the front-end dependencies.
* `libpq-dev`. If `bundle install` refuses to install pg, check this.
* `imagemagick`. Required for image manipulation on thumbnails and such.

## Getting the code

To install the web application:

    $ git clone https://github.com/makigas/makigas
    $ cd makigas
    $ bundle install

## Yarn dependencies

Rails 5.1 has adopted JavaScript and now it has first class support for Yarn,
Webpack and other JavaScript related tools. At the moment Yarn is used for
fetching front-end dependencies (Bootstrap, jQuery...), but I expect to use it
more and more in the future.

Make sure Node.js is installed on your system. LTS versions are recommended
for production servers. Make sure that Yarn is installed. Install front-end
dependencies using `bundle exec rake yarn:install` or simply `yarn`.

## Database

Upstream database is PostgreSQL and that is the officially supported one. Said
that, this web application may work on MySQL and sqlite3 as well, although I
haven't tested this, and it's not officially supported. If you experience bugs
by using MySQL, they cannot be fix.

**Note that no database.yml has been committed.** Copy the example file
`config/database.yml.example` and modify it to suit your needs. **It is
important not to commit sensitive information such as passwords to the
repository**.

    $ cp config/database.yml.example config/database.yml
    $ vim config/database.yml
    $ rake db:setup

## secrets.yml

There is no secrets.yml file committed to the project because it is dangerous
to track secret keys in public open source projects. Copy the example file
`config/secrets.yml.example` and fill the commented keys with the secret keys
that you want to use.

    $ cp config/secrets.yml.example config/secrets.yml
    $ vim config/secrets.yml

You can generate new secret keys using `rake secret` command.

## Creating administration users

Because the dashboard is a private system, it is not possible for you to
register as a new user using a web interface. Only an existing user can create
new users using the dashboard. Therefore, in order to set up the first user,
you will have to use the Rails console to seed the first user, like so:

    $ rails console
    ...
    > User.create(email: 'foo@example.com', password: '123456')

# Development and testing using Docker

## A rationale for Docker

Docker allows a cleaner host environment by defering all the development and
testing to some containers running the database engine, Ruby, and all the
required dependencies. No assets are installed in your host system, and cleaning
up the server is as easy as pruning the Docker images and containers the
application left.

Wait a second. Virtual machines also keep the host system in pristine condition.
Why should I use Docker and not Vagrant / VirtualBox?

* Vagrant spins up an entire GNU/Linux virtual box, having its own Linux kernel
  and its own userspace. If you run three Vagrant boxes, you are running three Linux kernel instances plus your host kernel (I'm assuming Linux).

* Docker uses a Linux kernel feature named LXC. When a Docker box is spinned
  inside a host computer running Linux, the Docker box shares your host's Linux
  kernel. If you run three Docker containers, only one Linux kernel instance
  is active – your host's; however, multiple userlands including different
  applications, mountpoints and process tables can coexist.

So, this has an interesting consequence: booting an entire GNU/Linux VM requires
a lot of time; while booting a Docker container requires seconds, since the
Linux kernel is already provided by your host.

If you are not using GNU/Linux as a host, the Docker daemon running on your
host computer will still create a global and invisible VM running the Moby Linux
distribution and use that VM as the shared Linux kernel. This VM runs using
the operating system native hypervisor engine – HyperV on Windows and
Hypervisor.framework on macOS.

## Workflows

* The Dockerfile for the makigas web application is located at `/Dockerfile`.
  It builds the system image by packaging the web application code and required
  dependencies (Node.js, Ruby, Imagemagick...) into a Docker image that, once
  started, starts the Puma server.

* `/docker-compose.yml` sets up a complete development platform including
  PostgreSQL as a database running on another container. This is the one that
  you will always use to operate the machine as it already sets up the
  environment so that the web application image built by the Dockerfile can use
  the database.

* `/spec/docker-compose.yml` sets up a second development platform including
  another PostgreSQL instance. This is the one that you'll use when running
  tests since it's connected to a **different** database, so it doesn't
  matter if the testing database gets trashed, it won't affect development
  (or production) databases.

## Development commands

Start a development session using `docker-compose up -d`. First issue of this
command will take significantly longer as it has to pull PostgreSQL and
build the web application. Then, it will boot the required containers. Once
they are ready, you can browse the server at the URL `http://localhost:3000`.

**Migrations are pending** (a.k.a. how do I run commands on this VM?):
Use `docker-compose exec web [command]`. Examples:

* Attach a shell: `docker-compose exec web /bin/sh`
* Attach another shell: `docker-compose exec web /bin/bash`
* Run a rake task: `docker-compose exec web rake -T`
* Migration: `docker-compose exec web rake db:migrate`

Stop a development session by using `docker-compose stop` or
`docker-compose down`. First command will stop the containers but won't delete
them. Second command will also delete the containers.

## Testing commands

* Change directory to `spec` to use `spec/docker-compose.yml`. This compose
  file uses a different database to avoid destroying data on development or
  production databases. Additionally, it doesn't run `rails server` as it's
  not required.

* Start a testing session using `docker-compose up -d`.

* Run RSpec: `docker-compose run --rm test rspec`. Since `run` will create
  an additional container, keep the `--rm` parameter to remove that container
  once RSpec ends.

* Stop the testing session using `docker-compose down`.

`docker-compose run` will return the status code of the given command. So,
if RSpec fails, `docker-compose run` will also return 1.

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
  Previous versions of makigas.es used a blogging engine such as WordPress with
  a lot of plugins and hacks in order to work as general purpose CMS systems.
  This version was crafted specifically for the data structures required for
  the web site and therefore it is more concise, flexible and easy to develop
  and maintain.

* **What is the point on sharing the source code?**
  I don't have any particular interest in this source code at this moment. I
  just want an app that works and that allows me to manage my videos and keep
  my information up to date.

[1]: https://github.com/makigas/makigas/blob/master/CONTRIBUTING.md
[2]: https://github.com/makigas/makigas/blob/master/CODE_OF_CONDUCT.md
[3]: https://www.danirod.es/contact/
