# makigas.es

**NOTE**: This is a work in progress. The source code for this application
hasn't been published yet because the web application is not even remotely
finished. If you want to browse the website, just do it using the actual
version of the website.

## About

This is the public source code for the makigas.es website. This is the first
iteration that uses a dynamic website that is not using PHP or WordPress.
The whole application has been redesigned using the Rails framework.

This is the small web application where I'll upload all the metadata about
the videos that are already listed on my YouTube channel, but... you know,
with more extras.

## Setting up

### Cloning and installing the application locally

Please note that official support exists only for Linux and MacOS X. This code
will probably run fine on Windows 10 with WSL (the Bash thingy), but since that
is a developer preview I won't take a look at it until is fully done. The
code is unlikely to run on vanilla Windows, although I haven't checked and I
don't actually care about it. (Server runs Linux, anyway, right?).

The web application uses Ruby 2.2 / Rails 4.2 so you should install that
beforehand. I recommend to use RVM since it will make your life better in so
many ways, specially when it comes to managing all the gems. It is easy to
set up:

    $ git clone http://github.com/makigas/makigas
    $ cd makigas
    $ bundle install

### Database

Upstream database is PostgreSQL and that is the officially supported one.
Said that, if you can get this to run under MySQL or sqlite3 (should do without
further issues), that is totally fine.

**Note that no database.yml has been committed.** Copy the example file and
modify it to suit your needs. **It is important not to commit sensitive
information such as passwords to the repository**.

    $ cp config/database.yml.example config/database.yml
    $ vim config/database.yml
    $ rake db:migrate

### secrets.yml

There is no secrets.yml file committed either. And please don't do that. Again
just copy config/secrets.yml.example and fill the commented keys with the
secret keys that you want to use.

    $ cp config/secrets.yml.example config/secrets.yml
    $ vim config/secrets.yml

You can generate new secret keys using `rake secret` command.

### Starting up

Make sure all the migrations are up to date and run `rails server` to start
the server locally in development mode. Note that the database should be
empty and you might need to create all your local data first.


## License

    makigas v5 - source code for the makigas.es application
    Copyright (C) 2016 Dani Rodríguez

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


## Frequently Asked Questions

* **What is the point on sharing the source code?**
  As I said before, I don't have any particular interest in the source code
  at the moment. I just want some app that will let me manage my videos and
  keep the information about them up to date.

* **Will you open source earlier versions of your web site?**
  That is something that I'm looking forward to. However, I'd have to clean
  the source code for them first since there might be things that I don't want
  to show you.

* **Can I use this source code for creating my own video website?**
  You'll have to do a lot of work beforehand since the source code is not
  designed for general purpose applications and therefore there are a lot of
  source code that is only valid for my website plus probably a lot of
  hardcoded strings plus my own templates.

* **Can I use this source code for creating a clone of your website?**
  Even if the source code is public, I'd politely ask you to not do that,
  at least without getting in touch with me first. There are a few restrictions
  that I would like to keep on letting other people use the 'makigas' name
  plus creating copies of my web page might be bad for SEO purposes. Again,
  you should get in touch with me before trying to do something _real_ with
  my code.
